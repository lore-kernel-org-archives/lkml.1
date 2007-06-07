Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbXFGH1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbXFGH1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFGH1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:27:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:15669 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXFGH1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=sBYUVKUHNVcDuRJh391wNoyVoSpnkjmH4PDLnDC4giMHRZgPGnitNLYmTn4qrt1D/nqTOtxjop+xJKS6W3GjXxAb8vLiyj182T2W3ddeEoVjtQDIDK+LCKUjfVESIpGZlIdQkSUv1z/bu2TovzdEN65mISmXI2H/oszZxnZYyFc=
Message-ID: <4667B347.9040900@gmail.com>
Date: Thu, 07 Jun 2007 16:27:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>	 <466196AD.3090502@garzik.org>	 <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>	 <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
In-Reply-To: <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------050701090905060901020309"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050701090905060901020309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gregor Jasny wrote:
> 2007/6/6, Tejun Heo <htejun@gmail.com>:
>> Let's see where we're failing.
> 
> [  186.849280] ata_piix 0000:00:07.1: version 2.11
> [  186.849665] scsi0 : ata_piix
> [  186.850241] scsi1 : ata_piix
> [  186.850596] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
> bmdma 0x00010860 irq 14
> [  186.851203] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
> bmdma 0x00010868 irq 15
> [    0.656666] Marking TSC unstable due to: possible TSC halt in C2.
> [    0.659999] Time: acpi_pm clocksource has been installed.
> [    0.659999] Switched to NOHz mode on CPU #0
> [    0.659999] ata1: ata_bus_post_reset: EXIT3
> [    0.709999] ata1.00: ata_hpa_resize 1: sectors = 78242976,
> hpa_sectors = 78242976
> [    0.723333] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
> [    0.739999] ata1.00: 78242976 sectors, multi 8: LBA48
> [    0.763333] ata1.00: ata_hpa_resize 1: sectors = 78242976,
> hpa_sectors = 78242976
> [    0.776666] ata1.00: configured for UDMA/33
> [    1.376666] Clocksource tsc unstable (delta = -498091579 ns)
> [   10.799998] ata2: ata_bus_post_reset: EXIT1
> [   10.813332] ata2: SRST failed (errno=-16)
> [   20.836664] ata2: ata_bus_post_reset: EXIT1
> [   20.849997] ata2: SRST failed (errno=-16)
> [   55.869994] ata2: ata_bus_post_reset: EXIT1
> [   55.883327] ata2: SRST failed (errno=-16)
> [   60.903327] ata2: ata_bus_post_reset: EXIT1
> [   60.916660] ata2: SRST failed (errno=-16)
> [   60.929993] ata2: reset failed, giving up
> [   60.946660] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
> MP0402H  UC10 PQ: 0 ANSI: 5

Ah.. okay.  Now I see what's going on.  Jeff, this is another device
which doesn't set nsect and lbal to 1 after reset.  Gregor, please try
the attached patch.

Thanks.

-- 
tejun

--------------050701090905060901020309
Content-Type: text/x-patch;
 name*0="libata-dont-test-slave-register-readiness-after-srst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="libata-dont-test-slave-register-readiness-after-srst.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4733f00..bac5e1f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3042,7 +3042,6 @@ int ata_wait_ready(struct ata_port *ap, unsigned long deadline)
 static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 			      unsigned long deadline)
 {
-	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned int dev0 = devmask & (1 << 0);
 	unsigned int dev1 = devmask & (1 << 1);
 	int rc, ret = 0;
@@ -3059,22 +3058,9 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 		}
 	}
 
-	/* if device 1 was found in ata_devchk, wait for
-	 * register access, then wait for BSY to clear
-	 */
-	while (dev1) {
-		u8 nsect, lbal;
-
-		ap->ops->dev_select(ap, 1);
-		nsect = ioread8(ioaddr->nsect_addr);
-		lbal = ioread8(ioaddr->lbal_addr);
-		if ((nsect == 1) && (lbal == 1))
-			break;
-		if (time_after(jiffies, deadline))
-			return -EBUSY;
-		msleep(50);	/* give drive a breather */
-	}
+	/* wait for device 1 */
 	if (dev1) {
+		ap->ops->dev_select(ap, 1);
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
 			if (rc != -ENODEV)

--------------050701090905060901020309--
