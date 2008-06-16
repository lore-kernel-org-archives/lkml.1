Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYFPDHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYFPDHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 23:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYFPDHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 23:07:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:2306 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYFPDHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 23:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=FizXE5wIzrbGToh7UZHowmoNhAYmWcXHwMiZZkb/a7+bhzNzy3Wi4Y6iI8qF824fGn
         hljz21uW6883kPVnX6guDjPFsW2atzcogycmf5ZHDhy1XGM7AgEnLHaNl/Kfx6yyu2FE
         7ohTqfdQ79G2HEd6deO0LrskHrPu4K5ZZv2pc=
Message-ID: <4855D8E2.10409@gmail.com>
Date: Mon, 16 Jun 2008 12:07:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme
 III 8GB
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>	<20080528222740.GB20893@isilmar.linta.de>	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>	<20080607223716.7d142072.komurojun-mbn@nifty.com>	<20080611072029.GB28692@comet.dominikbrodowski.net>	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>	<48537149.4040102@garzik.org> <20080614213612.96873c25.komurojun-mbn@nifty.com>
In-Reply-To: <20080614213612.96873c25.komurojun-mbn@nifty.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------020409020006020000010900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020409020006020000010900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Komuro wrote:
> On Sat, 14 Jun 2008 03:20:41 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
> 
> After removing the 3-lines below in ata_eh_reset
> the pata_pcmcia works properly.
> 
> 
> -       spin_lock_irqsave(link->ap->lock, flags);
> -       link->eh_info.serror = 0;
> -       spin_unlock_irqrestore(link->ap->lock, flags);
> 
> Please fix this problem.

Thanks for diagnosing the problem but it doesn't make any sense at all.
 Those three lines just clear cached SError value.  pata_pcmcia being a
PATA driver, SError is not implemented and always zero.

Also the init_one error is -ENOMEM.  For the above change to make any
difference, EH should have been entered which is invoked deep into
ata_host_register() and once control reaches that point it never returns
error code.  I have difficult time imagining any way the above diff can
have anything to do with the reported failure.

Please apply the attached patch and report the log after probe failure.

Thanks.

-- 
tejun

--------------020409020006020000010900
Content-Type: text/x-patch;
 name="pata_pcmcia-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pata_pcmcia-debug.patch"

diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 3d39f9d..d5bcdc2 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -177,8 +177,10 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 	struct ata_port_operations *ops = &pcmcia_port_ops;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (info == NULL)
+	if (info == NULL) {
+		printk("XXX info alloc failed\n");
 		return -ENOMEM;
+	}
 
 	/* Glue stuff together. FIXME: We may be able to get rid of info with care */
 	info->pdev = pdev;
@@ -196,8 +198,10 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 	/* Allocate resoure probing structures */
 
 	stk = kzalloc(sizeof(*stk), GFP_KERNEL);
-	if (!stk)
+	if (!stk) {
+		printk("XXX stk alloc failed\n");
 		goto out1;
+	}
 
 	cfg = &stk->parse.cftable_entry;
 
@@ -290,8 +294,11 @@ next_entry:
 	ret = -ENOMEM;
 	io_addr = devm_ioport_map(&pdev->dev, io_base, 8);
 	ctl_addr = devm_ioport_map(&pdev->dev, ctl_base, 1);
-	if (!io_addr || !ctl_addr)
+	if (!io_addr || !ctl_addr) {
+		printk("XXX ioport_map failed io_addr=%p ctl_addr=%p\n",
+		       io_addr, ctl_addr);
 		goto failed;
+	}
 
 	/* Success. Disable the IRQ nIEN line, do quirks */
 	iowrite8(0x02, ctl_addr);
@@ -311,8 +318,10 @@ next_entry:
 	 */
 	ret = -ENOMEM;
 	host = ata_host_alloc(&pdev->dev, n_ports);
-	if (!host)
+	if (!host) {
+		printk("XXX host alloc failed\n");
 		goto failed;
+	}
 
 	for (p = 0; p < n_ports; p++) {
 		ap = host->ports[p];
@@ -331,8 +340,10 @@ next_entry:
 	/* activate */
 	ret = ata_host_activate(host, pdev->irq.AssignedIRQ, ata_sff_interrupt,
 				IRQF_SHARED, &pcmcia_sht);
-	if (ret)
+	if (ret) {
+		printk("XXX host activate failed ret=%d\n", ret);
 		goto failed;
+	}
 
 	info->ndev = 1;
 	kfree(stk);

--------------020409020006020000010900--
