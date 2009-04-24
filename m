Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZDXQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZDXQ16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZDXQ1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:27:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZDXQ1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:27:48 -0400
Subject: Re: GFS2: Tracing support for review
From: Steven Whitehouse <swhiteho@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.0904151159130.31828@gandalf.stny.rr.com>
References: <1239810905.29604.60.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0904151159130.31828@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 24 Apr 2009 17:26:48 +0100
Message-Id: <1240590408.29604.119.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To follow up from the previous patch, here is an updated version. Please
feel free to put this into the tracing tree ready for the next merge
window, if you feel that it is ready.

I have left the "comm" printing in, since I do not see this being
printed otherwise:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-2527  [001]   451.793164: gfs2_glock_state_change: dm-0
glock 2:33119 state NL => EX tgt:EX dmt:-- task:glock_workqueue
           <...>-2527  [001]   451.793321: gfs2_promote: dm-0 glock
2:33119 promote first task:glock_workqueue
           <...>-2547  [000]   451.793342: gfs2_demote_rq: dm-0 glock
2:33119 demote EX to NL task:gfs2_quotad
           <...>-2547  [000]   451.793345: gfs2_glock_queue: dm-0 glock
2:33119 dequeue task:gfs2_quotad

This is an example of the output from this tracer. The patch (against
the latest -tip tree) is below,

Steve.




>From a03e0948290eb7eb1c930c2269442700ccc19f5a Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 24 Apr 2009 16:14:17 +0100
Subject: [PATCH] GFS2: Add tracepoints

This patch adds tracepoints to various important places
in GFS2. The main focus is the glock subsystem, which after
all is really the core of GFS2, but there are also some
points for monitoring journalling and block allocation.

The purpose of the tracepoints is to enable testing for
both correctness and performance.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/bmap.c       |    3 +
 fs/gfs2/glock.c      |   12 ++-
 fs/gfs2/glock.h      |   29 ++++
 fs/gfs2/incore.h     |   16 ++
 fs/gfs2/log.c        |    8 +
 fs/gfs2/lops.c       |    3 +
 fs/gfs2/ops_fstype.c |    3 +
 fs/gfs2/rgrp.c       |   10 +-
 fs/gfs2/trace_gfs2.h |  371 ++++++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 451 insertions(+), 4 deletions(-)
 create mode 100644 fs/gfs2/trace_gfs2.h

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 3a5d3f8..a17c2b1 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -26,6 +26,7 @@
 #include "dir.h"
 #include "util.h"
 #include "ops_address.h"
+#include "trace_gfs2.h"
 
 /* This doesn't need to be that large as max 64 bit pointers in a 4k
  * block is 512, so __u16 is fine for that. It saves stack space to
@@ -585,6 +586,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	clear_buffer_mapped(bh_map);
 	clear_buffer_new(bh_map);
 	clear_buffer_boundary(bh_map);
+	trace_gfs2_bmap(ip, bh_map, lblock, create, 1);
 	if (gfs2_is_dir(ip)) {
 		bsize = sdp->sd_jbsize;
 		arr = sdp->sd_jheightsize;
@@ -619,6 +621,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	ret = 0;
 out:
 	release_metapath(&mp);
+	trace_gfs2_bmap(ip, bh_map, lblock, create, ret);
 	bmap_unlock(ip, create);
 	return ret;
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1afd9f2..d34f5de 100644
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
 
@@ -836,6 +843,7 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 			gl->gl_demote_state != state) {
 		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
+	trace_gfs2_demote_rq(gl);
 }
 
 /**
@@ -921,6 +929,7 @@ fail:
 			goto do_cancel;
 		return;
 	}
+	trace_gfs2_glock_queue(gh, 1);
 	list_add_tail(&gh->gh_list, insert_pt);
 do_cancel:
 	gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
@@ -1017,6 +1026,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
 			fast_path = 1;
 	}
+	trace_gfs2_glock_queue(gh, 0);
 	spin_unlock(&gl->gl_spin);
 	if (likely(fast_path))
 		return;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index a602a28..282b35b 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -260,4 +260,33 @@ void gfs2_unregister_debugfs(void);
 
 extern const struct lm_lockops gfs2_dlm_ops;
 
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
+
+static inline const char *glock_trace_name(u8 state)
+{
+	switch(state) {
+	case DLM_LOCK_PR:
+		return "PR";
+	case DLM_LOCK_CW:
+		return "CW";
+	case DLM_LOCK_EX:
+		return "EX";
+	case DLM_LOCK_NL:
+		return "NL";
+	default:
+		return "--";
+	}
+}
+
 #endif /* __GLOCK_DOT_H__ */
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 399d1b9..4e37c6e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -503,6 +503,7 @@ struct gfs2_sbd {
 	struct kobject sd_kobj;
 	unsigned long sd_flags;	/* SDF_... */
 	struct gfs2_sb_host sd_sb;
+	unsigned char sd_devname[BDEVNAME_SIZE];
 
 	/* Constants computed on mount */
 
@@ -667,5 +668,20 @@ struct gfs2_sbd {
 	struct dentry *debugfs_dentry_glocks; /* for debugfs */
 };
 
+static inline const char *gfs2_blkst_name(u8 state)
+{
+	switch(state) {
+	case GFS2_BLKST_FREE:
+		return "free";
+	case GFS2_BLKST_USED:
+		return "used";
+	case GFS2_BLKST_DINODE:
+		return "dinode";
+	case GFS2_BLKST_UNLINKED:
+		return "unlinked";
+	}
+	return "???";
+}
+
 #endif /* __INCORE_DOT_H__ */
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 98918a7..f82d7be 100644
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
@@ -765,6 +771,7 @@ void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	gfs2_log_unlock(sdp);
 
 	sdp->sd_vfs->s_dirt = 0;
+	trace_gfs2_log_flush(sdp, 0);
 	up_write(&sdp->sd_log_flush_lock);
 
 	kfree(ai);
@@ -788,6 +795,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_reserved + tr->tr_reserved >= reserved);
 	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
 	atomic_add(unused, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, unused);
 	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
 			     sdp->sd_jdesc->jd_blocks);
 	sdp->sd_log_blks_reserved = reserved;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 80e4f5f..52e591b 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -25,6 +25,7 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
