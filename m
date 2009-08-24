Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZHXXVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZHXXVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZHXXV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:21:29 -0400
Received: from mx2.netapp.com ([216.240.18.37]:35251 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZHXXV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:21:28 -0400
X-IronPort-AV: E=Sophos;i="4.44,267,1249282800"; 
   d="scan'208";a="230723998"
Subject: [PATCH] NFSv4: Fix an infinite looping problem with the
 nfs4_state_manager
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Daniel J Blueman <daniel.blueman@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 24 Aug 2009 19:21:29 -0400
Message-Id: <1251156089.6325.362.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 24 Aug 2009 23:21:30.0591 (UTC) FILETIME=[9CA066F0:01CA2511]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 76db6d9500caeaa774a3e32a997eba30bbdc176b (nfs41: add session setup
to the state manager) introduces an infinite loop possibility in the NFSv4
state manager. By first checking nfs4_has_session() before clearing the
NFS4CLNT_SESSION_SETUP flag, it allows for a situation where someone sets
that flag, but it never gets cleared, and so the state manager loops.

In fact commit c3fad1b1aaf850bf692642642ace7cd0d64af0a3 (nfs41: add session
reset to state manager) causes this to happen every time we get a network
partition error.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
---

 fs/nfs/nfs4state.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 65ca8c1..1434080 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1250,8 +1250,8 @@ static void nfs4_state_manager(struct nfs_client *clp)
 				continue;
 		}
 		/* Initialize or reset the session */
-		if (nfs4_has_session(clp) &&
-		   test_and_clear_bit(NFS4CLNT_SESSION_SETUP, &clp->cl_state)) {
+		if (test_and_clear_bit(NFS4CLNT_SESSION_SETUP, &clp->cl_state)
+		   && nfs4_has_session(clp)) {
 			if (clp->cl_cons_state == NFS_CS_SESSION_INITING)
 				status = nfs4_initialize_session(clp);
 			else

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
