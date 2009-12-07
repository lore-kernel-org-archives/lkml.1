Return-Path: <linux-kernel-owner+w=401wt.eu-S935661AbZLGWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935661AbZLGWct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934004AbZLGWcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:32:46 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:39652 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861AbZLGWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:32:44 -0500
Subject: Re: linux-next: nfs tree build failure
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Adamson <andros@netapp.com>
In-Reply-To: <20091207192315.7fc0583e.sfr@canb.auug.org.au>
References: <20091207192315.7fc0583e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 17:32:45 -0500
Message-Id: <1260225165.2951.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 5 sum msgs/h 2 total rcpts 1993 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: ACA026BBFDCB14037052700FACB8FC14E217579C
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 32 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 19:23 +1100, Stephen Rothwell wrote: 
> Hi ,
> 
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
> 
> fs/built-in.o: In function `nfs_readpage_retry':
> read.c:(.text+0x79228): undefined reference to `nfs4_restart_rpc'
> fs/built-in.o: In function `nfs_async_unlink_done':
> unlink.c:(.text+0x7a0c0): undefined reference to `nfs4_restart_rpc'
> fs/built-in.o: In function `nfs_writeback_done':
> (.text+0x7b614): undefined reference to `nfs4_restart_rpc'
> 
> Caused by commit e608e79f1bf4b967afcf57777e63b5f0939b00e8 ("nfs41: call
> free slot from nfs4_restart_rpc").  This build is done without
> CONFIG_NFS_V4, so nfs4proc.o is not built.

Hi Stephen,

The following patch (committed today) should fix the above...

Thanks!
  Trond

----------------------------------------------------------------------------------------------- 
NFS: Fix up the declaration of nfs4_restart_rpc when NFSv4 not configured

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Also rename it: it is used in generic code, and so should not have a 'nfs4'
prefix.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/internal.h |   13 ++++++++++++-
 fs/nfs/nfs4proc.c |   25 +++++++------------------
 fs/nfs/read.c     |    2 +-
 fs/nfs/unlink.c   |    2 +-
 fs/nfs/write.c    |    2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index b1a020c..29e464d 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -197,7 +197,6 @@ extern const u32 nfs41_maxwrite_overhead;
 #endif
 
 /* nfs4proc.c */
-extern void nfs4_restart_rpc(struct rpc_task *, const struct nfs_client *);
 #ifdef CONFIG_NFS_V4
 extern struct rpc_procinfo nfs4_procedures[];
 #endif
@@ -367,3 +366,15 @@ unsigned int nfs_page_array_len(unsigned int base, size_t len)
 	return ((unsigned long)len + (unsigned long)base +
 		PAGE_SIZE - 1) >> PAGE_SHIFT;
 }
+
+/*
+ * Helper for restarting RPC calls in the possible presence of NFSv4.1
+ * sessions.
+ */
+static inline void nfs_restart_rpc(struct rpc_task *task, const struct nfs_client *clp)
+{
+	if (nfs4_has_session(clp))
+		rpc_restart_call_prepare(task);
+	else
+		rpc_restart_call(task);
+}
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index fbae2c9..acde776 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -625,17 +625,6 @@ static void nfs4_sequence_done(const struct nfs_server *server,
 #endif /* CONFIG_NFS_V4_1 */
 }
 
-void nfs4_restart_rpc(struct rpc_task *task, const struct nfs_client *clp)
-{
-#ifdef CONFIG_NFS_V4_1
-	if (nfs4_has_session(clp)) {
-		rpc_restart_call_prepare(task);
-		return;
-	}
-#endif /* CONFIG_NFS_V4_1 */
-	rpc_restart_call(task);
-}
-
 static void update_changeattr(struct inode *dir, struct nfs4_change_info *cinfo)
 {
 	struct nfs_inode *nfsi = NFS_I(dir);
@@ -1739,7 +1728,7 @@ static void nfs4_close_done(struct rpc_task *task, void *data)
 				break;
 		default:
 			if (nfs4_async_handle_error(task, server, state) == -EAGAIN) {
-				nfs4_restart_rpc(task, server->nfs_client);
+				nfs_restart_rpc(task, server->nfs_client);
 				return;
 			}
 	}
