Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbXKMRg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbXKMRg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXKMRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:36:18 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:64344 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbXKMRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:36:17 -0500
Date: Tue, 13 Nov 2007 09:34:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>, steved@redhat.com
Cc: trond.myklebust@fys.uio.no,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] nfs functions undefined [Was: mm snapshot
 broken-out-2007-11-13-04-14.tar.gz uploaded]
Message-Id: <20071113093442.bc2554c6.randy.dunlap@oracle.com>
In-Reply-To: <47399DA8.2060501@gmail.com>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
	<47399DA8.2060501@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 13:50:48 +0100 Jiri Slaby wrote:

> On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
> 
> ERROR: "nfs_put_super" [fs/nfs/nfs.ko] undefined!
> ERROR: "nfs_sb_deactive" [fs/nfs/nfs.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> 
> config:
> http://www.fi.muni.cz/~xslaby/sklad/config_64



From: Randy Dunlap <randy.dunlap@oracle.com>

nfs_put_super() and nfs_sb_deactive() should not be inside an
ifdef CONFIG_NFS_V4 block.

ERROR: "nfs_put_super" [fs/nfs/nfs.ko] undefined!
ERROR: "nfs_sb_deactive" [fs/nfs/nfs.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/nfs/super.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- linux-2624-rc2-mmbo.orig/fs/nfs/super.c
+++ linux-2624-rc2-mmbo/fs/nfs/super.c
@@ -1499,6 +1499,23 @@ error_splat_super:
 	return error;
 }
 
+static void nfs_put_super(struct super_block *sb)
+{
+	struct nfs_server *server = NFS_SB(sb);
+	/*
+	 * Make sure there are no outstanding ops to this server.
+	 * If so, wait for them to finish before allowing the
+	 * unmount to continue.
+	 */
+	wait_event(server->active_wq, atomic_read(&server->active) == 0);
+}
+
+void nfs_sb_deactive(struct nfs_server *server)
+{
+	if (atomic_dec_and_test(&server->active))
+		wake_up(&server->active_wq);
+}
+
 #ifdef CONFIG_NFS_V4
 
 /*
@@ -1771,17 +1788,6 @@ static void nfs4_kill_super(struct super
 	nfs_free_server(server);
 }
 
-static void nfs_put_super(struct super_block *sb)
-{
-	struct nfs_server *server = NFS_SB(sb);
-	/*
-	 * Make sure there are no outstanding ops to this server.
-	 * If so, wait for them to finish before allowing the
-	 * unmount to continue.
-	 */
-	wait_event(server->active_wq, atomic_read(&server->active) == 0);
-}
-
 /*
  * Clone an NFS4 server record on xdev traversal (FSID-change)
  */
@@ -1929,10 +1935,4 @@ error_splat_super:
 	return error;
 }
 
-void nfs_sb_deactive(struct nfs_server *server)
-{
-	if (atomic_dec_and_test(&server->active))
-		wake_up(&server->active_wq);
-}
-
 #endif /* CONFIG_NFS_V4 */
