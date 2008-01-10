Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYAJVIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYAJVIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYAJVIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:08:14 -0500
Received: from mx2.netapp.com ([216.240.18.37]:50570 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYAJVIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:08:12 -0500
X-IronPort-AV: E=Sophos;i="4.24,268,1196668800"; 
   d="scan'208";a="142003678"
Subject: NFSv4: Give the lock stateid its own sequence queue
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 10 Jan 2008 16:07:54 -0500
Message-Id: <1199999274.13775.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 10 Jan 2008 21:07:55.0574 (UTC) FILETIME=[DEC1DD60:01C853CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharing the open sequence queue causes a deadlock when we try to take both
a lock sequence id and and open sequence id.

This fixes the regression reported by Dimitri Puzin and Jeff Garzik:
See http://bugzilla.kernel.org/show_bug.cgi?id=9712

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/nfs4_fs.h   |    1 +
 fs/nfs/nfs4state.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index b35069a..bd1b9d6 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -115,6 +115,7 @@ struct nfs4_lock_state {
 #define NFS_LOCK_INITIALIZED 1
 	int			ls_flags;
 	struct nfs_seqid_counter	ls_seqid;
+	struct rpc_sequence	ls_sequence;
 	struct nfs_unique_id	ls_id;
 	nfs4_stateid		ls_stateid;
 	atomic_t		ls_count;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 23a9a36..5a39c6f 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -509,7 +509,10 @@ static struct nfs4_lock_state *nfs4_alloc_lock_state(struct nfs4_state *state, f
 	lsp = kzalloc(sizeof(*lsp), GFP_KERNEL);
 	if (lsp == NULL)
 		return NULL;
-	lsp->ls_seqid.sequence = &state->owner->so_sequence;
+	rpc_init_wait_queue(&lsp->ls_sequence.wait, "lock_seqid_waitqueue");
+	spin_lock_init(&lsp->ls_sequence.lock);
+	INIT_LIST_HEAD(&lsp->ls_sequence.list);
+	lsp->ls_seqid.sequence = &lsp->ls_sequence;
 	atomic_set(&lsp->ls_count, 1);
 	lsp->ls_owner = fl_owner;
 	spin_lock(&clp->cl_lock);
