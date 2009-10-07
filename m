Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbZJGI7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbZJGI7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZJGI7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:59:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:44620 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZJGI7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=Thxe0IjMI/dR05TYiNUrPeVc6/fRcBS22HbPZMFvGAqGcXGZeGl4I/6RNBKXDnZO45
         CJam/4Qdxlg2o7TCFsj5/CZ3nxB3xk9TwlcNxJd1/GqVcdWGtOxjbt5X0862eLKUk1z8
         EbTCz4RO8YSsjnKAOy9p4g9JezfYYKtLhg0bQ=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: avoid slice overrun when idling
Date: Wed, 7 Oct 2009 10:59:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc3cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910071059.01146.czoccolo@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle window for a queue is reduced when the queue is about to finish
its slice.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4ab33d8..55bb8ca 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1105,8 +1105,10 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * we don't want to idle for seeks, but we do want to allow
 	 * fair distribution of slice time for a process doing back-to-back
 	 * seeks. so allow a little bit of time for him to submit a new rq
+	 * but avoid overrunning its timeslice
 	 */
-	sl = cfqd->cfq_slice_idle;
+	sl = min_t(unsigned long, cfqd->cfq_slice_idle,
+		cfqq->slice_end - jiffies);
 	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 
-- 
1.6.2.5



