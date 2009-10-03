Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZJCI51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZJCI51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 04:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZJCI50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 04:57:26 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:36177 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZJCI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 04:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=Sk7wxhp6l7etOWlU7tiMy+euG2RWGV97IoIxmmW9s8cIDjWHQI1zRFrL92z8pVrBsf
         AIHA8S8lZj4uvhxFcB6CSPIH0GjjeXydZ7Xf/puhyxxrMB0hOTxhmtqCs2m1WBhv8UWr
         ++I22nm0uqV4chhRNDOi8sHoAiCZBW5NLNPoM=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq: enable idle for seeky processes on rotational NCQ devices
Date: Sat, 3 Oct 2009 10:57:41 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31cz; KDE/4.2.4; i686; ; )
Cc: Vivek Goyal <vgoyal@redhat.com>, Mike Galbraith <efault@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910031057.41695.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle window is currently disabled for seeky processes on all NCQ devices.
This is causing large latencies when seeky processes are competing with async writes,
for rotational NCQ devices.

This patch, based on Vivek Goyal's original idea (http://lkml.org/lkml/2009/7/12/110),
enables idle window for seeky processes on rotational NCQ devices.
As for non-NCQ devices, a smaller idle window (2ms) is used
for seeky processes compared to normal I/O (8ms).

RAIDs should be marked as non-rotational as well (and probably a better flag
name should be devised), since they can carry multiple operations in parallel.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1ca813b..7116f11 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1951,10 +1951,12 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (cfqd->hw_tag && CIC_SEEKY(cic)))
+	    (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag && CIC_SEEKY(cic)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
-		if (cic->ttime_mean > cfqd->cfq_slice_idle)
+		unsigned idle_time = CIC_SEEKY(cic) ? CFQ_MIN_TT
+			: cfqd->cfq_slice_idle;
+		if (cic->ttime_mean > idle_time)
 			enable_idle = 0;
 		else
 			enable_idle = 1;


