Return-Path: <linux-kernel-owner+w=401wt.eu-S1030881AbXAZQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881AbXAZQwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030874AbXAZQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:52:07 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59387 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030876AbXAZQwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:52:01 -0500
Date: Fri, 26 Jan 2007 17:51:58 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: horst.hummel@de.ibm.com
Subject: [S390] Remove dasd_ccw_log function.
Message-ID: <20070126165158.GP11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Horst Hummel <horst.hummel@de.ibm.com>

[S390] Remove dasd_ccw_log function.

Logging of relevant information is already done by disciplines
dump_sense function.

Signed-off-by: Horst Hummel <horst.hummel@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_3990_erp.c |    5 ---
 drivers/s390/block/dasd_erp.c      |   61 -------------------------------------
 drivers/s390/block/dasd_int.h      |    1 
 3 files changed, 67 deletions(-)

diff -urpN linux-2.6/drivers/s390/block/dasd_3990_erp.c linux-2.6-patched/drivers/s390/block/dasd_3990_erp.c
--- linux-2.6/drivers/s390/block/dasd_3990_erp.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_3990_erp.c	2007-01-26 17:28:02.000000000 +0100
@@ -170,7 +170,6 @@ dasd_3990_erp_examine(struct dasd_ccw_re
 	/* log the erp chain if fatal error occurred */
 	if ((era == dasd_era_fatal) && (device->state >= DASD_STATE_READY)) {
 		dasd_log_sense(cqr, irb);
-		dasd_log_ccw(cqr, 0, irb->scsw.cpa);
 	}
 
 	return era;
@@ -2640,7 +2639,6 @@ dasd_3990_erp_action(struct dasd_ccw_req
 
 	struct dasd_ccw_req *erp = NULL;
 	struct dasd_device *device = cqr->device;
-	__u32 cpa = cqr->irb.scsw.cpa;
 	struct dasd_ccw_req *temp_erp = NULL;
 
 	if (device->features & DASD_FEATURE_ERPLOG) {
@@ -2706,9 +2704,6 @@ dasd_3990_erp_action(struct dasd_ccw_req
 		}
 	}
 
-	if (erp->status == DASD_CQR_FAILED)
-		dasd_log_ccw(erp, 1, cpa);
-
 	/* enqueue added ERP request */
 	if (erp->status == DASD_CQR_FILLED) {
 		erp->status = DASD_CQR_QUEUED;
diff -urpN linux-2.6/drivers/s390/block/dasd_erp.c linux-2.6-patched/drivers/s390/block/dasd_erp.c
--- linux-2.6/drivers/s390/block/dasd_erp.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_erp.c	2007-01-26 17:28:02.000000000 +0100
@@ -182,69 +182,8 @@ dasd_log_sense(struct dasd_ccw_req *cqr,
 		device->discipline->dump_sense(device, cqr, irb);
 }
 
-void
-dasd_log_ccw(struct dasd_ccw_req * cqr, int caller, __u32 cpa)
-{
-	struct dasd_device *device;
-	struct dasd_ccw_req *lcqr;
-	struct ccw1 *ccw;
-	int cplength;
-
-	device = cqr->device;
-	/* log the channel program */
-	for (lcqr = cqr; lcqr != NULL; lcqr = lcqr->refers) {
-		DEV_MESSAGE(KERN_ERR, device,
-			    "(%s) ERP chain report for req: %p",
-			    caller == 0 ? "EXAMINE" : "ACTION", lcqr);
-		hex_dump_memory(device, lcqr, sizeof(struct dasd_ccw_req));
-
-		cplength = 1;
-		ccw = lcqr->cpaddr;
-		while (ccw++->flags & (CCW_FLAG_DC | CCW_FLAG_CC))
-			cplength++;
-
-		if (cplength > 40) {	/* log only parts of the CP */
-			DEV_MESSAGE(KERN_ERR, device, "%s",
-				    "Start of channel program:");
-			hex_dump_memory(device, lcqr->cpaddr,
-					40*sizeof(struct ccw1));
-
-			DEV_MESSAGE(KERN_ERR, device, "%s",
-				    "End of channel program:");
-			hex_dump_memory(device, lcqr->cpaddr + cplength - 10,
-					10*sizeof(struct ccw1));
-		} else {	/* log the whole CP */
-			DEV_MESSAGE(KERN_ERR, device, "%s",
-				    "Channel program (complete):");
-			hex_dump_memory(device, lcqr->cpaddr,
-					cplength*sizeof(struct ccw1));
-		}
-
-		if (lcqr != cqr)
-			continue;
-
-		/*
-		 * Log bytes arround failed CCW but only if we did
-		 * not log the whole CP of the CCW is outside the
-		 * logged CP.
-		 */
-		if (cplength > 40 ||
-		    ((addr_t) cpa < (addr_t) lcqr->cpaddr &&
-		     (addr_t) cpa > (addr_t) (lcqr->cpaddr + cplength + 4))) {
-
-			DEV_MESSAGE(KERN_ERR, device,
-				    "Failed CCW (%p) (area):",
-				    (void *) (long) cpa);
-			hex_dump_memory(device, cqr->cpaddr - 10,
-					20*sizeof(struct ccw1));
-		}
-	}
-
-}				/* end log_erp_chain */
-
 EXPORT_SYMBOL(dasd_default_erp_action);
 EXPORT_SYMBOL(dasd_default_erp_postaction);
 EXPORT_SYMBOL(dasd_alloc_erp_request);
 EXPORT_SYMBOL(dasd_free_erp_request);
 EXPORT_SYMBOL(dasd_log_sense);
-EXPORT_SYMBOL(dasd_log_ccw);
diff -urpN linux-2.6/drivers/s390/block/dasd_int.h linux-2.6-patched/drivers/s390/block/dasd_int.h
--- linux-2.6/drivers/s390/block/dasd_int.h	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_int.h	2007-01-26 17:28:02.000000000 +0100
@@ -559,7 +559,6 @@ struct dasd_ccw_req *dasd_alloc_erp_requ
 					    struct dasd_device *);
 void dasd_free_erp_request(struct dasd_ccw_req *, struct dasd_device *);
 void dasd_log_sense(struct dasd_ccw_req *, struct irb *);
-void dasd_log_ccw(struct dasd_ccw_req *, int, __u32);
 
 /* externals in dasd_3370_erp.c */
 dasd_era_t dasd_3370_erp_examine(struct dasd_ccw_req *, struct irb *);
