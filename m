Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbZDHHHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbZDHHHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbZDHHH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:07:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53699 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762128AbZDHHH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:07:26 -0400
Message-ID: <49DC4D54.3020001@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:08:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: felixb@sgi.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com
Subject: [PATCH 4/6] xfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
In-Reply-To: <49DC4CC0.9050805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++++----------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |   12 ++++--------
 2 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index d0b4994..34eaab6 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -489,17 +489,12 @@ xfs_attrmulti_attr_set(
 	if (len > XATTR_SIZE_MAX)
 		return EINVAL;
 
-	kbuf = kmalloc(len, GFP_KERNEL);
-	if (!kbuf)
-		return ENOMEM;
-
-	if (copy_from_user(kbuf, ubuf, len))
-		goto out_kfree;
+	kbuf = memdup_user(ubuf, len);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
 
 	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
 
- out_kfree:
-	kfree(kbuf);
 	return error;
 }
 
@@ -540,20 +535,16 @@ xfs_attrmulti_by_handle(
 	if (!size || size > 16 * PAGE_SIZE)
 		goto out_dput;
 
-	error = ENOMEM;
-	ops = kmalloc(size, GFP_KERNEL);
-	if (!ops)
+	ops = memdup_user(am_hreq.ops, size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
 		goto out_dput;
-
-	error = EFAULT;
-	if (copy_from_user(ops, am_hreq.ops, size))
-		goto out_kfree_ops;
+	}
 
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
 
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		ops[i].am_error = strncpy_from_user(attr_name,
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index c70c4e3..0882d16 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -427,20 +427,16 @@ xfs_compat_attrmulti_by_handle(
 	if (!size || size > 16 * PAGE_SIZE)
 		goto out_dput;
 
-	error = ENOMEM;
-	ops = kmalloc(size, GFP_KERNEL);
-	if (!ops)
+	ops = memdup_user(compat_ptr(am_hreq.ops), size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
 		goto out_dput;
-
-	error = EFAULT;
-	if (copy_from_user(ops, compat_ptr(am_hreq.ops), size))
-		goto out_kfree_ops;
+	}
 
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
 
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		ops[i].am_error = strncpy_from_user(attr_name,
-- 
1.5.4.rc3


