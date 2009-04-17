Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZDQB0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZDQB0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZDQB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:26:44 -0400
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:41111 "HELO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754736AbZDQB0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:26:43 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mm/page-writeback.c: fix sparse warnings
Date: Thu, 16 Apr 2009 21:26:35 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9049@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/page-writeback.c: fix sparse warnings
Thread-Index: Acm++4xMOosYje54QLSGaLOhcbeBEQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Apr 2009 01:26:42.0351 (UTC) FILETIME=[904883F0:01C9BEFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two sparse warnings in mm/page-writeback.c.

get_dirty_limits() calls clip_bdi_dirty_limit() and task_dirty_limit()
with variable pbdi_dirty as one of the arguments. This variable is
an unsigned long * but both functions expect it to be a long *. This
causes the following sparse warnings:

  warning: incorrect type in argument 3 (different signedness)
     expected long *pbdi_dirty
     got unsigned long *pbdi_dirty
  warning: incorrect type in argument 2 (different signedness)
     expected long *pdirty
     got unsigned long *pbdi_dirty

Fix the warnings by changing the long * to unsigned long * in both
functions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 30351f0..e40b3e3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -265,18 +265,20 @@ static void bdi_writeout_fraction(struct
backing_dev_info *bdi,
  * This avoids exceeding the total dirty_limit when the floating
averages
  * fluctuate too quickly.
  */
-static void
-clip_bdi_dirty_limit(struct backing_dev_info *bdi, long dirty, long
*pbdi_dirty)
+static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
+		unsigned long dirty, unsigned long *pbdi_dirty)
 {
-	long avail_dirty;
+	unsigned long avail_dirty;
+	unsigned long nr_pages;
 
-	avail_dirty = dirty -
-		(global_page_state(NR_FILE_DIRTY) +
+	nr_pages = global_page_state(NR_FILE_DIRTY) +
 		 global_page_state(NR_WRITEBACK) +
 		 global_page_state(NR_UNSTABLE_NFS) +
-		 global_page_state(NR_WRITEBACK_TEMP));
+		 global_page_state(NR_WRITEBACK_TEMP);
 
-	if (avail_dirty < 0)
+	if (nr_pages < dirty)
+		avail_dirty = dirty - nr_pages;
+	else
 		avail_dirty = 0;
 
 	avail_dirty += bdi_stat(bdi, BDI_RECLAIMABLE) +
@@ -299,10 +301,10 @@ static inline void task_dirties_fraction(struct
task_struct *tsk,
  *
  *   dirty -= (dirty/8) * p_{t}
  */
-static void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+static void task_dirty_limit(struct task_struct *tsk, unsigned long
*pdirty)
 {
 	long numerator, denominator;
-	long dirty = *pdirty;
+	unsigned long dirty = *pdirty;
 	u64 inv = dirty >> 3;
 
 	task_dirties_fraction(tsk, &numerator, &denominator); 
