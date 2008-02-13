Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbYBMJwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbYBMJwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYBMJvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:51:54 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:25460 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYBMJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZudPNgr6u/d8I8mWCytyhAMRKbn8A5cm8EmE751IlvulG8zmFuY+O9mg4Tqr1smcMSmWcYX6q+tEDFp2++XmcEzxj/FQlmQR/Lk2s7i10tQbSNSpILMdGe2Qgg30l8eKSrrvXoNMuRm6B+Rfu+MV8zG3jGkh5hCa9g05IF7+gCg=
Message-ID: <47B2BDAB.30606@gmail.com>
Date: Wed, 13 Feb 2008 18:51:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ata crash] Re: Linux 2.6.25-rc1
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu>
In-Reply-To: <20080212081816.GA17820@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> On a second attempt to boot the same bzImage, another ATA related 
> weirdness showed up:
> 
> [    8.226144] Calling initcall 0xc09f3d8e: isapnp_init+0x0/0xf()
> [    8.232017] Bad IO access at port 0x0 (outb(val,port))
> [    8.232799] ------------[ cut here ]------------
> [    8.232799] WARNING: at lib/iomap.c:44 bad_io_access+0x2f/0x34()
> [    8.232799] Pid: 1, comm: swapper Not tainted 2.6.25-rc1 #5
> [    8.232799]  [<c011fd63>] warn_on_slowpath+0x3c/0x4c
> [    8.232799]  [<c0358e9d>] ? serial8250_console_write+0x0/0x14e
> [    8.232799]  [<c01200a5>] ? __call_console_drivers+0x56/0x63
> [    8.232799]  [<c06b7acf>] ? _spin_unlock_irqrestore+0x15/0x21
> [    8.232799]  [<c0120556>] ? release_console_sem+0x1c1/0x1c9
> [    8.232799]  [<c015c400>] ? print_trailer+0x6e/0xfc
> [    8.232799]  [<c015c77f>] ? check_object+0x10b/0x181
> [    8.232799]  [<c01209a0>] ? printk+0x15/0x17
> [    8.232799]  [<c02cc2ce>] bad_io_access+0x2f/0x34
> [    8.232799]  [<c02cc48a>] iowrite8+0x31/0x34
> [    8.232799]  [<c04a1c8d>] ata_bmdma_freeze+0x1d/0x30
> [    8.232799]  [<c04a2063>] __ata_port_freeze+0x2c/0x33
> [    8.232799]  [<c04a224f>] ata_eh_freeze_port+0x21/0x2f
> [    8.232799]  [<c0497fa9>] ata_host_start+0xe1/0x132

Does the following patch fix the above problem?  pata_isapnp is the
only one which can have NULL ctl_addr and libata SFF layer wasn't
ready for that.

Thanks.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4e31071..c6c04dc 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2150,6 +2150,15 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			ap->ops->set_piomode(ap, dev);
 	}
 
+	if (!softreset && !hardreset) {
+		if (verbose)
+			ata_link_printk(link, KERN_INFO, "no reset method "
+					"available, skipping reset\n");
+		if (!(lflags & ATA_LFLAG_ASSUME_CLASS))
+			lflags |= ATA_LFLAG_ASSUME_ATA;
+		goto done;
+	}
+
 	/* Determine which reset to use and record in ehc->i.action.
 	 * prereset() may examine and modify it.
 	 */
@@ -2254,6 +2263,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
 
+ done:
 	ata_link_for_each_dev(dev, link) {
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Reset also wakes up
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 60cd4b1..93ea0db 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -56,7 +56,8 @@ u8 ata_irq_on(struct ata_port *ap)
 	ap->ctl &= ~ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ioaddr->ctl_addr)
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
 	tmp = ata_wait_idle(ap);
 
 	ap->ops->irq_clear(ap);
@@ -81,7 +82,8 @@ void ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
 
 	if (tf->ctl != ap->last_ctl) {
-		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		if (ioaddr->ctl_addr)
+			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
 		ata_wait_idle(ap);
 	}
@@ -167,13 +169,15 @@ void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 	tf->device = ioread8(ioaddr->device_addr);
 
 	if (tf->flags & ATA_TFLAG_LBA48) {
-		iowrite8(tf->ctl | ATA_HOB, ioaddr->ctl_addr);
+		if (ioaddr->ctl_addr)
+			iowrite8(tf->ctl | ATA_HOB, ioaddr->ctl_addr);
 		tf->hob_feature = ioread8(ioaddr->error_addr);
 		tf->hob_nsect = ioread8(ioaddr->nsect_addr);
 		tf->hob_lbal = ioread8(ioaddr->lbal_addr);
 		tf->hob_lbam = ioread8(ioaddr->lbam_addr);
 		tf->hob_lbah = ioread8(ioaddr->lbah_addr);
-		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		if (ioaddr->ctl_addr)
+			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
 	}
 }
@@ -352,7 +356,8 @@ void ata_bmdma_freeze(struct ata_port *ap)
 	ap->ctl |= ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ioaddr->ctl_addr)
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
 
 	/* Under certain circumstances, some controllers raise IRQ on
 	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
@@ -459,13 +464,14 @@ void ata_bmdma_drive_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
  */
 void ata_bmdma_error_handler(struct ata_port *ap)
 {
-	ata_reset_fn_t hardreset;
+	ata_reset_fn_t softreset = NULL, hardreset = NULL;
 
-	hardreset = NULL;
+	if (ap->ioaddr.ctl_addr)
+		softreset = ata_std_softreset;
 	if (sata_scr_valid(&ap->link))
 		hardreset = sata_std_hardreset;
 
-	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset, hardreset,
+	ata_bmdma_drive_eh(ap, ata_std_prereset, softreset, hardreset,
 			   ata_std_postreset);
 }
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
