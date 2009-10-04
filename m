Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZJDQjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZJDQjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbZJDQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:39:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:13944 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbZJDQjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=M/ozIBbM9H7l+958aVCuM3stWfQccqDGWTVklWXEmZV+2QQ5iyJyUsgILeYKsozZ55
         295OmcUswfAP52qsF/K/LP8jbncYu7SoKisjBFHH+ZkUNVMvTXnnIA/iUud+RzvNLTOQ
         5eyj/c6dHt61sV4/1mUHSo9S+2j0+TDFp2b3g=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq: enable idle for seeky processes on rotational NCQ devices
Date: Sun, 4 Oct 2009 18:37:34 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910041837.34546.czoccolo@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabled idle window cause large latencies when seeky processes are competing
with async writes, for rotational NCQ devices.

This patch, based on Vivek Goyal's original idea (http://lkml.org/lkml/2009/7/12/110),
unconditionally enables idle window for seeky processes on rotational NCQ devices.
As for non-NCQ devices, a smaller idle window (2ms) is used
for seeky processes compared to normal I/O (8ms).

RAIDs should be marked as non-rotational as well (and probably a better flag
name should be devised), since they can carry multiple operations in parallel.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ebab60c..576e92d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1981,10 +1981,14 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-           (!cfqd->cfq_latency && cfqd->hw_tag && CIC_SEEKY(cic)))
+           (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag && CIC_SEEKY(cic)))
                enable_idle = 0;
        else if (sample_valid(cic->ttime_samples)) {
-               if (cic->ttime_mean > cfqd->cfq_slice_idle)
+               unsigned idle_time = cfqd->cfq_slice_idle;
+               if (CIC_SEEKY(cic))
+                       idle_time = CFQ_MIN_TT;
+
+               if (cic->ttime_mean > idle_time)
                        enable_idle = 0;
                else
                        enable_idle = 1;


