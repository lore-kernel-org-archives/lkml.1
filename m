Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZGOV1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZGOV1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZGOV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:27:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZGOV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:27:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=miSRzubIBdemgB9droioP1AFGF1amiW6RU3ldPsk3h4Jc8W6+c7HwzKU0ZtVGereD
	xKSbIDJklTwQUxVdsgC1Q==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] block: Improve think time sampling for CFQ
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, vgoyal@redhat.com
Cc: nauman@google.com, mrubin@google.com
Date: Thu, 16 Jul 2009 02:56:54 +0530
Message-ID: <20090715212553.8349.51342.stgit@hyd-omgvisitor1.hyd.corp.google.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid taking a think time sample when the cfqq is not a sync queue or not
currently active or till its first request in the ongoing timeslice
completes.

Signed-off by: Divyesh Shah <dpshah@google.com>
---
This applies to Linus's kernel tree.

 block/cfq-iosched.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..1657d4f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1904,10 +1904,17 @@ err:
 }
 
 static void
-cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_io_context *cic)
+cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+			struct cfq_io_context *cic)
 {
-	unsigned long elapsed = jiffies - cic->last_end_request;
-	unsigned long ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
+	unsigned long elapsed, ttime;
+
+	if (!cfq_cfqq_sync(cfqq) || cfqq != cfqd->active_queue || 
+	    cfq_cfqq_slice_new(cfqq))
+		return;
+
+	elapsed = jiffies - cic->last_end_request;
+	ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
 
 	cic->ttime_samples = (7*cic->ttime_samples + 256) / 8;
 	cic->ttime_total = (7*cic->ttime_total + 256*ttime) / 8;
@@ -2072,7 +2079,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (rq_is_meta(rq))
 		cfqq->meta_pending++;
 
-	cfq_update_io_thinktime(cfqd, cic);
+	cfq_update_io_thinktime(cfqd, cfqq, cic);
 	cfq_update_io_seektime(cfqd, cic, rq);
 	cfq_update_idle_window(cfqd, cfqq, cic);
 