+#include "trace_gfs2.h"
 
 /**
  * gfs2_pin - Pin a buffer in memory
@@ -51,6 +52,7 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	if (bd->bd_ail)
 		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
 	get_bh(bh);
+	trace_gfs2_pin(bd, 1);
 }
 
 /**
@@ -87,6 +89,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	bd->bd_ail = ai;
 	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	trace_gfs2_pin(bd, 0);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
 }
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 650a730..9265655 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -32,6 +32,7 @@
 #include "log.h"
 #include "quota.h"
 #include "dir.h"
+#include "trace_gfs2.h"
 
 #define DO 0
 #define UNDO 1
@@ -776,6 +777,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		/* Map the extents for this journal's blocks */
 		map_journal_extents(sdp);
 	}
+	trace_gfs2_log_blocks(sdp, atomic_read(&sdp->sd_log_blks_free));
 
 	if (sdp->sd_lockstruct.ls_first) {
 		unsigned int x;
@@ -1165,6 +1167,7 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 
 	sdp->sd_args.ar_quota = GFS2_QUOTA_DEFAULT;
 	sdp->sd_args.ar_data = GFS2_DATA_DEFAULT;
+	bdevname(sb->s_bdev, sdp->sd_devname);
 
 	error = gfs2_mount_args(sdp, &sdp->sd_args, data);
 	if (error) {
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f03d024..24de3df 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -30,6 +30,7 @@
 #include "log.h"
 #include "inode.h"
 #include "ops_address.h"
+#include "trace_gfs2.h"
 
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
@@ -1476,7 +1477,7 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone -= *n;
 	spin_unlock(&sdp->sd_rindex_spin);
-
+	trace_gfs2_block_alloc(ip, block, *n, GFS2_BLKST_USED);
 	return block;
 }
 
@@ -1519,7 +1520,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone--;
 	spin_unlock(&sdp->sd_rindex_spin);
-
+	trace_gfs2_block_alloc(dip, block, 1, GFS2_BLKST_DINODE);
 	return block;
 }
 
@@ -1539,7 +1540,7 @@ void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	rgd = rgblk_free(sdp, bstart, blen, GFS2_BLKST_FREE);
 	if (!rgd)
 		return;
-
+	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
 	rgd->rd_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
@@ -1567,6 +1568,7 @@ void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	rgd = rgblk_free(sdp, bstart, blen, GFS2_BLKST_FREE);
 	if (!rgd)
 		return;
+	trace_gfs2_block_alloc(ip, bstart, blen, GFS2_BLKST_FREE);
 
 	rgd->rd_free += blen;
 
@@ -1590,6 +1592,7 @@ void gfs2_unlink_di(struct inode *inode)
 	rgd = rgblk_free(sdp, blkno, 1, GFS2_BLKST_UNLINKED);
 	if (!rgd)
 		return;
