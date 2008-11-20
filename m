Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbYKTOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbYKTOMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYKTOMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:12:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:34820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbYKTOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:12:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] FUSE: implement unsolicited notification
Date: Thu, 20 Nov 2008 23:11:37 +0900
Message-Id: <1227190298-4585-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227190298-4585-1-git-send-email-tj@kernel.org>
References: <1227190298-4585-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:11:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clients always used to write only in response to read requests.  To
implement poll efficiently, clients should be able to issue
unsolicited notifications.  This patch implements basic notification
support.

Zero fuse_out_header.unique is now accepted and considered unsolicited
notification and the error field contains notification code.  This
patch doesn't implement any actual notification.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c        |   34 ++++++++++++++++++++++++++++++++--
 include/linux/fuse.h |    4 ++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index b723614..1408b18 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -813,6 +813,21 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 	return err;
 }
 
+static int fuse_handle_notify(struct fuse_conn *fc, enum fuse_notify_code code,
+			      unsigned int size, struct fuse_copy_state *cs)
+{
+	int err;
+
+	switch (code) {
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	fuse_copy_finish(cs);
+	return err;
+}
+
 /* Look up request on processing list by unique ID */
 static struct fuse_req *request_find(struct fuse_conn *fc, u64 unique)
 {
@@ -876,9 +891,24 @@ static ssize_t fuse_dev_write(struct kiocb *iocb, const struct iovec *iov,
 	err = fuse_copy_one(&cs, &oh, sizeof(oh));
 	if (err)
 		goto err_finish;
+
+	if (oh.len != nbytes)
+		goto err_finish;
+
+	/*
+	 * Zero oh.unique indicates unsolicited notification message
+	 * and error contains notification code.
+	 */
+	if (!oh.unique) {
+		err = fuse_handle_notify(fc, oh.error, nbytes - sizeof(oh),
+					 &cs);
+		if (err)
+			return err;
+		return nbytes;
+	}
+
 	err = -EINVAL;
-	if (!oh.unique || oh.error <= -1000 || oh.error > 0 ||
-	    oh.len != nbytes)
+	if (oh.error <= -1000 || oh.error > 0)
 		goto err_finish;
 
 	spin_lock(&fc->lock);
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 608e300..abde994 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -203,6 +203,10 @@ enum fuse_opcode {
 	FUSE_IOCTL         = 39,
 };
 
+enum fuse_notify_code {
+	FUSE_NOTIFY_CODE_MAX,
+};
+
 /* The read buffer is required to be at least 8k, but may be much larger */
 #define FUSE_MIN_READ_BUFFER 8192
 
-- 
1.5.6

