Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0CJDXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:23:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0CJDXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:23:15 -0500
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: torvalds@linux-foundation.org, sds@tycho.nsa.gov, viro@ZenIV.linux.org.uk,
       jmorris@namei.org
Subject: [PATCH] anon_inodes: mark the anon inode private
Date: Tue,  9 Mar 2010 22:23:01 -0500
Message-Id: <1268191381-26950-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inotify was switched to use anon_inode instead of its own private filesystem
which only had one inode in commit c44dcc56d2b5c7 "switch inotify_user to
anon_inode"

The problem with this is that now the inotify inode is not a distinct inode
which can be managed by LSMs.  userspace tools which use inotify were allowed
to use the inotify inode but may not have had permission to do read/write type
operations on the anon_inode.  After looking at the anon_inode and its users
it looks like the best solution is to just mark the anon_inode as S_PRIVATE
so the security system will ignore it.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/anon_inodes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 9f0bf13..2de0095 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -209,6 +209,7 @@ static struct inode *anon_inode_mkinode(void)
 	inode->i_mode = S_IRUSR | S_IWUSR;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
+	inode->i_flags |= S_PRIVATE;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	return inode;
 }
-- 
1.6.5.3

