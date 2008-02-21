Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbYBUHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbYBUHNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYBUHNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:13:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52312 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbYBUHNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:13:44 -0500
Date: Thu, 21 Feb 2008 08:12:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ata crash] Re: Linux 2.6.25-rc1
Message-ID: <20080221071253.GB13694@elte.hu>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu> <47B2BDAB.30606@gmail.com> <47BCE2F5.6020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BCE2F5.6020305@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> Tejun Heo wrote:
> > Ingo Molnar wrote:
> >> On a second attempt to boot the same bzImage, another ATA related 
> >> weirdness showed up:
> >>
> >> [    8.226144] Calling initcall 0xc09f3d8e: isapnp_init+0x0/0xf()
> >> [    8.232017] Bad IO access at port 0x0 (outb(val,port))
> >> [    8.232799] ------------[ cut here ]------------
> >> [    8.232799] WARNING: at lib/iomap.c:44 bad_io_access+0x2f/0x34()
> >> [    8.232799] Pid: 1, comm: swapper Not tainted 2.6.25-rc1 #5
> >> [    8.232799]  [<c011fd63>] warn_on_slowpath+0x3c/0x4c
> >> [    8.232799]  [<c0358e9d>] ? serial8250_console_write+0x0/0x14e
> >> [    8.232799]  [<c01200a5>] ? __call_console_drivers+0x56/0x63
> >> [    8.232799]  [<c06b7acf>] ? _spin_unlock_irqrestore+0x15/0x21
> >> [    8.232799]  [<c0120556>] ? release_console_sem+0x1c1/0x1c9
> >> [    8.232799]  [<c015c400>] ? print_trailer+0x6e/0xfc
> >> [    8.232799]  [<c015c77f>] ? check_object+0x10b/0x181
> >> [    8.232799]  [<c01209a0>] ? printk+0x15/0x17
> >> [    8.232799]  [<c02cc2ce>] bad_io_access+0x2f/0x34
> >> [    8.232799]  [<c02cc48a>] iowrite8+0x31/0x34
> >> [    8.232799]  [<c04a1c8d>] ata_bmdma_freeze+0x1d/0x30
> >> [    8.232799]  [<c04a2063>] __ata_port_freeze+0x2c/0x33
> >> [    8.232799]  [<c04a224f>] ata_eh_freeze_port+0x21/0x2f
> >> [    8.232799]  [<c0497fa9>] ata_host_start+0xe1/0x132
> > 
> > Does the following patch fix the above problem?  pata_isapnp is the
> > only one which can have NULL ctl_addr and libata SFF layer wasn't
> > ready for that.
> 
> Ping.

Pong. Please consider it fixed and merge the fix upstream - i havent 
seen these problems since i put your fix into my qa tree (and forgot 
about it completely). If there's any problem left i'll follow up on it. 
(For the record, the patch below is the one i tested with various x86 
hardware.)

	Ingo

------------->
Subject: Re: Re: Linux 2.6.25-rc1
From: Tejun Heo <htejun@gmail.com>
Date: Wed, 13 Feb 2008 18:51:39 +0900

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/ata/libata-eh.c  |   10 ++++++++++
 drivers/ata/libata-sff.c |   22 ++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

Index: linux/drivers/ata/libata-eh.c
===================================================================
--- linux.orig/drivers/ata/libata-eh.c
+++ linux/drivers/ata/libata-eh.c
@@ -2150,6 +2150,15 @@ int ata_eh_reset(struct ata_link *link, 
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
@@ -2254,6 +2263,7 @@ int ata_eh_reset(struct ata_link *link, 
 		lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
 
+ done:
 	ata_link_for_each_dev(dev, link) {
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Reset also wakes up
Index: linux/drivers/ata/libata-sff.c
===================================================================
--- linux.orig/drivers/ata/libata-sff.c
+++ linux/drivers/ata/libata-sff.c
@@ -56,7 +56,8 @@ u8 ata_irq_on(struct ata_port *ap)
 	ap->ctl &= ~ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ioaddr->ctl_addr)
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
 	tmp = ata_wait_idle(ap);
 
 	ap->ops->irq_clear(ap);
@@ -81,7 +82,8 @@ void ata_tf_load(struct ata_port *ap, co
 	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
 
 	if (tf->ctl != ap->last_ctl) {
-		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		if (ioaddr->ctl_addr)
+			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
 		ata_wait_idle(ap);
 	}
@@ -167,13 +169,15 @@ void ata_tf_read(struct ata_port *ap, st
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
@@ -352,7 +356,8 @@ void ata_bmdma_freeze(struct ata_port *a
 	ap->ctl |= ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ioaddr->ctl_addr)
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
 
 	/* Under certain circumstances, some controllers raise IRQ on
 	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
@@ -459,13 +464,14 @@ void ata_bmdma_drive_eh(struct ata_port 
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
 
