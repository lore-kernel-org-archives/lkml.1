Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYEUBGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYEUBGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYEUBGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:06:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48401 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYEUBGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:06:33 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ecryptfs fixes
Cc: mhalcrow@us.ibm.com, linux-kernel@vger.kernel.org
Message-Id: <E1Jycml-0008IW-Kv@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:06:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 2206
Lines: 71

memcpy() from userland pointer is a Bad Thing(tm)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ecryptfs/miscdev.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 6560da1..50c994a 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -243,7 +243,6 @@ ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 	struct ecryptfs_daemon *daemon;
 	struct ecryptfs_msg_ctx *msg_ctx;
 	size_t packet_length_size;
-	u32 counter_nbo;
 	char packet_length[3];
 	size_t i;
 	size_t total_length;
@@ -328,20 +327,18 @@ check_list:
 		       "pending message\n", __func__, count, total_length);
 		goto out_unlock_msg_ctx;
 	}
-	i = 0;
-	buf[i++] = msg_ctx->type;
-	counter_nbo = cpu_to_be32(msg_ctx->counter);
-	memcpy(&buf[i], (char *)&counter_nbo, 4);
-	i += 4;
+	rc = -EFAULT;
+	if (put_user(msg_ctx->type, buf))
+		goto out_unlock_msg_ctx;
+	if (put_user(cpu_to_be32(msg_ctx->counter), (__be32 __user *)(buf + 1)))
+		goto out_unlock_msg_ctx;
+	i = 5;
 	if (msg_ctx->msg) {
-		memcpy(&buf[i], packet_length, packet_length_size);
+		if (copy_to_user(&buf[i], packet_length, packet_length_size))
+			goto out_unlock_msg_ctx;
 		i += packet_length_size;
-		rc = copy_to_user(&buf[i], msg_ctx->msg, msg_ctx->msg_size);
-		if (rc) {
-			printk(KERN_ERR "%s: copy_to_user returned error "
-			       "[%d]\n", __func__, rc);
+		if (copy_to_user(&buf[i], msg_ctx->msg, msg_ctx->msg_size))
 			goto out_unlock_msg_ctx;
-		}
 		i += msg_ctx->msg_size;
 	}
 	rc = i;
@@ -452,7 +449,8 @@ static ssize_t
 ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 		       size_t count, loff_t *ppos)
 {
-	u32 counter_nbo, seq;
+	__be32 counter_nbo;
+	u32 seq;
 	size_t packet_size, packet_size_length, i;
 	ssize_t sz = 0;
 	char *data;
@@ -485,7 +483,7 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 			       count);
 			goto out_free;
 		}
-		memcpy((char *)&counter_nbo, &data[i], 4);
+		memcpy(&counter_nbo, &data[i], 4);
 		seq = be32_to_cpu(counter_nbo);
 		i += 4;
 		rc = ecryptfs_parse_packet_length(&data[i], &packet_size,
-- 
1.5.3.GIT


