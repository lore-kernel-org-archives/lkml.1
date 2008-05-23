Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYEWT6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYEWT6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYEWT5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:57:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbYEWT5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:57:21 -0400
Message-Id: <20080523195534.918991067@redhat.com>
References: <20080523195506.084894989@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 May 2008 15:55:08 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH -mm 02/16] Use an indexed array for LRU variables
Content-Disposition: inline; filename=cl-use-indexed-array-of-lru-lists.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Currently we are defining explicit variables for the inactive
and active list. An indexed array can be more generic and avoid
repeating similar code in several places in the reclaim code.

We are saving a few bytes in terms of code size:

Before:

   text    data     bss     dec     hex filename
4097753  573120 4092484 8763357  85b7dd vmlinux

After:

   text    data     bss     dec     hex filename
4097729  573120 4092484 8763333  85b7c5 vmlinux

Having an easy way to add new lru lists may ease future work on
the reclaim code.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
V3 [riel]: memcontrol LRU arrayification

V1 -> V2 [lts]:
+ Remove extraneous  __dec_zone_state(zone, NR_ACTIVE) pointed
  out by Mel G.


 include/linux/memcontrol.h |   17 +-----
 include/linux/mm_inline.h  |   33 ++++++++----
 include/linux/mmzone.h     |   17 ++++--
 mm/memcontrol.c            |  115 ++++++++++++++++---------------------------
 mm/page_alloc.c            |    9 +--
 mm/swap.c                  |    2 
 mm/vmscan.c                |  120 +++++++++++++++++++++------------------------
 mm/vmstat.c                |    3 -
 8 files changed, 146 insertions(+), 170 deletions(-)

Index: linux-2.6.26-rc2-mm1/include/linux/mmzone.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/mmzone.h	2008-05-23 14:21:21.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/mmzone.h	2008-05-23 14:21:33.000000000 -0400
@@ -81,8 +81,8 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
-	NR_INACTIVE,
-	NR_ACTIVE,
+	NR_INACTIVE,	/* must match order of LRU_[IN]ACTIVE */
+	NR_ACTIVE,	/*  "     "     "   "       "         */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
@@ -107,6 +107,13 @@ enum zone_stat_item {
 #endif
 	NR_VM_ZONE_STAT_ITEMS };
 
+enum lru_list {
+	LRU_INACTIVE,	/* must match order of NR_[IN]ACTIVE */
+	LRU_ACTIVE,	/*  "     "     "   "       "        */
+	NR_LRU_LISTS };
+
+#define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
@@ -251,10 +258,8 @@ struct zone {
 
 	/* Fields commonly accessed by the page reclaim scanner */
 	spinlock_t		lru_lock;	
-	struct list_head	active_list;
-	struct list_head	inactive_list;
-	unsigned long		nr_scan_active;
-	unsigned long		nr_scan_inactive;
+	struct list_head	list[NR_LRU_LISTS];
+	unsigned long		nr_scan[NR_LRU_LISTS];
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
 
Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:21.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33

