Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbZDHHF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbZDHHF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761691AbZDHHFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:05:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61876 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761901AbZDHHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:05:32 -0400
Message-ID: <49DC4CE4.5080306@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:06:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] xattr: use memdup_user()
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
 fs/xattr.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 197c4fc..d51b8f9 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -237,13 +237,9 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = kmalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
-		if (copy_from_user(kvalue, value, size)) {
-			kfree(kvalue);
-			return -EFAULT;
-		}
+		kvalue = memdup_user(value, size);
+		if (IS_ERR(kvalue))
+			return PTR_ERR(kvalue);
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
-- 
1.5.4.rc3


