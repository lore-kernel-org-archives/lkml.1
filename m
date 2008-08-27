Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbYH0Nz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbYH0Nz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYH0Nte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbYH0Ntb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 42/59] CRED: Wrap task credential accesses in the SMBFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Steven French <sfrench@us.ibm.com>
Date: Wed, 27 Aug 2008 14:49:19 +0100
Message-ID: <20080827134918.19980.78709.stgit@warthog.procyon.org.uk>
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
Cc: Steven French <sfrench@us.ibm.com>
---

 fs/smbfs/dir.c   |    4 ++--
 fs/smbfs/inode.c |    2 +-
 fs/smbfs/proc.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 48da4fa..9e9bb0d 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -667,8 +667,8 @@ smb_make_node(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 	attr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID;
 	attr.ia_mode = mode;
-	attr.ia_uid = current->euid;
-	attr.ia_gid = current->egid;
+	attr.ia_uid = current_euid();
+	attr.ia_gid = current_egid();
 
 	if (!new_valid_dev(dev))
 		return -EINVAL;
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 3528f40..fc27fbf 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -586,7 +586,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 		if (parse_options(mnt, raw_data))
 			goto out_bad_option;
 	}
-	mnt->mounted_uid = current->uid;
+	mnt->mounted_uid = current_uid();
 	smb_setcodepage(server, &mnt->codepage);
 
 	/*
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index ee536e8..9468168 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -864,7 +864,7 @@ smb_newconn(struct smb_sb_info *server, struct smb_conn_opt *opt)
 		goto out;
 
 	error = -EACCES;
-	if (current->uid != server->mnt->mounted_uid && 
+	if (current_uid() != server->mnt->mounted_uid &&
 	    !capable(CAP_SYS_ADMIN))
 		goto out;
 

