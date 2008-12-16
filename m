Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYLPPQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYLPPQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbYLPPQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:16:00 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:26782 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758616AbYLPPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:15:53 -0500
Message-ID: <4947C624.3050602@panasas.com>
Date: Tue, 16 Dec 2008 17:15:48 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com>
In-Reply-To: <4947BFAA.4030208@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 15:14:20.0896 (UTC) FILETIME=[F8AFA600:01C95F90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In this patch are all the osd infrastructure that will be used later
by the file system.

Also the declarations of constants, on disk structures, and prototypes.

And the Kbuild+Kconfig files needed to build the exofs module.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/Kbuild   |   30 +++++
 fs/exofs/Kconfig  |   13 ++
 fs/exofs/common.h |  154 ++++++++++++++++++++++++
 fs/exofs/exofs.h  |  183 +++++++++++++++++++++++++++++
 fs/exofs/osd.c    |  334 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 714 insertions(+), 0 deletions(-)
 create mode 100644 fs/exofs/Kbuild
 create mode 100644 fs/exofs/Kconfig
 create mode 100644 fs/exofs/common.h
 create mode 100644 fs/exofs/exofs.h
 create mode 100644 fs/exofs/osd.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
new file mode 100644
index 0000000..fd3351e
--- /dev/null
+++ b/fs/exofs/Kbuild
@@ -0,0 +1,30 @@
+#
+# Kbuild for the EXOFS module
+#
+# Copyright (C) 2008 Panasas Inc.  All rights reserved.
+#
+# Authors:
+#   Boaz Harrosh <bharrosh@panasas.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2
+#
+# Kbuild - Gets included from the Kernels Makefile and build system
+#
+
+ifneq ($(OSD_INC),)
+# we are built out-of-tree Kconfigure everything as on
+
+CONFIG_EXOFS_FS=m
+ccflags += -DCONFIG_EXOFS_FS -DCONFIG_EXOFS_FS_MODULE
+# ccflags += -DCONFIG_EXOFS_DEBUG
+
+# if we are built out-of-tree and the hosting kernel has OSD headers
+# then "ccflags-y +=" will not pick the out-off-tree headers. Only by doing
+# this it will work. This might break in future kernels
+KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
+
+endif
+
+exofs-objs := osd.o
+obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/Kconfig b/fs/exofs/Kconfig
new file mode 100644
index 0000000..86194b2
--- /dev/null
+++ b/fs/exofs/Kconfig
@@ -0,0 +1,13 @@
+config EXOFS_FS
+	tristate "exofs: OSD based file system support"
+	depends on SCSI_OSD_ULD
+	help
+	  EXOFS is a file system that uses an OSD storage device,
+	  as its backing storage.
+
+# Debugging-related stuff
+config EXOFS_DEBUG
+	bool "Enable debugging"
+	depends on EXOFS_FS
+	help
+	  This option enables EXOFS debug prints.
diff --git a/fs/exofs/common.h b/fs/exofs/common.h
new file mode 100644
index 0000000..9a165b3
--- /dev/null
+++ b/fs/exofs/common.h
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __EXOFS_COM_H__
+#define __EXOFS_COM_H__
+
+#include <linux/types.h>
+#include <linux/timex.h>
+
+#include <scsi/osd_attributes.h>
+#include <scsi/osd_initiator.h>
+#include <scsi/osd_sec.h>
+
+/****************************************************************************
+ * Object ID related defines
+ * NOTE: inode# = object ID - EXOFS_OBJ_OFF
+ ****************************************************************************/
+#define EXOFS_OBJ_OFF	0x10000	/* offset for objects */
+#define EXOFS_SUPER_ID	0x10000	/* object ID for on-disk superblock */
+#define EXOFS_BM_ID	0x10001	/* object ID for ID bitmap */
+#define EXOFS_ROOT_ID	0x10002	/* object ID for root directory */
+#define EXOFS_TEST_ID	0x10003	/* object ID for test object */
+
+/* exofs Application specific page/attribute */
+#ifndef OSD_PAGE_NUM_IBM_UOBJ_FS_DATA
+# define OSD_PAGE_NUM_IBM_UOBJ_FS_DATA	   (OSD_APAGE_APP_DEFINED_FIRST + 3)
+# define OSD_ATTR_NUM_IBM_UOBJ_FS_DATA_INODE 1
+#endif
+
+/*
+ * The maximum number of files we can have is limited by the size of the
+ * inode number.  This is the largest object ID that the file system supports.
+ * Object IDs 0, 1, and 2 are always in use (see above defines).
+ */
+enum {
+	EXOFS_UINT64_MAX = (~0LL),
+	EXOFS_MAX_INO_ID = (sizeof(ino_t) * 8 == 64) ? EXOFS_UINT64_MAX :
+					(1LL << (sizeof(ino_t) * 8 - 1)),
+	EXOFS_MAX_ID	 = (EXOFS_MAX_INO_ID - 1 - EXOFS_OBJ_OFF),
+};
+
+/****************************************************************************
+ * Misc.
+ ****************************************************************************/
+#define EXOFS_BLKSHIFT	12
+#define EXOFS_BLKSIZE	(1UL << EXOFS_BLKSHIFT)
+
+/****************************************************************************
+ * superblock-related things
+ ****************************************************************************/
+#define EXOFS_SUPER_MAGIC	0x5DF5
+
+/*
+ * The file system control block - stored in an object's data (mainly, the one
+ * with ID EXOFS_SUPER_ID).  This is where the in-memory superblock is stored
+ * on disk.  Right now it just has a magic value, which is basically a sanity
+ * check on our ability to communicate with the object store.
+ */
+struct exofs_fscb {
+	uint32_t  s_nextid;	/* Highest object ID used */
+	uint32_t  s_numfiles;	/* Number of files on fs */
+	uint16_t  s_magic;	/* Magic signature */
+	uint16_t  s_newfs;	/* Non-zero if this is a new fs */
+};
+
+/****************************************************************************
+ * inode-related things
+ ****************************************************************************/
+#define EXOFS_IDATA		5
+
+/*
+ * The file control block - stored in an object's attributes.  This is where
+ * the in-memory inode is stored on disk.
+ */
+struct exofs_fcb {
+	uint64_t  i_size;		/* Size of the file */
+	uint16_t  i_mode;         	/* File mode */
+	uint16_t  i_links_count;  	/* Links count */
+	uint32_t  i_uid;          	/* Owner Uid */
+	uint32_t  i_gid;          	/* Group Id */
+	uint32_t  i_atime;        	/* Access time */
+	uint32_t  i_ctime;        	/* Creation time */
+	uint32_t  i_mtime;        	/* Modification time */
+	uint32_t  i_flags;        	/* File flags */
+	uint32_t  i_version;      	/* File version */
+	uint32_t  i_generation;   	/* File version (for NFS) */
+	uint32_t  i_data[EXOFS_IDATA];	/* Short symlink names and device #s */
+};
+
+#define EXOFS_INO_ATTR_SIZE	sizeof(struct exofs_fcb)
+
+/****************************************************************************
+ * dentry-related things
+ ****************************************************************************/
+#define EXOFS_NAME_LEN	255
+
+/*
+ * The on-disk directory entry
+ */
+struct exofs_dir_entry {
+	uint32_t	inode;			/* inode number           */
+	uint16_t	rec_len;		/* directory entry length */
+	uint8_t		name_len;		/* name length            */
+	uint8_t		file_type;		/* umm...file type        */
+	char		name[EXOFS_NAME_LEN];	/* file name              */
+};
+
+enum {
+	EXOFS_FT_UNKNOWN,
+	EXOFS_FT_REG_FILE,
+	EXOFS_FT_DIR,
+	EXOFS_FT_CHRDEV,
+	EXOFS_FT_BLKDEV,
+	EXOFS_FT_FIFO,
+	EXOFS_FT_SOCK,
+	EXOFS_FT_SYMLINK,
+	EXOFS_FT_MAX
+};
+
+#define EXOFS_DIR_PAD			4
+#define EXOFS_DIR_ROUND			(EXOFS_DIR_PAD - 1)
+#define EXOFS_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXOFS_DIR_ROUND) & \
+					 ~EXOFS_DIR_ROUND)
+#endif
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
new file mode 100644
index 0000000..8534450
--- /dev/null
+++ b/fs/exofs/exofs.h
@@ -0,0 +1,183 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/fs.h>
+#include <linux/time.h>
+#include "common.h"
+
+#ifndef __EXOFS_H__
+#define __EXOFS_H__
+
+#define EXOFS_ERR(fmt, a...) printk(KERN_ERR "exofs: " fmt, ##a)
+
+#ifdef CONFIG_EXOFS_DEBUG
+#define EXOFS_DBGMSG(fmt, a...) \
+	printk(KERN_NOTICE "exofs @%s:%d: " fmt, __func__, __LINE__, ##a)
+#else
+#define EXOFS_DBGMSG(fmt, a...) \
+	do {} while (0)
+#endif
+
+/* u64 has problems with printk this will cast it to unsigned long long */
+#define _LLU(x) (unsigned long long)(x)
+
+/*
+ * our extension to the in-memory superblock
+ */
+struct exofs_sb_info {
+	struct osd_dev	*s_dev;			/* returned by get_osd_dev    */
+	uint64_t	s_pid;			/* partition ID of file system*/
+	int		s_timeout;		/* timeout for OSD operations */
+	uint32_t	s_nextid;		/* highest object ID used     */
+	uint32_t	s_numfiles;		/* number of files on fs      */
+	spinlock_t	s_next_gen_lock;	/* spinlock for gen # update  */
+	u32		s_next_generation;	/* next gen # to use          */
+	atomic_t	s_curr_pending;		/* number of pending commands */
+	uint8_t		s_cred[OSD_CAP_LEN];	/* all-powerful credential    */
+};
+
+/*
+ * our inode flags
+ */
+#ifdef ARCH_HAS_ATOMIC_UNSIGNED
+typedef unsigned exofs_iflags_t;
+#else
+typedef unsigned long exofs_iflags_t;
+#endif
+
+#define OBJ_2BCREATED	0	/* object will be created soon*/
+#define OBJ_CREATED	1	/* object has been created on the osd*/
+
+#define Obj2BCreated(oi) \
+	test_bit(OBJ_2BCREATED, &(oi->i_flags))
+#define SetObj2BCreated(oi) \
+	set_bit(OBJ_2BCREATED, &(oi->i_flags))
+
+#define ObjCreated(oi) \
+	test_bit(OBJ_CREATED, &(oi->i_flags))
+#define SetObjCreated(oi) \
+	set_bit(OBJ_CREATED, &(oi->i_flags))
+
+/*
+ * our extension to the in-memory inode
+ */
+struct exofs_i_info {
+	exofs_iflags_t i_flags;            /* various atomic flags            */
+	__le32	       i_data[EXOFS_IDATA];/*short symlink names and device #s*/
+	uint32_t       i_dir_start_lookup; /* which page to start lookup      */
+	wait_queue_head_t i_wq;            /* wait queue for inode            */
+	uint64_t       i_commit_size;      /* the object's written length     */
+	uint8_t        i_cred[OSD_CAP_LEN];/* all-powerful credential         */
+	struct inode   vfs_inode;          /* normal in-memory inode          */
+};
+
+/*
+ * get to our inode from the vfs inode
+ */
+static inline struct exofs_i_info *EXOFS_I(struct inode *inode)
+{
+	return container_of(inode, struct exofs_i_info, vfs_inode);
+}
+
+/*************************
+ * function declarations *
+ *************************/
+/* osd.c                 */
+void make_credential(uint8_t[], uint64_t, uint64_t);
+int check_ok(struct osd_request *);
+int exofs_sync_op(struct osd_request *, int, uint8_t *);
+int exofs_async_op(struct osd_request *, osd_req_done_fn *, void *, char *);
+
+int prepare_get_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint32_t attr_len);
+int prepare_set_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint16_t attr_len,
+				    const unsigned char *attr_val);
+int extract_next_attr_from_req(struct osd_request *req,
+			       uint32_t *page_num, uint32_t *attr_num,
+			       uint16_t *attr_len, uint8_t **attr_val);
+struct osd_request *prepare_osd_format_lun(struct osd_dev *dev,
+					   uint64_t formatted_capacity);
+struct osd_request *prepare_osd_create_partition(struct osd_dev *dev,
+						 uint64_t requested_id);
+struct osd_request *prepare_osd_remove_partition(struct osd_dev *dev,
+						 uint64_t requested_id);
+struct osd_request *prepare_osd_create(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t requested_id);
+struct osd_request *prepare_osd_remove(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t obj_id);
+struct osd_request *prepare_osd_set_attr(struct osd_dev *dev,
+					 uint64_t part_id,
+					 uint64_t obj_id);
+struct osd_request *prepare_osd_get_attr(struct osd_dev *dev,
+					 uint64_t part_id,
+					 uint64_t obj_id);
+struct osd_request *prepare_osd_read(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint64_t obj_id,
+				     uint64_t length,
+				     uint64_t offset,
+				     int cmd_data_use_sg,
+				     unsigned char *cmd_data);
+struct osd_request *prepare_osd_write(struct osd_dev *dev,
+				      uint64_t part_id,
+				      uint64_t obj_id,
+				      uint64_t length,
+				      uint64_t offset,
+				      int cmd_data_use_sg,
+				      const unsigned char *cmd_data);
+struct osd_request *prepare_osd_list(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint32_t list_id,
+				     uint64_t alloc_len,
+				     uint64_t initial_obj_id,
+				     int use_sg,
+				     void *data);
+int extract_list_from_req(struct osd_request *req,
+			  uint64_t *total_matches_p,
+			  uint64_t *num_ids_retrieved_p,
+			  uint64_t *list_of_ids_p[],
+			  int      *is_list_of_partitions_p,
+			  int      *list_isnt_up_to_date_p,
+			  uint64_t *continuation_tag_p,
+			  uint32_t *list_id_for_more_p);
+
+void free_osd_req(struct osd_request *req);
+
+#endif
diff --git a/fs/exofs/osd.c b/fs/exofs/osd.c
new file mode 100644
index 0000000..3859d3e
--- /dev/null
+++ b/fs/exofs/osd.c
@@ -0,0 +1,334 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <scsi/scsi_device.h>
+#include <scsi/osd_sense.h>
+
+#include "exofs.h"
+
+int check_ok(struct osd_request *req)
+{
+	struct osd_sense_info osi;
+	int ret = osd_req_decode_sense(req, &osi);
+
+	if (ret) { /* translate to Linux codes */
+		if (osi.additional_code == scsi_invalid_field_in_cdb) {
+			if (osi.cdb_field_offset == OSD_CFO_STARTING_BYTE)
+				ret = -EFAULT;
+			if (osi.cdb_field_offset == OSD_CFO_OBJECT_ID)
+				ret = -ENOENT;
+			else
+				ret = -EINVAL;
+		} else if (osi.additional_code == osd_quota_error)
+			ret = -ENOSPC;
+		else
+			ret = -EIO;
+	}
+
+	return ret;
+}
+
+void make_credential(uint8_t cred_a[OSD_CAP_LEN], uint64_t pid, uint64_t oid)
+{
+	struct osd_obj_id obj = {
+		.partition = pid,
+		.id = oid
+	};
+
+	osd_sec_init_nosec_doall_caps(cred_a, &obj, false, true);
+}
+
+/*
+ * Perform a synchronous OSD operation.
+ */
+int exofs_sync_op(struct osd_request *req, int timeout, uint8_t *credential)
+{
+	int ret;
+
+	req->timeout = timeout;
+	ret = osd_finalize_request(req, 0, credential, NULL);
+	if (ret) {
+		EXOFS_DBGMSG("Faild to osd_finalize_request() => %d\n", ret);
+		return ret;
+	}
+
+	ret = osd_execute_request(req);
+
+	if (ret)
+		EXOFS_DBGMSG("osd_execute_request() => %d\n", ret);
+	/* osd_req_decode_sense(or, ret); */
+	return ret;
+}
+
+/*
+ * Perform an asynchronous OSD operation.
+ */
+int exofs_async_op(struct osd_request *req, osd_req_done_fn *async_done,
+		   void *caller_context, char *credential)
+{
+	int ret;
+
+	ret = osd_finalize_request(req, 0, credential, NULL);
+	if (ret) {
+		EXOFS_DBGMSG("Faild to osd_finalize_request() => %d\n", ret);
+		return ret;
+	}
+
+	ret = osd_execute_request_async(req, async_done, caller_context);
+
+	if (ret)
+		EXOFS_DBGMSG("osd_execute_request_async() => %d\n", ret);
+	return ret;
+}
+
+int prepare_get_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint32_t attr_len)
+{
+	struct osd_attr attr = {
+		.page = page_num,
+		.attr_id = attr_num,
+		.len = attr_len,
+	};
+
+	return osd_req_add_get_attr_list(req, &attr, 1);
+}
+
+int prepare_set_attr_list_add_entry(struct osd_request *req,
+				    uint32_t page_num,
+				    uint32_t attr_num,
+				    uint16_t attr_len,
+				    const unsigned char *attr_val)
+{
+	struct osd_attr attr = {
+		.page = page_num,
+		.attr_id = attr_num,
+		.len = attr_len,
+		.val_ptr = (u8 *)attr_val,
+	};
+
+	return osd_req_add_set_attr_list(req, &attr, 1);
+}
+
+int extract_next_attr_from_req(struct osd_request *req,
+	uint32_t *page_num, uint32_t *attr_num,
+	uint16_t *attr_len, uint8_t **attr_val)
+{
+	struct osd_attr attr = {.page = 0}; /* start with zeros */
+	void *iter = NULL;
+	int nelem;
+
+	do {
+		nelem = 1;
+		osd_req_decode_get_attr_list(req, &attr, &nelem, &iter);
+		if ((attr.page == *page_num) && (attr.attr_id == *attr_num)) {
+			*attr_len = attr.len;
+			*attr_val = attr.val_ptr;
+			return 0;
+		}
+	} while (iter);
+
+	return -EIO;
+}
+
+struct osd_request *prepare_osd_format_lun(struct osd_dev *dev,
+					   uint64_t formatted_capacity)
+{
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_format(or, formatted_capacity);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_create_partition(struct osd_dev *dev,
+						 uint64_t requested_id)
+{
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_create_partition(or, requested_id);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_remove_partition(struct osd_dev *dev,
+						 uint64_t requested_id)
+{
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_remove_partition(or, requested_id);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_create(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint64_t requested_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = requested_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_create_object(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_remove(struct osd_dev *dev,
+				     uint64_t part_id,
+				     uint64_t obj_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_remove_object(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_set_attr(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t obj_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_set_attributes(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_get_attr(struct osd_dev *dev,
+				       uint64_t part_id,
+				       uint64_t obj_id)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+
+	if (!or)
+		return NULL;
+
+	osd_req_get_attributes(or, &obj);
+
+	return or;
+}
+
+struct osd_request *prepare_osd_read(struct osd_dev *dev,
+				   uint64_t part_id,
+				   uint64_t obj_id,
+				   uint64_t length,
+				   uint64_t offset,
+				   int cmd_data_use_sg,
+				   unsigned char *cmd_data)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+	struct request_queue *req_q = dev->scsi_device->request_queue;
+	struct bio *bio;
+
+	if (!or)
+		return NULL;
+
+	BUG_ON(cmd_data_use_sg);
+	bio = bio_map_kern(req_q, cmd_data, length, or->alloc_flags);
+	if (!bio) {
+		osd_end_request(or);
+		return NULL;
+	}
+
+	osd_req_read(or, &obj, bio, offset);
+	EXOFS_DBGMSG("osd_req_read(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
+		_LLU(part_id), _LLU(obj_id), _LLU(length), _LLU(offset));
+	return or;
+}
+
+struct osd_request *prepare_osd_write(struct osd_dev *dev,
+				    uint64_t part_id,
+				    uint64_t obj_id,
+				    uint64_t length,
+				    uint64_t offset,
+				    int cmd_data_use_sg,
+				    const unsigned char *cmd_data)
+{
+	struct osd_obj_id obj = {
+		.partition = part_id,
+		.id = obj_id
+	};
+	struct osd_request *or = osd_start_request(dev, GFP_KERNEL);
+	struct request_queue *req_q = dev->scsi_device->request_queue;
+	struct bio *bio;
+
+	if (!or)
+		return NULL;
+
+	BUG_ON(cmd_data_use_sg);
+	bio = bio_map_kern(req_q, (u8 *)cmd_data, length, or->alloc_flags);
+	if (!bio) {
+		osd_end_request(or);
+		return NULL;
+	}
+
+	osd_req_write(or, &obj, bio, offset);
+	EXOFS_DBGMSG("osd_req_write(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
+		_LLU(part_id), _LLU(obj_id), _LLU(length), _LLU(offset));
+	return or;
+}
+
+void free_osd_req(struct osd_request *req)
+{
+	osd_end_request(req);
+}
-- 
1.6.0.1


