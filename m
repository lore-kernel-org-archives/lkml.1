Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbZAZN2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbZAZN2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZAZN0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:26:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZAZN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:26:37 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v7 5/5] switch compat readv/preadv/writev/pwritev from fget to fget_light
Date: Mon, 26 Jan 2009 14:26:29 +0100
Message-Id: <1232976389-13021-6-git-send-email-kraxel@redhat.com>
In-Reply-To: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
References: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 1a67eee..ad442ec 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1194,13 +1194,14 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 		 unsigned long vlen)
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
 
@@ -1210,15 +1211,16 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
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
 
@@ -1249,13 +1251,14 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 		  unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &file->f_pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1265,15 +1268,16 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
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
1.6.1

