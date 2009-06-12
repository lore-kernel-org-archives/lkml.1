Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbZFLN7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbZFLN7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbZFLN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:59:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbZFLN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:59:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] GFS2: Add tracepoints
Date: Fri, 12 Jun 2009 13:52:36 +0100
Message-Id: <1244811157-7558-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244811157-7558-1-git-send-email-swhiteho@redhat.com>
References: <1244811157-7558-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to trace various aspects of the GFS2
filesystem. The trace points are divided into three groups,
glocks, logging and bmap. These points have been chosen because
they allow inspection of the major internal functions of GFS2
and they are also generic enough that they are unlikely to need
any major changes as the filesystem evolves.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index d53a9be..3da2f1f 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,3 +1,4 @@
+EXTRA_CFLAGS := -I$(src)
 obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o dir.o eaops.o eattr.o glock.o \
 	glops.o inode.o log.o lops.o main.o meta_io.o \
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 3297635..6d47379 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -25,6 +25,7 @@
 #include "trans.h"
 #include "dir.h"
 #include "util.h"
+#include "trace_gfs2.h"
 
 /* This doesn't need to be that large as max 64 bit pointers in a 4k
  * block is 512, so __u16 is fine for that. It saves stack space to
@@ -589,6 +590,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	clear_buffer_mapped(bh_map);
 	clear_buffer_new(bh_map);
 	clear_buffer_boundary(bh_map);
+	trace_gfs2_bmap(ip, bh_map, lblock, create, 1);
 	if (gfs2_is_dir(ip)) {
 		bsize = sdp->sd_jbsize;
 		arr = sdp->sd_jheightsize;
@@ -623,6 +625,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	ret = 0;
 out:
 	release_metapath(&mp);
+	trace_gfs2_bmap(ip, bh_map, lblock, create, ret);
 	bmap_unlock(ip, create);
 	return ret;
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2bf62bc..297421c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -39,6 +39,8 @@
 #include "super.h"
 #include "util.h"
 #include "bmap.h"
+#define CREATE_TRACE_POINTS
+#include "trace_gfs2.h"
 
 struct gfs2_gl_hash_bucket {
         struct hlist_head hb_list;
@@ -155,7 +157,7 @@ static void glock_free(struct gfs2_glock *gl)
 
 	if (aspace)
 		gfs2_aspace_put(aspace);
-
+	trace_gfs2_glock_put(gl);
 	sdp->sd_lockstruct.ls_ops->lm_put_lock(gfs2_glock_cachep, gl);
 }
 
@@ -317,14 +319,17 @@ restart:
 						return 2;
 					gh->gh_error = ret;
 					list_del_init(&gh->gh_list);
+					trace_gfs2_glock_queue(gh, 0);
 					gfs2_holder_wake(gh);
 					goto restart;
 				}
 				set_bit(HIF_HOLDER, &gh->gh_iflags);
+				trace_gfs2_promote(gh, 1);
 				gfs2_holder_wake(gh);
 				goto restart;
 			}
 			set_bit(HIF_HOLDER, &gh->gh_iflags);
+			trace_gfs2_promote(gh, 0);
 			gfs2_holder_wake(gh);
 			continue;
 		}
@@ -354,6 +359,7 @@ static inline void do_error(struct gfs2_glock *gl, const int ret)
 		else
 			continue;
 		list_del_init(&gh->gh_list);
+		trace_gfs2_glock_queue(gh, 0);
 		gfs2_holder_wake(gh);
 	}
 }
@@ -422,6 +428,7 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	int rv;
 
 	spin_lock(&gl->gl_spin);
+	trace_gfs2_glock_state_change(gl, state);
 	state_change(gl, state);
 	gh = find_first_waiter(gl);
 
@@ -851,6 +858,7 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 			gl->gl_demote_state != state) {
 		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
+	trace_gfs2_demote_rq(gl);
 }
 
 /**
@@ -936,6 +944,7 @@ fail:
 			goto do_cancel;
 		return;
 	}
+	trace_gfs2_glock_queue(gh, 1);
 	list_add_tail(&gh->gh_list, insert_pt);
 do_cancel:
 	gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
@@ -1032,6 +1041,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
 			fast_path = 1;
 	}
+	trace_gfs2_glock_queue(gh, 0);
 	spin_unlock(&gl->gl_spin);
 	if (likely(fast_path))
 		return;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index f2e449c..13c6237 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -28,6 +28,7 @@
 #include "meta_io.h"
 #include "util.h"
 #include "dir.h"
+#include "trace_gfs2.h"
 
 #define PULL 1
 
@@ -313,6 +314,7 @@ int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 		gfs2_log_lock(sdp);
 	}
 	atomic_sub(blks, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, -blks);
 	gfs2_log_unlock(sdp);
 	mutex_unlock(&sdp->sd_log_reserve_mutex);
 
@@ -333,6 +335,7 @@ void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 
 	gfs2_log_lock(sdp);
 	atomic_add(blks, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, blks);
 	gfs2_assert_withdraw(sdp,
 			     atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
 	gfs2_log_unlock(sdp);
@@ -558,6 +561,7 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 
 	gfs2_log_lock(sdp);
 	atomic_add(dist, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, dist);
 	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
 	gfs2_log_unlock(sdp);
 
@@ -715,6 +719,7 @@ void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 		up_write(&sdp->sd_log_flush_lock);
 		return;
 	}
+	trace_gfs2_log_flush(sdp, 1);
 
 	ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ai->ai_ail1_list);
@@ -746,6 +751,7 @@ void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
 		gfs2_log_lock(sdp);
 		atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
+		trace_gfs2_log_blocks(sdp, -1);
 		gfs2_log_unlock(sdp);
 		log_write_header(sdp, 0, PULL);
 	}
@@ -763,7 +769,7 @@ void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 		ai = NULL;
 	}
 	gfs2_log_unlock(sdp);
-
+	trace_gfs2_log_flush(sdp, 0);
 	up_write(&sdp->sd_log_flush_lock);
 
 	kfree(ai);
@@ -787,6 +793,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_reserved + tr->tr_reserved >= reserved);
 	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
 	atomic_add(unused, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, unused);
 	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
 			     sdp->sd_jdesc->jd_blocks);
 	sdp->sd_log_blks_reserved = reserved;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 00315f5..9969ff0 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -27,6 +27,7 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
+#include "trace_gfs2.h"
 
 /**
  * gfs2_pin - Pin a buffer in memory
@@ -53,6 +54,7 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	if (bd->bd_ail)
 		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
 	get_bh(bh);
+	trace_gfs2_pin(bd, 1);
 }
 
 /**
@@ -89,6 +91,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	bd->bd_ail = ai;
 	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	trace_gfs2_pin(bd, 0);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
 }
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index cc34f27..7bc3c45 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -33,6 +33,7 @@
 #include "log.h"
 #include "quota.h"
 #include "dir.h"
+#include "trace_gfs2.h"
 
 #define DO 0
 #define UNDO 1
@@ -775,6 +776,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		/* Map the extents for this journal's blocks */
 		map_journal_extents(sdp);
 	}
