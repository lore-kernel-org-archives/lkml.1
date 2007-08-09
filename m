Return-Path: <linux-kernel-owner+w=401wt.eu-S939067AbXHIJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939067AbXHIJ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938491AbXHIJ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:07 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38927 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbXHIJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:05 -0400
Message-Id: <20070809092455.212609837@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:48 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/9] VFS: check nanoseconds in utimensat
Content-Disposition: inline; filename=utimens_check_fix.patch
CC: Ulrich Drepper <drepper@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

utimensat() (and possibly other callers of do_utimes()) didn't check
if the nanosecond value was within the allowed range.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/utimes.c
===================================================================
--- linux.orig/fs/utimes.c	2007-08-09 11:01:30.000000000 +0200
+++ linux/fs/utimes.c	2007-08-09 11:04:19.000000000 +0200
@@ -38,6 +38,14 @@ asmlinkage long sys_utime(char __user *f
 
 #endif
 
+static bool nsec_valid(long nsec)
+{
+	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
+		return true;
+
+	return nsec >= 0 && nsec <= 999999999;
+}
+
 /* If times==NULL, set access and modification to current time,
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
@@ -52,6 +60,11 @@ long do_utimes(int dfd, char __user *fil
 	struct file *f = NULL;
 
 	error = -EINVAL;
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		goto out;
+	}
+
 	if (flags & ~AT_SYMLINK_NOFOLLOW)
 		goto out;
 

--
