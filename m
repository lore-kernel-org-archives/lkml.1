Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZLaJPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZLaJPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZLaJPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:15:52 -0500
Received: from mga05.intel.com ([192.55.52.89]:60570 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbZLaJPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:15:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,480,1257148800"; 
   d="scan'208";a="760362127"
Subject: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: czoccolo@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Cc: Shaohua Li <shaohua.li@intel.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 31 Dec 2009 17:16:00 +0800
Message-Id: <1262250960.1819.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with kernel 2.6.32, fio mmap randread 64k has more than 40% regression with
2.6.33-rc1.

The test scenario: 1 JBOD has 12 disks and every disk has 2 partitions. Create
8 1-GB files per partition and start 8 processes to do rand read on the 8 files
per partitions. There are 8*24 processes totally. randread block size is 64K.

We found the regression on 2 machines. One machine has 8GB memory and the other has
6GB.

Bisect is very unstable. The related patches are many instead of just one.


1) commit 8e550632cccae34e265cb066691945515eaa7fb5
Author: Corrado Zoccolo <czoccolo@gmail.com>
Date:   Thu Nov 26 10:02:58 2009 +0100

    cfq-iosched: fix corner cases in idling logic


This patch introduces about less than 20% regression. I just reverted below section
and this part regression disappear. It shows this regression is stable and not impacted
by other patches.

@@ -1253,9 +1254,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
                return;

        /*
-        * still requests with the driver, don't idle
+        * still active requests from this queue, don't idle
         */
-       if (rq_in_driver(cfqd))
+       if (cfqq->dispatched)
                return;



2) How about other 20%~30% regressions? It's complicated. My bisect plus
Li Shaohua's investigation located 3 patches,
df5fe3e8e13883f58dc97489076bbcc150789a21,
b3b6d0408c953524f979468562e7e210d8634150,
5db5d64277bf390056b1a87d0bb288c8b8553f96.

tiobench also has regression and Li Shaohua located the same patches. See link
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/03355.html.

Shaohua worked about patches to fix the tiobench regression. However, his patch
doesn't work for fio randread 64k regression.
I retried bisect manually and eventually located below patch,

commit 718eee0579b802aabe3bafacf09d0a9b0830f1dd
Author: Corrado Zoccolo <czoccolo@gmail.com>
Date:   Mon Oct 26 22:45:29 2009 +0100

    cfq-iosched: fairness for sync no-idle queues



The patch is a little big. After many try, I found below section is the key.
@@ -2218,13 +2352,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);

        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-           (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
+           (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
                enable_idle = 0;

That section deletes the condition checking of !cfqd->cfq_latency, so
enable_idle=0 with more possibility.

I wrote a testing patch which just overlooks the original 3 patches related
to tiobench regression, and a patch which adds back the checking of !cfqd->cfq_latency.
Then, all regression of fio randread 64k disappears.

Then, instead of working around the original 3 patches, I applied Shaohua's 2 patches
and added the checking of !cfqd->cfq_latency while also reverting the patch mentioned in 1).
But the result still has more than 20% regression. So Shaohua's patches couldn't improve
fio rand read 64k regression.

fio_mmap_randread_4k has about 10% improvement instead of regression. I checked
that my patch plus the debugging patch have no impact on this improvement.

randwrite 64k has about 25% regression. My method also restores its performance.

I worked out a patch to add the checking of !cfqd->cfq_latency back in
function cfq_update_idle_window.

In addition, as for item 1), could we just revert the section in cfq_arm_slice_timer?

As Shaohua's patches don't work for this regression, we might continue to find
better methods. I will check it next week.

---

With kernel 2.6.33-rc1, fio rand read 64k has more than 40% regression. Located
below patch.

commit 718eee0579b802aabe3bafacf09d0a9b0830f1dd
Author: Corrado Zoccolo <czoccolo@gmail.com>
Date:   Mon Oct 26 22:45:29 2009 +0100

    cfq-iosched: fairness for sync no-idle queues

It introduces for more than 20% regression. The reason is function cfq_update_idle_window
forgets to check cfqd->cfq_latency, so enable_idle=0 with more possibility.

Below patch against 2.6.33-rc1 adds the checking back.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6.33_rc1/block/cfq-iosched.c linux-2.6.33_rc1_rand64k/block/cfq-iosched.c
--- linux-2.6.33_rc1/block/cfq-iosched.c	2009-12-23 14:12:03.000000000 +0800
+++ linux-2.6.33_rc1_rand64k/block/cfq-iosched.c	2009-12-31 16:26:32.000000000 +0800
@@ -3064,8 +3064,8 @@ cfq_update_idle_window(struct cfq_data *
 		cfq_mark_cfqq_deep(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
-	     && CFQQ_SEEKY(cfqq)))
+	    (!cfqd->cfq_latency && !cfq_cfqq_deep(cfqq) &&
+		sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)


