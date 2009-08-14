Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZHNMpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZHNMpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZHNMpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:45:38 -0400
Received: from www.tglx.de ([62.245.132.106]:57161 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbZHNMpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:45:38 -0400
Message-Id: <20090814123548.630318643@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:43:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Anton Altaparmakov <aia21@cantab.net>
Subject: [patch 10/11] ntfs: cleanup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=ntfs-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks and the NULLification of the pointers as the data structure
which contains the pointers is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Anton Altaparmakov <aia21@cantab.net>
---
 fs/ntfs/super.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/fs/ntfs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/ntfs/super.c
+++ linux-2.6-tip/fs/ntfs/super.c
@@ -201,8 +201,7 @@ use_utf8:
 						v, old_nls->charset);
 				nls_map = old_nls;
 			} else /* nls_map */ {
-				if (old_nls)
-					unload_nls(old_nls);
+				unload_nls(old_nls);
 			}
 		} else if (!strcmp(p, "utf8")) {
 			bool val = false;
@@ -2427,10 +2426,9 @@ static void ntfs_put_super(struct super_
 		ntfs_free(vol->upcase);
 		vol->upcase = NULL;
 	}
-	if (vol->nls_map) {
-		unload_nls(vol->nls_map);
-		vol->nls_map = NULL;
-	}
+
+	unload_nls(vol->nls_map);
+
 	sb->s_fs_info = NULL;
 	kfree(vol);
 


