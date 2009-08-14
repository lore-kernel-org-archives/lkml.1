Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZHNMnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZHNMnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZHNMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:48 -0400
Received: from www.tglx.de ([62.245.132.106]:49852 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbZHNMnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:46 -0400
Message-Id: <20090814123548.593005273@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:43:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: [patch 09/11] ncpfs: cleanup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=ncpfs-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks and the NULLification of the pointers as the data structure
which contains the pointers is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
---
 fs/ncpfs/inode.c |   12 ++----------
 fs/ncpfs/ioctl.c |    6 ++----
 2 files changed, 4 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/fs/ncpfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/ncpfs/inode.c
+++ linux-2.6-tip/fs/ncpfs/inode.c
@@ -746,16 +746,8 @@ static void ncp_put_super(struct super_b
 
 #ifdef CONFIG_NCPFS_NLS
 	/* unload the NLS charsets */
-	if (server->nls_vol)
-	{
-		unload_nls(server->nls_vol);
-		server->nls_vol = NULL;
-	}
-	if (server->nls_io)
-	{
-		unload_nls(server->nls_io);
-		server->nls_io = NULL;
-	}
+	unload_nls(server->nls_vol);
+	unload_nls(server->nls_io);
 #endif /* CONFIG_NCPFS_NLS */
 
 	if (server->info_filp)
Index: linux-2.6-tip/fs/ncpfs/ioctl.c
===================================================================
--- linux-2.6-tip.orig/fs/ncpfs/ioctl.c
+++ linux-2.6-tip/fs/ncpfs/ioctl.c
@@ -223,10 +223,8 @@ ncp_set_charsets(struct ncp_server* serv
 	oldset_io = server->nls_io;
 	server->nls_io = iocharset;
 
-	if (oldset_cp)
-		unload_nls(oldset_cp);
-	if (oldset_io)
-		unload_nls(oldset_io);
+	unload_nls(oldset_cp);
+	unload_nls(oldset_io);
 
 	return 0;
 }


