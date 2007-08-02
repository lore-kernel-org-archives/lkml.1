Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXHBXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXHBXMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbXHBXML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:12:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35329 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXHBXMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:12:10 -0400
Date: Thu, 2 Aug 2007 19:12:09 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       LKML <linux-kernel@vger.kernel.org>, werner@titro.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] hysdn: fix SMP brokenness
Message-ID: <20070802231209.GB20071@havoc.gtf.org>
References: <20070724074653.GA14987@havoc.gtf.org> <20070802231137.GA20071@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802231137.GA20071@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch has been committed to the 'hysdn' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

commit 4ef2632c0fdf4598cf6a417f39514257ecbb2ba2
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Aug 2 19:08:10 2007 -0400

    [ISDN] hysdn: fix SMP brokenness
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hysdn/Kconfig     |    2 +-
 drivers/isdn/hysdn/boardergo.c |   14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

4ef2632c0fdf4598cf6a417f39514257ecbb2ba2
diff --git a/drivers/isdn/hysdn/Kconfig b/drivers/isdn/hysdn/Kconfig
index c6d8a70..c9e4231 100644
--- a/drivers/isdn/hysdn/Kconfig
+++ b/drivers/isdn/hysdn/Kconfig
@@ -3,7 +3,7 @@
 #
 config HYSDN
 	tristate "Hypercope HYSDN cards (Champ, Ergo, Metro) support (module only)"
-	depends on m && PROC_FS && PCI && BROKEN_ON_SMP
+	depends on m && PROC_FS && PCI
 	help
 	  Say Y here if you have one of Hypercope's active PCI ISDN cards
 	  Champ, Ergo and Metro. You will then get a module called hysdn.
diff --git a/drivers/isdn/hysdn/boardergo.c b/drivers/isdn/hysdn/boardergo.c
index 6cdbad3..7145d37 100644
--- a/drivers/isdn/hysdn/boardergo.c
+++ b/drivers/isdn/hysdn/boardergo.c
@@ -90,7 +90,12 @@ ergo_irq_bh(struct work_struct *ugli_api)
 	card->hw_lock = 1;	/* we now lock the hardware */
 
 	do {
-		sti();		/* reenable other ints */
+		spin_unlock_irqrestore(&card->hysdn_lock, flags);
+
+		cond_resched();
+
+		spin_lock_irqsave(&card->hysdn_lock, flags);
+
 		again = 0;	/* assume loop not to be repeated */
 
 		if (!dpr->ToHyFlag) {
@@ -110,7 +115,7 @@ ergo_irq_bh(struct work_struct *ugli_api)
 				again = 1;	/* restart loop */
 			}
 		}		/* a message has arrived for us */
-		cli();		/* no further ints */
+
 		if (again) {
 			dpr->ToHyInt = 1;
 			dpr->ToPcInt = 1;	/* interrupt to E1 for all cards */
@@ -240,9 +245,7 @@ ergo_writebootimg(struct HYSDN_CARD *card, unsigned char *buf,
 		while (!dpram->ToHyNoDpramErrLog);	/* reread volatile register to flush PCI */
 
 		byteout(card->iobase + PCI9050_USER_IO, PCI9050_E1_RUN);	/* start E1 processor */
-		/* the interrupts are still masked */
 
-		sti();
 		msleep_interruptible(20);		/* Timeout 20ms */
 
 		if (((tDpramBootSpooler *) card->dpram)->Len != DPRAM_SPOOLER_DATA_SIZE) {
@@ -276,7 +279,6 @@ ergo_writebootseq(struct HYSDN_CARD *card, unsigned char *buf, int len)
 	dst = sp->Data;		/* point to data in spool structure */
 	buflen = sp->Len;	/* maximum len of spooled data */
 	wr_mirror = sp->WrPtr;	/* only once read */
-	sti();
 
 	/* try until all bytes written or error */
 	i = 0x1000;		/* timeout value */
@@ -380,7 +382,7 @@ ergo_waitpofready(struct HYSDN_CARD *card)
 #endif /* CONFIG_HYSDN_CAPI */
 			return (0);	/* success */
 		}		/* data has arrived */
-		sti();
+
 		msleep_interruptible(50);		/* Timeout 50ms */
 	}			/* wait until timeout */
 
