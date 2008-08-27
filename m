Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbYH0N4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbYH0N4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYH0Ntk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbYH0Nth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 41/59] CRED: Wrap task credential accesses in the ReiserFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, reiserfs-devel@vger.kernel.org
Date: Wed, 27 Aug 2008 14:49:13 +0100
Message-ID: <20080827134913.19980.39495.stgit@warthog.procyon.org.uk>
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
Cc: reiserfs-devel@vger.kernel.org
---

 fs/reiserfs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index f89ebb9..4f322e5 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -573,7 +573,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 	/* the quota init calls have to know who to charge the quota to, so
 	 ** we have to set uid and gid here
 	 */
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	inode->i_mode = mode;
 	/* Make inode invalid - just in case we are going to drop it before
 	 * the initialization happens */
@@ -584,7 +584,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else {
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	}
 	DQUOT_INIT(inode);
 	return 0;

