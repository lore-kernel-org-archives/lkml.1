Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbYGCIax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbYGCIax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYGCIRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:17:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:55176 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937013AbYGCHeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:34:03 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1215067667.21182.98.camel@pasglop>
References: <200806162124.43005.bzolnier@gmail.com>
	 <200806261051.34733.bzolnier@gmail.com> <1214470868.8011.455.camel@pasglop>
	 <200806261140.39531.bzolnier@gmail.com> <1215063236.21182.85.camel@pasglop>
	 <1215067667.21182.98.camel@pasglop>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 17:33:55 +1000
Message-Id: <1215070435.21182.107.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 16:47 +1000, Benjamin Herrenschmidt wrote:
> > Took me a while, kid was sick.
> > 
> > They apply on 20080625 (with various offset/fuzz but they do apply) and
> > the tree builds. The media bay however fails the same way as before with
> > IDE register errors.
> > 
> > I'll see if I can find where they come from.
> 
> Found multiple issues related to the ide-pmac <-> mediabay & ide core
> interaction changes. I've done some fixes but it's not quite there yet.
> It looks like it's getting IRQ issues with the mediabay CD, for some
> reasons looks like something unmasks the interrupt before there's a
> handler or around those lines... I get an irq "nobody cared" error, it
> gets disabled, and then hdc gets lost interrupts.
> 
> I'll dig a bit more and if I can't find what's up tonight, will send
> you my current patches in case you have some other idea.

Ok, so the interrupt stuff is weird, I need to dig more. I get basically
what looks like an interrupt storm in the enable_irq() after the probing
of the drives. I know the media-bay IDE has some weird behaviours at
probe time but that's not quite something I saw before. I'll have to
debug more.

In the meantime, here's the hacks I applied to your patch series to get
things mostly going (appart from that bug, which we -do- need to fix,
but give me a bit more time to track it down). You'll probably want to
integrate the fixes with your patches and remove the debug stuff :-)

You'll notice that I created a new state for when the media-bay is up
but IDE hasn't registered in yet. This might disappear in the future
when I do the libata bits but for now it fixes a few issues where
noprobe was never set properly, or if set, it would try to probe the
drives twice and blow up...

(The problem was either noprobe would stay set to 1 with your old code,
despite the clearing in the mediabay case because pmac_ide_init_dev
would set it back to 1. If you fix that you get into a case where
the bay is "up" before IDE is ready, and when IDE gets ready, both
the idea layer and the bay code race to trigger a probe).


Ben.

Index: linux-work/drivers/ide/ide-probe.c
===================================================================
--- linux-work.orig/drivers/ide/ide-probe.c	2008-07-03 15:50:24.000000000 +1000
+++ linux-work/drivers/ide/ide-probe.c	2008-07-03 17:14:42.000000000 +1000
@@ -770,11 +770,15 @@ static int ide_probe_port(ide_hwif_t *hw
 	unsigned int irqd;
 	int unit, rc = -ENODEV;
 
-	BUG_ON(hwif->present);
-
+	printk("ide_probe_port(%s) noprobe=%d,%d\n",
+	       hwif->name, hwif->drives[0].noprobe, hwif->drives[1].noprobe);
 	if (hwif->drives[0].noprobe && hwif->drives[1].noprobe)
 		return -EACCES;
 
+	WARN_ON(hwif->present);
+	if (hwif->present)
+		return 0;
+
 	/*
 	 * We must always disable IRQ, as probe_for_drive will assert IRQ, but
 	 * we'll install our IRQ driver much later...
@@ -798,6 +802,7 @@ static int ide_probe_port(ide_hwif_t *hw
 		(void) probe_for_drive(drive);
 		if (drive->present)
 			rc = 0;
+		ide_busy_sleep(hwif);
 	}
 
 	local_irq_restore(flags);
Index: linux-work/drivers/ide/ppc/pmac.c
===================================================================
--- linux-work.orig/drivers/ide/ppc/pmac.c	2008-07-03 15:54:43.000000000 +1000
+++ linux-work/drivers/ide/ppc/pmac.c	2008-07-03 15:57:12.000000000 +1000
@@ -951,8 +951,10 @@ static void pmac_ide_init_dev(ide_drive_
 
 	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
-		if (check_media_bay(pmif->node->parent, MB_CD) == -ENODEV)
+		if (check_media_bay(pmif->node->parent, MB_CD) == 0) {
+			drive->noprobe = 0;
 			return;
+		}
 #endif
 		drive->noprobe = 1;
 	}
@@ -1096,8 +1098,6 @@ static int __devinit pmac_ide_setup_devi
 	ide_device_add(idx, &d);
 
 	if (pmif->mediabay) {
-		hwif->drives[0].noprobe = 0;
-		hwif->drives[1].noprobe = 0;
 #ifdef CONFIG_PMAC_MEDIABAY
 		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq,
 					hwif);
Index: linux-work/drivers/macintosh/mediabay.c
===================================================================
--- linux-work.orig/drivers/macintosh/mediabay.c	2008-07-03 16:20:13.000000000 +1000
+++ linux-work/drivers/macintosh/mediabay.c	2008-07-03 16:41:07.000000000 +1000
@@ -156,7 +156,8 @@ enum {
 	mb_ide_resetting,	/* IDE reset bit unser, waiting MB_IDE_WAIT */
 	mb_ide_waiting,		/* Waiting for BUSY bit to go away until MB_IDE_TIMEOUT */
 	mb_up,			/* Media bay full */
-	mb_powering_down	/* Powering down (avoid too fast down/up) */
+	mb_powering_down,	/* Powering down (avoid too fast down/up) */
+	mb_wait_ide_init,	/* Wait for IDE layer to go up */
 };
 
 #define MB_POWER_SOUND		0x08
@@ -448,7 +449,7 @@ int media_bay_set_ide_infos(struct devic
  			bay->cd_base	= (void __iomem *) base;
 			bay->cd_irq	= irq;
 
-			if ((MB_CD != bay->content_id) || bay->state != mb_up) {
+			if ((MB_CD != bay->content_id) || bay->state != mb_wait_ide_init) {
 				up(&bay->lock);
 				return 0;
 			}
@@ -522,8 +523,8 @@ static void media_bay_step(int i)
 	    	break;
 	case mb_ide_waiting:
 		if (bay->cd_base == NULL) {
-			bay->timer = 0;
-			bay->state = mb_up;
+			bay->timer = -1;
+			bay->state = mb_wait_ide_init;
 			MBDBG("mediabay%d: up before IDE init\n", i);
 			break;
 		} else if (MB_IDE_READY(i)) {
@@ -557,6 +558,9 @@ static void media_bay_step(int i)
 			bay->timer = 0;
 	    	}
 		break;
+	case mb_wait_ide_init:
+		bay->timer = -1;
+		break;
 #endif /* CONFIG_BLK_DEV_IDE_PMAC */
 	case mb_powering_down:
 	    	bay->state = mb_empty;
@@ -656,7 +660,8 @@ static int __devinit media_bay_attach(st
 		msleep(MB_POLL_DELAY);
 		media_bay_step(i);
 	} while((bay->state != mb_empty) &&
-		(bay->state != mb_up));
+		(bay->state != mb_up) &&
+		(bay->state != mb_wait_ide_init));
 
 	/* Mark us ready by filling our mdev data */
 	macio_set_drvdata(mdev, bay);


