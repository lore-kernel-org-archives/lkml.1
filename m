Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbZKXNt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbZKXNt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbZKXNt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:49:28 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:53626 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbZKXNt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=DjXaay1QlSAJ/qMk4uAzzO0pu2k9JsBQ+OyQ4sPmVifZ6AECMsBoZWSmKSSLZNw56/
         1azYWBicoGm8RJKOe1b9TxMF6Mh4JmBCUiR6o6jJws/vwk16GQ1kWRvQByevb0DXQwh8
         rZINM+4wIibRXiJXpsC18+xwdnKytnwy+gVpo=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/4] cfq-iosched: idling on deep seeky sync queues
Date: Tue, 24 Nov 2009 14:49:20 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911241449.20715.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeky sync queues with large depth can gain unfairly big share of disk
time, at the expense of other seeky queues. This patch ensures that
idling will be enabled for queues with I/O depth at least 4, and small
think time. The decision to enable idling is sticky, until an idle
window times out without seeing a new request.

The reasoning behind the decision is that, if an application is using
large I/O depth, it is already optimized to make full utilization of
the hardware, and therefore we reserve a slice of exclusive use for it.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 2a304f4..373e80f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -260,6 +260,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
+	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -286,6 +287,7 @@ CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
+CFQ_CFQQ_FNS(deep);
 #undef CFQ_CFQQ_FNS
 
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
@@ -2359,8 +2361,12 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
+	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
+		cfq_mark_cfqq_deep(cfqq);
+
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
+	    (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
+	     && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
@@ -2858,6 +2864,11 @@ static void cfq_idle_slice_timer(unsigned long data)
 		 */
 		if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 			goto out_kick;
+
+		/*
+		 * Queue depth flag is reset only when the idle didn't succeed
+		 */
+		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
 	cfq_slice_expired(cfqd, timed_out);
-- 
1.6.2.5


