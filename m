Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYDXB12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYDXB12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYDXB1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:27:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46999 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYDXB1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:27:19 -0400
Date: Wed, 23 Apr 2008 18:27:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       pbadari@us.ibm.com, cmm@us.ibm.com, mathur@linux.vnet.ibm.com,
       hch@infradead.org
Subject: [PATCH] list_for_each_rcu must die: ext4
Message-ID: <20080424012715.GA21836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of list_for_each_rcu() can be profitably replaced by the
easier-to-use list_for_each_entry_rcu().  This patch makes this change for
the ext4 filesystem, in preparation for removing the list_for_each_rcu()
API entirely.

Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 mballoc.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25/fs/ext4/mballoc.c linux-2.6.25-lfer-ext/fs/ext4/mballoc.c
--- linux-2.6.25/fs/ext4/mballoc.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-lfer-ext/fs/ext4/mballoc.c	2008-04-23 16:42:12.000000000 -0700
@@ -819,7 +819,7 @@ static int __mb_check_buddy(struct ext4_
 	struct ext4_group_info *grp;
 	int fragments = 0;
 	int fstart;
-	struct list_head *cur;
+	struct ext4_prealloc_space *pa;
 	void *buddy;
 	void *buddy2;
 
@@ -895,10 +895,8 @@ static int __mb_check_buddy(struct ext4_
 
 	grp = ext4_get_group_info(sb, e4b->bd_group);
 	buddy = mb_find_buddy(e4b, 0, &max);
-	list_for_each(cur, &grp->bb_prealloc_list) {
+	list_for_each_entry(pa, &grp->bb_prealloc_list, group_list) {
 		ext4_group_t groupnr;
-		struct ext4_prealloc_space *pa;
-		pa = list_entry(cur, struct ext4_prealloc_space, group_list);
 		ext4_get_group_no_and_offset(sb, pa->pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
 		for (i = 0; i < pa->len; i++)
@@ -3151,7 +3149,7 @@ static void ext4_mb_normalize_request(st
 {
 	int bsbits, max;
 	ext4_lblk_t end;
-	struct list_head *cur;
+	struct ext4_prealloc_space *pa;
 	loff_t size, orig_size, start_off;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3240,12 +3238,9 @@ static void ext4_mb_normalize_request(st
 
 	/* check we don't cross already preallocated blocks */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		struct ext4_prealloc_space *pa;
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 		unsigned long pa_end;
 
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
-
 		if (pa->pa_deleted)
 			continue;
 		spin_lock(&pa->pa_lock);
@@ -3287,10 +3282,8 @@ static void ext4_mb_normalize_request(st
 
 	/* XXX: extra loop to check we really don't overlap preallocations */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		struct ext4_prealloc_space *pa;
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 		unsigned long pa_end;
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0) {
 			pa_end = pa->pa_lstart + pa->pa_len;
@@ -3417,7 +3410,6 @@ static int ext4_mb_use_preallocated(stru
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_locality_group *lg;
 	struct ext4_prealloc_space *pa;
-	struct list_head *cur;
 
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
@@ -3425,8 +3417,7 @@ static int ext4_mb_use_preallocated(stru
 
 	/* first, try per-file preallocation */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
+	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
 
 		/* all fields in this condition don't change,
 		 * so we can skip locking for them */
@@ -3458,8 +3449,7 @@ static int ext4_mb_use_preallocated(stru
 		return 0;
 
 	rcu_read_lock();
-	list_for_each_rcu(cur, &lg->lg_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
+	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list, pa_inode_list) {
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0 && pa->pa_free >= ac->ac_o_ex.fe_len) {
 			atomic_inc(&pa->pa_count);
@@ -3486,7 +3476,6 @@ static void ext4_mb_generate_from_pa(str
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct ext4_prealloc_space *pa;
-	struct list_head *cur;
 	ext4_group_t groupnr;
 	ext4_grpblk_t start;
 	int preallocated = 0;
@@ -3501,8 +3490,7 @@ static void ext4_mb_generate_from_pa(str
 	 * allocation in buddy when concurrent ext4_mb_put_pa()
 	 * is dropping preallocation
 	 */
-	list_for_each(cur, &grp->bb_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+	list_for_each_entry(pa, &grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 					     &groupnr, &start);
@@ -4104,11 +4092,8 @@ static void ext4_mb_show_ac(struct ext4_
 		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
 		struct ext4_prealloc_space *pa;
 		ext4_grpblk_t start;
-		struct list_head *cur;
 		ext4_lock_group(sb, i);
-		list_for_each(cur, &grp->bb_prealloc_list) {
-			pa = list_entry(cur, struct ext4_prealloc_space,
-					pa_group_list);
+		list_for_each_entry(pa, &grp->bb_prealloc_list, pa_group_list) {
 			spin_lock(&pa->pa_lock);
 			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 						     NULL, &start);