+	trace_gfs2_block_alloc(ip, blkno, 1, GFS2_BLKST_UNLINKED);
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_trans_add_rg(rgd);
@@ -1621,6 +1624,7 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
 {
 	gfs2_free_uninit_di(rgd, ip->i_no_addr);
+	trace_gfs2_block_alloc(ip, ip->i_no_addr, 1, GFS2_BLKST_FREE);
 	gfs2_quota_change(ip, -1, ip->i_inode.i_uid, ip->i_inode.i_gid);
 	gfs2_meta_wipe(ip, ip->i_no_addr, 1);
 }
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
new file mode 100644
index 0000000..d273747
--- /dev/null
+++ b/fs/gfs2/trace_gfs2.h
@@ -0,0 +1,371 @@
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
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	u8,	new_state		)
+		__field(	u8,	dmt_state		)
+		__field(	u8,	tgt_state		)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+	),
+
+	TP_fast_assign(
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->new_state	= glock_trace_state(new_state);
+		__entry->tgt_state	= glock_trace_state(gl->gl_target);
+		__entry->dmt_state	= DLM_LOCK_IV;
+		if (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
+		    test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags))
+			__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+	),
+
+	TP_printk("%s glock %d:%lld state %s => %s tgt:%s dmt:%s task:%s",
+		  __entry->devname, __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  glock_trace_name(__entry->cur_state),
+		  glock_trace_name(__entry->new_state),
+		  glock_trace_name(__entry->tgt_state),
+		  glock_trace_name(__entry->dmt_state),
+		  __entry->comm)
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
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+	),
+
+	TP_fast_assign(
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+	),
+
+	TP_printk("%s glock %d:%lld state %s => %s task:%s",
+		  __entry->devname, __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+                  glock_trace_name(__entry->cur_state),
+		  glock_trace_name(DLM_LOCK_IV),
+		  __entry->comm)
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
+		__field(	u64,	glnum		)
+		__field(	u32,	gltype		)
+		__field(	u8,	cur_state	)
+		__field(	u8,	dmt_state	)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+	),
+
+	TP_fast_assign(
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+	),
+
+	TP_printk("%s glock %d:%lld demote %s to %s task:%s",
+		  __entry->devname, __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+                  glock_trace_name(__entry->cur_state),
+                  glock_trace_name(__entry->dmt_state),
+		  __entry->comm)
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
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	int,	first			)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+	),
+
+	TP_fast_assign(
+		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
+		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
+		__entry->first	= first;
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, gh->gh_gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+	),
+
+	TP_printk("%s glock %u:%llu promote%s task:%s",
+		  __entry->devname, __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->first ? " first": "",
+		  __entry->comm)
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
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+		__field(	int,	queue			)
+	),
+
+	TP_fast_assign(
+		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
+		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, gh->gh_gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+		__entry->queue		= queue;
+	),
+
+	TP_printk("%s glock %u:%llu %squeue task:%s",
+		  __entry->devname, __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->queue ? "" : "de",
+		  __entry->comm)
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
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+		__field(	int,	pin			)
+		__field(	u32,	len			)
+		__field(	sector_t,	block		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, bd->bd_gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+		__entry->pin		= pin;
+		__entry->len		= bd->bd_bh->b_size;
+		__entry->block		= bd->bd_bh->b_blocknr;
+	),
+
+	TP_printk("%s log %s %llu/%lu task:%s",
+		  __entry->devname, __entry->pin ? "pin" : "unpin",
+		 (unsigned long long)__entry->block,
+		 (unsigned long)__entry->len,
+		  __entry->comm)
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
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+		__field(	int,	start			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, sdp->sd_devname, BDEVNAME_SIZE);
+		__entry->start		= start;
+	),
+
+	TP_printk("%s log flush %s task:%s",
+		  __entry->devname, __entry->start ? "start" : "end",
+		  __entry->comm)
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
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+		__field(	int,	blocks			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, sdp->sd_devname, BDEVNAME_SIZE);
+		__entry->blocks		= blocks;
+	),
+
+	TP_printk("%s log reserve %d task:%s",
+		  __entry->devname, __entry->blocks, __entry->comm)
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
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
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
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, ip->i_gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+		__entry->lblock		= lblock;
+		__entry->pblock		= buffer_mapped(bh) ?  bh->b_blocknr : 0;
+		__entry->inum		= ip->i_no_addr;
+		__entry->state		= bh->b_state;
+		__entry->len		= bh->b_size;
+		__entry->create		= create;
+		__entry->errno		= errno;
+	),
+
+	TP_printk("%s bmap %llu map %llu/%lu to %llu flags:%08lx %s%d task:%s",
+		  __entry->devname,
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->lblock,
+		  (unsigned long)__entry->len,
+		  (unsigned long long)__entry->pblock,
+		  __entry->state, __entry->create ? "create " : "",
+		  __entry->errno, __entry->comm)
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
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__array(	char,	devname, BDEVNAME_SIZE	)
+		__field(	u64,	start			)
+		__field(	u64,	inum			)
+		__field(	u32,	len			)
+		__field(	u8,	block_state		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		memcpy(__entry->devname, ip->i_gl->gl_sbd->sd_devname, BDEVNAME_SIZE);
+		__entry->start		= block;
+		__entry->inum		= ip->i_no_addr;
+		__entry->len		= len;
+		__entry->block_state	= block_state;
+	),
+
+	TP_printk("%s bmap %llu alloc %llu/%lu %s task:%s",
+		  __entry->devname,
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->start,
+		  (unsigned long)__entry->len,
+		  gfs2_blkst_name(__entry->block_state),
+		  __entry->comm)
+);
+
+#endif /* _TRACE_GFS2_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../fs/gfs2/
+#include <trace/define_trace.h>
+
-- 
1.6.0.6



