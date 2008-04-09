Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYDIBLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYDIBLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 21:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYDIBLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 21:11:32 -0400
Received: from mx2.netapp.com ([216.240.18.37]:63919 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYDIBLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 21:11:31 -0400
X-IronPort-AV: E=Sophos;i="4.25,626,1199692800"; 
   d="scan'208";a="25288721"
Subject: [GIT] Please pull NFS client fixes against linux-2.6.25-rc8
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 08 Apr 2008 21:10:14 -0400
Message-Id: <1207703414.21370.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 09 Apr 2008 01:10:15.0956 (UTC) FILETIME=[7843D540:01C899DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "hotfixes" branch of the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git hotfixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/file.c     |    4 ++++
 fs/nfs/inode.c    |    1 +
 net/sunrpc/clnt.c |    4 ----
 net/sunrpc/xdr.c  |    9 ++++++---
 4 files changed, 11 insertions(+), 7 deletions(-)

commit ed13c27e546667fb0967ae30f5070cd7f6455f90
Author: Chuck Lever <chuck.lever@oracle.com>
Date:   Mon Apr 7 16:52:44 2008 -0400

    SUNRPC: Fix a memory leak in rpc_create()
    
    Commit 510deb0d was supposed to move the xprt_create_transport() call in
    rpc_create(), but neglected to remove the old call site.  This resulted in
    a transport leak after every rpc_create() call.
    
    This leak is present in 2.6.24 and 2.6.25.
    
    Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 240ee831187e000704cba3208ef6b0a8ad49bd64
Author: Bryan Wu <cooloney@kernel.org>
Date:   Tue Apr 1 20:23:39 2008 -0700

    fix bug - executing FDPIC ELF on NFS mount triggers BUG() at mm/nommu.c:862:/do_mmap_private()
    
    NFS needs a NOMMU version mmap function to support uClinux on NOMMU machine
    http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=3992
    
    Signed-off-by: Bryan Wu <cooloney@kernel.org>
    Cc: Mike Frysinger <vapier.adi@gmail.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 66d3aac04175c35564cc5982934b68bc4f89a76d
Author: Jeff Layton <jlayton@redhat.com>
Date:   Mon Mar 31 15:01:58 2008 -0400

    NFS: initialize flags field in nfs_open_context
    
    The nfs_open_context struct had a "flags" field added recently, but the
    allocator isn't initializing it. It also looks like the allocator isn't
    initializing the mode or list either, but they seem to be overwritten
    by the caller, so that's less of an issue.
    
    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit daeba89d43af0fa469d38a4ccdc32fff8ca17c2e
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon Mar 31 17:02:02 2008 -0400

    SUNRPC: don't call flush_dcache_page() with an invalid pointer
    
    Fix a problem in _copy_to_pages(), whereby it may call flush_dcache_page()
    with an invalid pointer due to the fact that 'pgto' gets incremented
    beyond the end of the page array. Fix is to exit the loop without this
    unnecessary increment of pgto.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index ef57a5a..5d2e9d9 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -64,7 +64,11 @@ const struct file_operations nfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= nfs_file_read,
 	.aio_write	= nfs_file_write,
+#ifdef CONFIG_MMU
 	.mmap		= nfs_file_mmap,
+#else
+	.mmap		= generic_file_mmap,
+#endif
 	.open		= nfs_file_open,
 	.flush		= nfs_file_flush,
 	.release	= nfs_file_release,
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index a4c7cf2..6f88d7c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -506,6 +506,7 @@ static struct nfs_open_context *alloc_nfs_open_context(struct vfsmount *mnt, str
 		ctx->cred = get_rpccred(cred);
 		ctx->state = NULL;
 		ctx->lockowner = current->files;
+		ctx->flags = 0;
 		ctx->error = 0;
 		ctx->dir_cookie = 0;
 		atomic_set(&ctx->count, 1);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 8c6a7f1..8834d68 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -261,10 +261,6 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *args)
 	};
 	char servername[48];
 
-	xprt = xprt_create_transport(&xprtargs);
-	if (IS_ERR(xprt))
-		return (struct rpc_clnt *)xprt;
-
 	/*
 	 * If the caller chooses not to specify a hostname, whip
 	 * up a string representation of the passed-in address.
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 995c3fd..79a55d5 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -244,7 +244,7 @@ _copy_to_pages(struct page **pages, size_t pgbase, const char *p, size_t len)
 	pgto = pages + (pgbase >> PAGE_CACHE_SHIFT);
 	pgbase &= ~PAGE_CACHE_MASK;
 
-	do {
+	for (;;) {
 		copy = PAGE_CACHE_SIZE - pgbase;
 		if (copy > len)
 			copy = len;
@@ -253,6 +253,10 @@ _copy_to_pages(struct page **pages, size_t pgbase, const char *p, size_t len)
 		memcpy(vto + pgbase, p, copy);
 		kunmap_atomic(vto, KM_USER0);
 
+		len -= copy;
+		if (len == 0)
+			break;
+
 		pgbase += copy;
 		if (pgbase == PAGE_CACHE_SIZE) {
 			flush_dcache_page(*pgto);
@@ -260,8 +264,7 @@ _copy_to_pages(struct page **pages, size_t pgbase, const char *p, size_t len)
 			pgto++;
 		}
 		p += copy;
-
-	} while ((len -= copy) != 0);
+	}
 	flush_dcache_page(*pgto);
 }
 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
