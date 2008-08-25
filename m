Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYHYVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYHYVXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYHYVWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:22:55 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:15182 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYHYVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:22:54 -0400
Message-Id: <20080825212053.255444022@quilx.com>
References: <20080825212035.861870487@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Aug 2008 14:20:36 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 1/3] dentries: Always use list_del_init() when removing a dentry from the lru
Content-Disposition: inline; filename=consitent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch restores what commit 4a0962abd187df29b7d1378b2f372a55667d54c0
already implemented. The feature was subsequently clobbered by
commit da3bbdd4632c0171406b2677e31494afa5bde2f8

Before this patch some execution path use list_del() instead of
list_del_init() which results in inconsitencies in the state of d_lru
when the object is freed.

The performance of list_del_init() and list_del() is the same.
So lets just have one dentry removal function named dentry_lru_del() that always
does a list_del_init().

The result of this patch is that dentry->d_lru is now always empty when a
dentry is freed. The dentry defragmentation patch depends on a defined state
of a dentry on free.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-next/fs/dcache.c
===================================================================
--- linux-next.orig/fs/dcache.c	2008-08-25 15:44:58.000000000 -0500
+++ linux-next/fs/dcache.c	2008-08-25 15:45:59.000000000 -0500
@@ -141,15 +141,6 @@
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
-		list_del(&dentry->d_lru);
-		dentry->d_sb->s_nr_dentry_unused--;
-		dentry_stat.nr_unused--;
-	}
-}
-
-static void dentry_lru_del_init(struct dentry *dentry)
-{
-	if (likely(!list_empty(&dentry->d_lru))) {
 		list_del_init(&dentry->d_lru);
 		dentry->d_sb->s_nr_dentry_unused--;
 		dentry_stat.nr_unused--;
@@ -316,7 +307,7 @@
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
 	atomic_inc(&dentry->d_count);
-	dentry_lru_del_init(dentry);
+	dentry_lru_del(dentry);
 	return dentry;
 }
 
@@ -432,7 +423,7 @@
 
 		if (dentry->d_op && dentry->d_op->d_delete)
 			dentry->d_op->d_delete(dentry);
-		dentry_lru_del_init(dentry);
+		dentry_lru_del(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
 		spin_lock(&dcache_lock);
@@ -492,7 +483,7 @@
 	}
 	while (!list_empty(&tmp)) {
 		dentry = list_entry(tmp.prev, struct dentry, d_lru);
-		dentry_lru_del_init(dentry);
+		dentry_lru_del(dentry);
 		spin_lock(&dentry->d_lock);
 		/*
 		 * We found an inuse dentry which was not removed from
@@ -621,7 +612,7 @@
 
 	/* detach this root from the system */
 	spin_lock(&dcache_lock);
-	dentry_lru_del_init(dentry);
+	dentry_lru_del(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dcache_lock);
 
@@ -635,7 +626,7 @@
 			spin_lock(&dcache_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				dentry_lru_del_init(loop);
+				dentry_lru_del(loop);
 				__d_drop(loop);
 				cond_resched_lock(&dcache_lock);
 			}
@@ -817,7 +808,7 @@
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		dentry_lru_del_init(dentry);
+		dentry_lru_del(dentry);
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache

-- 
