Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYF2AH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYF2AH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYF2AHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:07:49 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33924 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbYF2AHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:07:10 -0400
Date: Sun, 29 Jun 2008 01:07:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] unionfs: fix memory leak
In-Reply-To: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
Message-ID: <Pine.LNX.4.64.0806290105430.20280@blonde.site>
References: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unionfs has slowly been leaking memory: although many places do explicitly
free the dentry's lower_paths array (and I've not changed those, in case
the ordering is important), not all do - and adding a WARN_ON didn't seem
to finger any particular culprit.  So free_dentry_private_data needs to
kfree lower_paths (other freeers are good about setting it to NULL).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's git-unionfs-fixup.patch

 fs/unionfs/lookup.c |    1 +
 1 file changed, 1 insertion(+)
 
--- mmotm/fs/unionfs/lookup.c	2008-06-27 13:39:18.000000000 +0100
+++ linux/fs/unionfs/lookup.c	2008-06-27 14:08:00.000000000 +0100
@@ -498,6 +498,7 @@ void free_dentry_private_data(struct den
 {
 	if (!dentry || !dentry->d_fsdata)
 		return;
+	kfree(UNIONFS_D(dentry)->lower_paths);
 	kmem_cache_free(unionfs_dentry_cachep, dentry->d_fsdata);
 	dentry->d_fsdata = NULL;
 }
