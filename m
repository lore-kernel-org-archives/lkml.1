Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYH0N6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYH0N6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYH0Nus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:50:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbYH0Nur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:50:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 44/59] CRED: Wrap task credential accesses in the UBIFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-mtd@lists.infradead.org
Date: Wed, 27 Aug 2008 14:49:29 +0100
Message-ID: <20080827134929.19980.35334.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org
---

 fs/ubifs/budget.c |    2 +-
 fs/ubifs/dir.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 1540981..fd0df9a 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -375,7 +375,7 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
  */
 static int can_use_rp(struct ubifs_info *c)
 {
-	if (current->fsuid == c->rp_uid || capable(CAP_SYS_RESOURCE) ||
+	if (current_fsuid() == c->rp_uid || capable(CAP_SYS_RESOURCE) ||
 	    (c->rp_gid != 0 && in_group_p(c->rp_gid)))
 		return 1;
 	return 0;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 2b267c9..4884f06 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -104,13 +104,13 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, const struct inode *dir,
 	 */
 	inode->i_flags |= (S_NOCMTIME);
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
 			 ubifs_current_time(inode);