@@ -2974,7 +2963,7 @@ static int nfs4_read_done(struct rpc_task *task, struct nfs_read_data *data)
 	nfs4_sequence_done(server, &data->res.seq_res, task->tk_status);
 
 	if (nfs4_async_handle_error(task, server, data->args.context->state) == -EAGAIN) {
-		nfs4_restart_rpc(task, server->nfs_client);
+		nfs_restart_rpc(task, server->nfs_client);
 		return -EAGAIN;
 	}
 
@@ -2998,7 +2987,7 @@ static int nfs4_write_done(struct rpc_task *task, struct nfs_write_data *data)
 			   task->tk_status);
 
 	if (nfs4_async_handle_error(task, NFS_SERVER(inode), data->args.context->state) == -EAGAIN) {
-		nfs4_restart_rpc(task, NFS_SERVER(inode)->nfs_client);
+		nfs_restart_rpc(task, NFS_SERVER(inode)->nfs_client);
 		return -EAGAIN;
 	}
 	if (task->tk_status >= 0) {
@@ -3026,7 +3015,7 @@ static int nfs4_commit_done(struct rpc_task *task, struct nfs_write_data *data)
 	nfs4_sequence_done(NFS_SERVER(inode), &data->res.seq_res,
 			   task->tk_status);
 	if (nfs4_async_handle_error(task, NFS_SERVER(inode), NULL) == -EAGAIN) {
-		nfs4_restart_rpc(task, NFS_SERVER(inode)->nfs_client);
+		nfs_restart_rpc(task, NFS_SERVER(inode)->nfs_client);
 		return -EAGAIN;
 	}
 	nfs_refresh_inode(inode, data->res.fattr);
@@ -3737,7 +3726,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 			break;
 		default:
 			if (nfs4_async_handle_error(task, calldata->server, NULL) == -EAGAIN)
-				nfs4_restart_rpc(task,
+				nfs_restart_rpc(task,
 						 calldata->server->nfs_client);
 	}
 }
@@ -4392,7 +4381,7 @@ static void nfs4_get_lease_time_done(struct rpc_task *task, void *calldata)
 		dprintk("%s Retry: tk_status %d\n", __func__, task->tk_status);
 		rpc_delay(task, NFS4_POLL_RETRY_MIN);
 		task->tk_status = 0;
-		nfs4_restart_rpc(task, data->clp);
+		nfs_restart_rpc(task, data->clp);
 		return;
 	}
 	dprintk("<-- %s\n", __func__);
@@ -4854,7 +4843,7 @@ void nfs41_sequence_call_done(struct rpc_task *task, void *data)
 
 		if (_nfs4_async_handle_error(task, NULL, clp, NULL)
 								== -EAGAIN) {
-			nfs4_restart_rpc(task, clp);
+			nfs_restart_rpc(task, clp);
 			return;
 		}
 	}
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index d319bfb..db9b360 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -368,7 +368,7 @@ static void nfs_readpage_retry(struct rpc_task *task, struct nfs_read_data *data
 	argp->offset += resp->count;
 	argp->pgbase += resp->count;
 	argp->count -= resp->count;
-	nfs4_restart_rpc(task, NFS_SERVER(data->inode)->nfs_client);
+	nfs_restart_rpc(task, NFS_SERVER(data->inode)->nfs_client);
 }
 
 /*
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 1064c91..6da3d3f 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -83,7 +83,7 @@ static void nfs_async_unlink_done(struct rpc_task *task, void *calldata)
 	struct inode *dir = data->dir;
 
 	if (!NFS_PROTO(dir)->unlink_done(task, dir))
-		nfs4_restart_rpc(task, NFS_SERVER(dir)->nfs_client);
+		nfs_restart_rpc(task, NFS_SERVER(dir)->nfs_client);
 }
 
 /**
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index d546c60..a28123b 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1216,7 +1216,7 @@ int nfs_writeback_done(struct rpc_task *task, struct nfs_write_data *data)
 				 */
 				argp->stable = NFS_FILE_SYNC;
 			}
-			nfs4_restart_rpc(task, server->nfs_client);
+			nfs_restart_rpc(task, server->nfs_client);
 			return -EAGAIN;
 		}
 		if (time_before(complain, jiffies)) {


