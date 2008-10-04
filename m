Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYJDSOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYJDSOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 14:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYJDSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 14:13:56 -0400
Received: from smtp02.zero.jp ([210.157.5.232]:56267 "EHLO smtp.zero.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753421AbYJDSNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 14:13:55 -0400
X-Spam-Flag: NO
X-Spam-Score: 2.408
Date: Sat, 04 Oct 2008 14:11:35 -0400 (EDT)
Message-Id: <20081004.141135.41629152.k-ueda@ct.jp.nec.com>
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 2/2] scsi: export busy state via q->lld_busy_fn()
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20081004.140350.74754456.k-ueda@ct.jp.nec.com>
References: <20081004.140350.74754456.k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements q->lld_busy_fn() for scsi mid layer to export
its busy state for request stacking drivers.

For efficiency, no lock is taken to check the busy state of
shost/starget/sdev, since the returned value is not guaranteed and
may be changed after request stacking drivers call the function,
regardless of taking lock or not.

When scsi can't dispatch I/Os anymore and needs to kill I/Os
(e.g. !sdev), scsi needs to return 'not busy'.
Otherwise, request stacking drivers may hold requests forever.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+)

Index: scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-post-merge-2.6.orig/drivers/scsi/scsi_lib.c
+++ scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
@@ -1465,6 +1465,37 @@ static inline int scsi_host_queue_ready(
 }
 
 /*
+ * Busy state exporting function for request stacking drivers.
+ *
+ * For efficiency, no lock is taken to check the busy state of
+ * shost/starget/sdev, since the returned value is not guaranteed and
+ * may be changed after request stacking drivers call the function,
+ * regardless of taking lock or not.
+ *
+ * When scsi can't dispatch I/Os anymore and needs to kill I/Os
+ * (e.g. !sdev), scsi needs to return 'not busy'.
+ * Otherwise, request stacking drivers may hold requests forever.
+ */
+static int scsi_lld_busy(struct request_queue *q)
+{
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost;
+	struct scsi_target *starget;
+
+	if (!sdev)
+		return 0;
+
+	shost = sdev->host;
+	starget = scsi_target(sdev);
+
+	if (scsi_host_in_recovery(shost) || scsi_host_is_busy(shost) ||
+	    scsi_target_is_busy(starget) || scsi_device_is_busy(sdev))
+		return 1;
+
+	return 0;
+}
+
+/*
  * Kill a request for a dead device
  */
 static void scsi_kill_request(struct request *req, struct request_queue *q)
@@ -1767,6 +1798,7 @@ struct request_queue *scsi_alloc_queue(s
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
+	blk_queue_lld_busy(q, scsi_lld_busy);
 	return q;
 }
 
