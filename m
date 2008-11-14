Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYKNBXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYKNBXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYKNBVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:21:52 -0500
Received: from cobra.newdream.net ([66.33.216.30]:38156 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYKNBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:39 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 03/19] ceph: client types
Date: Thu, 13 Nov 2008 16:56:02 -0800
Message-Id: <1226624178-3761-4-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1226624178-3761-3-git-send-email-sage@newdream.net>
References: <1226624178-3761-1-git-send-email-sage@newdream.net>
 <1226624178-3761-2-git-send-email-sage@newdream.net>
 <1226624178-3761-3-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We first define constants, types, and prototypes for the kernel client
proper.

A few subsystems are defined separately later: the MDS, OSD, and
monitor clients, and the messaging layer.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/super.h |  687 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/types.h |   20 ++
 2 files changed, 707 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/super.h
 create mode 100644 fs/ceph/types.h

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
new file mode 100644
index 0000000..bdf45d1
--- /dev/null
+++ b/fs/ceph/super.h
@@ -0,0 +1,687 @@
+#ifndef _FS_CEPH_SUPER_H
+#define _FS_CEPH_SUPER_H
+
+#include <linux/fs.h>
+#include <linux/wait.h>
+#include <linux/completion.h>
+#include <linux/pagemap.h>
+#include <linux/exportfs.h>
+#include <linux/sysfs.h>
+#include <linux/sysfs.h>
+#include <linux/backing-dev.h>
+
+#include "types.h"
+#include "ceph_debug.h"
+#include "messenger.h"
+#include "mon_client.h"
+#include "mds_client.h"
+#include "osd_client.h"
+
+/* f_type in struct statfs */
+#define CEPH_SUPER_MAGIC 0x00c36400
+
+/* large granularity for statfs utilization stats to facilitate
+ * large volume sizes on 32-bit machines. */
+#define CEPH_BLOCK_SHIFT   20  /* 1 MB */
+#define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
+
+/*
+ * subtract jiffies
+ */
+static inline unsigned long time_sub(unsigned long a, unsigned long b)
+{
+	BUG_ON(time_after(b, a));
+	return (long)a - (long)b;
+}
+
+/*
+ * mount options
+ */
+#define CEPH_MOUNT_FSID          (1<<0)
+#define CEPH_MOUNT_NOSHARE       (1<<1) /* don't share client with other sbs */
+#define CEPH_MOUNT_MYIP          (1<<2) /* specified my ip */
+#define CEPH_MOUNT_UNSAFE_WRITEBACK (1<<3)
+#define CEPH_MOUNT_DIRSTAT       (1<<4) /* funky `cat dirname` for stats */
+#define CEPH_MOUNT_RBYTES        (1<<5) /* dir st_bytes = rbytes */
+#define CEPH_MOUNT_NOCRC         (1<<6) /* no data crc on writes */
+
+#define CEPH_MOUNT_DEFAULT   (CEPH_MOUNT_RBYTES)
+
+#define CEPH_DEFAULT_READ_SIZE	(128*1024) /* readahead */
+
+#define MAX_MON_MOUNT_ADDR	5
+
+struct ceph_mount_args {
+	int sb_flags;
+	int flags;
+	int mount_timeout;
+	struct ceph_fsid fsid;
+	struct ceph_entity_addr my_addr;
+	int num_mon;
+	struct ceph_entity_addr mon_addr[MAX_MON_MOUNT_ADDR];
+	int wsize;
+	int rsize;            /* max readahead */
+	int osd_timeout;
+	char *snapdir_name;   /* default ".snap" */
+};
+
+enum {
+	CEPH_MOUNT_MOUNTING,
+	CEPH_MOUNT_MOUNTED,
+	CEPH_MOUNT_UNMOUNTING,
+	CEPH_MOUNT_UNMOUNTED,
+	CEPH_MOUNT_SHUTDOWN,
+};
+
+
+extern struct kobject *ceph_kobj;
+
+/*
+ * per-filesystem client state
+ *
+ * possibly shared by multiple mount points, if they are
+ * mounting the same ceph filesystem/cluster.
+ */
+struct ceph_client {
+	u32 whoami;                   /* my client number */
+
+	struct mutex mount_mutex;       /* serialize mount attempts */
+	struct ceph_mount_args mount_args;
+	struct ceph_fsid fsid;
+
+	struct super_block *sb;
+
+	unsigned long mount_state;
+	wait_queue_head_t mount_wq;
+
+	struct ceph_messenger *msgr;   /* messenger instance */
+	struct ceph_mon_client monc;
+	struct ceph_mds_client mdsc;
+	struct ceph_osd_client osdc;
+
+	/* writeback */
+	struct workqueue_struct *wb_wq;
+	struct workqueue_struct *pg_inv_wq;
+	struct workqueue_struct *trunc_wq;
+
+	struct kobject *client_kobj;
+
+	struct backing_dev_info backing_dev_info;
+};
+
+static inline struct ceph_client *ceph_client(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+/*
+ * File i/o capability.  This tracks shared state with the metadata
+ * server that allows us to read and write data to this file.  For any
+ * given inode, we may have multiple capabilities, one issued by each
+ * metadata server, and our cumulative access is the OR of all issued
+ * capabilities.
+ *
+ * Each cap is referenced by the inode's i_caps tree and by a per-mds
+ * session capability list.
+ */
+struct ceph_cap {
+	struct ceph_inode_info *ci;
+	struct rb_node ci_node;         /* per-ci cap tree */
+	struct ceph_mds_session *session;
+	struct list_head session_caps;  /* per-session caplist */
+	int mds;
+	int issued;       /* latest, from the mds */
+	int implemented;  /* what we've implemented (for tracking revocation) */
+	u32 seq, mseq, gen;
+};
+
+/*
+ * Snapped cap state that is pending flush to mds.  When a snapshot occurs,
+ * we first complete any in-process sync writes and writeback any dirty
+ * data before flushing the snapped state (tracked here) back to the MDS.
+ */
+struct ceph_cap_snap {
+	struct list_head ci_item;
+	u64 follows;
+	int issued;
+	u64 size;
+	struct timespec mtime, atime, ctime;
+	u64 time_warp_seq;
+	struct ceph_snap_context *context;
+	int writing;   /* a sync write is still in progress */
+	int dirty;     /* dirty pages awaiting writeback */
+};
+
+/*
+ * The frag tree describes how a directory is fragmented, potentially across
+ * multiple metadata servers.  It is also used to indicate points where
+ * metadata authority is delegated, and whether/where metadata is replicated.
+ *
+ * A _leaf_ frag will be present in the i_fragtree IFF there is
+ * delegation info.  That is, if mds >= 0 || ndist > 0.
+ */
+#define MAX_DIRFRAG_REP 4
+
+struct ceph_inode_frag {
+	struct rb_node node;
+
+	/* fragtree state */
+	u32 frag;
+	int split_by;         /* i.e. 2^(split_by) children */
+
+	/* delegation info */
+	int mds;              /* -1 if same authority as parent */
+	int ndist;            /* >0 if replicated */
+	int dist[MAX_DIRFRAG_REP];
+};
+
+
+/*
+ * Ceph inode.
+ */
+struct ceph_inode_info {
+	struct ceph_vino i_vino;   /* ceph ino + snap */
+
+	u64 i_version;
+	u64 i_truncate_seq, i_time_warp_seq;
+
+	struct ceph_file_layout i_layout;
+	char *i_symlink;
+
+	/* for dirs */
+	struct timespec i_rctime;
+	u64 i_rbytes, i_rfiles, i_rsubdirs;
+	u64 i_files, i_subdirs;
+
+
+	struct rb_root i_fragtree;
+	struct mutex i_fragtree_mutex;
+
+	/* (still encoded) xattr blob. we avoid the overhead of parsing
+	 * this until someone actually called getxattr, etc. */
+	int i_xattr_len;
+	char *i_xattr_data;
+
+	/* inode lease.  protected _both_ by i_lock and i_lease_session's
+	 * s_mutex. */
+	int i_lease_mask;
+	struct ceph_mds_session *i_lease_session;
+	long unsigned i_lease_ttl;     /* jiffies */
+	u32 i_lease_gen;
+	struct list_head i_lease_item; /* mds session list */
+
+	/* capabilities.  protected _both_ by i_lock and cap->session's
+	 * s_mutex. */
+	struct rb_root i_caps;           /* cap list */
+	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
+	unsigned long i_hold_caps_until; /* jiffies */
+	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
+	int i_cap_exporting_mds;         /* to handle cap migration between */
+	unsigned i_cap_exporting_mseq;   /*  mds's. */
+	unsigned i_cap_exporting_issued;
+	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
+	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 */
+	unsigned i_snap_caps;           /* cap bits for snapped files */
+
+	int i_nr_by_mode[CEPH_FILE_MODE_NUM];  /* open file counts */
+
+	loff_t i_max_size;            /* max file size authorized by mds */
+	loff_t i_reported_size; /* (max_)size reported to or requested of mds */
+	loff_t i_wanted_max_size;     /* offset we'd like to write too */
+	loff_t i_requested_max_size;  /* max_size we've requested */
+
+	struct timespec i_old_atime;
+
+	/* held references to caps */
+	int i_rd_ref, i_rdcache_ref, i_wr_ref;
+	int i_wrbuffer_ref, i_wrbuffer_ref_head;
+	u32 i_rdcache_gen;      /* we increment this each time we get RDCACHE.
+				   If it's non-zero, we _may_ have cached
+				   pages. */
+	u32 i_rdcache_revoking; /* RDCACHE gen to async invalidate, if any */
+
+	struct ceph_snap_realm *i_snap_realm; /* snap realm (if caps) */
+	struct list_head i_snap_realm_item;
+	struct list_head i_snap_flush_item;
+
+	struct work_struct i_wb_work;  /* writeback work */
+	struct work_struct i_pg_inv_work;  /* page invalidation work */
+
+	loff_t i_vmtruncate_to;        /* delayed truncate work */
+	struct work_struct i_vmtruncate_work;
+
+	struct inode vfs_inode; /* at end */
+};
+
+static inline struct ceph_inode_info *ceph_inode(struct inode *inode)
+{
+	return list_entry(inode, struct ceph_inode_info, vfs_inode);
+}
+
+/* find a specific frag @f */
+static inline struct ceph_inode_frag *
+__ceph_find_frag(struct ceph_inode_info *ci, u32 f)
+{
+	struct rb_node *n = ci->i_fragtree.rb_node;
+
+	while (n) {
+		struct ceph_inode_frag *frag =
+			rb_entry(n, struct ceph_inode_frag, node);
+		int c = frag_compare(f, frag->frag);
+		if (c < 0)
+			n = n->rb_left;
+		else if (c > 0)
+			n = n->rb_right;
+		else
+			return frag;
+	}
+	return NULL;
+}
+
+/*
+ * choose fragment for value @v.  copy frag content to pfrag, if leaf
+ * exists
+ */
+extern u32 ceph_choose_frag(struct ceph_inode_info *ci, u32 v,
+			      struct ceph_inode_frag *pfrag,
+			      int *found);
+
+/*
+ * Ceph dentry state
+ */
+struct ceph_dentry_info {
+	struct dentry *dentry;
+	struct ceph_mds_session *lease_session;
+	u32 lease_gen;
+	struct list_head lease_item; /* mds session list */
+};
+
+static inline struct ceph_dentry_info *ceph_dentry(struct dentry *dentry)
+{
+	return (struct ceph_dentry_info *)dentry->d_fsdata;
+}
+
+
+/*
+ * ino_t is <64 bits on many architectures, blech.
+ *
+ * don't include snap in ino hash, at leaset for now.
+ */
+static inline ino_t ceph_vino_to_ino(struct ceph_vino vino)
+{
+	ino_t ino = (ino_t)vino.ino;  /* ^ (vino.snap << 20); */
+#if BITS_PER_LONG == 32
+	ino ^= vino.ino >> (sizeof(u64)-sizeof(ino_t)) * 8;
+#endif
+	return ino;
+}
+
+static inline int ceph_set_ino_cb(struct inode *inode, void *data)
+{
+	ceph_inode(inode)->i_vino = *(struct ceph_vino *)data;
+	inode->i_ino = ceph_vino_to_ino(*(struct ceph_vino *)data);
+	return 0;
+}
+
+static inline struct ceph_vino ceph_vino(struct inode *inode)
+{
+	return ceph_inode(inode)->i_vino;
+}
+
+/* for printf-style formatting */
+#define ceph_vinop(i) ceph_inode(i)->i_vino.ino, ceph_inode(i)->i_vino.snap
+
+static inline u64 ceph_ino(struct inode *inode)
+{
+	return ceph_inode(inode)->i_vino.ino;
+}
+static inline u64 ceph_snap(struct inode *inode)
+{
+	return ceph_inode(inode)->i_vino.snap;
+}
+
+static inline int ceph_ino_compare(struct inode *inode, void *data)
+{
+	struct ceph_vino *pvino = (struct ceph_vino *)data;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	return ci->i_vino.ino == pvino->ino &&
+		ci->i_vino.snap == pvino->snap;
+}
+
+static inline struct inode *ceph_find_inode(struct super_block *sb,
+					    struct ceph_vino vino)
+{
+	ino_t t = ceph_vino_to_ino(vino);
+	return ilookup5(sb, t, ceph_ino_compare, &vino);
+}
+
+
+/*
+ * caps helpers
+ */
+extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
+
+static inline int ceph_caps_issued(struct ceph_inode_info *ci)
+{
+	int issued;
+	spin_lock(&ci->vfs_inode.i_lock);
+	issued = __ceph_caps_issued(ci, NULL);
+	spin_unlock(&ci->vfs_inode.i_lock);
+	return issued;
+}
+
+static inline int __ceph_caps_used(struct ceph_inode_info *ci)
+{
+	int used = 0;
+	if (ci->i_rd_ref)
+		used |= CEPH_CAP_RD;
+	if (ci->i_rdcache_ref || ci->i_rdcache_gen)
+		used |= CEPH_CAP_RDCACHE;
+	if (ci->i_wr_ref)
+		used |= CEPH_CAP_WR;
+	if (ci->i_wrbuffer_ref)
+		used |= CEPH_CAP_WRBUFFER;
+	return used;
+}
+
+/*
+ * wanted, by virtue of open file modes
+ */
+static inline int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
+{
+	int want = 0;
+	int mode;
+	for (mode = 0; mode < 4; mode++)
+		if (ci->i_nr_by_mode[mode])
+			want |= ceph_caps_for_mode(mode);
+	return want;
+}
+
+/*
+ * wanted, by virtual of open file modes AND cap refs (buffered/cached data)
+ */
+static inline int __ceph_caps_wanted(struct ceph_inode_info *ci)
+{
+	int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
+	if (w & CEPH_CAP_WRBUFFER)
+		w |= CEPH_CAP_EXCL;  /* we want EXCL if we have dirty data */
+	return w;
+}
+
+/* for counting open files by mode */
+static inline void __ceph_get_fmode(struct ceph_inode_info *ci, int mode)
+{
+	ci->i_nr_by_mode[mode]++;
+}
+extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode);
+
+static inline struct ceph_client *ceph_inode_to_client(struct inode *inode)
+{
+	return (struct ceph_client *)inode->i_sb->s_fs_info;
+}
+
+static inline struct ceph_client *ceph_sb_to_client(struct super_block *sb)
+{
+	return (struct ceph_client *)sb->s_fs_info;
+}
+
+static inline int ceph_queue_writeback(struct inode *inode)
+{
+	return queue_work(ceph_inode_to_client(inode)->wb_wq,
+		   &ceph_inode(inode)->i_wb_work);
+}
+
+static inline int ceph_queue_page_invalidation(struct inode *inode)
+{
+	return queue_work(ceph_inode_to_client(inode)->pg_inv_wq,
+		   &ceph_inode(inode)->i_pg_inv_work);
+}
+
+
+/*
+ * keep readdir buffers attached to file->private_data
+ */
+struct ceph_file_info {
+	int mode;      /* initialized on open */
+	u32 frag;      /* one frag at a time; screw seek_dir() on large dirs */
+	struct ceph_mds_request *last_readdir;
+
+	/* used for -o dirstat read() on directory thing */
+	char *dir_info;
+	int dir_info_len;
+};
+
+
+
+/*
+ * snapshots
+ */
+
+/*
+ * A "snap context" is the set of existing snapshots when we
+ * write data.  It is used by the OSD to guide its COW behavior.
+ *
+ * The ceph_snap_context is refcounted, and attached to each dirty
+ * page, indicating which context the dirty data belonged when it was
+ * dirtied.
+ */
+struct ceph_snap_context {
+	atomic_t nref;
+	u64 seq;
+	int num_snaps;
+	u64 snaps[];
+};
+
+static inline struct ceph_snap_context *
+ceph_get_snap_context(struct ceph_snap_context *sc)
+{
+	/*
+	printk("get_snap_context %p %d -> %d\n", sc, atomic_read(&sc->nref),
+	       atomic_read(&sc->nref)+1);
+	*/
+	if (sc)
+		atomic_inc(&sc->nref);
+	return sc;
+}
+
+static inline void ceph_put_snap_context(struct ceph_snap_context *sc)
+{
+	if (!sc)
+		return;
+	/*
+	printk("put_snap_context %p %d -> %d\n", sc, atomic_read(&sc->nref),
+	       atomic_read(&sc->nref)-1);
+	*/
+	if (atomic_dec_and_test(&sc->nref)) {
+		/*printk(" deleting snap_context %p\n", sc);*/
+		kfree(sc);
+	}
+}
+
+/*
+ * A "snap realm" describes a subset of the file hierarchy sharing
+ * the same set of snapshots that apply to it.  The realms themselves
+ * are organized into a hierarchy, such that children inherit (some of)
+ * the snapshots of their parents.
+ *
+ * All inodes within the realm that have capabilities are linked into a
+ * per-realm list.
+ */
+struct ceph_snap_realm {
+	u64 ino;
+	int nref;
+	u64 created, seq;
+	u64 parent_ino;
+	u64 parent_since;   /* snapid when our current parent became so */
+
+	u64 *prior_parent_snaps;      /* snaps inherited from any parents we */
+	int num_prior_parent_snaps;   /*  had prior to parent_since */
+	u64 *snaps;                   /* snaps specific to this realm */
+	int num_snaps;
+
+	struct ceph_snap_realm *parent;
+	struct list_head children;       /* list of child realms */
+	struct list_head child_item;
+
+	/* the current set of snaps for this realm */
+	struct ceph_snap_context *cached_context;
+
+	struct list_head inodes_with_caps;
+};
+
+
+
+/*
+ * calculate the number of pages a given length and offset map onto,
+ * if we align the data.
+ */
+static inline int calc_pages_for(u64 off, u64 len)
+{
+	return ((off+len+PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT) -
+		(off >> PAGE_CACHE_SHIFT);
+}
+
+
+
+/* snap.c */
+extern void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
+				struct ceph_snap_realm *realm);
+extern struct ceph_snap_realm *ceph_update_snap_trace(struct ceph_mds_client *m,
+						      void *p, void *e,
+						      bool deletion);
+extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
+			     struct ceph_msg *msg);
+extern void ceph_queue_cap_snap(struct ceph_inode_info *ci,
+				struct ceph_snap_context *snapc);
+extern int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
+				  struct ceph_cap_snap *capsnap);
+
+/*
+ * a cap_snap is "pending" if it is still awaiting an in-progress
+ * sync write (that may/may not still update size, mtime, etc.).
+ */
+static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
+{
+	return !list_empty(&ci->i_cap_snaps) &&
+		list_entry(ci->i_cap_snaps.prev, struct ceph_cap_snap,
+			   ci_item)->writing;
+}
+
+
+/* super.c */
+extern const char *ceph_msg_type_name(int type);
+
+/* inode.c */
+extern const struct inode_operations ceph_file_iops;
+extern struct kmem_cache *ceph_inode_cachep;
+
+extern struct inode *ceph_alloc_inode(struct super_block *sb);
+extern void ceph_destroy_inode(struct inode *inode);
+
+extern struct inode *ceph_get_inode(struct super_block *sb,
+				    struct ceph_vino vino);
+extern struct inode *ceph_get_snapdir(struct inode *parent);
+extern int ceph_fill_inode(struct inode *inode,
+			   struct ceph_mds_reply_info_in *iinfo,
+			   struct ceph_mds_reply_dirfrag *dirinfo);
+extern void ceph_fill_file_bits(struct inode *inode, int issued,
+				u64 truncate_seq, u64 size,
+				u64 time_warp_seq, struct timespec *ctime,
+				struct timespec *mtime, struct timespec *atime);
+extern int ceph_fill_trace(struct super_block *sb,
+			   struct ceph_mds_request *req,
+			   struct ceph_mds_session *session);
+extern int ceph_readdir_prepopulate(struct ceph_mds_request *req);
+
+extern int ceph_inode_lease_valid(struct inode *inode, int mask);
+extern int ceph_dentry_lease_valid(struct dentry *dentry);
+
+extern void ceph_inode_set_size(struct inode *inode, loff_t size);
+extern void ceph_inode_writeback(struct work_struct *work);
+extern void ceph_vmtruncate_work(struct work_struct *work);
+extern void __ceph_do_pending_vmtruncate(struct inode *inode);
+
+extern int ceph_do_getattr(struct dentry *dentry, int mask);
+extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
+extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			struct kstat *stat);
+extern int ceph_setxattr(struct dentry *, const char *, const void *,
+			 size_t, int);
+extern ssize_t ceph_getxattr(struct dentry *, const char *, void *, size_t);
+extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
+extern int ceph_removexattr(struct dentry *, const char *);
+
+/* caps.c */
+extern void ceph_handle_caps(struct ceph_mds_client *mdsc,
+			     struct ceph_msg *msg);
+extern int ceph_add_cap(struct inode *inode,
+			struct ceph_mds_session *session,
+			int fmode, unsigned issued,
+			unsigned cap, unsigned seq,
+			void *snapblob, int snapblob_len,
+			struct ceph_cap *new_cap);
+extern void ceph_remove_cap(struct ceph_cap *cap);
+extern int ceph_get_cap_mds(struct inode *inode);
+extern int ceph_get_cap_refs(struct ceph_inode_info *ci, int need, int want,
+			     int *got, loff_t offset);
+extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
+extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
+				       struct ceph_snap_context *snapc);
+extern void __ceph_flush_snaps(struct ceph_inode_info *ci,
+			       struct ceph_mds_session **psession);
+extern void ceph_check_caps(struct ceph_inode_info *ci, int delayed);
+extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
+
+/* addr.c */
+extern const struct address_space_operations ceph_aops;
+extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
+
+/* file.c */
+extern const struct file_operations ceph_file_fops;
+extern const struct address_space_operations ceph_aops;
+extern int ceph_open(struct inode *inode, struct file *file);
+extern struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
+				       struct nameidata *nd, int mode,
+				       int locked_dir);
+extern int ceph_release(struct inode *inode, struct file *filp);
+
+
+/* dir.c */
+extern const struct file_operations ceph_dir_fops;
+extern const struct inode_operations ceph_dir_iops;
+extern struct dentry_operations ceph_dentry_ops, ceph_snap_dentry_ops,
+	ceph_snapdir_dentry_ops;
+
+extern char *ceph_build_path(struct dentry *dn, int *len, u64 *base, int min);
+extern struct dentry *ceph_do_lookup(struct super_block *sb,
+				     struct dentry *dentry,
+				     int mask, int on_inode, int locked_dir);
+extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
+					 struct dentry *dentry, int err);
+
+/*
+ * our d_ops vary depending on whether the inode is live,
+ * snapshotted (read-only), or a virtual ".snap" directory.
+ */
+static inline void ceph_init_dentry(struct dentry *dentry)
+{
+	if (ceph_snap(dentry->d_parent->d_inode) == CEPH_NOSNAP)
+		dentry->d_op = &ceph_dentry_ops;
+	else if (ceph_snap(dentry->d_parent->d_inode) == CEPH_SNAPDIR)
+		dentry->d_op = &ceph_snapdir_dentry_ops;
+	else
+		dentry->d_op = &ceph_snap_dentry_ops;
+	dentry->d_time = 0;
+}
+
+/* ioctl.c */
+extern long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
+/* export.c */
+extern const struct export_operations ceph_export_ops;
+
+/* proc.c */
+extern int ceph_proc_init(void);
+extern void ceph_proc_cleanup(void);
+
+#endif /* _FS_CEPH_SUPER_H */
diff --git a/fs/ceph/types.h b/fs/ceph/types.h
new file mode 100644
index 0000000..3c874b7
--- /dev/null
+++ b/fs/ceph/types.h
@@ -0,0 +1,20 @@
+#ifndef _FS_CEPH_TYPES_H
+#define _FS_CEPH_TYPES_H
+
+/* needed before including ceph_fs.h */
+#include <linux/in.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/string.h>
+
+#include "ceph_fs.h"
+
+/*
+ * Identify inodes by both their ino and snapshot id (a u64).
+ */
+struct ceph_vino {
+	u64 ino;
+	u64 snap;
+};
+
+#endif
-- 
1.5.6.5

