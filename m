Return-Path: <linux-kernel-owner+w=401wt.eu-S1030884AbXAZQwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030884AbXAZQwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030854AbXAZQwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:52:24 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35555 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030876AbXAZQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:52:20 -0500
Date: Fri, 26 Jan 2007 17:52:17 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: horst.hummel@de.ibm.com
Subject: [S390] dasd: fix unconditional reserve handling.
Message-ID: <20070126165217.GQ11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Horst Hummel <horst.hummel@de.ibm.com>

[S390] dasd: fix unconditional reserve handling.

The reserve/release IOCTLs sometimes do not work. If second system
does a 'steal lock' the pending unit check (Format 3 Msg F) is
delivered. Since ERP is disabled for reserve/release, the IOCTL call
fails. We have to allow basic ERP (retries) for reserve/release IOCTLs.

Signed-off-by: Horst Hummel <horst.hummel@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd.c      |    6 +++---
 drivers/s390/block/dasd_eckd.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -urpN linux-2.6/drivers/s390/block/dasd.c linux-2.6-patched/drivers/s390/block/dasd.c
--- linux-2.6/drivers/s390/block/dasd.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd.c	2007-01-26 17:28:03.000000000 +0100
@@ -1022,8 +1022,6 @@ dasd_int_handler(struct ccw_device *cdev
 		 irb->scsw.cstat == 0 &&
 		 !irb->esw.esw0.erw.cons)
 		era = dasd_era_none;
-	else if (!test_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags))
- 	        era = dasd_era_fatal; /* don't recover this request */
 	else if (irb->esw.esw0.erw.cons)
 		era = device->discipline->examine_error(cqr, irb);
 	else
@@ -1127,7 +1125,9 @@ restart:
 				cqr->status = DASD_CQR_FAILED;
 				cqr->stopclk = get_clock();
 			} else {
-				if (cqr->irb.esw.esw0.erw.cons) {
+				if (cqr->irb.esw.esw0.erw.cons &&
+				    test_bit(DASD_CQR_FLAGS_USE_ERP,
+					     &cqr->flags)) {
 					erp_fn = device->discipline->
 						erp_action(cqr);
 					erp_fn(cqr);
diff -urpN linux-2.6/drivers/s390/block/dasd_eckd.c linux-2.6-patched/drivers/s390/block/dasd_eckd.c
--- linux-2.6/drivers/s390/block/dasd_eckd.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_eckd.c	2007-01-26 17:28:03.000000000 +0100
@@ -1380,7 +1380,7 @@ dasd_eckd_release(struct dasd_device *de
 	cqr->device = device;
 	clear_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags);
 	set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
-	cqr->retries = 0;
+	cqr->retries = 2;	/* set retry counter to enable basic ERP */
 	cqr->expires = 2 * HZ;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
@@ -1420,7 +1420,7 @@ dasd_eckd_reserve(struct dasd_device *de
 	cqr->device = device;
 	clear_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags);
 	set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
-	cqr->retries = 0;
+	cqr->retries = 2;	/* set retry counter to enable basic ERP */
 	cqr->expires = 2 * HZ;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
@@ -1459,7 +1459,7 @@ dasd_eckd_steal_lock(struct dasd_device 
 	cqr->device = device;
 	clear_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags);
 	set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
-	cqr->retries = 0;
+	cqr->retries = 2;	/* set retry counter to enable basic ERP */
 	cqr->expires = 2 * HZ;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
