Return-Path: <linux-kernel-owner+w=401wt.eu-S965452AbXD1HYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbXD1HYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXD1HYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:24:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:9987 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965452AbXD1HYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=ImPgBjs9bi5MXObvADVmxKGIOhIQIXxxO4w9typCYYdMsRBmHtB5+b7qCjATGu3oCwSDcCFzbb+xdUoXKGloGely5L6TGArvTzkMrrnxxKAKB6IXt7hB9nYR+QdYP77zWreDPaYEz+9xhgg+tSOXZPGlVIKveVPWX6hb0gIw9CI=
Date: Sat, 28 Apr 2007 16:18:49 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH] sunrpc: fix error path in module_init
Message-ID: <20070428071849.GA9545@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes error code paths in sunrpc.

register_rpc_pipefs() needs to clean up rpc_inode_cache
by kmem_cache_destroy() on register_filesystem() failure.

init_sunrpc() needs to unregister rpc_pipe_fs by unregister_rpc_pipefs()
when rpc_init_mempool() returns error.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 net/sunrpc/rpc_pipe.c    |    9 ++++++++-
 net/sunrpc/sunrpc_syms.c |    6 ++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

Index: 2.6-mm/net/sunrpc/rpc_pipe.c
===================================================================
--- 2.6-mm.orig/net/sunrpc/rpc_pipe.c
+++ 2.6-mm/net/sunrpc/rpc_pipe.c
@@ -845,6 +845,8 @@ init_once(void * foo, struct kmem_cache 
 
 int register_rpc_pipefs(void)
 {
+	int err;
+
 	rpc_inode_cachep = kmem_cache_create("rpc_inode_cache",
 				sizeof(struct rpc_inode),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
@@ -852,7 +854,12 @@ int register_rpc_pipefs(void)
 				init_once, NULL);
 	if (!rpc_inode_cachep)
 		return -ENOMEM;
-	register_filesystem(&rpc_pipe_fs_type);
+	err = register_filesystem(&rpc_pipe_fs_type);
+	if (err) {
+		kmem_cache_destroy(rpc_inode_cachep);
+		return err;
+	}
+
 	return 0;
 }
 
Index: 2.6-mm/net/sunrpc/sunrpc_syms.c
===================================================================
--- 2.6-mm.orig/net/sunrpc/sunrpc_syms.c
+++ 2.6-mm/net/sunrpc/sunrpc_syms.c
@@ -146,9 +146,11 @@ init_sunrpc(void)
 	int err = register_rpc_pipefs();
 	if (err)
 		goto out;
-	err = rpc_init_mempool() != 0;
-	if (err)
+	err = rpc_init_mempool();
+	if (err) {
+		unregister_rpc_pipefs();
 		goto out;
+	}
 #ifdef RPC_DEBUG
 	rpc_register_sysctl();
 #endif