+	trace_gfs2_log_blocks(sdp, atomic_read(&sdp->sd_log_blks_free));
 
 	if (sdp->sd_lockstruct.ls_first) {
 		unsigned int x;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index de32397..daa4ae3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -29,6 +29,7 @@
 #include "util.h"
 #include "log.h"
 #include "inode.h"
+#include "trace_gfs2.h"
 
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
@@ -1519,7 +1520,7 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone -= *n;
 	spin_unlock(&sdp->sd_rindex_spin);
-
+	trace_gfs2_block_alloc(ip, block, *n, GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
 
@@ -1571,7 +1572,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone--;
 	spin_unlock(&sdp->sd_rindex_spin);
-
+	trace_gfs2_block_alloc(dip, block, 1, GFS2_BLKST_DINODE);
 	return block;
 }
 
@@ -1591,7 +1592,7 @@ void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	rgd = rgblk_free(sdp, bstart, blen, GFS2_BLKST_FREE);
 	if (!rgd)
 		return;
-
+	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
 	rgd->rd_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
@@ -1619,7 +1620,7 @@ void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	rgd = rgblk_free(sdp, bstart, blen, GFS2_BLKST_FREE);
 	if (!rgd)
 		return;
-
+	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
 	rgd->rd_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
@@ -1642,6 +1643,7 @@ void gfs2_unlink_di(struct inode *inode)
 	rgd = rgblk_free(sdp, blkno, 1, GFS2_BLKST_UNLINKED);
 	if (!rgd)
 		return;
+	trace_gfs2_block_alloc(ip, blkno, 1, GFS2_BLKST_UNLINKED);
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_trans_add_rg(rgd);
@@ -1673,6 +1675,7 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
 {
 	gfs2_free_uninit_di(rgd, ip->i_no_addr);
+	trace_gfs2_block_alloc(ip, ip->i_no_addr, 1, GFS2_BLKST_FREE);
 	gfs2_quota_change(ip, -1, ip->i_inode.i_uid, ip->i_inode.i_gid);
 	gfs2_meta_wipe(ip, ip->i_no_addr, 1);
 }
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
new file mode 100644
index 0000000..98d6ef1
--- /dev/null
+++ b/fs/gfs2/trace_gfs2.h
@@ -0,0 +1,407 @@
+#if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_GFS2_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM gfs2
+#define TRACE_INCLUDE_FILE trace_gfs2
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/dlmconstants.h>
+#include <linux/gfs2_ondisk.h>
+#include "incore.h"
+#include "glock.h"
+
+#define dlm_state_name(nn) { DLM_LOCK_##nn, #nn }
+#define glock_trace_name(x) __print_symbolic(x,		\
+			    dlm_state_name(IV),		\
+			    dlm_state_name(NL),		\
+			    dlm_state_name(CR),		\
+			    dlm_state_name(CW),		\
+			    dlm_state_name(PR),		\
+			    dlm_state_name(PW),		\
+			    dlm_state_name(EX))
+
+#define block_state_name(x) __print_symbolic(x,			\
+			    { GFS2_BLKST_FREE, "free" },	\
+			    { GFS2_BLKST_USED, "used" },	\
+			    { GFS2_BLKST_DINODE, "dinode" },	\
+			    { GFS2_BLKST_UNLINKED, "unlinked" })
+
+#define show_glock_flags(flags) __print_flags(flags, "",	\
+	{(1UL << GLF_LOCK),			"l" },		\
+	{(1UL << GLF_DEMOTE),			"D" },		\
+	{(1UL << GLF_PENDING_DEMOTE),		"d" },		\
+	{(1UL << GLF_DEMOTE_IN_PROGRESS),	"p" },		\
+	{(1UL << GLF_DIRTY),			"y" },		\
+	{(1UL << GLF_LFLUSH),			"f" },		\
+	{(1UL << GLF_INVALIDATE_IN_PROGRESS),	"i" },		\
+	{(1UL << GLF_REPLY_PENDING),		"r" },		\
+	{(1UL << GLF_INITIAL),			"I" },		\
+	{(1UL << GLF_FROZEN),			"F" })
+
+#ifndef NUMPTY
+#define NUMPTY
+static inline u8 glock_trace_state(unsigned int state)
+{
+	switch(state) {
+	case LM_ST_SHARED:
+		return DLM_LOCK_PR;
+	case LM_ST_DEFERRED:
+		return DLM_LOCK_CW;
+	case LM_ST_EXCLUSIVE:
+		return DLM_LOCK_EX;
+	}
+	return DLM_LOCK_NL;
+}
+#endif
+
+/* Section 1 - Locking
+ *
+ * Objectives:
+ * Latency: Remote demote request to state change
+ * Latency: Local lock request to state change
+ * Latency: State change to lock grant
+ * Correctness: Ordering of local lock state vs. I/O requests
+ * Correctness: Responses to remote demote requests
+ */
+
+/* General glock state change (DLM lock request completes) */
+TRACE_EVENT(gfs2_glock_state_change,
+
+	TP_PROTO(const struct gfs2_glock *gl, unsigned int new_state),
+
+	TP_ARGS(gl, new_state),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	u8,	new_state		)
+		__field(	u8,	dmt_state		)
+		__field(	u8,	tgt_state		)
+		__field(	unsigned long,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->new_state	= glock_trace_state(new_state);
+		__entry->tgt_state	= glock_trace_state(gl->gl_target);
+		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
+		__entry->flags		= gl->gl_flags;
+	),
+
+	TP_printk("%u,%u glock %d:%lld state %s to %s tgt:%s dmt:%s flags:%s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		 (unsigned long long)__entry->glnum,
+		  glock_trace_name(__entry->cur_state),
+		  glock_trace_name(__entry->new_state),
+		  glock_trace_name(__entry->tgt_state),
+		  glock_trace_name(__entry->dmt_state),
+		  show_glock_flags(__entry->flags))
+);
+
+/* State change -> unlocked, glock is being deallocated */
+TRACE_EVENT(gfs2_glock_put,
+
+	TP_PROTO(const struct gfs2_glock *gl),
+
+	TP_ARGS(gl),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	unsigned long,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->flags		= gl->gl_flags;
+	),
+
+	TP_printk("%u,%u glock %d:%lld state %s => %s flags:%s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+                  __entry->gltype, (unsigned long long)__entry->glnum,
+                  glock_trace_name(__entry->cur_state),
+		  glock_trace_name(DLM_LOCK_IV),
+		  show_glock_flags(__entry->flags))
+
+);
+
+/* Callback (local or remote) requesting lock demotion */
+TRACE_EVENT(gfs2_demote_rq,
+
+	TP_PROTO(const struct gfs2_glock *gl),
+
+	TP_ARGS(gl),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	u8,	dmt_state		)
+		__field(	unsigned long,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
+		__entry->flags		= gl->gl_flags;
+	),
+
+	TP_printk("%u,%u glock %d:%lld demote %s to %s flags:%s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+                  glock_trace_name(__entry->cur_state),
+                  glock_trace_name(__entry->dmt_state),
+		  show_glock_flags(__entry->flags))
+
+);
+
+/* Promotion/grant of a glock */
+TRACE_EVENT(gfs2_promote,
+
+	TP_PROTO(const struct gfs2_holder *gh, int first),
+
+	TP_ARGS(gh, first),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	int,	first			)
+		__field(	u8,	state			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= gh->gh_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
+		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
+		__entry->first	= first;
+		__entry->state	= glock_trace_state(gh->gh_state);
+	),
+
+	TP_printk("%u,%u glock %u:%llu promote %s %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->first ? "first": "other",
+		  glock_trace_name(__entry->state))
+);
+
+/* Queue/dequeue a lock request */
+TRACE_EVENT(gfs2_glock_queue,
+
+	TP_PROTO(const struct gfs2_holder *gh, int queue),
+
+	TP_ARGS(gh, queue),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	int,	queue			)
+		__field(	u8,	state			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= gh->gh_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
+		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
+		__entry->queue	= queue;
+		__entry->state	= glock_trace_state(gh->gh_state);
+	),
+
+	TP_printk("%u,%u glock %u:%llu %squeue %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->queue ? "" : "de",
+		  glock_trace_name(__entry->state))
+);
+
+/* Section 2 - Log/journal
+ *
+ * Objectives:
+ * Latency: Log flush time
+ * Correctness: pin/unpin vs. disk I/O ordering
+ * Performance: Log usage stats
+ */
+
+/* Pin/unpin a block in the log */
+TRACE_EVENT(gfs2_pin,
+
+	TP_PROTO(const struct gfs2_bufdata *bd, int pin),
+
+	TP_ARGS(bd, pin),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	int,	pin			)
+		__field(	u32,	len			)
+		__field(	sector_t,	block		)
+		__field(	u64,	ino			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bd->bd_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->pin		= pin;
+		__entry->len		= bd->bd_bh->b_size;
+		__entry->block		= bd->bd_bh->b_blocknr;
+		__entry->ino		= bd->bd_gl->gl_name.ln_number;
+	),
+
+	TP_printk("%u,%u log %s %llu/%lu inode %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->pin ? "pin" : "unpin",
+		  (unsigned long long)__entry->block,
+		  (unsigned long)__entry->len,
+		  (unsigned long long)__entry->ino)
+);
+
+/* Flushing the log */
+TRACE_EVENT(gfs2_log_flush,
+
+	TP_PROTO(const struct gfs2_sbd *sdp, int start),
+
+	TP_ARGS(sdp, start),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	int,	start			)
+		__field(	u64,	log_seq			)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = sdp->sd_vfs->s_dev;
+		__entry->start		= start;
+		__entry->log_seq	= sdp->sd_log_sequence;
+	),
+
+	TP_printk("%u,%u log flush %s %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->start ? "start" : "end",
+		  (unsigned long long)__entry->log_seq)
+);
+
+/* Reserving/releasing blocks in the log */
+TRACE_EVENT(gfs2_log_blocks,
+
+	TP_PROTO(const struct gfs2_sbd *sdp, int blocks),
+
+	TP_ARGS(sdp, blocks),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	int,	blocks			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sdp->sd_vfs->s_dev;
+		__entry->blocks		= blocks;
+	),
+
+	TP_printk("%u,%u log reserve %d", MAJOR(__entry->dev),
+		  MINOR(__entry->dev), __entry->blocks)
+);
+
+/* Section 3 - bmap
+ *
+ * Objectives:
+ * Latency: Bmap request time
+ * Performance: Block allocator tracing
+ * Correctness: Test of disard generation vs. blocks allocated
+ */
+
+/* Map an extent of blocks, possibly a new allocation */
+TRACE_EVENT(gfs2_bmap,
+
+	TP_PROTO(const struct gfs2_inode *ip, const struct buffer_head *bh,
+		sector_t lblock, int create, int errno),
+
+	TP_ARGS(ip, bh, lblock, create, errno),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	sector_t, lblock		)
+		__field(	sector_t, pblock		)
+		__field(	u64,	inum			)
+		__field(	unsigned long, state		)
+		__field(	u32,	len			)
+		__field(	int,	create			)
+		__field(	int,	errno			)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = ip->i_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->lblock		= lblock;
+		__entry->pblock		= buffer_mapped(bh) ?  bh->b_blocknr : 0;
+		__entry->inum		= ip->i_no_addr;
+		__entry->state		= bh->b_state;
+		__entry->len		= bh->b_size;
+		__entry->create		= create;
+		__entry->errno		= errno;
+	),
+
+	TP_printk("%u,%u bmap %llu map %llu/%lu to %llu flags:%08lx %s %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->lblock,
+		  (unsigned long)__entry->len,
+		  (unsigned long long)__entry->pblock,
+		  __entry->state, __entry->create ? "create " : "nocreate",
+		  __entry->errno)
+);
+
+/* Keep track of blocks as they are allocated/freed */
+TRACE_EVENT(gfs2_block_alloc,
+
+	TP_PROTO(const struct gfs2_inode *ip, u64 block, unsigned len,
+		u8 block_state),
+
+	TP_ARGS(ip, block, len, block_state),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	start			)
+		__field(	u64,	inum			)
+		__field(	u32,	len			)
+		__field(	u8,	block_state		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= ip->i_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->start		= block;
+		__entry->inum		= ip->i_no_addr;
+		__entry->len		= len;
+		__entry->block_state	= block_state;
+	),
+
+	TP_printk("%u,%u bmap %llu alloc %llu/%lu %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->start,
+		  (unsigned long)__entry->len,
+		  block_state_name(__entry->block_state))
+);
+
+#endif /* _TRACE_GFS2_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#include <trace/define_trace.h>
+
-- 
1.6.0.6

