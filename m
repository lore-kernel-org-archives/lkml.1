Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752603AbYLSP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYLSP7q (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 19 Dec 2008 10:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYLSP6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:58:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYLSP6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:58:35 -0500
From: y@redhat.com
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [Patch v5 3/6] create compat_writev()
Date: Fri, 19 Dec 2008 16:58:22 +0100
Message-Id: <1229702305-23027-4-git-send-email-y>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
References: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 361cb7d..1ca314f 100644
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
1.5.6.5

