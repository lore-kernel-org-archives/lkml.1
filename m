Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbZIQTk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbZIQTk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZIQTkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:40:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZIQTkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:40:25 -0400
Date: Thu, 17 Sep 2009 21:40:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: a.p.zijlstra@chello.nl, trond.myklebust@fys.uio.no
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090917194027.GS23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917124233.GJ23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17 2009, Jens Axboe wrote:
> Hi,
> 
> This can cause a hang on NFS umount, since the bdi gets pruned before we
> flush any pending dirty IO. Peter, can you check whether it fixes your
> issue?

There's another problem with NFS && backing devices. NFS may call
bdi_destroy() on a bdi without ever called bdi_init(). This was always a
bad idea, now it's an issue.

So, Trond, can I safely add a server->flags private flag to indicate
that we have called bdi_init()? Then nfs_free_server() knows when to
call bdi_destroy(). Seems like the safest fix, since error handling is
currently 'just call nfs_free_server()'.

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e350bd6..8ffee33 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -936,6 +936,7 @@ static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, str
 	error = bdi_init(&server->backing_dev_info);
 	if (error)
 		goto out_error;
+	server->flags |= NFS_MOUNT_BDI_INITED;
 
 
 	/* Get some general file system info */
@@ -1021,7 +1022,8 @@ void nfs_free_server(struct nfs_server *server)
 	nfs_put_client(server->nfs_client);
 
 	nfs_free_iostats(server->io_stats);
-	bdi_destroy(&server->backing_dev_info);
+	if (server->flags & NFS_MOUNT_BDI_INITED)
+		bdi_destroy(&server->backing_dev_info);
 	kfree(server);
 	nfs_release_automount_timer();
 	dprintk("<-- nfs_free_server()\n");
diff --git a/include/linux/nfs_mount.h b/include/linux/nfs_mount.h
index 4499016..842ef74 100644
--- a/include/linux/nfs_mount.h
+++ b/include/linux/nfs_mount.h
@@ -69,5 +69,6 @@ struct nfs_mount_data {
 #define NFS_MOUNT_LOOKUP_CACHE_NONEG	0x10000
 #define NFS_MOUNT_LOOKUP_CACHE_NONE	0x20000
 #define NFS_MOUNT_NORESVPORT		0x40000
+#define NFS_MOUNT_BDI_INITED		0x80000
 
 #endif

-- 
Jens Axboe

