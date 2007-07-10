Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbXGJK4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbXGJK4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbXGJK4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:56:03 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:43871 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbXGJK4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:56:01 -0400
Message-ID: <469365B2.9020809@suse.de>
Date: Tue, 10 Jul 2007 19:55:46 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andi Kleen <ak@suse.de>, 7091@blargh.com, linux-ide@vger.kernel.org,
       jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil, writing bug with multiple cards?
References: <courier.4689EFD9.0000589A@blargh.com> <200707040908.21512.ak@suse.de> <courier.468B579E.00002ECF@blargh.com> <200707041038.57677.ak@suse.de> <468B5FBD.3040104@gmail.com>
In-Reply-To: <468B5FBD.3040104@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------040008050602020000020200"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040008050602020000020200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Andi Kleen wrote:
>> On Wednesday 04 July 2007 10:17:34 7091@blargh.com wrote:
>>
>>>> Most likely it is some sort of hardware bug that we might
>>>> not be able to do much about. Have you tried contacting SIL or VIA? 
>>> No, I haven't.  Like I mentioned above, the OpenBSD drivers seemed to work, 
>>> or at least did with similar tests.  I would need to run the more extensive 
>>> checks to be positive, but those take a lot of time, obviously.  And 
>>> downtime for the box, a lot of which isn't really manageable, at the moment. 
>> Perhaps the OpenBSD drivers program the SIL chip in a different way
>> that avoids this problem. 
>>
>>>> e.g. if you have some other system with a different chipset it might
>>>> be useful to test the SIL controllers in those.
>>> The previous motherboard was an AMD 760 chipset, and it had the same 
>>> problem. 
>> Ok this means it's likely a SIL issue, not a chipset issue.
> 
> Hmmmm... okay.  I'll take look at the openBSD driver.  I still have no
> idea what it can be tho.  Maybe, FIFO setup?

Please give a shot at the attached patch on top of 2.6.22.  Thanks.

-- 
tejun

--------------040008050602020000020200
Content-Type: text/x-patch;
 name="sata_sil-update-cache-line-programming.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_sil-update-cache-line-programming.patch"

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 2a86dc4..6c0fe7e 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -280,14 +280,6 @@ static int slow_down = 0;
 module_param(slow_down, int, 0444);
 MODULE_PARM_DESC(slow_down, "Sledgehammer used to work around random problems, by limiting commands to 15 sectors (0=off, 1=on)");
 
-
-static unsigned char sil_get_device_cache_line(struct pci_dev *pdev)
-{
-	u8 cache_line = 0;
-	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &cache_line);
-	return cache_line;
-}
-
 /**
  *	sil_set_mode		-	wrap set_mode functions
  *	@ap: port to set up
@@ -597,17 +589,29 @@ static void sil_init_controller(struct ata_host *host)
 	u32 tmp;
 	int i;
 
-	/* Initialize FIFO PCI bus arbitration */
-	cls = sil_get_device_cache_line(pdev);
-	if (cls) {
-		cls >>= 3;
-		cls++;  /* cls = (line_size/8)+1 */
-		for (i = 0; i < host->n_ports; i++)
-			writew(cls << 8 | cls,
-			       mmio_base + sil_port[i].fifo_cfg);
-	} else
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "cache line size not set.  Driver may not function\n");
+	/* When the Silicon Image 3112/4 retries a PCI memory read
+	 * command, it may retry it as a memory read multiple command
+	 * under some circumstances.  This can totally confuse some
+	 * PCI controllers, so ensure that it will never do this by
+	 * making sure that the Read Threshold (FIFO Read Request
+	 * Control) field of the FIFO Valid Byte Count and Control
+	 * registers for all the channels are set to be at least as
+	 * large as the cacheline size register.
+	 *
+	 * tj - code and comment shamelessly taken from NetBSD.
+	 */
+	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &cls);
+	cls *= 4;
+
+	if (cls > 224) {
+		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 224 / 4);
+		cls = 224;
+	} else if (cls < 32)
+		cls = 32;
+
+	cls = DIV_ROUND_UP(cls, 32);
+	for (i = 0; i < host->n_ports; i++)
+		writeb(cls, mmio_base + sil_port[i].fifo_cfg);
 
 	/* Apply R_ERR on DMA activate FIS errata workaround */
 	if (host->ports[0]->flags & SIL_FLAG_RERR_ON_DMA_ACT) {

--------------040008050602020000020200--
