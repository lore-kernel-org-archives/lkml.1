Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbYERWED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbYERWED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYERWDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:03:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:45604 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYERWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ryOU22FM7tcPEgmw70utq1s+QIrbNa/cqB7C32pLJxKMIiyMQ7l2XhiXrYk33JW4oMW6OAZJYtgK/mdDnu/TO4r52WxL6Sf/m3942CtFwT+bIKimLuoODJz+mtciUH7M46uV500MX8dbAbAvy0ufZueoGhOrlU1NA4ln/tJvb74=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] procfs: switch ERR_PTR to ERR_OR_0_PTR when "error" might be 0
Date: Mon, 19 May 2008 00:03:14 +0200
Message-Id: <1211148194-16187-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_pid_follow_link and proc_self_follow_link call ERR_PTR with 0 argument
(invalid errno) in most of situtations.
Replace ERR_PTR calls with ERR_OR_0_PTR which accepts 0 argument.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 808cbdc..ebbb8e6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1292,7 +1292,7 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
 	nd->last_type = LAST_BIND;
 out:
-	return ERR_PTR(error);
+	return ERR_OR_0_PTR(error);
 }
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
@@ -2228,7 +2228,7 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
 	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
-	return ERR_PTR(vfs_follow_link(nd,tmp));
+	return ERR_OR_0_PTR(vfs_follow_link(nd,tmp));
 }
 
 static const struct inode_operations proc_self_inode_operations = {
-- 
1.5.4.5

