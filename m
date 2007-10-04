Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXJDCkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXJDCkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbXJDCk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:40:29 -0400
Received: from uni21mr.unity.ncsu.edu ([152.1.2.137]:35811 "EHLO
	uni21mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXJDCk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:40:28 -0400
Message-ID: <47045299.2000601@ncsu.edu>
Date: Wed, 03 Oct 2007 22:40:25 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Code style fix for open_exec
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.313940, Antispam-Data: 2007.10.3.191541
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From d2a6c5d29dc34cfea892124ab72b4eb55d2f8a80 Mon Sep 17 00:00:00 2001
From: Casey Dahlin <cjdahlin@ncsu.edu>
Date: Wed, 3 Oct 2007 22:01:49 -0400
Subject: [PATCH] Code style fix for open_exec

Fix a horribly mangled 5 level indent and severe abuse of goto in the 
open_exec
function.

Signed-off-by: Casey Dahlin <cjdahlin@ncsu.edu>

diff --git a/fs/exec.c b/fs/exec.c
index c21a8cc..d73da5a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -676,32 +676,32 @@ struct file *open_exec(const char *name)
     struct file *file;
 
     err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd, 
FMODE_READ|FMODE_EXEC);
+
+    if (err) return ERR_PTR(err);
+
+    file = ERR_PTR(-EACCES);
+    if ((nd.mnt->mnt_flags & MNT_NOEXEC) ||
+            !S_ISREG(nd.dentry->d_inode->i_mode))
+        goto fail;
+
+    err = vfs_permission(&nd, MAY_EXEC);
     file = ERR_PTR(err);
+    if (err) goto fail;
 
-    if (!err) {
-        struct inode *inode = nd.dentry->d_inode;
-        file = ERR_PTR(-EACCES);
-        if (!(nd.mnt->mnt_flags & MNT_NOEXEC) &&
-            S_ISREG(inode->i_mode)) {
-            int err = vfs_permission(&nd, MAY_EXEC);
-            file = ERR_PTR(err);
-            if (!err) {
-                file = nameidata_to_filp(&nd, O_RDONLY);
-                if (!IS_ERR(file)) {
-                    err = deny_write_access(file);
-                    if (err) {
-                        fput(file);
-                        file = ERR_PTR(err);
-                    }
-                }
-out:
-                return file;
-            }
-        }
-        release_open_intent(&nd);
-        path_release(&nd);
+    file = nameidata_to_filp(&nd, O_RDONLY);
+    if (IS_ERR(file)) return file;
+
+    err = deny_write_access(file);
+    if (err) {
+        fput(file);
+        file = ERR_PTR(err);
     }
-    goto out;
+
+    return file;
+fail:
+    release_open_intent(&nd);
+    path_release(&nd);
+    return file;
 }
 
 EXPORT_SYMBOL(open_exec);
