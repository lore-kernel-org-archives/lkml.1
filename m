Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbZLGIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbZLGIXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZLGIXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:23:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56675 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962AbZLGIXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:23:11 -0500
Date: Mon, 7 Dec 2009 19:23:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Adamson <andros@netapp.com>
Subject: linux-next: nfs tree build failure
Message-Id: <20091207192315.7fc0583e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

fs/built-in.o: In function `nfs_readpage_retry':
read.c:(.text+0x79228): undefined reference to `nfs4_restart_rpc'
fs/built-in.o: In function `nfs_async_unlink_done':
unlink.c:(.text+0x7a0c0): undefined reference to `nfs4_restart_rpc'
fs/built-in.o: In function `nfs_writeback_done':
(.text+0x7b614): undefined reference to `nfs4_restart_rpc'

Caused by commit e608e79f1bf4b967afcf57777e63b5f0939b00e8 ("nfs41: call
free slot from nfs4_restart_rpc").  This build is done without
CONFIG_NFS_V4, so nfs4proc.o is not built.

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Dec 2009 19:14:54 +1100
Subject: [PATCH] nfs: fixup for non NFS_V4 build

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nfs/internal.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index b1a020c..23f1fd2 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -197,9 +197,15 @@ extern const u32 nfs41_maxwrite_overhead;
 #endif
 
 /* nfs4proc.c */
-extern void nfs4_restart_rpc(struct rpc_task *, const struct nfs_client *);
 #ifdef CONFIG_NFS_V4
+extern void nfs4_restart_rpc(struct rpc_task *, const struct nfs_client *);
 extern struct rpc_procinfo nfs4_procedures[];
+#else
+static inline void nfs4_restart_rpc(struct rpc_task *task,
+		const struct nfs_client *client)
+{
+	rpc_restart_call(task);
+}
 #endif
 
 /* proc.c */
-- 
1.6.5.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
