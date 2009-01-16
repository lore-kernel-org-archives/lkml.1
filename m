Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbZAPQq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbZAPQq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbZAPQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:45:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZAPQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:45:58 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 2/5] create compat_writev()
Date: Fri, 16 Jan 2009 17:45:41 +0100
Message-Id: <1232124344-25892-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 63738cc..9f20d10 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1202,15 +1202,11 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsign
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_writev(struct file *file, const struct compat_iovec __user *vec,
+                            unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out;
 
@@ -1218,16 +1214,29 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsig
 	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
 		goto out;
 
-	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
+	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 
 out:
 	if (ret > 0)
 		add_wchar(current, ret);
 	inc_syscw(current);
-	fput(file);
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+{
+	struct file *file;
+	ssize_t ret;
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_writev(file, vec, vlen, &file->f_pos);
+        fput(file);
+        return ret;
+}
+
 asmlinkage long
 compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
 		    unsigned int nr_segs, unsigned int flags)
-- 
1.6.1

