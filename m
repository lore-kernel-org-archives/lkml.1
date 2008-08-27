Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYH0OBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYH0OBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbYH0Nva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbYH0Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/59] CRED: Wrap task credential accesses in the autofs4
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Ian Kent <raven@themaw.net>,
       autofs@linux.kernel.org
Date: Wed, 27 Aug 2008 14:47:09 +0100
Message-ID: <20080827134709.19980.94497.stgit@warthog.procyon.org.uk>
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
Cc: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org
---

 fs/autofs4/inode.c |    4 ++--
 fs/autofs4/waitq.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 7bb3e5b..8c9cf24 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -233,8 +233,8 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	*uid = current->uid;
-	*gid = current->gid;
+	*uid = current_uid();
+	*gid = current_gid();
 	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 35216d1..dc1fa39 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -391,8 +391,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		memcpy(&wq->name, &qstr, sizeof(struct qstr));
 		wq->dev = autofs4_get_dev(sbi);
 		wq->ino = autofs4_get_ino(sbi);
-		wq->uid = current->uid;
-		wq->gid = current->gid;
+		wq->uid = current_uid();
+		wq->gid = current_gid();
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */

