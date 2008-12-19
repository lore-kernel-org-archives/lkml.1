Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751434AbYLSQAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbYLSQAd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 19 Dec 2008 11:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYLSP6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:58:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYLSP6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:58:35 -0500
From: y@redhat.com
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [Patch v5 6/6] switch compat readv/preadv/writev/pwritev from fget to fget_light
Date: Fri, 19 Dec 2008 16:58:25 +0100
Message-Id: <1229702305-23027-7-git-send-email-y>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
References: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>


Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 4e1fa33..8d48705 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1192,13 +1192,14 @@ asmlinkage ssize_t
 compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_readv(file, vec, vlen, &file->f_pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1208,15 +1209,16 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_readv(file, vec, vlen, &pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1245,13 +1247,14 @@ asmlinkage ssize_t
 compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &file->f_pos);
-        fput(file);
+        fput_light(file, fput_needed);
         return ret;
 }
 
@@ -1261,15 +1264,16 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
-- 
1.5.6.5

