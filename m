Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXCNPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXCNPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422663AbXCNPUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:20:48 -0400
Received: from smtp.nokia.com ([131.228.20.170]:63137 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161339AbXCNPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:13 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:19:54 +0200
Message-Id: <20070314151954.1112.59383.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/22 take 3] UBI: internal header
X-OriginalArrivalTime: 14 Mar 2007 15:19:54.0429 (UTC) FILETIME=[37DF7ED0:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314171955-1A8E6BB0-1DB80534/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/ubi.h tmp-to/drivers/mtd/ubi/ubi.h
--- tmp-from/drivers/mtd/ubi/ubi.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/ubi.h	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,867 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (C) Nokia Corporation, 2006, 2007
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: Artem B. Bityutskiy
+ */
+
+#ifndef __UBI_UBI_H__
+#define __UBI_UBI_H__
+
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/string.h>
+#include <linux/mtd/mtd.h>
+
+#include <mtd/ubi-header.h>
+#include <linux/mtd/ubi.h>
+
+#include "debug.h"
+
+/* Maximum number UBI devices supported in this implementation */
+#define UBI_MAX_DEVICES 32
+
+/* Name used for UBI character devices, sysfs, etc */
+#define UBI_STRING_NAME "ubi"
+
+/* Normal UBI messages */
+#define ubi_msg(fmt, ...)                                               \
+	printk(KERN_INFO "UBI: " fmt "\n", ##__VA_ARGS__)
+/* UBI warning messages */
+#define ubi_warn(fmt, ...)                                              \
+	printk(KERN_WARNING "UBI warning: %s: " fmt "\n", __FUNCTION__, \
+	       ##__VA_ARGS__)
+/* UBI error messages */
+#define ubi_err(fmt, ...)                                               \
+	printk(KERN_ERR "UBI error: %s " fmt "\n", __FUNCTION__,        \
+	       ##__VA_ARGS__)
+
+extern int ubis_num;
+extern struct ubi_info *ubis[];
+
+/*
+ * I/O unit's stuff.
+ *
+ * ============================================================================
+ */
+
+/**
+ * struct ubi_io_info - UBI I/O unit description data structure.
+ *
+ * @flash_size: underlying MTD device size (in bytes)
+ * @peb_count: count of physical eraseblocks on the MTD device
+ * @peb_size: physical eraseblock size
+ * @bad_peb_count: count of bad physical eraseblocks
+ * @good_peb_count: count of good physical eraseblocks
+ * @min_io_size: minimal input/output unit size of the underlying MTD device
+ * @hdrs_min_io_size: minimal I/O unit size used for VID and EC headers
+ * @ro_mode: if the UBI device is in read-only mode
+ * @leb_size: logical eraseblock size
+ * @leb_start: starting offset of logical eraseblocks within physical
+ * eraseblocks
+ * @ec_hdr_alsize: size of the EC header aligned to @hdrs_min_io_size
+ * @vid_hdr_alsize: size of the VID header aligned to @hdrs_min_io_size
+ * @vid_hdr_offset: starting offset of the volume identifier header (might be
+ * unaligned)
+ * @vid_hdr_aloffset: starting offset of the VID header aligned to
+ * @hdrs_min_io_size
+ * @vid_hdr_shift: contains @vid_hdr_offset - @vid_hdr_aloffset
+ * @bad_allowed: whether the MTD device admits of bad physical eraseblocks or
+ * not
+ * @mtd_num: MTD device number
+ * @mtd_name: MTD device name
+ * @mtd: MTD device descriptor
+ */
+struct ubi_io_info {
+	long long flash_size; /* public  */
+	int peb_count;        /* public  */
+	int peb_size;         /* public  */
+	int bad_peb_count;    /* public  */
+	int good_peb_count;   /* public  */
+	int min_io_size;      /* public  */
+	int hdrs_min_io_size; /* public  */
+	int ro_mode;          /* public  */
+	int leb_size;         /* public  */
+	int leb_start;        /* public  */
+	int ec_hdr_alsize;    /* public  */
+	int vid_hdr_alsize;   /* public  */
+	int vid_hdr_offset;   /* public  */
+	int vid_hdr_aloffset; /* public  */
+	int vid_hdr_shift;    /* public  */
+	int bad_allowed;      /* public  */
+	int mtd_num;          /* public  */
+	const char *mtd_name; /* public  */
+	struct mtd_info *mtd; /* private */
+};
+
+/*
+ * Error codes returned by the I/O unit.
+ *
+ * UBI_IO_PEB_EMPTY: the physical eraseblock is empty, i.e. it contains only
+ * 0xFF bytes
+ * UBI_IO_PEB_FREE: the physical eraseblock is free, i.e. it contains only a
+ * valid erase counter header, and the rest are %0xFF bytes
+ * UBI_IO_BAD_EC_HDR: the erase counter header is corrupted (bad magic or CRC)
+ * UBI_IO_BAD_VID_HDR: the volume identifier header is corrupted (bad magic or
+ * CRC)
+ * UBI_IO_BITFLIPS: bit-flips were detected and corrected
+ */
+enum {
+	UBI_IO_PEB_EMPTY = 1,
+	UBI_IO_PEB_FREE,
+	UBI_IO_BAD_EC_HDR,
+	UBI_IO_BAD_VID_HDR,
+	UBI_IO_BITFLIPS
+};
+
+int ubi_io_read(const struct ubi_info *ubi, void *buf, int pnum, int offset,
+		int len);
+int ubi_io_write(const struct ubi_info *ubi, const void *buf, int pnum,
+		 int offset, int len);
+int ubi_io_sync_erase(const struct ubi_info *ubi, int pnum, int torture);
+int ubi_io_is_bad(const struct ubi_info *ubi, int pnum);
+int ubi_io_mark_bad(const struct ubi_info *ubi, int pnum);
+int ubi_io_read_ec_hdr(const struct ubi_info *ubi, int pnum,
+		       struct ubi_ec_hdr *ec_hdr, int verbose);
+int ubi_io_write_ec_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_ec_hdr *ec_hdr);
+int ubi_io_read_vid_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_vid_hdr *vid_hdr, int verbose);
+int ubi_io_write_vid_hdr(const struct ubi_info *ubi, int pnum,
+			 struct ubi_vid_hdr *vid_hdr);
+int ubi_io_init(struct ubi_info *ubi, int mtd_num, int vid_hdr_offset,
+		int data_offset);
+void ubi_io_close(const struct ubi_info *ubi);
+
+/*
+ * Scanning unit's stuff.
+ *
+ * ============================================================================
+ */
+
+/* The erase counter value for this physical eraseblock is unknown */
+#define NAND_SCAN_UNKNOWN_EC (-1)
+
+/* Get sequence number during early initialization stages */
+#define ubi_scan_next_sqnum(si) (++(si)->max_sqnum)
+
+/**
+ * struct ubi_scan_leb - scanning information about a physical eraseblock.
+ *
+ * @ec: erase counter (%NAND_SCAN_UNKNOWN_EC if it is unknown)
+ * @pnum: physical eraseblock number
+ * @lnum: logical eraseblock number
+ * @scrub: if this physical eraseblock needs scrubbing
+ * @sqnum: sequence number
+ * @u.rb: link in the per-volume RB-tree of &struct ubi_scan_leb objects
+ * @u.list: link in one of the eraseblock lists
+ * @leb_ver: logical eraseblock version (obsolete)
+ *
+ * One object of this type is allocated for each physical eraseblock during
+ * scanning.
+ */
+struct ubi_scan_leb {
+	int ec;
+	int pnum;
+	int lnum;
+	int scrub;
+	unsigned long long sqnum;
+	union {
+		struct rb_node rb;
+		struct list_head list;
+	} u;
+	uint32_t leb_ver; /* FIXME: obsolete, to be removed */
+};
+
+/**
+ * struct ubi_scan_volume - scanning information about a volume.
+ *
+ * @vol_id: volume ID
+ * @highest_lnum: highest logical eraseblock number in this volume
+ * @leb_count: number of logical eraseblocks in this volume
+ * @vol_type: volume type
+ * @used_ebs: number of used logical eraseblocks in this volume (only for
+ * static volumes)
+ * @last_data_size: amount of data in the last logical eraseblock of this
+ * volume (always equivalent to the usable logical eraseblock size in case of
+ * dynamic volumes)
+ * @data_pad: how many bytes at the end of logical eraseblocks of this volume
+ * are not used (due to volume alignment)
+ * @compat: compatibility flags of this volume
+ * @rb: link in the volume RB-tree
+ * @root: root of the RB-tree containing all the eraseblock belonging to this
+ * volume (&struct ubi_scan_leb objects)
+ *
+ * One object of this type is allocated for each volume during scanning.
+ */
+struct ubi_scan_volume {
+	int vol_id;
+	int highest_lnum;
+	int leb_count;
+	int vol_type;
+	int used_ebs;
+	int last_data_size;
+	int data_pad;
+	int compat;
+	struct rb_node rb;
+	struct rb_root root;
+};
+
+/**
+ * struct ubi_scan_info - UBI scanning information.
+ *
+ * @volumes: root of the volume RB-tree
+ * @corr: list of corrupted physical eraseblocks
+ * @free: list of free physical eraseblocks
+ * @erase: list of physical eraseblocks which have to be erased
+ * @alien: list of physical eraseblocks which should not be used by UBI (e.g.,
+ * those belonging to "preserve"-compatible internal volumes)
+ * @vols_found: number of volumes found during scanning
+ * @highest_vol_id: highest volume ID
+ * @alien_peb_count: count of physical eraseblocks in the @alien list
+ * @is_empty: flag indicating whether the MTD device is empty or not
+ * @min_ec: lowest erase counter value
+ * @max_ec: highest erase counter value
+ * @max_sqnum: highest sequence number value
+ * @mean_ec: mean erase counter value
+ * @ec_sum: a temporary variable used when calculating @mean_ec
+ * @ec_count: a temporary variable used when calculating @mean_ec
+ *
+ * This data structure contains the result of scanning and may be used by other
+ * UBI units to build final UBI data structures, further error-recovery and so
+ * on.
+ */
+struct ubi_scan_info {
+	struct rb_root volumes;       /* public  */
+	struct list_head corr;        /* public  */
+	struct list_head free;        /* public  */
+	struct list_head erase;       /* public  */
+	struct list_head alien;       /* public  */
+	int vols_found;               /* public  */
+	int highest_vol_id;           /* public  */
+	int alien_peb_count;          /* public  */
+	int is_empty;                 /* public  */
+	int min_ec;                   /* public  */
+	int max_ec;                   /* public  */
+	unsigned long long max_sqnum; /* public  */
+	int mean_ec;                  /* public  */
+	int ec_sum;                   /* private */
+	int ec_count;                 /* private */
+};
+
+int ubi_scan_add_peb(const struct ubi_info *ubi, struct ubi_scan_info *si,
+		     int pnum, int ec, const struct ubi_vid_hdr *vid_hdr,
+		     int bitflips);
+int ubi_scan_add_corr_peb(struct ubi_scan_info *si, int pnum, int ec);
+struct ubi_scan_volume *ubi_scan_find_sv(const struct ubi_scan_info *si,
+					 int vol_id);
+struct ubi_scan_leb *ubi_scan_find_seb(const struct ubi_scan_volume *sv,
+				       int lnum);
+int ubi_scan_erase_peb(const struct ubi_info *ubi,
+		       const struct ubi_scan_info *si, int pnum, int ec);
+struct ubi_scan_leb *ubi_scan_get_free_peb(const struct ubi_info *ubi,
+					   struct ubi_scan_info *si);
+void ubi_scan_rm_volume(struct ubi_scan_info *si, struct ubi_scan_volume *sv);
+struct ubi_scan_info *ubi_scan(struct ubi_info *ubi);
+void ubi_scan_destroy_si(struct ubi_scan_info *si);
+
+/*
+ * Volume table unit's stuff.
+ *
+ * ============================================================================
+ */
+
+/**
+ * struct ubi_vtbl_vtr - in-memory representation of volume table records.
+ *
+ * @reserved_pebs: how many physical eraseblocks are reserved for this volume
+ * @alignment: volume alignment
+ * @data_pad: how many bytes are not used at the end of physical eraseblocks to
+ * satisfy the requested alignment
+ * @vol_type: volume type (%UBI_DYNAMIC_VOLUME or %UBI_STATIC_VOLUME)
+ * @name_len: volume name length
+ * @name: volume name
+ * @usable_leb_size: logical eraseblock size without padding
+ * @used_ebs: how many logical eraseblocks in this volume contain data
+ * @last_eb_bytes: how many bytes are stored in the last logical eraseblock
+ * @used_bytes: how many bytes of data this volume contains
+ * @corrupted: non-zero if the volume is corrupted (static volumes only)
+ * @upd_marker: non-zero if the update marker is set for this volume
+ *
+ * Note, the @usable_leb_size field is not stored on flash, as it is easily
+ * calculated with help of the @data_pad field. But it is just very handy, so
+ * we keep it in the in-RAM volume table record representation. The same is
+ * true for @last_eb_bytes, @used_bytes and @corrupted. We do not store them in
+ * the on-flash volume table but keep handy in RAM.
+ *
+ * The @corrupted field indicates that the volume's contents is corrupted.
+ * Since UBI protects only the contents of static volumes, this field is only
+ * relevant to static volumes. In case of dynamic volumes it is user's
+ * responsibility to assure data integrity.
+ *
+ * The @upd_marker flag indicates that this volume is either being updated at
+ * the moment or is damaged because of an unclean reboot. Note, the @corrupted
+ * flag is always cleared if the @upd_marker flag is set.
+ */
+struct ubi_vtbl_vtr {
+	int reserved_pebs;
+	int alignment;
+	int data_pad;
+	int vol_type;
+	int name_len;
+	int usable_leb_size;
+	const char *name;
+	int used_ebs;
+	int last_eb_bytes;
+	long long used_bytes;
+	int corrupted;
+	int upd_marker;
+};
+
+/**
+ * struct ubi_vtbl_info - UBI volume table unit description data structure.
+ *
+ * @vt_slots: how many volume table records are stored in the volume table
+ * @vol_count: count of existing volumes
+ * @vt_size: size of the volume table in bytes
+ * @vt: in-RAM copy of the volume table
+ * @ivol_vtrs: volume table records corresponding to internal volumes
+ * @vtbl_lock: protects volume table
+ */
+struct ubi_vtbl_info {
+	int vt_slots;                                     /* public  */
+	int vol_count;                                    /* public  */
+	int vt_size;                                      /* private */
+	struct ubi_vtbl_vtr *vt;                          /* private */
+	struct ubi_vtbl_vtr ivol_vtrs[UBI_INT_VOL_COUNT]; /* private */
+	struct mutex vtbl_lock;
+};
+
+int ubi_vtbl_mkvol(struct ubi_info *ubi, int vol_id, struct ubi_vtbl_vtr *vtr);
+int ubi_vtbl_rmvol(struct ubi_info *ubi, int vol_id);
+int ubi_vtbl_rsvol(struct ubi_info *ubi, int vol_id, int reserved_pebs);
+int ubi_vtbl_set_upd_marker(struct ubi_info *ubi, int vol_id);
+int ubi_vtbl_clear_upd_marker(struct ubi_info *ubi, int vol_id,
+			      long long bytes);
+int ubi_vtbl_set_corrupted(struct ubi_info *ubi, int vol_id);
+const struct ubi_vtbl_vtr *ubi_vtbl_get_vtr(const struct ubi_info *ubi,
+					    int vol_id);
+int ubi_vtbl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+void ubi_vtbl_close(const struct ubi_info *ubi);
+
+/*
+ * Accounting unit's stuff.
+ *
+ * ============================================================================
+ */
+
+/**
+ * struct ubi_acc_info - UBI accounting unit description data structure.
+ *
+ * @rsvd_pebs: count of reserved physical eraseblocks
+ * @avail_pebs: count of available physical eraseblocks
+ * @beb_rsvd_pebs: how many physical eraseblocks are reserved for bad PEB
+ * handling
+ * @beb_rsvd_max: how many PEBs have to be reserved for bad PEB handling, i.e.,
+ * the normal level of reserved PEBs
+ * @lock: protects @rsvd_pebs, @avail_pebs, @beb_rsvd_pebs, and @beb_rsvd_max
+ */
+struct ubi_acc_info {
+	int rsvd_pebs;     /* public  */
+	int avail_pebs;    /* public  */
+	int beb_rsvd_pebs; /* public  */
+	int beb_rsvd_max;  /* public  */
+	spinlock_t lock;   /* private */
+};
+
+int ubi_acc_reserve(struct ubi_info *ubi, int pebs);
+void ubi_acc_free(struct ubi_info *ubi, int pebs);
+void ubi_acc_peb_marked_bad(struct ubi_info *ubi);
+int ubi_acc_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/*
+ * Wear-leveling unit's stuff.
+ *
+ * ============================================================================
+ */
+
+struct ubi_wl_entry;
+struct ubi_work;
+
+/**
+ * struct ubi_wl_info - the UBI wear-leveling unit description data structure.
+ *
+ * @used: RB-tree of used physical eraseblocks
+ * @free: RB-tree of free physical eraseblocks
+ * @scrub: RB-tree of physical eraseblocks which need scrubbing
+ * @prot.pnum: protection tree indexed by physical eraseblock numbers
+ * @prot.aec: protection tree indexed by absolute erase counter value
+ * @lock: protects the @used, @free, @prot, @lookuptbl, @abs_ec, @move_from,
+ * @move_to, @move_to_put @erase_pending, @wl_scheduled, and @pending_works
+ * fields
+ * @wl_scheduled: non-zero if the wear leveling was scheduled
+ * @lookuptbl: a table to quickly find a &struct ubi_wl_entry object for any
+ * physical eraseblock
+ * @abs_ec: absolute erase counter
+ * @move_from: physical eraseblock from where the data is being moved
+ * @move_to: physical eraseblock where the data is being moved to
+ * @move_from_put: if the "from" PEB was put
+ * @move_to_put: if the "to" PEB was put
+ * @max_ec: current highest erase counter value
+ * @pending_works: list of pending works
+ * @pending_works_count: count of pending works
+ * @task: pointer to the &struct task_struct of the background thread
+ * @thread_enabled: if the background thread is enabled
+ * @bgt_name: background thread name
+ */
+struct ubi_wl_info {
+	struct rb_root used;             /* private */
+	struct rb_root free;             /* private */
+	struct rb_root scrub;            /* private */
+	struct {
+		struct rb_root pnum;     /* private */
+		struct rb_root aec;      /* private */
+	} prot;
+	spinlock_t lock;                 /* private */
+	int wl_scheduled;                /* private */
+	struct ubi_wl_entry **lookuptbl; /* private */
+	unsigned long long abs_ec;       /* public  */
+	struct ubi_wl_entry *move_from;  /* private */
+	struct ubi_wl_entry *move_to;    /* private */
+	int move_from_put;               /* private */
+	int move_to_put;                 /* private */
+	int max_ec;                      /* public  */
+	struct list_head pending_works;  /* private */
+	int pending_works_count;         /* public  */
+	struct task_struct *task;        /* private */
+	int thread_enabled;              /* private */
+	char *bgt_name;                  /* public  */
+};
+
+int ubi_wl_get_peb(struct ubi_info *ubi, enum ubi_data_type dtype);
+int ubi_wl_put_peb(struct ubi_info *ubi, int pnum, int torture);
+int ubi_wl_flush(struct ubi_info *ubi);
+int ubi_wl_scrub_peb(struct ubi_info *ubi, int pnum);
+void ubi_wl_enable_thread(struct ubi_info *ubi);
+int ubi_wl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+void ubi_wl_close(struct ubi_info *ubi);
+
+/*
+ * EBA unit's stuff.
+ *
+ * ============================================================================
+ */
+
+/**
+ * struct ubi_eba_info - UBI EBA unit description data structure.
+ *
+ * @eba_tbl: the eraseblock association table
+ * @global_sq_cnt: global sequence counter
+ * @eba_tbl_lock: protects the EBA table and the global sequence counter
+ * @ltree: the lock tree
+ * @ltree_lock: protects the lock tree
+ * @num_volumes: number of volumes mapped by the EBA table
+ */
+struct ubi_eba_info {
+	struct ubi_eba_tbl_volume *eba_tbl; /* private */
+	unsigned long long global_sq_cnt;   /* private */
+	spinlock_t eba_tbl_lock;            /* private */
+	struct rb_root ltree;               /* private */
+	spinlock_t ltree_lock;              /* private */
+	int num_volumes;                    /* private */
+};
+
+int ubi_eba_mkvol(struct ubi_info *ubi, int vol_id, int leb_count);
+int ubi_eba_rmvol(struct ubi_info *ubi, int vol_id);
+int ubi_eba_rsvol(struct ubi_info *ubi, int vol_id, int reserved_pebs);
+int ubi_eba_unmap_leb(struct ubi_info *ubi, int vol_id, int lnum);
+int ubi_eba_read_leb(struct ubi_info *ubi, int vol_id, int lnum, void *buf,
+		     int offset, int len, int check);
+int ubi_eba_write_leb(struct ubi_info *ubi, int vol_id, int lnum,
+		      const void *buf, int offset, int len,
+		      enum ubi_data_type dtype);
+int ubi_eba_write_leb_st(struct ubi_info *ubi, int vol_id, int lnum,
+			 const void *buf, int len, enum ubi_data_type dtype,
+			 int used_ebs);
+int ubi_eba_leb_is_mapped(struct ubi_info *ubi, int vol_id, int lnum);
+void ubi_eba_leb_remap(struct ubi_info *ubi, int vol_id, int lnum, int pnum);
+int ubi_eba_copy_leb(struct ubi_info *ubi, int from, int to,
+		     struct ubi_vid_hdr *vid_hdr);
+int ubi_eba_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+void ubi_eba_close(const struct ubi_info *ubi);
+
+/*
+ * User-interfaces unit's stuff.
+ *
+ * ============================================================================
+ */
+
+struct ubi_vol_desc;
+
+/**
+ * struct ubi_uif_volume - UBI volume description data structure.
+ *
+ * @dev: class device object to make use of the the Linux device model
+ * @cdev: Linux character device object to create a character device for this
+ * volume
+ * @ubi: reference to the UBI description object this volume belongs to
+ * @vol_id: volume ID
+ * @list: links volumes belonging to the same UBI device
+ * @readers: number of users holding this volume in read-only mode
+ * @writers: number of users holding this volume in read-write mode
+ * @exclusive: whether somebody holds this volume in exclusive mode
+ * @removed: if the volume was removed from the UBI device
+ * @checked: if this static volume was checked
+ * @vol_lock: protects the @readers, @writers, @exclusive, and @removed fields
+ *
+ * @updating: whether the volume is being updated
+ * @upd_ebs: how many eraseblocks are expected to be updated
+ * @upd_bytes: how many bytes are expected to be received
+ * @upd_received: how many update bytes were already received
+ * @upd_buf: update buffer which is used to collect update data
+ *
+ * @gluebi_desc: gluebi UBI volume descriptor
+ * @gluebi_refcount: reference count of the gluebi MTD device
+ * @gluebi_mtd: MTD device description object of the gluebi MTD device
+ */
+struct ubi_uif_volume {
+	struct device dev;
+	struct cdev cdev;
+	struct ubi_info *ubi;
+	int vol_id;
+	struct list_head list;
+	int readers;
+	int writers;
+	int exclusive;
+	int removed;
+	int checked;
+	spinlock_t vol_lock;
+
+	int updating;
+	int upd_ebs;
+	long long upd_bytes;
+	long long upd_received;
+	void *upd_buf;
+
+#ifdef CONFIG_MTD_UBI_GLUEBI
+	/* Gluebi-related stuff may be compiled out */
+	struct ubi_vol_desc *gluebi_desc;
+	int gluebi_refcount;
+	struct mtd_info gluebi_mtd;
+#endif
+};
+
+/**
+ * struct ubi_vol_desc - descriptor of the UBI volume returned when it is
+ * opened.
+ *
+ * @vol: reference to the corresponding volume description object
+ * @mode: open mode (%UBI_READONLY, %UBI_READWRITE, or %UBI_EXCLUSIVE)
+ */
+struct ubi_vol_desc {
+	struct ubi_uif_volume *vol;
+	int mode;
+};
+
+/**
+ * struct ubi_uif_info - UBI user interfaces unit description structure.
+ *
+ * @cdev: Linux character device object to create a character device of this
+ * UBI device
+ * @dev: class device object to use the the Linux device model
+ * @major: major number of this UBI character device
+ * @volumes: list of 'struct ubi_uif_volume' objects of each volume
+ * @volumes_list_lock: protects the the @volumes list
+ * @vol_check_lock: serializes volume checking
+ * @vol_change_lock: serializes volume creation/deletion/re-sizing
+ * @ubi_name: name of this UBI device
+ *
+ * The @volumes_list_lock lock protects the list of volumes. So it has to be
+ * locked when the @volumes list is being accessed. If @vol->vol_lock has to be
+ * locked simultaneously, @volumes_list_lock is locked first.
+ *
+ * The @vol_check_lock lock is used when checking static volumes consistency to
+ * prevent simultaneous volume checks.
+ *
+ * The volume_change_lock serializes volume creation, deletion and re-sizing,
+ * i.e. it serializes access to the volume table and EBA units.
+ */
+struct ubi_uif_info {
+	struct cdev cdev;
+	struct device dev;
+	int major;
+	struct list_head volumes;
+	spinlock_t volumes_list_lock;
+	struct mutex vol_check_lock;
+	struct mutex vol_change_lock;
+	char ubi_name[sizeof(UBI_STRING_NAME) + 5];
+};
+
+int ubi_uif_get_exclusive(struct ubi_vol_desc *desc);
+void ubi_uif_revoke_exclusive(struct ubi_vol_desc *desc, int mode);
+int ubi_uif_init(struct ubi_info *ubi);
+void ubi_uif_close(struct ubi_info *ubi);
+
+/* The update functionality is implemented in upd.c */
+int ubi_upd_start(struct ubi_uif_volume *vol, long long bytes);
+int ubi_upd_write_data(struct ubi_uif_volume *vol, const void __user *buf,
+		       int count);
+void ubi_upd_abort(struct ubi_uif_volume *vol);
+
+/* Character device interfaces are implemented in cdev.c */
+int ubi_cdev_init(struct ubi_info *ubi);
+void ubi_cdev_close(struct ubi_info *ubi);
+int ubi_cdev_vol_init(struct ubi_info *ubi, struct ubi_uif_volume *vol);
+#define ubi_cdev_vol_close(vol) cdev_del(&(vol)->cdev)
+
+/* The volume management functionality is implemented at vmt.c */
+int ubi_vmt_mkvol(struct ubi_info *ubi, int vol_id, struct ubi_vtbl_vtr *vtr);
+int ubi_vmt_rmvol(struct ubi_vol_desc *desc);
+int ubi_vmt_rsvol(struct ubi_info *ubi, int vol_id, int reserved_pebs);
+
+/* Sysfs support is implemented in sysfs.c */
+int ubi_sysfs_infr_init(void);
+void ubi_sysfs_infr_close(void);
+int ubi_sysfs_init(struct ubi_info *ubi);
+void ubi_sysfs_close(struct ubi_info *ubi);
+int ubi_sysfs_vol_init(struct ubi_info *ubi, struct ubi_uif_volume *vol);
+void ubi_sysfs_vol_close(struct ubi_uif_volume *vol);
+
+/* Gluebi stuff is implemented in gluebi.c */
+#ifdef CONFIG_MTD_UBI_GLUEBI
+int ubi_gluebi_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol);
+int ubi_gluebi_vol_close(struct ubi_uif_volume *vol);
+#else
+#define ubi_gluebi_vol_init(ubi, vol) 0
+#define ubi_gluebi_vol_close(vol) 0
+#endif
+
+/**
+ * struct ubi_info - UBI device description structure
+ *
+ * @ubi_num: number of the UBI device
+ * @io: input/output unit information
+ * @wl: wear-leveling unit information
+ * @beb: bad eraseblock handling unit information
+ * @vtbl: volume table unit information
+ * @acc: accounting unit information
+ * @upd: update unit information
+ * @eba: EBA unit information
+ * @uif: user interface unit information
+ */
+struct ubi_info {
+	int ubi_num;
+	struct ubi_io_info   io;
+	struct ubi_wl_info   wl;
+	struct ubi_vtbl_info vtbl;
+	struct ubi_acc_info  acc;
+	struct ubi_eba_info  eba;
+	struct ubi_uif_info  uif;
+};
+
+/*
+ * Miscellaneous stuff.
+ *
+ * ============================================================================
+ */
+
+/**
+ * rb_for_each_entry - walk an RB-tree.
+ *
+ * @rb: a pointer to type 'struct rb_node' to to use as a loop counter
+ * @pos: a pointer to RB-tree entry type to use as a loop counter
+ * @root: RB-tree's root
+ * @member: the name of the 'struct rb_node' within the RB-tree entry
+ */
+#define rb_for_each_entry(rb, pos, root, member)                             \
+	for (rb = rb_first(root),                                            \
+	     pos = (rb ? container_of(rb, typeof(*pos), member) : NULL);     \
+	     rb;                                                             \
+	     rb = rb_next(rb), pos = container_of(rb, typeof(*pos), member))
+
+/*
+ * align_up - align an integer to another integer.
+ *
+ * @x: the integer to align
+ * @y: the integer to align to
+ *
+ * This function returns the lowest number which is multiple to @y and not less
+ * then @x.
+ */
+static inline int align_up(int x, int y)
+{
+	return y*(x/y) + (!!(x % y)) * y;
+}
+
+/*
+ * align_down - align an integer to another integer.
+ *
+ * @x: the integer to align
+ * @y: the integer to align to
+ *
+ * This function returns the highest number which is multiple to @y and not
+ * greater then @x.
+ */
+static inline int align_down(int x, int y)
+{
+	return y*(x/y);
+}
+
+int ubi_buf_all_ff(const void *buf, int size);
+int ubi_buf_all_zeroes(const void *buf, int size);
+int ubi_check_pattern(const void *buf, uint8_t patt, int size);
+int ubi_calc_data_len(const struct ubi_info *ubi, const void *buf, int length);
+int ubi_check_volume(struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_zalloc_vid_hdr - allocate a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns a pointer to the newly allocated and zero-filled
+ * volume identifier header object in case of success and %NULL in case of
+ * failure.
+ */
+static inline struct ubi_vid_hdr *ubi_zalloc_vid_hdr(const struct ubi_info *ubi)
+{
+	void *vid_hdr;
+
+	vid_hdr = kzalloc(ubi->io.vid_hdr_alsize, GFP_KERNEL);
+	if (unlikely(!vid_hdr))
+		return NULL;
+
+	/*
+	 * If VID headers may be stored at non-aligned flash offsets, so we
+	 * shift the pointer to hide alignment complexities from other UBI
+	 * units.
+	 */
+	return vid_hdr + ubi->io.vid_hdr_shift;
+}
+
+/**
+ * ubi_free_vid_hdr - free a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ * @vid_hdr: a pointer to the object to free
+ */
+static inline void ubi_free_vid_hdr(const struct ubi_info *ubi,
+				    struct ubi_vid_hdr *vid_hdr)
+{
+	void *p = vid_hdr;
+
+	if (unlikely(!p))
+		return;
+	/* The pointer was shifted, shift it back */
+	kfree(p - ubi->io.vid_hdr_shift);
+}
+
+/*
+ * This function is equivalent to 'ubi_io_read()', but @offset is relative to
+ * the beginning of the logical eraseblock, not to the beginning of the
+ * physical eraseblock.
+ */
+static inline int ubi_io_read_data(const struct ubi_info *ubi, void *buf,
+				   int pnum, int offset, int len)
+{
+	ubi_assert(offset >= 0);
+	return ubi_io_read(ubi, buf, pnum, offset + ubi->io.leb_start, len);
+}
+
+/*
+ * This function is equivalent to 'ubi_io_write()', but @offset is relative to
+ * the beginning of the logical eraseblock, not to the beginning of the
+ * physical eraseblock.
+ */
+static inline int ubi_io_write_data(const struct ubi_info *ubi, const void *buf,
+				    int pnum, int offset, int len)
+{
+	ubi_assert(offset >= 0);
+	return ubi_io_write(ubi, buf, pnum, offset + ubi->io.leb_start, len);
+}
+
+/**
+ * ubi_ro_mode - switch to read-only mode.
+ *
+ * @ubi: the UBI device description object
+ */
+static inline void ubi_ro_mode(struct ubi_info *ubi)
+{
+	ubi->io.ro_mode = 1;
+	ubi_warn("switch to read-only mode");
+}
+
+/**
+ * ubi_is_ivol - check if a volume is an internal volume.
+ *
+ * @vol_id: ID of the volume to test
+ *
+ * If the volume is internal volume, %1 is returned, otherwise %0 is returned.
+ */
+static inline int ubi_is_ivol(int vol_id)
+{
+	return vol_id >= UBI_INTERNAL_VOL_START &&
+	       vol_id < UBI_INTERNAL_VOL_START + UBI_INT_VOL_COUNT;
+}
+
+/*
+ * ubi_ivol_is_known - check if this is a known internal volume.
+ *
+ * @vol_id: ID of the volume to check.
+ *
+ * This function returns non-zero if this is a known and supported internal
+ * volume and non-zero if not.
+ */
+static inline int ubi_ivol_is_known(int vol_id)
+{
+	return vol_id == UBI_LAYOUT_VOL_ID;
+}
+
+/**
+ * ubi_get_compat - get compatibility flags of a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ *
+ * This function returns compatibility flags of volumes. User volumes have no
+ * compatibility flags, so %0 is returned. The @vol_id must be correct.
+ */
+static inline int ubi_get_compat(const struct ubi_info *ubi, int vol_id)
+{
+	if (!ubi_is_ivol(vol_id))
+		return 0;
+
+	switch (vol_id) {
+		case UBI_LAYOUT_VOL_ID:
+			return UBI_LAYOUT_VOLUME_COMPAT;
+		default:
+			BUG();
+	}
+
+	return -ENODEV;
+}
+
+#endif /* !__UBI_UBI_H__ */
