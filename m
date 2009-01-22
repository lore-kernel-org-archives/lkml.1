Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbZAVRye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbZAVRye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbZAVRul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:41 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43218 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760108AbZAVRua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:30 -0500
Message-Id: <20090122175029.702941000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:29 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 12/14] macro for scanning all gru chiplets
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_gru_max_gid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add macro for scanning all active GRU chiplets. Maximum
chiplet id is saved during GRU initialization.

Signed-off-by: Jack Steiner <steiner@sgi.com>
---
 drivers/misc/sgi-gru/grufault.c  |   11 ++---------
 drivers/misc/sgi-gru/grufile.c   |    3 +++
 drivers/misc/sgi-gru/gruprocfs.c |    4 ++--
 drivers/misc/sgi-gru/grutables.h |    9 +++++++--
 4 files changed, 14 insertions(+), 13 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-01-15 08:18:12.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-01-15 08:18:13.000000000 -0600
@@ -600,18 +600,11 @@ static int gru_unload_all_contexts(void)
 {
 	struct gru_thread_state *gts;
 	struct gru_state *gru;
-	int maxgid, gid, ctxnum;
-	int nodesperblade;
+	int gid, ctxnum;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (num_online_nodes() > 1 &&
-			(uv_node_to_blade_id(1) == uv_node_to_blade_id(0)))
-		nodesperblade = 2;
-	else
-		nodesperblade = 1;
-	maxgid = GRU_CHIPLETS_PER_BLADE * num_online_nodes() / nodesperblade;
-	for (gid = 0; gid < maxgid; gid++) {
+	foreach_gid(gid) {
 		gru = GID_TO_GRU(gid);
 		spin_lock(&gru->gs_lock);
 		for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-01-15 08:18:11.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-01-15 08:18:13.000000000 -0600
@@ -59,6 +59,7 @@
 struct gru_blade_state *gru_base[GRU_MAX_BLADES] __read_mostly;
 unsigned long gru_start_paddr __read_mostly;
 unsigned long gru_end_paddr __read_mostly;
+unsigned int gru_max_gids __read_mostly;
 struct gru_stats_s gru_stats;
 
 /* Guaranteed user available resources on each node */
@@ -288,6 +289,8 @@ static void gru_init_chiplet(struct gru_
 	gru->gs_dsr_map = (1UL << GRU_DSR_AU) - 1;
 	gru->gs_asid_limit = MAX_ASID;
 	gru_tgh_flush_init(gru);
+	if (gru->gs_gid >= gru_max_gids)
+		gru_max_gids = gru->gs_gid + 1;
 	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
 		gru->gs_gru_base_paddr);
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-01-15 08:18:09.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-01-15 08:18:13.000000000 -0600
@@ -226,7 +226,7 @@ static void seq_stop(struct seq_file *fi
 
 static void *seq_start(struct seq_file *file, loff_t *gid)
 {
-	if (*gid < GRU_MAX_GRUS)
+	if (*gid < gru_max_gids)
 		return gid;
 	return NULL;
 }
@@ -234,7 +234,7 @@ static void *seq_start(struct seq_file *
 static void *seq_next(struct seq_file *file, void *data, loff_t *gid)
 {
 	(*gid)++;
-	if (*gid < GRU_MAX_GRUS)
+	if (*gid < gru_max_gids)
 		return gid;
 	return NULL;
 }
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-01-15 08:18:09.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-01-15 08:18:13.000000000 -0600
@@ -153,6 +153,7 @@
 extern struct gru_stats_s gru_stats;
 extern struct gru_blade_state *gru_base[];
 extern unsigned long gru_start_paddr, gru_end_paddr;
+extern unsigned int gru_max_gids;
 
 #define GRU_MAX_BLADES		MAX_NUMNODES
 #define GRU_MAX_GRUS		(GRU_MAX_BLADES * GRU_CHIPLETS_PER_BLADE)
@@ -406,12 +407,12 @@ struct gru_state {
 							   gru segments (64) */
 	void			*gs_gru_base_vaddr;	/* Virtual address of
 							   gru segments (64) */
-	unsigned char		gs_gid;			/* unique GRU number */
+	unsigned short		gs_gid;			/* unique GRU number */
+	unsigned short		gs_blade_id;		/* blade of GRU */
 	unsigned char		gs_tgh_local_shift;	/* used to pick TGH for
 							   local flush */
 	unsigned char		gs_tgh_first_remote;	/* starting TGH# for
 							   remote flush */
-	unsigned short		gs_blade_id;		/* blade of GRU */
 	spinlock_t		gs_asid_lock;		/* lock used for
 							   assigning asids */
 	spinlock_t		gs_lock;		/* lock used for
@@ -506,6 +507,10 @@ struct gru_blade_state {
 			(i) < GRU_CHIPLETS_PER_BLADE;			\
 			(i)++, (gru)++)
 
+/* Scan all GRUs */
+#define foreach_gid(gid)						\
+	for ((gid) = 0; (gid) < gru_max_gids; (gid)++)
+
 /* Scan all active GTSs on a gru. Note: must hold ss_lock to use this macro. */
 #define for_each_gts_on_gru(gts, gru, ctxnum)				\
 	for ((ctxnum) = 0; (ctxnum) < GRU_NUM_CCH; (ctxnum)++)		\

