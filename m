Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXE3VbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXE3VbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbXE3VbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:31:00 -0400
Received: from mx2.netapp.com ([216.240.18.37]:58882 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbXE3Va7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:30:59 -0400
X-IronPort-AV: E=Sophos;i="4.14,594,1170662400"; 
   d="scan'208";a="64689941"
Subject: [GIT] Please pull one more NFS client fix...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 30 May 2007 17:30:39 -0400
Message-Id: <1180560639.6770.58.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 30 May 2007 21:30:40.0606 (UTC) FILETIME=[C56F77E0:01C7A301]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "fixes" branch of the repository at

   git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git fixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/direct.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

commit b4946ffb1860597b187d78d61ac6504177eb0ff8
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed May 30 12:58:00 2007 -0400

    NFS: Fix a refcount leakage in O_DIRECT
    
    The current code is leaking a reference to dreq->kref when the calls to
    nfs_direct_read_schedule() and nfs_direct_write_schedule() return an
    error.
    This patch moves the call to kref_put() from nfs_direct_wait() back into
    nfs_direct_read() and nfs_direct_write() (which are the functions that
    actually took the reference in the first place) fixing the leak.
    
    Thanks to Denis V. Lunev for spotting the bug and proposing the original
    fix.
    
    Acked-by: Denis V. Lunev <dlunev@gmail.com>
    Acked-by: Chuck Lever <chuck.lever@oracle.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0c542ec..00eee87 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -168,7 +168,7 @@ static inline struct nfs_direct_req *nfs_direct_req_alloc(void)
 	return dreq;
 }
 
-static void nfs_direct_req_release(struct kref *kref)
+static void nfs_direct_req_free(struct kref *kref)
 {
 	struct nfs_direct_req *dreq = container_of(kref, struct nfs_direct_req, kref);
 
@@ -177,6 +177,11 @@ static void nfs_direct_req_release(struct kref *kref)
 	kmem_cache_free(nfs_direct_cachep, dreq);
 }
 
+static void nfs_direct_req_release(struct nfs_direct_req *dreq)
+{
+	kref_put(&dreq->kref, nfs_direct_req_free);
+}
+
 /*
  * Collects and returns the final error value/byte-count.
  */
@@ -196,7 +201,6 @@ static ssize_t nfs_direct_wait(struct nfs_direct_req *dreq)
 		result = dreq->count;
 
 out:
-	kref_put(&dreq->kref, nfs_direct_req_release);
 	return (ssize_t) result;
 }
 
@@ -214,7 +218,7 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 	}
 	complete_all(&dreq->completion);
 
-	kref_put(&dreq->kref, nfs_direct_req_release);
+	nfs_direct_req_release(dreq);
 }
 
 /*
@@ -369,6 +373,7 @@ static ssize_t nfs_direct_read(struct kiocb *iocb, unsigned long user_addr, size
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	rpc_clnt_sigunmask(clnt, &oldset);
+	nfs_direct_req_release(dreq);
 
 	return result;
 }
@@ -716,6 +721,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, unsigned long user_addr, siz
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	rpc_clnt_sigunmask(clnt, &oldset);
+	nfs_direct_req_release(dreq);
 
 	return result;
 }
