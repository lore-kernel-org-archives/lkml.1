Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYAPDLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYAPDLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYAPDLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:11:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:4820 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386AbYAPDLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eXlpvKG5sbRuHQK4fpnmgbzU2j8OEyFSvqMTE/BK0gGPjIMyqFCwaFstF7eTytDma/9yw5aQ8NAbO/iPpOMAc/FNOHyJ3Pj1BTWkPdYdb5+xsGyqX45QukH95Lsr58+5R+vE/G50VZZwoth8CLDgkYP9YIOpEXOCWlFkkrrI4Ok=
Message-ID: <478D75BD.1010805@gmail.com>
Date: Wed, 16 Jan 2008 12:10:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in sysfs_rename/move_dir()
References: <478D74A6.7000206@gmail.com>
In-Reply-To: <478D74A6.7000206@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_rename/move_dir() have the following bugs.

* On dentry lookup failure, kfree() is called on ERR_PTR() value.
* sysfs_move_dir() has an extra dput() on success path.

Fix them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c
+++ work/fs/sysfs/dir.c
@@ -783,6 +783,7 @@ int sysfs_rename_dir(struct kobject * ko
 	old_dentry = sysfs_get_dentry(sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
+		old_dentry = NULL;
 		goto out;
 	}
 
@@ -850,6 +851,7 @@ int sysfs_move_dir(struct kobject *kobj,
 	old_dentry = sysfs_get_dentry(sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
+		old_dentry = NULL;
 		goto out;
 	}
 	old_parent = old_dentry->d_parent;
@@ -857,6 +859,7 @@ int sysfs_move_dir(struct kobject *kobj,
 	new_parent = sysfs_get_dentry(new_parent_sd);
 	if (IS_ERR(new_parent)) {
 		error = PTR_ERR(new_parent);
+		new_parent = NULL;
 		goto out;
 	}
 
@@ -880,7 +883,6 @@ again:
 	error = 0;
 	d_add(new_dentry, NULL);
 	d_move(old_dentry, new_dentry);
-	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
 	sysfs_unlink_sibling(sd);
