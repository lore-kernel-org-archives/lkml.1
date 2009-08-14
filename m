Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZHNMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZHNMnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZHNMnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:41 -0400
Received: from www.tglx.de ([62.245.132.106]:49833 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbZHNMne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:34 -0400
Message-Id: <20090814123548.555482868@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:43:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [patch 08/11] jfs: cleanup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=jfs-clenaup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
check and the NULLification of the pointer as the data structure which
contains the pointer is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

---
 fs/jfs/super.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/fs/jfs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/jfs/super.c
+++ linux-2.6-tip/fs/jfs/super.c
@@ -178,13 +178,11 @@ static void jfs_put_super(struct super_b
 	rc = jfs_umount(sb);
 	if (rc)
 		jfs_err("jfs_umount failed with return code %d", rc);
-	if (sbi->nls_tab)
-		unload_nls(sbi->nls_tab);
-	sbi->nls_tab = NULL;
+
+	unload_nls(sbi->nls_tab);
 
 	truncate_inode_pages(sbi->direct_inode->i_mapping, 0);
 	iput(sbi->direct_inode);
-	sbi->direct_inode = NULL;
 
 	kfree(sbi);
 
@@ -347,8 +345,7 @@ static int parse_options(char *options, 
 
 	if (nls_map != (void *) -1) {
 		/* Discard old (if remount) */
-		if (sbi->nls_tab)
-			unload_nls(sbi->nls_tab);
+		unload_nls(sbi->nls_tab);
 		sbi->nls_tab = nls_map;
 	}
 	return 1;


