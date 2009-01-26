Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZAZN0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZAZN0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZAZN0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:26:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZAZN0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:26:36 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v7 1/5] create compat_readv()
Date: Mon, 26 Jan 2009 14:26:25 +0100
Message-Id: <1232976389-13021-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
References: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some code from compat_sys_readv() which can be shared with the
upcoming compat_sys_preadv().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 65a070e..75c1b46 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1167,16 +1167,12 @@ out:
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_readv(struct file *file,
+			   const struct compat_iovec __user *vec,
+			   unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
-
 	if (!(file->f_mode & FMODE_READ))
 		goto out;
 
@@ -1184,12 +1180,26 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsign
 	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
 		goto out;
 
-	ret = compat_do_readv_writev(READ, file, vec, vlen, &file->f_pos);
+	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
 
 out:
 	if (ret > 0)
 		add_rchar(current, ret);
 	inc_syscr(current);
+	return ret;
+}
+
+asmlinkage ssize_t
+compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
+		 unsigned long vlen)
+{
+	struct file *file;
+	ssize_t ret;
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_readv(file, vec, vlen, &file->f_pos);
 	fput(file);
 	return ret;
 }
-- 
1.6.1

