Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbXKFTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbXKFTzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbXKFTwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45397 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755987AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195201.086507503@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:59 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 15/28] cpu alloc: XFS counters
Content-Disposition: inline; filename=cpu_alloc_xfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove the useless zeroing after allocation. Allocpercpu already
zeroed the objects.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/xfs/xfs_mount.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2007-11-04 19:31:30.000000000 -0800
+++ linux-2.6/fs/xfs/xfs_mount.c	2007-11-04 19:55:16.000000000 -0800
@@ -1924,7 +1924,7 @@ xfs_icsb_cpu_notify(
 
 	mp = (xfs_mount_t *)container_of(nfb, xfs_mount_t, m_icsb_notifier);
 	cntp = (xfs_icsb_cnts_t *)
-			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
+			CPU_PTR(mp->m_sb_cnts, (unsigned long)hcpu);
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -1976,10 +1976,7 @@ int
 xfs_icsb_init_counters(
 	xfs_mount_t	*mp)
 {
-	xfs_icsb_cnts_t *cntp;
-	int		i;
-
-	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
+	mp->m_sb_cnts = CPU_ALLOC(xfs_icsb_cnts_t, GFP_KERNEL | __GFP_ZERO);
 	if (mp->m_sb_cnts == NULL)
 		return -ENOMEM;
 
@@ -1989,11 +1986,6 @@ xfs_icsb_init_counters(
 	register_hotcpu_notifier(&mp->m_icsb_notifier);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
-	}
-
 	mutex_init(&mp->m_icsb_mutex);
 
 	/*
@@ -2026,7 +2018,7 @@ xfs_icsb_destroy_counters(
 {
 	if (mp->m_sb_cnts) {
 		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
-		free_percpu(mp->m_sb_cnts);
+		CPU_FREE(mp->m_sb_cnts);
 	}
 	mutex_destroy(&mp->m_icsb_mutex);
 }
@@ -2056,7 +2048,7 @@ xfs_icsb_lock_all_counters(
 	int		i;
 
 	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
+		cntp = (xfs_icsb_cnts_t *)CPU_PTR(mp->m_sb_cnts, i);
 		xfs_icsb_lock_cntr(cntp);
 	}
 }
@@ -2069,7 +2061,7 @@ xfs_icsb_unlock_all_counters(
 	int		i;
 
 	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
+		cntp = (xfs_icsb_cnts_t *)CPU_PTR(mp->m_sb_cnts, i);
 		xfs_icsb_unlock_cntr(cntp);
 	}
 }
@@ -2089,7 +2081,7 @@ xfs_icsb_count(
 		xfs_icsb_lock_all_counters(mp);
 
 	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
+		cntp = (xfs_icsb_cnts_t *)CPU_PTR(mp->m_sb_cnts, i);
 		cnt->icsb_icount += cntp->icsb_icount;
 		cnt->icsb_ifree += cntp->icsb_ifree;
 		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
@@ -2167,7 +2159,7 @@ xfs_icsb_enable_counter(
 
 	xfs_icsb_lock_all_counters(mp);
 	for_each_online_cpu(i) {
-		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
+		cntp = CPU_PTR(mp->m_sb_cnts, i);
 		switch (field) {
 		case XFS_SBS_ICOUNT:
 			cntp->icsb_icount = count + resid;
@@ -2307,7 +2299,7 @@ xfs_icsb_modify_counters(
 	might_sleep();
 again:
 	cpu = get_cpu();
-	icsbp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, cpu);
+	icsbp = (xfs_icsb_cnts_t *)CPU_PTR(mp->m_sb_cnts, cpu);
 
 	/*
 	 * if the counter is disabled, go to slow path

-- 
