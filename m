Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbXKOQOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbXKOQOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764345AbXKOQOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:14:16 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:24561 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764278AbXKOQOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:14:14 -0500
Date: Thu, 15 Nov 2007 19:13:25 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: less LOCK operations during lookup
Message-ID: <20071115161325.GF6216@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pseudo-code for lookup effectively is:

	LOCK kernel
	LOCK proc_subdir_lock
		find PDE
		UNLOCK proc_subdir_lock

		get inode

		LOCK proc_subdir_lock
		goto unlock
	UNLOCK proc_subdir_lock
	UNLOCK kernel

We can get rid of LOCK/UNLOCK pair after getting inode simply by jumping
to unlock_kernel() directly.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -403,12 +403,12 @@ struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nam
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
 				inode = proc_get_inode(dir->i_sb, ino, de);
-				spin_lock(&proc_subdir_lock);
-				break;
+				goto out_unlock;
 			}
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
+out_unlock:
 	unlock_kernel();
 
 	if (inode) {

