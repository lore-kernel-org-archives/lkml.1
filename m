Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbZJFUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbZJFUqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933300AbZJFUqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:46:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:25817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbZJFUqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:46:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,514,1249282800"; 
   d="scan'208";a="733606070"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com, greg@kroah.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Integrating SEP Driver with RAR Driver
Date: Tue,  6 Oct 2009 13:46:17 -0700
Message-Id: <1254861977-18123-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SEP stands for Security Processor; a dedicated processor
that does encryption, decryption, key management, and
secure storage.

RAR stands for Restricted Access Region; this is memory
aboard the MID platform that is restricted (via hardware)
from access by software running on the x86 processor. 
Dedicated 'smart' peripherals such as sound, video, and
encryption can access these regions of memory. They are here
to help protect copyrighted midia from being illegally copied.

This is upstream revision 4 of the SEP driver.

This is a patch referenced from the linux-next repository
as pulled on October 6, 2009; from the following URL:

git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

This is a modified SEP driver to include integration with
the RAR driver

The SEP uses a region of restricted memory to hold its own
firmware; protecting that firmware and it's operation by
snooping via the x86 software.

Please be aware that this patch does not contain any encryption
algorithm. It only transports data to and from user space
applications to the security processor.

Please be aware that the SEP does require propriatary firmware;
however, the firmware is not within the kernel. It is to be
located in /lib/firmware and loaded by the normal kernel
firmware infrastructure using the request_firmware() kernel
api function call.

Please be aware that this driver does require the presence of
the RAR driver in order to compile and run.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: October 06, 2009

---
 drivers/staging/sep/Kconfig                   |    9 +-
 drivers/staging/sep/Makefile                  |    3 +-
 drivers/staging/sep/sep_driver_api.h          |  622 +++--
 drivers/staging/sep/sep_driver_config.h       |  212 ++-
 drivers/staging/sep/sep_driver_ext_api.h      |  113 +
 drivers/staging/sep/sep_driver_hw_defs.h      |   68 +-
 drivers/staging/sep/sep_ext_with_pci_driver.c |  681 +++++
 drivers/staging/sep/sep_main_mod.c            | 3704 +++++++++++++++++++++++++
 create mode 100644 drivers/staging/sep/sep_driver_ext_api.h
 create mode 100644 drivers/staging/sep/sep_ext_with_pci_driver.c
 create mode 100644 drivers/staging/sep/sep_main_mod.c

diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 0a9c39c..ef3c785 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -1,10 +1,9 @@
 config DX_SEP
-	tristate "Discretix SEP driver"
-#	depends on MRST
-	depends on RAR_REGISTER && PCI
-	default y
+	tristate "SEP driver"
+	depends on X86_MRST && RAR_REGISTER
+	default n
 	help
-	  Discretix SEP driver
+	  SEP driver
 
 	  If unsure say M. The compiled module will be
 	  called sep_driver.ko
diff --git a/drivers/staging/sep/Makefile b/drivers/staging/sep/Makefile
index 628d5f9..e2528e8 100644
--- a/drivers/staging/sep/Makefile
+++ b/drivers/staging/sep/Makefile
@@ -1,2 +1,3 @@
+EXTRA_CFLAGS += -DLITTLE__ENDIAN -DDX_CC5_SEP_PLAT -DCRYS_NO_EXT_IF_MODE_SUPPORT
 obj-$(CONFIG_DX_SEP) := sep_driver.o
-
+sep_driver-objs := sep_main_mod.o sep_ext_with_pci_driver.o
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 383543d..c1bfb57 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -1,38 +1,40 @@
-/*
- *
- *  sep_driver_api.h - Security Processor Driver api definitions
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the Free
- *  Software Foundation; either version 2 of the License, or (at your option)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License along with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- *  CONTACTS:
- *
- *  Mark Allyn		mark.a.allyn@intel.com
- *
- *  CHANGES:
- *
- *  2009.06.26	Initial publish
- *
- */
-
-#ifndef __SEP_DRIVER_API_H__
+/**************************************************************************
+ *  Copyright(c) 2009 Intel Corporation. All rights reserved.		* 
+ *  Copyright(c) 2009 Discretix. All rights reserved.			*
+ *									*
+ *   This software is        						 *
+ *   protected by copyright, international treaties and various patents.   *
+ *   Any copy or reproduction of this Software as permitted below, must    *
+ *   include this Copyright Notice as well as any other notices provided   *
+ *   under such license.                                                   *
+ *                                                                         *
+ *   This program shall be governed by, and may be used and redistributed  *
+ *   under the terms and conditions of the GNU General Public       *
+ *   License, version 2.1, as published by the Free Software Foundation.   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied      *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.      *
+ *   See the GNU General Public License for more details.                  *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public      *
+ *   License along with this program; if not, please write to the          *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+ 
+ #ifndef __SEP_DRIVER_API_H__
 #define __SEP_DRIVER_API_H__
 
-
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
 
 /*----------------------------------------------------------------
   IOCTL command defines
@@ -83,6 +85,9 @@
 /* init sep command */
 #define SEP_IOCSEPINIT                         _IO(SEP_IOC_MAGIC_NUMBER , 13)
 
+/* set non blocking mode */
+#define SEP_IOCSETAPIMODE                      _IO(SEP_IOC_MAGIC_NUMBER , 14)
+
 /* end transaction command */
 #define SEP_IOCENDTRANSACTION                  _IO(SEP_IOC_MAGIC_NUMBER , 15)
 
@@ -92,9 +97,18 @@
 /* get the offset of the address starting from the beginnnig of the map area */
 #define SEP_IOCGETMAPPEDADDROFFSET             _IO(SEP_IOC_MAGIC_NUMBER , 17)
 
+/* reallocate cache and resident */
+#define SEP_IOCREALLOCEXTCACHE                 _IO(SEP_IOC_MAGIC_NUMBER , 18)
+
 /* get time address and value */
 #define SEP_IOCGETIME                          _IO(SEP_IOC_MAGIC_NUMBER , 19)
 
+#define SEP_IOCRARPREPAREMESSAGE                 _IO(SEP_IOC_MAGIC_NUMBER , 20)
+
+#define SEP_IOCTLSINGLETONLOCK                 _IO(SEP_IOC_MAGIC_NUMBER , 32)
+
+#define SEP_IOCTLSETCALLERID                   _IO(SEP_IOC_MAGIC_NUMBER , 33)
+
 /*-------------------------------------------
     TYPEDEFS
 ----------------------------------------------*/
@@ -103,12 +117,14 @@
   init command struct
 */
 struct sep_driver_init_t {
-	/* start of the 1G of the host memory address that SEP can access */
-	unsigned long message_addr;
+  /* start of the 1G of the host memory address that SEP can access */
+  unsigned long   message_addr;
 
-	/* start address of resident */
-	unsigned long message_size_in_words;
+  /* start address of resident */
+  unsigned long   message_size_in_words;
 
+  /* offset of the init message in the sep sram */
+  unsigned long   sep_sram_addr;
 };
 
 
@@ -116,192 +132,183 @@ struct sep_driver_init_t {
   realloc cache resident command
 */
 struct sep_driver_realloc_cache_resident_t {
-	/* new cache address */
-	u64 new_cache_addr;
-	/* new resident address */
-	u64 new_resident_addr;
-	/* new resident address */
-	u64  new_shared_area_addr;
-	/* new base address */
-	u64 new_base_addr;
-};
+  /* base address */
+  unsigned long   base_addr;
 
-struct sep_driver_alloc_t {
-	/* virtual address of allocated space */
-	unsigned long offset;
+  /* current cache address */
+  unsigned long   cache_addr;
 
-	/* physical address of allocated space */
-	unsigned long phys_address;
+  /* cache size in bytes*/
+  unsigned long   cache_size_in_bytes;
 
-	/* number of bytes to allocate */
-	unsigned long num_bytes;
-};
+  /* current resident address */
+  unsigned long   resident_addr;
 
-/*
- */
-struct sep_driver_write_t {
-	/* application space address */
-	unsigned long app_address;
-
-	/* address of the data pool */
-	unsigned long datapool_address;
+  /* resident size in bytes*/
+  unsigned long   resident_size_in_bytes;
 
-	/* number of bytes to write */
-	unsigned long num_bytes;
-};
-
-/*
- */
-struct sep_driver_read_t {
-	/* application space address */
-	unsigned long app_address;
+  /* current dcache address */
+  unsigned long   dcache_addr;
 
-	/* address of the data pool */
-	unsigned long datapool_address;
+  /* resident size in bytes*/
+  unsigned long   dcache_size_in_bytes;
 
-	/* number of bytes to read */
-	unsigned long num_bytes;
-};
+  /* ext cache current address */
+  unsigned long   extcache_addr;
 
-/*
-*/
-struct sep_driver_build_sync_table_t {
-	/* address value of the data in */
-	unsigned long app_in_address;
+  /* ext cache size in bytes*/
+  unsigned long   extcache_size_in_bytes;
 
-	/* size of data in */
-	unsigned long data_in_size;
+  /* new cache address */
+  unsigned long   new_cache_addr;
 
-	/* address of the data out */
-	unsigned long app_out_address;
+  /* new resident address */
+  unsigned long   new_resident_addr;
 
-	/* the size of the block of the operation - if needed,
-	   every table will be modulo this parameter */
-	unsigned long block_size;
+  /* new dcache address */
+  unsigned long   new_dcache_addr;
 
-	/* the physical address of the first input DMA table */
-	unsigned long in_table_address;
+  /* new resident address */
+  unsigned long   new_shared_area_addr;
 
-	/* number of entries in the first input DMA table */
-	unsigned long in_table_num_entries;
+  /* new base address */
+  unsigned long   new_base_addr;
+};
 
-	/* the physical address of the first output DMA table */
-	unsigned long out_table_address;
 
-	/* number of entries in the first output DMA table */
-	unsigned long out_table_num_entries;
+struct sep_driver_realloc_ext_cache_t {
+  /* current external cache address */
+  unsigned long   ext_cache_addr;
 
-	/* data in the first input table */
-	unsigned long table_data_size;
+  /* external cache size in bytes*/
+  unsigned long   ext_cache_size_in_bytes;
 
-	/* distinct user/kernel layout */
-	bool isKernelVirtualAddress;
+  /* new external cache address */
+  unsigned long   new_ext_cache_addr;
 
 };
 
 /*
+  set api mode command struct
 */
-struct sep_driver_build_flow_table_t {
-	/* flow type */
-	unsigned long flow_type;
-
-	/* flag for input output */
-	unsigned long input_output_flag;
+struct sep_driver_set_api_mode_t {
+  /* mode to set - 1 - blocking, 0 - non-blocking */
+  unsigned long   mode;
+};
 
-	/* address value of the data in */
-	unsigned long virt_buff_data_addr;
+struct sep_driver_alloc_t {
+  /* virtual address of allocated space */
+  unsigned long offset;
 
-	/* size of data in */
-	unsigned long num_virtual_buffers;
+  /* physical address of allocated space */
+  unsigned long phys_address;
 
-	/* the physical address of the first input DMA table */
-	unsigned long first_table_addr;
+  /* number of bytes to allocate */
+  unsigned long num_bytes;
+};
 
-	/* number of entries in the first input DMA table */
-	unsigned long first_table_num_entries;
+/*
+ */
+struct sep_driver_write_t {
+  /* application space address */
+  unsigned long app_address;
 
-	/* data in the first input table */
-	unsigned long first_table_data_size;
+  /* address of the data pool */
+  unsigned long datapool_address;
 
-	/* distinct user/kernel layout */
-	bool isKernelVirtualAddress;
+  /* number of bytes to write */
+  unsigned long num_bytes;
 };
 
+/*
+ */
+struct sep_driver_read_t {
+  /* application space address */
+  unsigned long app_address;
 
-struct sep_driver_add_flow_table_t {
-	/* flow id  */
-	unsigned long flow_id;
-
-	/* flag for input output */
-	unsigned long inputOutputFlag;
+  /* address of the data pool */
+  unsigned long datapool_address;
 
-	/* address value of the data in */
-	unsigned long virt_buff_data_addr;
+  /* number of bytes to read */
+  unsigned long num_bytes;
+};
 
-	/* size of data in */
-	unsigned long num_virtual_buffers;
+/*
+*/
+struct sep_driver_build_sync_table_t {
+  /* address value of the data in */
+  unsigned long  app_in_address;
 
-	/* address of the first table */
-	unsigned long first_table_addr;
+  /* size of data in */
+  unsigned long  data_in_size;
 
-	/* number of entries in the first table */
-	unsigned long first_table_num_entries;
+  /* address of the data out */
+  unsigned long  app_out_address;
 
-	/* data size of the first table */
-	unsigned long first_table_data_size;
+  /* the size of the block of the operation - if needed,
+  every table will be modulo this parameter */
+  unsigned long  block_size;
 
-	/* distinct user/kernel layout */
-	bool isKernelVirtualAddress;
+  /* the physical address of the first input DMA table */
+  unsigned long  in_table_address;
 
-};
+  /* number of entries in the first input DMA table */
+  unsigned long  in_table_num_entries;
 
-/*
-  command struct for set flow id
-*/
-struct sep_driver_set_flow_id_t {
-	/* flow id to set */
-	unsigned long flow_id;
-};
+  /* the physical address of the first output DMA table */
+  unsigned long  out_table_address;
 
+  /* number of entries in the first output DMA table */
+  unsigned long  out_table_num_entries;
 
-/* command struct for add tables message */
-struct sep_driver_add_message_t {
-	/* flow id to set */
-	unsigned long flow_id;
+  /* data in the first input table */
+  unsigned long  table_data_size;
 
-	/* message size in bytes */
-	unsigned long message_size_in_bytes;
+  /* distinct user/kernel layout */
+  bool isKernelVirtualAddress;
 
-	/* address of the message */
-	unsigned long message_address;
 };
 
+
 /* command struct for static pool addresses  */
 struct sep_driver_static_pool_addr_t {
-	/* physical address of the static pool */
-	unsigned long physical_static_address;
+  /* physical address of the static pool */
+  unsigned long   physical_static_address;
 
-	/* virtual address of the static pool */
-	unsigned long virtual_static_address;
+  /* virtual address of the static pool */
+  unsigned long   virtual_static_address;
 };
 
 /* command struct for getiing offset of the physical address from
 	the start of the mapped area  */
 struct sep_driver_get_mapped_offset_t {
-	/* physical address of the static pool */
-	unsigned long physical_address;
+  /* physical address of the static pool */
+  unsigned long   physical_address;
 
-	/* virtual address of the static pool */
-	unsigned long offset;
+  /* virtual address of the static pool */
+  unsigned long   offset;
 };
 
 /* command struct for getting time value and address */
 struct sep_driver_get_time_t {
-	/* physical address of stored time */
-	unsigned long time_physical_address;
+  /* physical address of stored time */
+  unsigned long   time_physical_address;
+
+  /* value of the stored time */
+  unsigned long   time_value;
+};
+
+/* command struct for getting time value and address */
+struct sep_driver_set_caller_id_t {
+  /* pid of the process */
+  unsigned long   pid;
+
+  /* virtual address of the caller id hash */
+  unsigned long   callerIdAddress;
+
+  /* caller id hash size in bytes */
+  unsigned long   callerIdSizeInBytes;
 
-	/* value of the stored time */
-	unsigned long time_value;
 };
 
 
@@ -309,34 +316,34 @@ struct sep_driver_get_time_t {
   structure that represent one entry in the DMA LLI table
 */
 struct sep_lli_entry_t {
-	/* physical address */
-	unsigned long physical_address;
+  /* physical address */
+  unsigned long  physical_address;
 
-	/* block size */
-	unsigned long block_size;
+  /* block size */
+  unsigned long  block_size;
 };
 
 /*
   structure that reperesents data needed for lli table construction
 */
 struct sep_lli_prepare_table_data_t {
-	/* pointer to the memory where the first lli entry to be built */
-	struct sep_lli_entry_t *lli_entry_ptr;
+  /* pointer to the memory where the first lli entry to be built */
+  struct sep_lli_entry_t  *lli_entry_ptr;
 
-	/* pointer to the array of lli entries from which the table is to be built */
-	struct sep_lli_entry_t *lli_array_ptr;
+  /* pointer to the array of lli entries from which the table is to be built */
+  struct sep_lli_entry_t  *lli_array_ptr;
 
-	/* number of elements in lli array */
-	int lli_array_size;
+  /* number of elements in lli array */
+  int               lli_array_size;
 
-	/* number of entries in the created table */
-	int num_table_entries;
+  /* number of entries in the created table */
+  int               num_table_entries;
 
-	/* number of array entries processed during table creation */
-	int num_array_entries_processed;
+  /* number of array entries processed during table creation */
+  int               num_array_entries_processed;
 
-	/* the totatl data size in the created table */
-	int lli_table_total_data_size;
+  /* the totatl data size in the created table */
+  int               lli_table_total_data_size;
 };
 
 /*
@@ -344,82 +351,229 @@ struct sep_lli_prepare_table_data_t {
   to show what table looks like
 */
 struct sep_lli_table_t {
-	/* number of pages mapped in this tables. If 0 - means that the table
-	   is not defined (used as a valid flag) */
-	unsigned long num_pages;
-	/*
-	   pointer to array of page pointers that represent the mapping of the
-	   virtual buffer defined by the table to the physical memory. If this
-	   pointer is NULL, it means that the table is not defined
-	   (used as a valid flag)
-	 */
-	struct page **table_page_array_ptr;
-
-	/* maximum flow entries in table */
-	struct sep_lli_entry_t lli_entries[SEP_DRIVER_MAX_FLOW_NUM_ENTRIES_IN_TABLE];
+  /* number of pages mapped in this tables. If 0 - means that the table
+  is not defined (used as a valid flag)*/
+  unsigned long num_pages;
+  /*
+    pointer to array of page pointers that represent the mapping of the
+    virtual buffer defined by the table to the physical memory. If this
+    pointer is NULL, it means that the table is not defined
+    (used as a valid flag)
+  */
+  struct page  **table_page_array_ptr;
+
+  /* maximum flow entries in table */
+  struct sep_lli_entry_t lli_entries[SEP_DRIVER_MAX_FLOW_NUM_ENTRIES_IN_TABLE];
+};
+
+struct sep_caller_id_entry {
+
+  int pid;
+
+  unsigned char callerIdHash[SEP_CALLER_ID_HASH_SIZE_IN_BYTES];
+
 };
 
 
+/************ RAR Driver structures **************/
+/**
+ * @typedef RAR_handle_t
+ *
+ * @brief This type specifies a memory handle corresponding to a
+ *        location in a restricted access region.
+ *
+ * @todo Use type other than @c void*.  An @c int may be sufficient.
+ */
+typedef void* RAR_handle_t;
+
+/**
+ * @typedef RAR_type_t
+ *
+ * @brief Type that specifies different kinds of RAR regions
+ *        that could be set up.
+ */
+typedef unsigned long RAR_type_t;
+
 /*
-  structure for keeping the mapping of the virtual buffer into physical pages
+    context of the device
 */
-struct sep_flow_buffer_data {
-	/* pointer to the array of page structs pointers to the pages of the
-	   virtual buffer */
-	struct page **page_array_ptr;
+struct device_context
+{
+    /* RAR related information */
+    unsigned long rar_physical_address;
+    void *rar_virtual_address;
+
+    u32 rar_start_address;
+    u32 rar_end_address;
+    size_t rar_size;
+
+    /* address of the shared memory allocated during init for SEP driver */
+    unsigned long			shared_area_addr;
+
+    /* the physical address of the shared area */
+    unsigned long			phys_shared_area_addr;
+
+    /* major and minor device numbers */
+    dev_t					device_number;
+
+    /* the files operations structure of the driver */
+    struct file_operations  fops;
+
+    /* cdev struct of the driver */
+    struct cdev			cdev;
+
+    struct pci_dev		*pdev;
+    /*
+    mutex for the access to the internals of the sep driver
+    */
+    struct mutex			dev_mutex;
+
+
+    /* wait queue head (event) of the driver */
+    wait_queue_head_t		event;
+
+
+    /* start address of the access to the SEP registers from driver */
+    unsigned long			reg_base_address;
+
+    /* transaction counter that coordinates the transactions between SEP and HOST */
+    unsigned long			host_to_sep_send_counter;
+
+    /* counter for the messages from sep */
+    unsigned long			sep_to_host_reply_counter;
+
+    /* counter for the number of bytes allocated in the pool for the current
+    transaction */
+    unsigned long			data_pool_bytes_allocated;
+
+    /* array of pointers to the pages that represent input data for the synchronic
+    DMA action */
+    struct page		**in_page_array;
 
-	/* number of pages taken by the virtual buffer */
-	unsigned long num_pages;
+/* array of pointers to the pages that represent out data for the synchronic
+DMA action */
+    struct page		**out_page_array;
 
-	/* this flag signals if this page_array is the last one among many that were
-	   sent in one setting to SEP */
-	unsigned long last_page_array_flag;
+/* number of pages in the sep_in_page_array */
+    unsigned long					in_num_pages;
+
+/* number of pages in the sep_out_page_array */
+    unsigned long					out_num_pages;
+
+/* flag for API mode - 1 -is blocking, 0 is non-blocking */
+    unsigned long			block_mode_flag;
+
+#ifdef DX_CC52_SUPPORT
+
+/* major and minor device numbers for singleton */
+    dev_t                   singleton_device_number;
+
+/* the files operations structure of the driver for singleton access */
+    struct file_operations  singleton_fops;
+
+/* cdev struct for singleton */
+    struct cdev             singleton_cdev;
+
+/* access flag for singleton */
+    int                     singleton_access_flag;
+
+/* caller id table */
+    struct sep_caller_id_entry
+			caller_id_table[SEP_CALLER_ID_TABLE_NUM_ENTRIES];
+
+#endif /*DX_CC52_SUPPORT*/
 };
 
+
+
+/*
+  this function locks SEP by locking the semaphore
+*/
+int sep_lock(void);
+
+/*
+  this function unlocks SEP
+*/
+void sep_unlock(void);
+
 /*
-  struct that keeps all the data for one flow
+	this function returns the address of the message shared area
 */
-struct sep_flow_context_t {
-	/*
-	   work struct for handling the flow done interrupt in the workqueue
-	   this structure must be in the first place, since it will be used
-	   forcasting to the containing flow context
-	 */
-	struct work_struct flow_wq;
+void sep_map_shared_area(unsigned long *mappedAddr_ptr);
 
-	/* flow id */
-	unsigned long flow_id;
 
-	/* additional input tables exists */
-	unsigned long input_tables_flag;
+/*
+	this function returns the address of the message shared area
+*/
+void sep_send_msg_rdy_cmd(void);
 
-	/* additional output tables exists */
-	unsigned long output_tables_flag;
 
-	/*  data of the first input file */
-	struct sep_lli_entry_t first_input_table;
+/*
+	This function releases all the application virtual
+	buffer physical pages, that were previously locked
+*/
+int sep_free_dma_pages(struct page **page_array_ptr,
+			unsigned long num_pages,
+			unsigned long dirtyFlag);
 
-	/* data of the first output table */
-	struct sep_lli_entry_t first_output_table;
+/*
+	This function creates the input and output dma tables for
+	symmetric operations (AES/DES) according to the block size
+	from LLI arays
+*/
+int sep_construct_dma_tables_from_lli(
+					struct sep_lli_entry_t *lli_in_array,
+					unsigned long     sep_in_lli_entries,
+					struct sep_lli_entry_t *lli_out_array,
+					unsigned long     sep_out_lli_entries,
+					unsigned long     block_size,
+					unsigned long    *lli_table_in_ptr,
+					unsigned long    *lli_table_out_ptr,
+					unsigned long    *in_num_entries_ptr,
+					unsigned long    *out_num_entries_ptr,
+					unsigned long    *table_data_size_ptr);
 
-	/* last input table data */
-	struct sep_lli_entry_t last_input_table;
+/*
+	This function builds input and output DMA tables for synhronic symmetric
+	operations (AES, DES) It also checks that each table is of the modular
+	block size
+*/
+int sep_prepare_input_output_dma_table(unsigned long   app_virt_in_addr,
+				unsigned long   app_virt_out_addr,
+				unsigned long   data_size,
+				unsigned long   block_size,
+				unsigned long  *lli_table_in_ptr,
+				unsigned long  *lli_table_out_ptr,
+				unsigned long  *in_num_entries_ptr,
+				unsigned long  *out_num_entries_ptr,
+				unsigned long  *table_data_size_ptr,
+				bool            isKernelVirtualAddress);
 
-	/* last output table data */
-	struct sep_lli_entry_t last_output_table;
+/*
+	This function prepares only input DMA table for synhronic symmetric
+	operations (HASH)
+*/
+int sep_prepare_input_dma_table(unsigned long   app_virt_addr,
+				unsigned long   data_size,
+				unsigned long   block_size,
+				unsigned long  *lli_table_ptr,
+				unsigned long  *num_entries_ptr,
+				unsigned long  *table_data_size_ptr,
+				bool            isKernelVirtualAddress);
 
-	/* first list of table */
-	struct sep_lli_entry_t input_tables_in_process;
+/* this functions frees all the resources that were allocated for the building
+	of the LLI DMA tables */
+void sep_free_dma_resources(void);
 
-	/* output table in process (in sep) */
-	struct sep_lli_entry_t output_tables_in_process;
 
-	/* size of messages in bytes */
-	unsigned long message_size_in_bytes;
+/* poll(suspend) , until reply from sep */
+void sep_driver_poll(void);
 
-	/* message */
-	unsigned char message[SEP_MAX_ADD_MESSAGE_LENGTH_IN_BYTES];
-};
+/*
+	this function handles the request for freeing dma table for
+	synhronic actions
+*/
+int sep_free_dma_table_data_handler(void);
 
 
 #endif
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 6008fe5..035175a 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -1,35 +1,29 @@
-/*
- *
- *  sep_driver_config.h - Security Processor Driver configuration
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the Free
- *  Software Foundation; either version 2 of the License, or (at your option)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License along with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- *  CONTACTS:
- *
- *  Mark Allyn		mark.a.allyn@intel.com
- *
- *  CHANGES:
- *
- *  2009.06.26	Initial publish
- *
- */
-
-#ifndef __SEP_DRIVER_CONFIG_H__
+/**************************************************************************
+ *  Copyright(c) 2009 Intel Corporation. All rights reserved.		*
+ *  Copyright(c) 2009 Discretix. All rights reserved.			*
+ *									*
+ *   This software is						         *
+ *   protected by copyright, international treaties and various patents.   *
+ *   Any copy or reproduction of this Software as permitted below, must    *
+ *   include this Copyright Notice as well as any other notices provided   *
+ *   under such license.                                                   *
+ *                                                                         *
+ *   This program shall be governed by, and may be used and redistributed  *
+ *   under the terms and conditions of the GNU General Public       *
+ *   License, version 2.1, as published by the Free Software Foundation.   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied      *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.      *
+ *   See the GNU General Public License for more details.                  *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public      *
+ *   License along with this program; if not, please write to the          *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+ 
+ #ifndef __SEP_DRIVER_CONFIG_H__
 #define __SEP_DRIVER_CONFIG_H__
 
 
@@ -39,7 +33,7 @@
 
 /* if flag is on , then the driver is running in polling and
 	not interrupt mode */
-#define SEP_DRIVER_POLLING_MODE                         1
+#define SEP_DRIVER_POLLING_MODE                         0
 
 /* flag which defines if the shared area address should be
 	reconfiged (send to SEP anew) during init of the driver */
@@ -48,6 +42,14 @@
 /* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
 #define SEP_DRIVER_ARM_DEBUG_MODE                       0
 
+/* RAR lock mode - cahce, resident and ext cache must be copied to external RAR
+   and locked by driver in the same API */
+#define SEP_DRIVER_LOCK_RAR_MODE                        0
+
+/* flag which defines if the SEP driver should config the OTP (flag is 1),
+   or not (flag is 0) */
+#define SEP_DRIVER_CONFIG_OTP                           1
+
 /*-------------------------------------------
 	INTERNAL DATA CONFIGURATION
 	-------------------------------------------*/
@@ -82,6 +84,10 @@
 	it is divided as following:
 
 	TIME_MEMORY_AREA                     8B
+
+	RAR_MEMORY_AREA                      8B
+    
+    CURRENT_CALLER_ID_MEMORY             70B
 -----------------------------------------------------------*/
 
 
@@ -109,8 +115,13 @@
 #define SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES         (1024 * 4)
 
 /* system data (time, caller id etc') pool */
-#define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES           100
+#define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES           (1024 * 3)
+
+/* the size in bytes of the time memory */
+#define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES                  8
 
+/* the size in bytes of the RAR parameters memory */
+#define SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES            8
 
 /* area size that is mapped  - we map the MESSAGE AREA, STATIC POOL and
 	DATA POOL areas. area must be module 4k */
@@ -152,6 +163,15 @@
 #define SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES \
 	(SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES)
 
+/* offset of the RAR area */
+#define SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES \
+	(SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES + \
+	SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES)
+
+/* offset of the caller id area */
+#define SEP_DRIVER_SYSTEM_CALLER_ID_MEMORY_OFFSET_IN_BYTES \
+	(SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + 8 \
+    SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
 
 
 /* start physical address of the SEP registers memory in HOST */
@@ -184,42 +204,126 @@
 /* mask for entries after being shifted left */
 #define SEP_NUM_ENTRIES_MASK                                  0x7F
 
-/* default flow id */
-#define SEP_FREE_FLOW_ID                                      0xFFFFFFFF
-
-/* temp flow id used during cretiong of new flow until receiving
-	real flow id from sep */
-#define SEP_TEMP_FLOW_ID                   (SEP_DRIVER_NUM_FLOWS + 1)
-
-/* maximum add buffers message length in bytes */
-#define SEP_MAX_ADD_MESSAGE_LENGTH_IN_BYTES                   (7 * 4)
-
 /* maximum number of concurrent virtual buffers */
 #define SEP_MAX_VIRT_BUFFERS_CONCURRENT                       100
 
 /* the token that defines the start of time address */
 #define SEP_TIME_VAL_TOKEN                                    0x12345678
 
+/* size of the caller id hash (sha2) */
+#define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
+
+/* maximum number of entries in the caller id table */
+#define SEP_CALLER_ID_TABLE_NUM_ENTRIES                       20
+
+/* the token that defines the start of time address */
+#define SEP_RAR_VAL_TOKEN                                     0xABABABAB
+
+/* ioctl error that should be returned when trying
+   to realloc the cache/resident second time */
+#define SEP_ALREADY_INITIALIZED_ERR                           12
+
 /* DEBUG LEVEL MASKS */
 #define SEP_DEBUG_LEVEL_BASIC       0x1
 
+#define SEP_DEBUG_LEVEL_REGISTERS   0x2
+
 #define SEP_DEBUG_LEVEL_EXTENDED    0x4
 
 
-/* Debug helpers */
+/* FUNCTIONAL MACROS */
+
+/* debug macro without paramaters */
+#define DEBUG_PRINT_0(DEBUG_LEVEL , info) \
+do { \
+	if (DEBUG_LEVEL & sepDebug) \
+		printk(KERN_WARNING info); \
+} while (0)
+
+/* debug macro with 1 paramater */
+#define DEBUG_PRINT_1(DEBUG_LEVEL , info , param1) \
+do { \
+	if (DEBUG_LEVEL & sepDebug) \
+		printk(KERN_WARNING info, param1); \
+} while (0)
+
+/* debug macro with 2 paramaters */
+#define DEBUG_PRINT_2(DEBUG_LEVEL, info, param1, param2) \
+do { \
+	if (DEBUG_LEVEL & sepDebug) \
+		printk(KERN_WARNING info , param1, param2); \
+} while (0)
 
-#define dbg(fmt, args...) \
-do {\
-	if (debug & SEP_DEBUG_LEVEL_BASIC) \
-		printk(KERN_DEBUG fmt, ##args); \
-} while(0);
+/* debug macro with 3 paramaters */
+#define DEBUG_PRINT_3(DEBUG_LEVEL, info, param1, param2, param3) \
+do { \
+	if (DEBUG_LEVEL & sepDebug) \
+		printk(KERN_WARNING info , param1, param2 , param3); \
+} while (0)
+
+/* debug macro with 4 paramaters */
+#define DEBUG_PRINT_4(DEBUG_LEVEL, info, param1, param2, param3, param4) \
+do { \
+	if (DEBUG_LEVEL & sepDebug) \
+		printk(KERN_WARNING info, param1, param2, param3, param4); \
+} while (0)
 
-#define edbg(fmt, args...) \
+#if 0
+/* write register macro with option for debug print */
+#define SEP_WRITE_REGISTER(address, value) \
 do { \
-	if (debug & SEP_DEBUG_LEVEL_EXTENDED) \
-		printk(KERN_DEBUG fmt, ##args); \
-} while(0);
+	if (sepDebug & SEP_DEBUG_LEVEL_REGISTERS) \
+		printk(KERN_WARNING "Write Register: address %lu value %lu\n", \
+		(unsigned long)(address), (unsigned long)(value)); \
+	writel((value), (void *)(address)); \
+} while (0)
+
+/* read register macro with option for debug print */
+#define SEP_READ_REGISTER(address , value) \
+do { \
+	(value) = readl((void *)(address)); \
+	if (sepDebug & SEP_DEBUG_LEVEL_REGISTERS) \
+		printk(KERN_WARNING "Read Register: address %lu value %lu\n", \
+		(address), (value)); \
+} while (0)
+#else
+
+#if 1
 
+#define SEP_WRITE_REGISTER(address, value)  writel((value), (void *)(address))
+#define SEP_READ_REGISTER(address, value)  (value) = readl((void *)(address))
+#endif
+
+#endif
 
+#if 0
+#define SEP_WRITE_ROM(address, value)  writel((value), (void *)(address))
+
+#define SEP_WRITE_REGISTER(address, value) \
+do { \
+	unsigned long i; \
+	for (i = 0; i < 1000; i++); \
+		writel((value), (void *)(address)); \
+} while (0)
+
+
+#define SEP_READ_REGISTER(address , value) \
+do { \
+	unsigned long i; \
+	for (i = 0; i < 1000; i++); \
+		(value) = readl((void *) (address)); \
+} while (0)
+
+#endif
+
+/* wait for SRAM write complete(indirect write */
+#define SEP_WAIT_SRAM_WRITE_COMPLETE() \
+do { \
+	unsigned long  reg_val; \
+	do { \
+		SEP_READ_REGISTER(sep_context.reg_base_address + \
+		HW_SRAM_DATA_READY_REG_ADDR, (reg_val)); \
+	} while (!(reg_val & 0x1)); \
+} while (0)
 
 #endif
diff --git a/drivers/staging/sep/sep_driver_ext_api.h b/drivers/staging/sep/sep_driver_ext_api.h
new file mode 100644
index 0000000..cff45e0
--- /dev/null
+++ b/drivers/staging/sep/sep_driver_ext_api.h
@@ -0,0 +1,113 @@
+/**************************************************************************
+ *   Copyright(c) 2009 Intel Corporation. All rights reserved.		*
+ *   Copyright(c) 2009 Discretix. All rights reserved.			*
+ *									*
+ *   This software is         						*
+ *   protected by copyright, international treaties and various patents.   *
+ *   Any copy or reproduction of this Software as permitted below, must    *
+ *   include this Copyright Notice as well as any other notices provided   *
+ *   under such license.                                                   *
+ *                                                                         *
+ *   This program shall be governed by, and may be used and redistributed  *
+ *   under the terms and conditions of the GNU General Public       *
+ *   License, version 2.1, as published by the Free Software Foundation.   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied      *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.      *
+ *   See the GNU General Public License for more details.                  *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public      *
+ *   License along with this program; if not, please write to the          *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+ 
+ #ifndef __SEP_DRIVER_EXT_API_H__
+#define __SEP_DRIVER_EXT_API_H__
+
+/* shared variables */
+extern int sepDebug;
+
+extern struct device_context sep_context;
+
+/*
+this function loads the ROM code in SEP (needed only in the debug mode on FPGA)
+*/
+void sep_load_rom_code(void);
+
+/*
+This functions locks the area of the resident and cache sep code (if possible)
+*/
+void sep_lock_cache_resident_area(void);
+
+/*
+This functions copies the cache and resident from their source location into
+destination memory, which is external to Linux VM and is given as physical
+address
+*/
+int sep_copy_cache_resident_to_area(unsigned long   src_cache_addr,
+				unsigned long   cache_size_in_bytes,
+				unsigned long   src_resident_addr,
+				unsigned long   resident_size_in_bytes,
+				unsigned long   dcache_size_in_bytes,
+				unsigned long  *dst_new_cache_addr_ptr,
+				unsigned long  *dst_new_resident_addr_ptr,
+				unsigned long  *dst_new_dcache_addr_ptr);
+
+/*
+  This functions copies the external cache (3rd party) from
+  it's source location into destination memory,
+  which is external to Linux VM and is given as physical address.
+  It is supposed to be adjustent to the i-cache boundary
+*/
+int sep_copy_ext_cache_to_area(unsigned long   src_ext_cache_addr,
+				unsigned long   ext_cache_size_in_bytes,
+				unsigned long   *dst_new_ext_cache_addr_ptr);
+
+
+
+/*
+This functions maps and allocates the shared area on the external
+RAM (device) The input is shared_area_size - the size of the memory
+to allocate. The outputs are kernel_shared_area_addr_ptr - the kerenl
+address of the mapped and allocated shared area, and
+phys_shared_area_addr_ptr - the physical address of the shared area
+*/
+int sep_map_and_alloc_shared_area(unsigned long   shared_area_size,
+				unsigned long  *kernel_shared_area_addr_ptr,
+				unsigned long  *phys_shared_area_addr_ptr);
+
+/*
+This functions unmaps and deallocates the shared area on the  external
+RAM (device) The input is shared_area_size - the size of the memory to
+deallocate,kernel_shared_area_addr_ptr - the kernel address of the
+mapped and allocated shared area,phys_shared_area_addr_ptr - the physical
+address of the shared area
+*/
+void sep_unmap_and_free_shared_area(unsigned long   shared_area_size,
+				unsigned long   kernel_shared_area_addr,
+				unsigned long   phys_shared_area_addr);
+
+
+/*
+This functions returns the physical address inside shared area according
+to the virtual address. It can be either on the externa RAM device
+(ioremapped), or on the system RAM
+*/
+unsigned long sep_shared_area_virt_to_phys(unsigned long virt_address);
+
+/*
+This functions returns the vitrual address inside shared area according
+to the physical address. It can be either on the externa RAM device
+(ioremapped), or on the system RAM This implementation is for the external RAM
+*/
+unsigned long sep_shared_area_phys_to_virt(unsigned long phys_address);
+
+/*
+This function registers th driver to the device
+subsystem (either PCI, USB, etc)
+*/
+int sep_register_driver_to_device(void);
+
+#endif /*__SEP_DRIVER_EXT_API_H__*/
diff --git a/drivers/staging/sep/sep_driver_hw_defs.h b/drivers/staging/sep/sep_driver_hw_defs.h
index ea6abd8..4098a34 100644
--- a/drivers/staging/sep/sep_driver_hw_defs.h
+++ b/drivers/staging/sep/sep_driver_hw_defs.h
@@ -1,35 +1,29 @@
-/*
- *
- *  sep_driver_hw_defs.h - Security Processor Driver hardware definitions
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the Free
- *  Software Foundation; either version 2 of the License, or (at your option)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License along with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- *  CONTACTS:
- *
- *  Mark Allyn		mark.a.allyn@intel.com
- *
- *  CHANGES:
- *
- *  2009.06.26	Initial publish
- *
- */
-
-#ifndef SEP_DRIVER_HW_DEFS__H
+/**************************************************************************
+ *  Copyright(c) 2009 Intel Corporation. All rights reserved.		*
+ *  Copyright(c) 2009 Discretix. All rights reserved.			*
+ *									*
+ *   This software is         						*
+ *   protected by copyright, international treaties and various patents.   *
+ *   Any copy or reproduction of this Software as permitted below, must    *
+ *   include this Copyright Notice as well as any other notices provided   *
+ *   under such license.                                                   *
+ *                                                                         *
+ *   This program shall be governed by, and may be used and redistributed  *
+ *   under the terms and conditions of the GNU General Public       *
+ *   License, version 2.1, as published by the Free Software Foundation.   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied      *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.      *
+ *   See the GNU General Public License for more details.                  *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public      *
+ *   License along with this program; if not, please write to the          *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+ 
+ #ifndef SEP_DRIVER_HW_DEFS__H
 #define SEP_DRIVER_HW_DEFS__H
 
 /*--------------------------------------------------------------------------*/
@@ -39,6 +33,10 @@
 /*       DO NOT EDIT THIS FILE !!!                                          */
 /*--------------------------------------------------------------------------*/
 
+#ifdef __cplusplus
+extern "C"
+{
+#endif
 
 /* cf registers */
 #define 	 HW_R0B_ADDR_0_REG_ADDR 		 0x0000UL
@@ -229,4 +227,8 @@
 #define 	 HW_CLR_SRAM_BUSY_REG_REG_ADDR 	      0x0F0CUL
 #define    HW_CC_SRAM_BASE_ADDRESS              0x5800UL
 
-#endif				/* ifndef HW_DEFS */
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* ifndef HW_DEFS */
diff --git a/drivers/staging/sep/sep_ext_with_pci_driver.c b/drivers/staging/sep/sep_ext_with_pci_driver.c
new file mode 100644
index 0000000..c06f106
--- /dev/null
+++ b/drivers/staging/sep/sep_ext_with_pci_driver.c
@@ -0,0 +1,681 @@
+/*
+ *
+ *  sep_ext_with_pci_driver.c - Security Processor Driver 
+ *  pci initialization functions
+ *
+ *  Copyright(c) 2009 Intel Corporation or its suppliers. All rights reserved.
+ *  Copyright(c) 2009 Discretix. All rights reserved.
+ *  
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the Free
+ *  Software Foundation; either version 2 of the License, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ *  more details.
+ *
+ *  You should have received a copy of the GNU General Public License along with
+ *  this program; if not, write to the Free Software Foundation, Inc., 59
+ *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ *  CONTACTS:
+ *
+ *  Mark Allyn		mark.a.allyn@intel.com
+ *
+ *  CHANGES:
+ *
+ *  2009.06.26	Initial publish
+ * 
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/semaphore.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/ioctl.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/pagemap.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/sched.h>
+#include <linux/rar/memrar.h>
+#include <linux/rar/rar_register.h>
+#include "sep_driver_hw_defs.h"
+#include "sep_driver_config.h"
+#include "sep_driver_api.h"
+#include "sep_driver_ext_api.h"
+
+#if SEP_DRIVER_ARM_DEBUG_MODE
+
+#define  CRYS_SEP_ROM_length                  0x4000
+
+#define  CRYS_SEP_ROM_start_address           0x8000C000UL
+
+#define  CRYS_SEP_ROM_start_address_offset    0xC000UL
+
+#define  SEP_ROM_BANK_register                0x80008420UL
+
+#define  SEP_ROM_BANK_register_offset         0x8420UL
+
+#define SEP_RAR_IO_MEM_REGION_START_ADDRESS   0x82000000
+
+/* 2M size */
+/* #define SEP_RAR_IO_MEM_REGION_SIZE            (1024*1024*2)
+
+static unsigned long CRYS_SEP_ROM[] = {
+	#include "SEP_ROM_image.h"
+};
+
+#else
+*/
+
+/*-------------
+ THOSE 2 definitions are specific to the board - must be
+ defined during integration
+---------------*/
+#define SEP_RAR_IO_MEM_REGION_START_ADDRESS   0xFF0D0000
+
+/* 2M size */
+
+#endif /* SEP_DRIVER_ARM_DEBUG_MODE */
+
+#define BASE_ADDRESS_FOR_SYSTEM 0xfffc0000
+#define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
+
+irqreturn_t sep_inthandler(int irq , void* dev_id);
+
+/* NOTE - must be defined specific to the board */
+#define VENDOR_ID                             0x8086
+
+/* io memory (register area) */
+static unsigned long io_memory_start_physical_address;
+static unsigned long io_memory_end_physical_address;
+static unsigned long io_memory_size;
+void *io_memory_start_virtual_address;
+
+/* shared memory region */
+static dma_addr_t shared_physical_address;
+static void *shared_virtual_address;
+
+/* firmware regions */
+static unsigned long cache_physical_address;
+static unsigned long cache_size;
+static void *cache_virtual_address;
+
+static unsigned long resident_physical_address;
+static unsigned long resident_size;
+static void *resident_virtual_address;
+
+static unsigned long dcache_physical_address;
+static unsigned long dcache_size;
+static void *dcache_virtual_address;
+
+int sep_callback(void *sep_context_pointer);
+
+/* device interrupt (as retrieved from PCI) */
+int sep_irq;
+
+/* temporary */
+unsigned long jiffies_future;
+
+/*-----------------------------
+    private functions
+--------------------------------*/
+
+/*
+  function that is activated on the succesfull probe of the SEP device
+*/
+static int __devinit sep_probe(struct pci_dev *pdev,
+  const struct pci_device_id *ent);
+
+static struct pci_device_id sep_pci_id_tbl[] = {
+	{ PCI_DEVICE(VENDOR_ID, 0x080c) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
+
+/* field for registering driver to PCI device */
+static struct pci_driver sep_pci_driver = {
+	.name = "sep_sec_driver",
+	.id_table = sep_pci_id_tbl,
+	.probe = sep_probe
+};
+
+/*
+  This functions locks the area of the resisnd and cache sep code
+*/
+void sep_lock_cache_resident_area(void)
+{
+	int error;
+	error = rar_lock(RAR_TYPE_IMAGE);
+	if (error) {
+		DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver:cant lock RAR region %d\n",
+		  error);
+	}
+}
+
+
+/*
+  This functions copies the cache and resident from their source location into
+  destination memory, which is external to Linux VM and is given as
+   physical address
+*/
+int sep_copy_cache_resident_to_area(unsigned long   src_cache_addr,
+				unsigned long   cache_size_in_bytes,
+				unsigned long   src_resident_addr,
+				unsigned long   resident_size_in_bytes,
+				unsigned long   dcache_size_in_bytes,
+				unsigned long *dst_new_cache_addr_ptr,
+				unsigned long *dst_new_resident_addr_ptr,
+				unsigned long  *dst_new_dcache_addr_ptr)
+{
+	/* resident address in user space */
+	unsigned long resident_addr;
+
+	/* cahce address in user space */
+	unsigned long cache_addr;
+
+	const struct firmware *fw;
+
+	char *cache_name = "cache.image.bin";
+	char *res_name =  "resident.image.bin";
+
+	/* error */
+	int error;
+
+	/*--------------------------------
+	    CODE
+	-------------------------------------*/
+	error = 0;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:rar_virtual is %p\n",
+	  sep_context.rar_virtual_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:rar_physical is %08lx\n",
+	  sep_context.rar_physical_address);
+
+	cache_physical_address = sep_context.rar_physical_address;
+	cache_virtual_address = sep_context.rar_virtual_address;
+
+	/* load cache */
+	error = request_firmware(&fw, cache_name, &sep_context.pdev->dev);
+	if (error) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver:cant request cache fw\n");
+		goto end_function;
+	}
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:cache data loc is %p\n",
+	  (void *)fw->data);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:cache data size is %08x\n",
+	  fw->size);
+
+	memcpy((void *)cache_virtual_address, (void *)fw->data, fw->size);
+
+	cache_size = fw->size;
+
+	cache_addr = (unsigned long)cache_virtual_address;
+
+	release_firmware(fw);
+
+	resident_physical_address = cache_physical_address+cache_size;
+	resident_virtual_address = cache_virtual_address+cache_size;
+
+	/* load resident */
+	error = request_firmware(&fw, res_name, &sep_context.pdev->dev);
+	if (error) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver:cant request res fw\n");
+		goto end_function;
+	}
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:res data loc is %p\n",
+	  (void *)fw->data);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:res data size is %08x\n",
+	  fw->size);
+
+	memcpy((void *)resident_virtual_address, (void *)fw->data, fw->size);
+
+	resident_size = fw->size;
+
+	release_firmware(fw);
+
+	dcache_physical_address = resident_physical_address+resident_size;
+	dcache_virtual_address = resident_virtual_address+resident_size;
+
+	resident_addr = (unsigned long)resident_virtual_address;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:resident_addr (physical )is %08lx\n",
+	  resident_physical_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:cache_addr (physical) is %08lx\n",
+	  cache_physical_address);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:resident_addr (logical )is %08lx\n",
+	  resident_addr);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:cache_addr (logical) is %08lx\n",
+	  cache_addr);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:resident_size is %08lx\n", resident_size);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:cache_size is %08lx\n", cache_size);
+
+
+
+	/* physical addresses */
+	*dst_new_cache_addr_ptr = cache_physical_address;
+	*dst_new_resident_addr_ptr = resident_physical_address;
+	*dst_new_dcache_addr_ptr = dcache_physical_address;
+
+end_function:
+
+	return error;
+}
+
+/*
+  This functions maps and allocates the
+  shared area on the  external RAM (device)
+  The input is shared_area_size - the size of the memory to
+  allocate. The outputs
+  are kernel_shared_area_addr_ptr - the kerenl
+  address of the mapped and allocated
+  shared area, and phys_shared_area_addr_ptr
+  - the physical address of the shared area
+*/
+int sep_map_and_alloc_shared_area(unsigned long shared_area_size,
+				unsigned long *kernel_shared_area_addr_ptr,
+				unsigned long *phys_shared_area_addr_ptr)
+{
+	shared_virtual_address = dma_alloc_coherent(&sep_context.pdev->dev,
+	  shared_area_size, &shared_physical_address, GFP_KERNEL);
+
+	if (!shared_virtual_address) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "sep_driver:shared memory kmalloc failed\n");
+		return -1;
+	}
+
+	*kernel_shared_area_addr_ptr = (unsigned long)shared_virtual_address;
+	/* set the physical address of the shared area */
+	*phys_shared_area_addr_ptr = (unsigned long)shared_physical_address;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:shared_virtual_address is %p\n",
+	shared_virtual_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:shared_region_size is %08lx\n",
+	shared_area_size);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:shared_physical_addr is %08lx\n",
+	*phys_shared_area_addr_ptr);
+
+	return 0;
+}
+
+/*
+  This functions unmaps and deallocates the shared area
+  on the  external RAM (device)
+  The input is shared_area_size - the size of the memory to deallocate,kernel_
+  shared_area_addr_ptr - the kernel address of the mapped and allocated
+  shared area,phys_shared_area_addr_ptr - the physical address of
+  the shared area
+*/
+void sep_unmap_and_free_shared_area(unsigned long   shared_area_size,
+					unsigned long   kernel_shared_area_addr,
+					unsigned long   phys_shared_area_addr)
+{
+	dma_free_coherent(&sep_context.pdev->dev, (size_t)shared_area_size,
+	  (void *)kernel_shared_area_addr, (dma_addr_t)phys_shared_area_addr);
+}
+
+/*
+  This functions returns the physical address inside shared area according
+  to the virtual address. It can be either on the externa RAM device
+  (ioremapped), or on the system RAM
+  This implementation is for the external RAM
+*/
+unsigned long sep_shared_area_virt_to_phys(unsigned long virt_address)
+{
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:sh virt to phys v %08lx\n",
+	  virt_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:sh virt to phys p %08lx\n",
+	  shared_physical_address
+	  + (virt_address - (unsigned long)shared_virtual_address));
+
+	return (unsigned long)shared_physical_address +
+	  (virt_address - (unsigned long)shared_virtual_address);
+}
+
+/*
+  This functions returns the virtual address inside shared area
+  according to the physical address. It can be either on the
+  externa RAM device (ioremapped), or on the system RAM This implementation
+  is for the external RAM
+*/
+unsigned long sep_shared_area_phys_to_virt(unsigned long phys_address)
+{
+	return (unsigned long)shared_virtual_address
+	  + (phys_address - shared_physical_address);
+}
+
+
+/*
+  function that is activaed on the succesfull probe of the SEP device
+*/
+static int __devinit sep_probe(struct pci_dev *pdev,
+			const struct pci_device_id *ent)
+{
+	/* error */
+	int error;
+
+	/*------------------------
+	CODE
+	---------------------------*/
+
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	  "Sep pci probe starting\n");
+	error = 0;
+
+	/* enable the device */
+	error = pci_enable_device(pdev);
+	if (error) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "error enabling pci device\n");
+		goto end_function;
+	}
+
+	/* set the pci dev pointer */
+	sep_context.pdev = pdev;
+
+	/* get the io memory start address */
+	io_memory_start_physical_address = pci_resource_start(pdev, 0);
+	if (!io_memory_start_physical_address) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver error pci resource start\n");
+		goto end_function;
+	}
+
+	/* get the io memory end address */
+	io_memory_end_physical_address = pci_resource_end(pdev, 0);
+	if (!io_memory_end_physical_address) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver error pci resource end\n");
+		goto end_function;
+	}
+
+	io_memory_size = io_memory_end_physical_address -
+	  io_memory_start_physical_address + 1;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:io_memory_start_physical_address is %08lx\n",
+	io_memory_start_physical_address);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:io_memory_end_phyaical_address is %08lx\n",
+	io_memory_end_physical_address);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:io_memory_size is %08lx\n",
+	io_memory_size);
+
+	io_memory_start_virtual_address =
+	  ioremap_nocache(io_memory_start_physical_address,
+	  io_memory_size);
+	if (!io_memory_start_virtual_address) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver error ioremap of io memory\n");
+		goto end_function;
+	}
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:io_memory_start_virtual_address is %p\n",
+	io_memory_start_virtual_address);
+
+	sep_context.reg_base_address = (unsigned long)io_memory_start_virtual_address;
+
+	/* call the register_rar function (this will use the sep_callback 
+ *         function to perform the rar related activities; this callback
+ *         is used in case we are running now prior to the rar register
+ *         driver running. */
+	error = register_rar(&sep_callback, (void *)&sep_context);
+
+#if !SEP_DRIVER_POLLING_MODE
+
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: about to write IMR and ICR REG_ADDR\n");
+
+	/* clear ICR register */
+	SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_HOST_ICR_REG_ADDR,
+	  0xFFFFFFFF);
+
+	/* set the IMR register - open only GPR 2 */
+	SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_HOST_IMR_REG_ADDR,
+	  (~(0x1 << 13)));
+
+	/* figure out our irq */
+	error = pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, (u8 *)&sep_irq);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: my irq is %d\n", sep_irq);
+
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: about to call request_irq\n");
+	/* get the interrupt line */
+	error = request_irq(sep_irq, sep_inthandler, IRQF_SHARED,
+	  "sep_driver", &sep_context.reg_base_address);
+	if (error)
+		goto end_function;
+
+	goto end_function;
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: about to write IMR REG_ADDR");
+
+	/* set the IMR register - open only GPR 2 */
+	SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_HOST_IMR_REG_ADDR,
+	  (~(0x1 << 13)));
+
+#endif /* SEP_DRIVER_POLLING_MODE */
+
+end_function:
+
+	return error;
+}
+
+/*
+  this function registers th driver to
+  the device subsystem( either PCI, USB, etc)
+*/
+int sep_register_driver_to_device(void)
+{
+	return pci_register_driver(&sep_pci_driver);
+}
+
+
+
+void sep_load_rom_code()
+{
+#if SEP_DRIVER_ARM_DEBUG_MODE
+	/* Index variables */
+	unsigned long i, k, j;
+	unsigned long regVal;
+	unsigned long Error;
+	unsigned long warning;
+
+	/* Loading ROM from SEP_ROM_image.h file */
+	k = sizeof(CRYS_SEP_ROM);
+
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: DX_CC_TST_SepRomLoader start\n");
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: k is %lu\n", k);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: sep_context.reg_base_address is %p\n",
+	  sep_context.reg_base_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: CRYS_SEP_ROM_start_address_offset is %p\n",
+	  CRYS_SEP_ROM_start_address_offset);
+
+	for (i = 0; i < 4; i++) {
+		/* write bank */
+		SEP_WRITE_REGISTER(sep_context.reg_base_address
+		  + SEP_ROM_BANK_register_offset, i);
+
+		for (j = 0; j < CRYS_SEP_ROM_length / 4; j++) {
+			SEP_WRITE_REGISTER(sep_context.reg_base_address +
+			  CRYS_SEP_ROM_start_address_offset + 4*j,
+			  CRYS_SEP_ROM[i * 0x1000 + j]);
+
+			k = k - 4;
+
+			if (k == 0) {
+				j = CRYS_SEP_ROM_length;
+				i = 4;
+			}
+		}
+	}
+
+	/* reset the SEP*/
+	SEP_WRITE_REGISTER(sep_context.reg_base_address
+	  + HW_HOST_SEP_SW_RST_REG_ADDR, 0x1);
+
+	/* poll for SEP ROM boot finish */
+	do {
+		SEP_READ_REGISTER(sep_context.reg_base_address
+		  + HW_HOST_SEP_HOST_GPR3_REG_ADDR, regVal);
+	} while (!regVal);
+
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver: ROM polling ended\n");
+
+	switch (regVal) {
+	case 0x1:
+		/* fatal error - read erro status from GPRO */
+		SEP_READ_REGISTER(sep_context.reg_base_address
+		  + HW_HOST_SEP_HOST_GPR0_REG_ADDR, Error);
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver: ROM polling case 1\n");
+		break;
+	case 0x2:
+		/* Boot First Phase ended  */
+		SEP_READ_REGISTER(sep_context.reg_base_address
+		  + HW_HOST_SEP_HOST_GPR0_REG_ADDR, warning);
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver: ROM polling case 2\n");
+		break;
+	case 0x4:
+		/* Cold boot ended successfully  */
+		SEP_READ_REGISTER(sep_context.reg_base_address
+		  + HW_HOST_SEP_HOST_GPR0_REG_ADDR, warning);
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver: ROM polling case 4\n");
+		Error = 0;
+		break;
+	case 0x8:
+		/* Warmboot ended successfully */
+		SEP_READ_REGISTER(sep_context.reg_base_address
+		  + HW_HOST_SEP_HOST_GPR0_REG_ADDR, warning);
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver: ROM polling case 8\n");
+		Error = 0;
+		break;
+	case 0x10:
+		/* ColdWarm boot ended successfully */
+		SEP_READ_REGISTER(sep_context.reg_base_address
+		  + HW_HOST_SEP_HOST_GPR0_REG_ADDR, warning);
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver: ROM polling case 16\n");
+		Error = 0;
+		break;
+	case 0x20:
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver: ROM polling case 32\n");
+		break;
+	}
+
+#endif
+}
+
+/* following is the callback for the rar_driver to call in case we attempt
+ * to register too soon 
+ */
+
+int sep_callback(void *sep_context_pointer)
+{
+	int error;
+	struct device_context *my_sep_context;
+
+	my_sep_context = (struct device_context *)sep_context_pointer;
+
+	/* set up rar base address from rar_register driver*/
+	error = rar_get_address(RAR_TYPE_IMAGE, &my_sep_context->rar_start_address,
+	  &my_sep_context->rar_end_address);
+
+	if (error) {
+		DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver:cant get RAR region - error is %d\n",
+		  error);
+		goto end_function;
+	}
+	
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:retrieved RAR start is %x\n", my_sep_context->rar_start_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:retrieved RAR end is %x\n", my_sep_context->rar_end_address);
+
+	/* now make sure we 'own' this address range */
+	my_sep_context->rar_size = (size_t)(my_sep_context->rar_end_address - 
+	  my_sep_context->rar_start_address + 1);
+
+	if (!request_mem_region(my_sep_context->rar_start_address,
+	  my_sep_context->rar_size, "sep_sec_driver")) { 
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver:request mem region failed for rar\n");
+		goto end_function;
+	}
+
+	my_sep_context->rar_virtual_address = ioremap_nocache(
+	  my_sep_context->rar_start_address, my_sep_context->rar_size);
+	if (!my_sep_context->rar_virtual_address) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		  "SEP Driver:cant ioremap_nocache rar\n");
+		goto end_function;
+	}
+
+	my_sep_context->rar_physical_address = my_sep_context->rar_start_address;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:rar_physical is %08lx\n",
+	my_sep_context->rar_physical_address);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "SEP Driver:rar_virtual is %p\n",
+	my_sep_context->rar_virtual_address);
+
+end_function:
+
+	return error;
+}
diff --git a/drivers/staging/sep/sep_main_mod.c b/drivers/staging/sep/sep_main_mod.c
new file mode 100644
index 0000000..3a1b9db
--- /dev/null
+++ b/drivers/staging/sep/sep_main_mod.c
@@ -0,0 +1,3704 @@
+/**************************************************************************
+ *   Copyright 2009 Intel Corporation or its suppliers.                    *
+ *   Copyright(c) 2009 Discretix. All rights reserved. This                *
+ *   protected by copyright, international treaties and various patents.   *
+ *   Any copy or reproduction of this Software as permitted below, must    *
+ *   include this Copyright Notice as well as any other notices provided   *
+ *   under such license.                                                   *
+ *                                                                         *
+ *   This program shall be governed by, and may be used and redistributed  *
+ *   under the terms and conditions of the GNU General Public       *
+ *   License, version 2.1, as published by the Free Software Foundation.   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied      *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.      *
+ *   See the GNU General Public License for more details.                  *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public      *
+ *   License along with this program; if not, please write to the          *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <asm/ioctl.h>
+#include <linux/ioport.h>
+#include <asm/io.h>
+#include <linux/interrupt.h>
+#include <linux/pagemap.h>
+#include <asm/cacheflush.h>
+#include <linux/rar/memrar.h>
+#include <linux/rar/rar_register.h>
+
+#ifdef DX_CC52_SUPPORT
+#include <linux/netlink.h>
+#include <linux/connector.h>
+#include <linux/cn_proc.h>
+#endif
+
+#include "sep_driver_hw_defs.h"
+#include "sep_driver_config.h"
+#include "sep_driver_api.h"
+#include "sep_driver_ext_api.h"
+
+/*----------------------------------------
+	DEFINES
+-----------------------------------------*/
+
+
+#define INT_MODULE_PARM(n, v) int n = v; module_param(n, int, 0)
+
+/*--------------------------------------
+  TYPEDEFS
+  -----------------------------------------*/
+
+
+
+/*--------------------------------------------
+	GLOBAL variables
+--------------------------------------------*/
+
+
+/* debug messages level */
+INT_MODULE_PARM(sepDebug, 0x7);
+MODULE_PARM_DESC(sepDebug, "Flag to enable SEP debug messages");
+
+/* context of the device */
+struct device_context   sep_context;
+
+/* start address of the access to the SEP registers from driver */
+static unsigned int g_rar_handle_virt;
+
+
+/*------------------------------------------------
+  PROTOTYPES
+---------------------------------------------------*/
+
+/*
+  interrupt handler function
+*/
+irqreturn_t sep_inthandler(int irq, void *dev_id);
+
+/*
+  this function registers the driver to the file system
+*/
+static int  sep_register_driver_to_fs(void);
+
+/*
+  this function unregisters driver from fs
+*/
+static void sep_unregister_driver_from_fs(void);
+
+/*
+  reconfig the shared area between HOST and SEP - needed
+  in case the DX_CC_Init function was called before OS loading
+*/
+static int sep_reconfig_shared_area(void);
+
+/*
+  config the OTP - usually needed in debug mode
+*/
+static void sep_debug_config_otp(void);
+
+
+
+/*
+  this function calculates the size of data that can be inserted into the lli
+  table from this array the condition is that either the table is full
+  (all etnries are entered), or there are no more entries in the lli array
+*/
+static unsigned long sep_calculate_lli_table_max_size(
+			struct sep_lli_entry_t	*lli_in_array_ptr,
+			unsigned long	num_array_entries);
+/*
+  this functions builds ont lli table from the lli_array according to the
+  given size of data
+*/
+static void sep_build_lli_table(struct sep_lli_entry_t	*lli_array_ptr,
+			struct sep_lli_entry_t		*lli_table_ptr,
+			unsigned long		*num_processed_entries_ptr,
+			unsigned long		*num_table_entries_ptr,
+			unsigned long	table_data_size);
+
+/*
+  this function goes over the list of the print created tables and prints
+  all the data
+*/
+static void sep_debug_print_lli_tables(struct sep_lli_entry_t	*lli_table_ptr,
+					unsigned long	num_table_entries,
+					unsigned long	table_data_size);
+
+
+
+/*
+  This function raises interrupt to SEPm that signals that is has a new
+  command from HOST
+*/
+static void sep_send_command_handler(void);
+
+
+/*
+  This function raises interrupt to SEP that signals that is has a
+  new reply from HOST
+*/
+static void sep_send_reply_command_handler(void);
+
+/*
+  This function handles the allocate data pool memory request
+  This function returns calculates the physical address of the allocated memory
+  and the offset of this area from the mapped address. Therefore, the FVOs in
+  user space can calculate the exact virtual address of this allocated memory
+*/
+static int sep_allocate_data_pool_memory_handler(unsigned long arg);
+
+
+/*
+  This function  handles write into allocated data pool command
+*/
+static int sep_write_into_data_pool_handler(unsigned long arg);
+
+/*
+  this function handles the read from data pool command
+*/
+static int sep_read_from_data_pool_handler(unsigned long arg);
+
+/*
+  this function handles tha request for creation of the DMA table
+  for the synchronic symmetric operations (AES,DES)
+*/
+static int sep_create_sync_dma_tables_handler(unsigned long arg);
+
+/*
+  This API handles the end transaction request
+*/
+static int sep_end_transaction_handler(unsigned long arg);
+
+/*
+  this function handles the request for SEP start
+*/
+static int sep_start_handler(void);
+
+/*
+  this function handles the request for SEP initialization
+*/
+static int sep_init_handler(unsigned long arg);
+
+/*
+  this function handles the request cache and resident reallocation
+*/
+static int sep_realloc_cache_resident_handler(unsigned long arg);
+
+
+/*
+  This api handles the setting of API mode to blocking or non-blocking
+*/
+static int sep_set_api_mode_handler(unsigned long arg);
+
+/*
+  This function will calculate and set the physical address in
+  the system memory to indicate the RAR output buffer.
+*/
+static int sep_rar_prepare_output_msg_handler(unsigned long arg);
+
+/*
+  This function locks all the physical pages of the kernel virtual buffer
+  and construct a basic lli  array, where each entry holds the physical
+  page address and the size that application data holds in this physical pages
+*/
+static int sep_lock_kernel_pages(unsigned long	kernel_virt_addr,
+				unsigned long	data_size,
+				unsigned long	*num_pages_ptr,
+				struct sep_lli_entry_t	**lli_array_ptr,
+				struct page	***page_array_ptr);
+
+/*
+  this function returns the physical and virtual addresses of the static pool
+*/
+static int sep_get_static_pool_addr_handler(unsigned long arg);
+
+/*
+  this address gets the offset of the physical address from the start of
+  the mapped area
+*/
+static int sep_get_physical_mapped_offset_handler(unsigned long arg);
+
+
+/*
+  this function handles the request for get time
+*/
+static int sep_get_time_handler(unsigned long arg);
+
+/*
+  calculates time and sets it at the predefined address
+*/
+static int sep_set_time(unsigned long	*address_ptr,
+			unsigned long	*time_in_sec_ptr);
+
+/*
+  PATCH for configuring the DMA to single burst instead of multi-burst
+*/
+static void sep_configure_dma_burst(void);
+
+/*
+	This function locks all the physical pages of the
+	application virtual buffer and construct a basic lli
+	array, where each entry holds the physical page address
+	and the size that application data holds in this physical pages
+*/
+static int sep_lock_user_pages(unsigned long  app_virt_addr,
+				unsigned long       data_size,
+				unsigned long      *num_pages_ptr,
+				struct sep_lli_entry_t   **lli_array_ptr,
+				struct page      ***page_array_ptr);
+
+int rar_handle_to_buf(struct RAR_buffer *buffers,
+				      size_t count);
+
+#ifdef DX_CC52_SUPPORT
+/*
+  initializes the caller id functionality
+*/
+static int sep_init_caller_id(void);
+
+
+/*
+  callback for the netlink connector registration
+*/
+static void sep_cn_callback(void *data);
+
+/*
+  this function handles the request for ext(3rd party)cache reallocation
+*/
+static int sep_realloc_ext_cache_handler(unsigned long arg);
+
+/*
+  this function handles the request from signleton to lock access
+*/
+static int sep_singleton_lock_handler(void);
+
+/*
+  singleton ioctl
+*/
+static int sep_singleton_ioctl(struct inode *inode,
+				struct file  *filp,
+				unsigned int   cmd,
+				unsigned long  arg);
+
+/*
+  signleton open function
+*/
+static int sep_singleton_open(struct inode *inode_ptr , struct file *file_ptr);
+
+/*
+  inserts the data into the caller id table
+*/
+static int sep_set_caller_id_handler(unsigned long);
+
+/*
+  prepares the data of the current caller id for external
+  extraction
+*/
+static int sep_set_current_caller_id(void);
+
+
+#endif /*DX_CC52_SUPPORT*/
+
+
+/*---------------------------------------------
+	FUNCTIONS
+-----------------------------------------------*/
+
+/*
+  this function locks SEP by locking the semaphore
+*/
+int sep_lock()
+{
+  mutex_lock(&sep_context.dev_mutex);
+
+  return 0;
+}
+
+/*
+  this function unlocks SEP
+*/
+void sep_unlock()
+{
+  /* release mutex */
+  mutex_unlock(&sep_context.dev_mutex);
+}
+
+/*
+  this function returns the address of the message shared area
+*/
+void sep_map_shared_area(unsigned long		*mappedAddr_ptr)
+{
+  *mappedAddr_ptr = sep_context.shared_area_addr;
+}
+
+/*
+  this function returns the address of the message shared area
+*/
+void sep_send_msg_rdy_cmd()
+{
+  sep_send_command_handler();
+}
+
+/* this functions frees all the resources that were allocated for the building
+of the LLI DMA tables */
+void sep_free_dma_resources()
+{
+  sep_free_dma_table_data_handler();
+}
+
+/* poll(suspend), until reply from sep */
+void sep_driver_poll()
+{
+  unsigned long	retVal = 0;
+
+#ifdef SEP_DRIVER_POLLING_MODE
+
+  while (sep_context.host_to_sep_send_counter != (retVal & 0x7FFFFFFF))
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+			HW_HOST_SEP_HOST_GPR2_REG_ADDR,
+			retVal);
+
+  sep_context.sep_to_host_reply_counter++;
+#else
+  /* poll, until reply from sep */
+  wait_event(sep_context.event,
+			(sep_context.host_to_sep_send_counter ==
+			sep_context.sep_to_host_reply_counter));
+
+#endif
+}
+
+/*----------------------------------------------------------------------
+  open function of the character driver - must only lock the mutex
+	must also release the memory data pool allocations
+------------------------------------------------------------------------*/
+static int sep_open(struct inode *inode_ptr, struct file *file_ptr)
+{
+  /* return value */
+  int			error;
+
+  /*-----------------
+	CODE
+  ---------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "SEP Driver:--------> open start\n");
+
+  error = 0;
+
+  /* check the blocking mode */
+  if (sep_context.block_mode_flag)
+	/* lock mutex */
+	mutex_lock(&sep_context.dev_mutex);
+  else
+	error = mutex_trylock(&sep_context.dev_mutex);
+
+  /* check the error */
+  if (error) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: down_interruptible failed\n");
+
+	goto end_function;
+  }
+
+  /* release data pool allocations */
+  sep_context.data_pool_bytes_allocated = 0;
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "SEP Driver:<-------- open end\n");
+
+  return error;
+}
+
+
+/*------------------------------------------------------------
+	release function
+-------------------------------------------------------------*/
+static int sep_release(struct inode *inode_ptr, struct file *file_ptr)
+{
+  /*-----------------
+	CODE
+  ---------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"----------->SEP Driver: sep_release start\n");
+
+#if 0/*!SEP_DRIVER_POLLING_MODE*/
+  /* close IMR */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_HOST_IMR_REG_ADDR,
+					0x7FFF);
+
+  /* release IRQ line */
+  free_irq(SEP_DIRVER_IRQ_NUM, &sep_context.reg_base_address);
+
+#endif
+
+  /* unlock the sep mutex */
+  mutex_unlock(&sep_context.dev_mutex);
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_release end\n");
+
+  return 0;
+}
+
+
+
+
+/*---------------------------------------------------------------
+  map function - this functions maps the message shared area
+-----------------------------------------------------------------*/
+static int sep_mmap(struct file  *filp, struct vm_area_struct  *vma)
+{
+  /* physical addr */
+  unsigned long phys_addr;
+
+  /*-----------------------
+	CODE
+  -------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "-------->SEP Driver: mmap start\n");
+
+  /* check that the size of the mapped range is as the size of the message
+  shared area */
+  if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver mmap requested size is more than allowed\n");
+	printk(KERN_WARNING "SEP Driver mmap requested size is more \
+			than allowed\n");
+	printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n",
+	vma->vm_end);
+	printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n",
+	vma->vm_start);
+	return -EAGAIN;
+  }
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+  "SEP Driver:g_sep_shared_area_addr is %08lx\n",
+  sep_context.shared_area_addr);
+
+  /* get physical address */
+  phys_addr  = sep_context.phys_shared_area_addr;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED, "SEP Driver: phys_addr is %08lx\n",
+phys_addr);
+
+  if (remap_pfn_range(vma,
+	 vma->vm_start,
+	 phys_addr >> PAGE_SHIFT,
+	 vma->vm_end - vma->vm_start,
+	 vma->vm_page_prot)) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver remap_page_range failed\n");
+	printk(KERN_WARNING  "SEP Driver remap_page_range failed\n");
+	return -EAGAIN;
+  }
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "SEP Driver:<-------- mmap end\n");
+
+  return 0;
+}
+
+
+/*-----------------------------------------------
+  poll function
+*----------------------------------------------*/
+static unsigned int sep_poll(struct file  *filp, poll_table  *wait)
+{
+  unsigned long count;
+
+  unsigned int	mask = 0;
+
+  /* flow id */
+  unsigned long	retVal = 0;
+
+  /*----------------------------------------------
+	CODE
+  -------------------------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "---------->SEP Driver poll: start\n");
+
+
+#if SEP_DRIVER_POLLING_MODE
+
+  while (sep_context.host_to_sep_send_counter != (retVal & 0x3FFFFFFF)) {
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+	HW_HOST_SEP_HOST_GPR2_REG_ADDR,
+	retVal);
+
+	for (count = 0; count < 10 * 4; count += 4)
+	DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+	"Poll Debug Word %lu of the message is %lu\n",
+	count,
+	*((unsigned long *)(sep_context.shared_area_addr +
+	SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES + count)));
+  }
+
+  sep_context.sep_to_host_reply_counter++;
+#else
+  /* add the event to the polling wait table */
+  poll_wait(filp, &sep_context.event, wait);
+
+#endif
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"sep_host_to_sep_send_counter is %lu\n",
+		sep_context.host_to_sep_send_counter);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"sep_sep_to_host_reply_counter is %lu\n",
+	sep_context.sep_to_host_reply_counter);
+
+  /* check if the data is ready */
+  if (sep_context.host_to_sep_send_counter ==
+    sep_context.sep_to_host_reply_counter) {
+
+    for (count = 0; count < 12 * 4; count += 4)
+		DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+		"Sep Mesg Word %lu of the message is %lu\n",
+		count,
+		*((unsigned long *)(sep_context.shared_area_addr + count)));
+
+	for (count = 0; count < 10 * 4; count += 4)
+		DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+		"Debug Data Word %lu of the message is %lu\n",
+		count,
+		*((unsigned long *)(sep_context.shared_area_addr +
+								0x1800 +
+								count)));
+
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+			HW_HOST_SEP_HOST_GPR2_REG_ADDR,
+			retVal);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED, "retVal is %lu\n", retVal);
+
+    /* check printf request from sep */
+    if ((retVal >> 30) & 0x1) {
+
+      DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED ,
+		"SEP Driver: sep printf request in\n");
+      mask |= POLLHUP;
+
+      goto end_function;
+    }
+
+    /* check if the this is sep reply or request */
+	if (retVal >> 31) {
+	    DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	    "SEP Driver: sep request in\n");
+	    /* request */
+	    mask |= POLLOUT | POLLWRNORM;
+	} else {
+	    DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+			"SEP Driver: sep reply in\n");
+	    mask |= POLLIN | POLLRDNORM;
+	}
+    if (!(retVal >> 31)) {
+
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED ,
+		"SEP Driver: sep reply in\n");
+		mask |= POLLIN | POLLRDNORM;
+
+#ifdef DX_DEBUG_RAR_SUPPORT
+	if ((*((unsigned long *)
+		(sep_context.shared_area_addr + 16)) == 0x707/*WMDRM*/) &&
+	    ((unsigned long *)g_rar_handle_virt != NULL)) {
+	  /*copy the decryption result from STATIC_POOL_AREA to RAR buffer*/
+	  memcpy((unsigned long *)g_rar_handle_virt,
+				(unsigned long *)(sep_context.shared_area_addr +
+				SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES),
+				0x1000);
+	}
+#endif
+      goto end_function;
+    }
+
+  }
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "SEP Driver:<-------- poll exit\n");
+  return mask;
+}
+
+
+static int sep_ioctl(struct inode		*inode,
+					struct file		*filp,
+					unsigned int		cmd,
+					unsigned long		arg)
+{
+
+  /* error */
+  int			error;
+
+  /*------------------------
+	CODE
+  ------------------------*/
+  error = 0;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"------------>SEP Driver: ioctl start\n");
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED, "SEP Driver: cmd is %x\n", cmd);
+
+  /* check that the command is for sep device */
+  if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
+	error = -ENOTTY;
+
+	switch (cmd) {
+	case SEP_IOCSENDSEPCOMMAND:
+
+	  /* send command to SEP */
+	sep_send_command_handler();
+
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: after sep_send_command_handler\n");
+
+	  break;
+
+	case SEP_IOCSENDSEPRPLYCOMMAND:
+
+	  /* send reply command to SEP */
+	sep_send_reply_command_handler();
+
+	  break;
+
+	case SEP_IOCALLOCDATAPOLL:
+
+	  /* allocate data pool */
+	error = sep_allocate_data_pool_memory_handler(arg);
+
+	  break;
+
+	case SEP_IOCWRITEDATAPOLL:
+
+	  /* write data into memory pool */
+	error = sep_write_into_data_pool_handler(arg);
+
+	  break;
+
+	case SEP_IOCREADDATAPOLL:
+
+	  /* read data from data pool into application memory */
+	error = sep_read_from_data_pool_handler(arg);
+
+	  break;
+
+	case SEP_IOCCREATESYMDMATABLE:
+
+	  /* create dma table for synhronic operation */
+	error = sep_create_sync_dma_tables_handler(arg);
+
+	  break;
+
+	case SEP_IOCFREEDMATABLEDATA:
+
+	  /* free the pages */
+	error = sep_free_dma_table_data_handler();
+
+	  break;
+
+	case SEP_IOCSEPSTART:
+
+	  /* start command to sep */
+	error = sep_start_handler();
+	  break;
+
+	case SEP_IOCSEPINIT:
+
+	  /* init command to sep */
+	error = sep_init_handler(arg);
+	  break;
+
+	case SEP_IOCSETAPIMODE:
+
+	  /* set non- blocking mode */
+	error = sep_set_api_mode_handler(arg);
+
+	  break;
+
+	case SEP_IOCGETSTATICPOOLADDR:
+
+		/* get the physical and virtual addresses of the static pool */
+		error = sep_get_static_pool_addr_handler(arg);
+
+		break;
+
+	case SEP_IOCENDTRANSACTION:
+
+	error = sep_end_transaction_handler(arg);
+
+		break;
+
+	case SEP_IOCREALLOCCACHERES:
+
+	error = sep_realloc_cache_resident_handler(arg);
+
+	  break;
+
+	case SEP_IOCGETMAPPEDADDROFFSET:
+
+	error = sep_get_physical_mapped_offset_handler(arg);
+
+	  break;
+
+#ifdef DX_CC52_SUPPORT
+	case SEP_IOCREALLOCEXTCACHE:
+
+      error = sep_realloc_ext_cache_handler(arg);
+
+      break;
+#endif
+
+	case SEP_IOCGETIME:
+
+	error = sep_get_time_handler(arg);
+
+	  break;
+
+	case SEP_IOCRARPREPAREMESSAGE:
+
+	error = sep_rar_prepare_output_msg_handler(arg);
+
+	  break;
+
+	default:
+	error = -ENOTTY;
+	  break;
+  }
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- ioctl end\n");
+
+  return error;
+}
+
+
+/*
+  this function registers the driver to the file system
+*/
+static int  sep_register_driver_to_fs(void)
+{
+  /* return value */
+  int			ret_val;
+
+  /* major number */
+  int          major;
+
+  /*---------------------
+	CODE
+  -----------------------*/
+
+#ifdef DX_CC52_SUPPORT
+  ret_val = alloc_chrdev_region(&sep_context.device_number,
+							0,
+							2,
+							"sep_sec_driver");
+#else
+  ret_val = alloc_chrdev_region(&sep_context.device_number,
+							0,
+							1,
+							"sep_sec_driver");
+#endif
+  if (ret_val) {
+	  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "sep_driver:major number allocation failed, retval is %d\n", ret_val);
+	  goto end_function;
+  }
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+  "sep_driver:major number allocation is %d\n", MAJOR(sep_context.device_number));
+
+  /* get the major number */
+  major = MAJOR(sep_context.device_number);
+
+  /* set the files operations structure */
+  sep_context.fops.owner = THIS_MODULE;
+  sep_context.fops.ioctl = sep_ioctl;
+  sep_context.fops.poll = sep_poll;
+  sep_context.fops.open = sep_open;
+  sep_context.fops.release = sep_release;
+  sep_context.fops.mmap = sep_mmap;
+
+  /* init cdev */
+  cdev_init(&sep_context.cdev, &sep_context.fops);
+  sep_context.cdev.owner = THIS_MODULE;
+
+  /* register the driver with the kernel */
+  ret_val = cdev_add(&sep_context.cdev, sep_context.device_number, 1);
+
+  if (ret_val) {
+	  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	  "sep_driver:cdev_add failed, retval is %d\n",
+	  ret_val);
+	  goto end_function_unregister_devnum;
+  }
+
+#ifdef DX_CC52_SUPPORT
+
+  sep_context.singleton_device_number = MKDEV(major, 1);
+
+
+  /* set the singleton device file operations  */
+  sep_context.singleton_fops.owner = THIS_MODULE;
+  sep_context.singleton_fops.ioctl = sep_singleton_ioctl;
+  sep_context.singleton_fops.poll = sep_poll;
+  sep_context.singleton_fops.open = sep_singleton_open;
+  sep_context.singleton_fops.release = sep_release;
+  sep_context.singleton_fops.mmap = sep_mmap;
+
+  /* init singleton cdev */
+  cdev_init(&sep_context.singleton_cdev , &sep_context.singleton_fops);
+  sep_context.singleton_cdev.owner = THIS_MODULE;
+
+  /* register the driver with the kernel fs */
+  ret_val = cdev_add(&sep_context.singleton_cdev ,
+				sep_context.singleton_device_number ,
+				1);
+  if (ret_val) {
+    DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED ,
+		"sep_driver:cdev_add 2 failed, retval is %d\n" ,
+		ret_val);
+    goto end_function_unregister_first_dev;
+  }
+
+  goto end_function;
+
+end_function_unregister_first_dev:
+
+  /* delete the first device */
+  cdev_del(&sep_context.cdev);
+
+#endif
+
+goto end_function;
+
+end_function_unregister_devnum:
+
+#ifdef DX_CC52_SUPPORT
+  /* unregister dev numbers */
+  unregister_chrdev_region(sep_context.device_number, 2);
+#else
+  unregister_chrdev_region(sep_context.device_number, 1);
+#endif
+
+end_function:
+
+  return ret_val;
+}
+
+/*
+  this function unregisters driver from fs
+*/
+static void sep_unregister_driver_from_fs(void)
+{
+  /*-------------------
+	CODE
+  ---------------------*/
+
+  cdev_del(&sep_context.cdev);
+
+#ifdef DX_CC52_SUPPORT
+  cdev_del(&sep_context.singleton_cdev);
+
+  /* unregister dev numbers */
+  unregister_chrdev_region(sep_context.device_number, 2);
+#else
+  unregister_chrdev_region(sep_context.device_number, 1);
+#endif
+
+}
+
+/*
+  reconfig the shared area between HOST and SEP - needed in case
+  the DX_CC_Init function was called before OS loading
+*/
+static int sep_reconfig_shared_area(void)
+{
+  int ret_val;
+
+  /*----------------------
+      CODE
+  --------------------------*/
+
+  ret_val = 0;
+
+#if SEP_DRIVER_RECONFIG_MESSAGE_AREA
+
+  /* send the new SHARED MESSAGE AREA to the SEP */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+					HW_HOST_HOST_SEP_GPR1_REG_ADDR ,
+					sep_context.phys_shared_area_addr);
+
+  /* poll for SEP response */
+  SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_HOST_GPR1_REG_ADDR ,
+					ret_val);
+  while (ret_val != 0xffffffff &&
+		ret_val != sep_context.phys_shared_area_addr) {
+    SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_HOST_GPR1_REG_ADDR ,
+					ret_val);
+  }
+
+  /* check the return value (register) */
+  if (ret_val != sep_context.phys_shared_area_addr)
+		ret_val = -ENOMEM;
+
+
+#endif
+
+  return ret_val;
+}
+
+
+
+/*
+  config the OTP - usually needed in debug mode
+*/
+static void sep_debug_config_otp(void)
+{
+#if SEP_DRIVER_CONFIG_OTP
+  /*-------------------------
+      CODE
+  ----------------------------*/
+
+  /* set LCS to non-secure */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4124, 0x0);
+
+  /* load the HASH value of the key to the OTP */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x414C, 0x84016ba2);/*OEM0*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4150, 0x37bccadf);/*OEM1*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4154, 0x24abae06);/*OEM2*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4158, 0x924b737e);/*OEM3*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x415C, 0xc76754df);/*OEM4*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4160, 0x5d6523bc);/*OEM5*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4164, 0xbe5d0932);/*OEM6*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x4168, 0x7e03e713);/*OEM7*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + 0x416C, 0x00007979);/*ECC*/
+
+#endif
+
+  return;
+}
+
+/*--------------------------------------------------------------
+  init function
+----------------------------------------------------------------*/
+static int __init sep_init(void)
+{
+  /* return value */
+  int			ret_val;
+
+  /* size to of memory for allocation */
+  int			size;
+
+  /*------------------------
+	CODE
+  ------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:-------->Init start\n");
+
+  ret_val = 0;
+
+  ret_val = sep_register_driver_to_device();
+  if (ret_val) {
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"sep_driver:sep_driver_to_device failed, ret_val is %d\n",
+	ret_val);
+	goto end_function_unregister_from_fs;
+  }
+
+  /* register driver to fs */
+  ret_val = sep_register_driver_to_fs();
+  if (ret_val)
+	goto end_function_deallocate_sep_shared_area;
+
+  /* set the starting mode to blocking */
+  sep_context.block_mode_flag = 1;
+
+  /* calculate the total size for allocation */
+  size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
+
+
+
+  /* allocate the shared area */
+  if (sep_map_and_alloc_shared_area(size,
+				&sep_context.shared_area_addr,
+				&sep_context.phys_shared_area_addr)) {
+	ret_val = -ENOMEM;
+	/* allocation failed */
+	goto end_function_unmap_io_memory;
+  }
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: g_sep_shared_area_addr is %08lx\n",
+	sep_context.shared_area_addr);
+
+  /* initialize mutex */
+  mutex_init(&sep_context.dev_mutex);
+
+  /* initialize wait queue */
+  init_waitqueue_head(&sep_context.event);
+
+
+#ifdef DX_CC52_SUPPORT
+  /* init the caller id */
+  ret_val = sep_init_caller_id();
+  if (ret_val)
+    goto end_function_deallocate_sep_shared_area;
+
+#endif
+
+  /* config the OTP - usually needed in debug mode */
+  sep_debug_config_otp();
+
+  /* load the rom code */
+  sep_load_rom_code();
+
+  /* reconfig the shared area - needed in case that OS
+	was initialized after the DX_CC_Init */
+  ret_val = sep_reconfig_shared_area();
+  if (ret_val)
+	goto end_function_unregister_from_fs;
+
+
+  goto end_function;
+
+end_function_unregister_from_fs:
+
+  /* unregister from fs */
+  sep_unregister_driver_from_fs();
+
+end_function_deallocate_sep_shared_area:
+
+  /* de-allocate shared area */
+  sep_unmap_and_free_shared_area(size,
+				sep_context.shared_area_addr,
+				sep_context.phys_shared_area_addr);
+
+end_function_unmap_io_memory:
+
+end_function_unregister_io_memory:
+
+  /* release io memory region */
+  release_mem_region(SEP_IO_MEM_REGION_START_ADDRESS, SEP_IO_MEM_REGION_SIZE);
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,  "SEP Driver:<-------- Init end\n");
+
+  return ret_val;
+}
+
+
+
+
+/*-------------------------------------------------------------
+  exit function
+--------------------------------------------------------------*/
+static void __exit sep_exit(void)
+{
+  /* size */
+  int			size;
+
+  /*-----------------------------
+	CODE
+  --------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "SEP Driver:--------> Exit start\n");
+
+  /* unregister from fs */
+  sep_unregister_driver_from_fs();
+
+  /* calculate the total size for de-allocation */
+  size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
+
+
+  /* free shared area  */
+  sep_unmap_and_free_shared_area(size,
+				sep_context.shared_area_addr,
+				sep_context.phys_shared_area_addr);
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: free pages SEP SHARED AREA \n");
+
+  iounmap((void *)sep_context.reg_base_address);
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED, "SEP Driver: iounmap \n");
+
+  /* release io memory region */
+  release_mem_region(SEP_IO_MEM_REGION_START_ADDRESS, SEP_IO_MEM_REGION_SIZE);
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED, "SEP Driver: release_mem_region \n");
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,  "SEP Driver:<-------- Exit end\n");
+}
+
+
+/*
+  interrupt handler function
+*/
+irqreturn_t sep_inthandler(int irq, void *dev_id)
+{
+  /* int error */
+  irqreturn_t			int_error;
+
+  /* reg value */
+  unsigned long		reg_val;
+
+  /*-----------------------------
+	CODE
+  -----------------------------*/
+
+  int_error = IRQ_HANDLED;
+
+  /* read the IRR register to check if this is SEP interrupt */
+  SEP_READ_REGISTER(sep_context.reg_base_address + HW_HOST_IRR_REG_ADDR,
+					reg_val);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED, "SEP Interrupt - reg is %08lx\n",
+			reg_val);
+
+
+  /* check if this is reply interrupt from SEP */
+  if (reg_val & (0x1 << 13)) {
+    /* update the counter of reply messages */
+    sep_context.sep_to_host_reply_counter++;
+
+    /* wake up the waiting process */
+    wake_up(&sep_context.event);
+  } else {
+    int_error = IRQ_NONE;
+    goto end_function;
+  }
+
+  /* clear the interrupt */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_HOST_ICR_REG_ADDR,
+					reg_val);
+
+end_function:
+
+  return int_error;
+}
+
+
+/*
+  This function prepares only input DMA table for synhronic symmetric
+  operations (HASH)
+*/
+int sep_prepare_input_dma_table(unsigned long	app_virt_addr,
+				unsigned long	data_size,
+				unsigned long	block_size,
+				unsigned long	*lli_table_ptr,
+				unsigned long	*num_entries_ptr,
+				unsigned long	*table_data_size_ptr,
+				bool			isKernelVirtualAddress)
+
+{
+  /* pointer to the info entry of the table - the last entry */
+  struct sep_lli_entry_t		*info_entry_ptr;
+
+  /* array of pointers ot page */
+  struct sep_lli_entry_t		*lli_array_ptr;
+
+  /* points to the first entry to be processed in the lli_in_array */
+  unsigned long		current_entry;
+
+  /* num entries in the virtual buffer */
+  unsigned long		sep_lli_entries;
+
+  /* lli table pointer */
+  struct sep_lli_entry_t		*in_lli_table_ptr;
+
+  /* the total data in one table */
+  unsigned long		table_data_size;
+
+  /* number of entries in lli table */
+  unsigned long		num_entries_in_table;
+
+  /* next table address */
+  unsigned long		lli_table_alloc_addr;
+
+  /* result */
+  unsigned long		result;
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_prepare_input_dma_table start\n");
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED, "SEP Driver:data_size is %lu\n",
+		data_size);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED, "SEP Driver:block_size is %lu\n",
+		block_size);
+
+  /* initialize the pages pointers */
+  sep_context.in_page_array = 0;
+  sep_context.in_num_pages = 0;
+
+  if (data_size == 0) {
+	/* special case  - created 2 entries table with zero data */
+	in_lli_table_ptr = (struct sep_lli_entry_t *)
+			(sep_context.shared_area_addr +
+			SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES);
+	in_lli_table_ptr->physical_address = sep_context.shared_area_addr +
+			SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES;
+	in_lli_table_ptr->block_size = 0;
+
+	in_lli_table_ptr++;
+	in_lli_table_ptr->physical_address = 0xFFFFFFFF;
+	in_lli_table_ptr->block_size = 0;
+
+	*lli_table_ptr = sep_context.phys_shared_area_addr +
+			SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES;
+	*num_entries_ptr = 2;
+	*table_data_size_ptr = 0;
+
+	goto end_function;
+  }
+
+  /* check if the pages are in Kernel Virtual Address layout */
+  if (isKernelVirtualAddress == true)
+	/* lock the pages of the kernel buffer and translate them to pages */
+	result = sep_lock_kernel_pages(app_virt_addr,
+					data_size,
+					&sep_context.in_num_pages,
+					&lli_array_ptr,
+					&sep_context.in_page_array);
+  else
+	/* lock the pages of the user buffer and translate them to pages */
+	result = sep_lock_user_pages(app_virt_addr,
+				data_size,
+				&sep_context.in_num_pages,
+				&lli_array_ptr,
+				&sep_context.in_page_array);
+
+  if (result)
+	return result;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+  "SEP Driver:output sep_in_num_pages is %lu\n",
+  sep_context.in_num_pages);
+
+  current_entry = 0;
+  info_entry_ptr = 0;
+  sep_lli_entries = sep_context.in_num_pages;
+
+  /* initiate to point after the message area */
+  lli_table_alloc_addr = sep_context.shared_area_addr +
+		SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES;
+
+  /* loop till all the entries in in array are not processed */
+  while (current_entry < sep_lli_entries) {
+	/* set the new input and output tables */
+	in_lli_table_ptr = (struct sep_lli_entry_t *)lli_table_alloc_addr;
+
+	lli_table_alloc_addr += sizeof(struct sep_lli_entry_t) *
+				SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+	/* calculate the maximum size of data for input table */
+	table_data_size = sep_calculate_lli_table_max_size(
+		&lli_array_ptr[current_entry],
+		(sep_lli_entries - current_entry));
+
+	/* now calculate the table size so that it will be module block size */
+	table_data_size = (table_data_size / block_size) * block_size;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:output table_data_size is %lu\n",
+	table_data_size);
+
+	/* construct input lli table */
+	sep_build_lli_table(&lli_array_ptr[current_entry],
+						in_lli_table_ptr,
+						&current_entry,
+						&num_entries_in_table,
+						table_data_size);
+
+	if (info_entry_ptr == 0) {
+	  /* set the output parameters to physical addresses */
+	  *lli_table_ptr = sep_shared_area_virt_to_phys(
+		  (unsigned long)in_lli_table_ptr);
+	  *num_entries_ptr = num_entries_in_table;
+	  *table_data_size_ptr = table_data_size;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:output lli_table_in_ptr is %08lx\n",
+	*lli_table_ptr);
+	} else {
+	  /* update the info entry of the previous in table */
+	info_entry_ptr->physical_address = sep_shared_area_virt_to_phys(
+				(unsigned long)in_lli_table_ptr);
+	info_entry_ptr->block_size = ((num_entries_in_table) << 24) |
+				(table_data_size);
+	}
+
+	/* save the pointer to the info entry of the current tables */
+	info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
+  }
+
+  /* print input tables */
+  sep_debug_print_lli_tables((struct sep_lli_entry_t *)
+			sep_shared_area_phys_to_virt(*lli_table_ptr),
+			*num_entries_ptr,
+			*table_data_size_ptr);
+
+  /* the array of the pages */
+  kfree(lli_array_ptr);
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_prepare_input_dma_table end\n");
+
+  return 0;
+
+}
+
+/*
+  This function builds input and output DMA tables for synhronic
+  symmetric operations (AES, DES). It also checks that each table
+  is of the modular block size
+*/
+int sep_prepare_input_output_dma_table(unsigned long	app_virt_in_addr,
+					unsigned long	app_virt_out_addr,
+					unsigned long	data_size,
+					unsigned long	block_size,
+					unsigned long	*lli_table_in_ptr,
+					unsigned long	*lli_table_out_ptr,
+					unsigned long	*in_num_entries_ptr,
+					unsigned long	*out_num_entries_ptr,
+					unsigned long	*table_data_size_ptr,
+					bool 		isKernelVirtualAddress)
+
+{
+  /* array of pointers of page */
+  struct sep_lli_entry_t		*lli_in_array;
+
+  /* array of pointers of page */
+  struct sep_lli_entry_t		*lli_out_array;
+
+  /* result */
+  int				result;
+
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_prepare_input_output_dma_table start\n");
+
+  result = 0;
+
+  /* initialize the pages pointers */
+  sep_context.in_page_array = 0;
+  sep_context.out_page_array = 0;
+
+  /* check if the pages are in Kernel Virtual Address layout */
+  if (isKernelVirtualAddress == true) {
+	/* lock the pages of the kernel buffer and translate them to pages */
+	result = sep_lock_kernel_pages(app_virt_in_addr,
+				data_size,
+				&sep_context.in_num_pages,
+				&lli_in_array,
+				&sep_context.in_page_array);
+	if (result) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: sep_lock_kernel_pages for input virtual buffer failed\n");
+	goto end_function;
+	}
+  } else {
+	/* lock the pages of the user buffer and translate them to pages */
+	result = sep_lock_user_pages(app_virt_in_addr,
+					data_size,
+					&sep_context.in_num_pages,
+					&lli_in_array,
+					&sep_context.in_page_array);
+	if (result) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: sep_lock_user_pages for input virtual buffer failed\n");
+	goto end_function;
+	}
+  }
+
+  if (isKernelVirtualAddress == true) {
+	result = sep_lock_kernel_pages(app_virt_out_addr,
+				data_size,
+				&sep_context.out_num_pages,
+				&lli_out_array,
+				&sep_context.out_page_array);
+	if (result) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: sep_lock_kernel_pages for output virtual buffer failed\n");
+	goto end_function_with_error1;
+	}
+  } else {
+	result = sep_lock_user_pages(app_virt_out_addr,
+					data_size,
+					&sep_context.out_num_pages,
+					&lli_out_array,
+					&sep_context.out_page_array);
+	if (result) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: sep_lock_user_pages for output virtual buffer failed\n");
+	goto end_function_with_error1;
+	}
+  }
+
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"sep_in_num_pages is %lu\n", sep_context.in_num_pages);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"sep_out_num_pages is %lu\n", sep_context.out_num_pages);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
+	SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+
+  /* call the fucntion that creates table from the lli arrays */
+  result = sep_construct_dma_tables_from_lli(lli_in_array,
+					sep_context.in_num_pages,
+					lli_out_array,
+					sep_context.out_num_pages,
+					 block_size,
+					lli_table_in_ptr,
+					lli_table_out_ptr,
+					in_num_entries_ptr,
+					out_num_entries_ptr,
+					table_data_size_ptr);
+  if (result) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: sep_construct_dma_tables_from_lli failed\n");
+	goto end_function_with_error2;
+  }
+
+  /* fall through - free the lli entry arrays */
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC, "in_num_entries_ptr is %08lx\n",
+	*in_num_entries_ptr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC, "out_num_entries_ptr is %08lx\n",
+	*out_num_entries_ptr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC, "table_data_size_ptr is %08lx\n",
+	*table_data_size_ptr);
+
+
+end_function_with_error2:
+
+  kfree(lli_out_array);
+
+end_function_with_error1:
+
+  kfree(lli_in_array);
+
+end_function:
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC,
+"SEP Driver:<-------- sep_prepare_input_output_dma_table end result = %d\n",
+(int)result);
+
+  return result;
+
+}
+
+
+/*
+ This function creates the input and output dma tables for
+ symmetric operations (AES/DES) according to the block size from LLI arays
+*/
+int sep_construct_dma_tables_from_lli(struct sep_lli_entry_t	*lli_in_array,
+					unsigned long	sep_in_lli_entries,
+					struct sep_lli_entry_t	*lli_out_array,
+					unsigned long	sep_out_lli_entries,
+					unsigned long	block_size,
+					unsigned long	*lli_table_in_ptr,
+					unsigned long	*lli_table_out_ptr,
+					unsigned long	*in_num_entries_ptr,
+					unsigned long	*out_num_entries_ptr,
+					unsigned long	*table_data_size_ptr)
+{
+  /* points to the area where next lli table can be allocated */
+  unsigned long	lli_table_alloc_addr;
+
+  /* input lli table */
+  struct sep_lli_entry_t		*in_lli_table_ptr;
+
+  /* output lli table */
+  struct sep_lli_entry_t		*out_lli_table_ptr;
+
+  /* pointer to the info entry of the table - the last entry */
+  struct sep_lli_entry_t		*info_in_entry_ptr;
+
+  /* pointer to the info entry of the table - the last entry */
+  struct sep_lli_entry_t		*info_out_entry_ptr;
+
+  /* points to the first entry to be processed in the lli_in_array */
+  unsigned long	current_in_entry;
+
+  /* points to the first entry to be processed in the lli_out_array */
+  unsigned long	current_out_entry;
+
+  /* max size of the input table */
+  unsigned long	in_table_data_size;
+
+  /* max size of the output table */
+  unsigned long	out_table_data_size;
+
+  /* flag te signifies if this is the first tables build from the arrays */
+  unsigned long	  first_table_flag;
+
+  /* the data size that should be in table */
+  unsigned long	table_data_size;
+
+  /* number of etnries in the input table */
+  unsigned long	num_entries_in_table;
+
+  /* number of etnries in the output table */
+  unsigned long	num_entries_out_table;
+
+  /*---------------------
+	CODE
+  ------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_construct_dma_tables_from_lli start\n");
+
+  /* initiate to pint after the message area */
+  lli_table_alloc_addr = sep_context.shared_area_addr +
+	SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES;
+
+  current_in_entry = 0;
+  current_out_entry = 0;
+  first_table_flag = 1;
+  info_in_entry_ptr = 0;
+  info_out_entry_ptr = 0;
+
+  /* loop till all the entries in in array are not processed */
+  while (current_in_entry < sep_in_lli_entries) {
+	/* set the new input and output tables */
+	in_lli_table_ptr = (struct sep_lli_entry_t *)lli_table_alloc_addr;
+
+	lli_table_alloc_addr += sizeof(struct sep_lli_entry_t) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+	/* set the first output tables */
+	out_lli_table_ptr = (struct sep_lli_entry_t *)lli_table_alloc_addr;
+
+	lli_table_alloc_addr += sizeof(struct sep_lli_entry_t) *
+				SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+	/* calculate the maximum size of data for input table */
+	in_table_data_size =
+			sep_calculate_lli_table_max_size(
+			&lli_in_array[current_in_entry],
+			(sep_in_lli_entries - current_in_entry));
+
+	/* calculate the maximum size of data for output table */
+	out_table_data_size =
+			sep_calculate_lli_table_max_size(
+			&lli_out_array[current_out_entry],
+			(sep_out_lli_entries - current_out_entry));
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:in_table_data_size is %lu\n", in_table_data_size);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:out_table_data_size is %lu\n", out_table_data_size);
+
+	/* check where the data is smallest */
+	table_data_size = in_table_data_size;
+	if (table_data_size > out_table_data_size)
+	table_data_size = out_table_data_size;
+
+	/* now calculate the table size so that it will be module block size */
+	table_data_size = (table_data_size / block_size) * block_size;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:table_data_size is %lu\n",
+		table_data_size);
+
+	/* construct input lli table */
+	sep_build_lli_table(&lli_in_array[current_in_entry],
+						in_lli_table_ptr,
+						&current_in_entry,
+						&num_entries_in_table,
+						table_data_size);
+
+	/* construct output lli table */
+	sep_build_lli_table(&lli_out_array[current_out_entry],
+						out_lli_table_ptr,
+						&current_out_entry,
+						&num_entries_out_table,
+						table_data_size);
+
+	/* if info entry is null - this is the first table built */
+	if (info_in_entry_ptr == 0) {
+	  /* set the output parameters to physical addresses */
+	  *lli_table_in_ptr =
+		sep_shared_area_virt_to_phys((unsigned long)in_lli_table_ptr);
+	  *in_num_entries_ptr = num_entries_in_table;
+	  *lli_table_out_ptr =
+		sep_shared_area_virt_to_phys((unsigned long)out_lli_table_ptr);
+	  *out_num_entries_ptr = num_entries_out_table;
+	  *table_data_size_ptr = table_data_size;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:output lli_table_in_ptr is %08lx\n", *lli_table_in_ptr);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:output lli_table_out_ptr is %08lx\n", *lli_table_out_ptr);
+	} else {
+	  /* update the info entry of the previous in table */
+	info_in_entry_ptr->physical_address =
+		sep_shared_area_virt_to_phys((unsigned long)in_lli_table_ptr);
+	info_in_entry_ptr->block_size =
+		((num_entries_in_table) << 24) | (table_data_size);
+
+	  /* update the info entry of the previous in table */
+	info_out_entry_ptr->physical_address =
+		sep_shared_area_virt_to_phys((unsigned long)out_lli_table_ptr);
+	info_out_entry_ptr->block_size =
+		((num_entries_out_table) << 24) | (table_data_size);
+	}
+
+	/* save the pointer to the info entry of the current tables */
+	info_in_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
+	info_out_entry_ptr = out_lli_table_ptr + num_entries_out_table - 1;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:output num_entries_out_table is %lu\n",
+		(unsigned long)num_entries_out_table);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:output info_in_entry_ptr is %lu\n",
+		(unsigned long)info_in_entry_ptr);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:output info_out_entry_ptr is %lu\n",
+		(unsigned long)info_out_entry_ptr);
+  }
+
+  /* print input tables */
+  sep_debug_print_lli_tables(
+	(struct sep_lli_entry_t *)
+	sep_shared_area_phys_to_virt(*lli_table_in_ptr),
+	*in_num_entries_ptr,
+	*table_data_size_ptr);
+
+  /* print output tables */
+  sep_debug_print_lli_tables(
+	(struct sep_lli_entry_t *)
+	sep_shared_area_phys_to_virt(*lli_table_out_ptr),
+	*out_num_entries_ptr,
+	*table_data_size_ptr);
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:<-------- sep_construct_dma_tables_from_lli end\n");
+
+  return 0;
+}
+
+/*
+  this function calculates the size of data that can be inserted into the lli
+  table from this array the condition is that either the table is full
+  (all etnries are entered), or there are no more entries in the lli array
+*/
+unsigned long sep_calculate_lli_table_max_size(
+			struct sep_lli_entry_t	*lli_in_array_ptr,
+			unsigned long	num_array_entries)
+{
+  /* table data size */
+  unsigned long table_data_size;
+
+  /* counter */
+  unsigned long counter;
+
+  /*---------------------
+	CODE
+  ----------------------*/
+
+  table_data_size = 0;
+
+  /* calculate the data in the out lli table if till we fill the whole
+  table or till the data has ended */
+  for (counter = 0;
+	(counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&
+	(counter < num_array_entries); counter++)
+	table_data_size += lli_in_array_ptr[counter].block_size;
+
+  return table_data_size;
+}
+
+/*
+  this functions builds ont lli table from the lli_array according to
+  the given size of data
+*/
+static void sep_build_lli_table(struct sep_lli_entry_t	*lli_array_ptr,
+				struct sep_lli_entry_t	*lli_table_ptr,
+				unsigned long	*num_processed_entries_ptr,
+				unsigned long	*num_table_entries_ptr,
+				unsigned long	table_data_size)
+{
+  /* current table data size */
+  unsigned long curr_table_data_size;
+
+  /* counter of lli array entry */
+  unsigned long array_counter;
+
+  /*-----------------------
+	CODE
+  ---------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_build_lli_table start\n");
+
+  /* init currrent table data size and lli array entry counter */
+  curr_table_data_size = 0;
+  array_counter = 0;
+  *num_table_entries_ptr = 1;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+  "SEP Driver:table_data_size is %lu\n",
+	table_data_size);
+
+  /* fill the table till table size reaches the needed amount */
+  while (curr_table_data_size < table_data_size) {
+	/* update the number of entries in table */
+	(*num_table_entries_ptr)++;
+
+	lli_table_ptr->physical_address =
+		lli_array_ptr[array_counter].physical_address;
+	lli_table_ptr->block_size = lli_array_ptr[array_counter].block_size;
+	curr_table_data_size += lli_table_ptr->block_size;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr is %08lx\n",
+	(unsigned long)lli_table_ptr);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr->physical_address is %08lx\n",
+	lli_table_ptr->physical_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr->block_size is %lu\n",
+	lli_table_ptr->block_size);
+
+	/* check for overflow of the table data */
+	if (curr_table_data_size > table_data_size) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:curr_table_data_size > table_data_size\n");
+
+	  /* update the size of block in the table */
+	lli_table_ptr->block_size -= (curr_table_data_size - table_data_size);
+
+	  /* update the physical address in the lli array */
+	lli_array_ptr[array_counter].physical_address +=
+			lli_table_ptr->block_size;
+
+	  /* update the block size left in the lli array */
+	lli_array_ptr[array_counter].block_size =
+			(curr_table_data_size - table_data_size);
+	} else
+	  /* advance to the next entry in the lli_array */
+	  array_counter++;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr->physical_address is %08lx\n",
+	lli_table_ptr->physical_address);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr->block_size is %lu\n",
+	lli_table_ptr->block_size);
+
+	/* move to the next entry in table */
+	lli_table_ptr++;
+  }
+
+  /* set the info entry to default */
+  lli_table_ptr->physical_address = 0xffffffff;
+  lli_table_ptr->block_size = 0;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr is %08lx\n",
+	(unsigned long)lli_table_ptr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr->physical_address is %08lx\n",
+	lli_table_ptr->physical_address);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:lli_table_ptr->block_size is %lu\n",
+	lli_table_ptr->block_size);
+
+
+  /* set the output parameter */
+  *num_processed_entries_ptr += array_counter;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:*num_processed_entries_ptr is %lu\n",
+	*num_processed_entries_ptr);
+
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_build_lli_table end\n");
+
+  return;
+}
+
+/*
+  this function goes over the list of the print created tables and
+  prints all the data
+*/
+static void sep_debug_print_lli_tables(struct sep_lli_entry_t	*lli_table_ptr,
+					unsigned long	num_table_entries,
+					unsigned long	table_data_size)
+{
+  unsigned long table_count;
+
+  unsigned long entries_count;
+  /*-----------------------------
+	CODE
+  -------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_debug_print_lli_tables start\n");
+
+  table_count = 1;
+  while ((unsigned long)lli_table_ptr != 0xffffffff) {
+	DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: lli table %08lx, table_data_size is %lu\n",
+	table_count,
+	table_data_size);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: num_table_entries is %lu\n", num_table_entries);
+
+	/* print entries of the table (without info entry) */
+	for (entries_count = 0;
+		entries_count < num_table_entries;
+		entries_count++, lli_table_ptr++) {
+		DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:lli_table_ptr address is %08lx\n",
+		(unsigned long)lli_table_ptr);
+		DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:phys address is %08lx block size is %lu\n",
+		lli_table_ptr->physical_address, lli_table_ptr->block_size);
+	}
+
+	/* point to the info entry */
+	lli_table_ptr--;
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:phys lli_table_ptr->block_size is %lu\n",
+	lli_table_ptr->block_size);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:phys lli_table_ptr->physical_address is %08lx\n",
+	lli_table_ptr->physical_address);
+
+
+	table_data_size = lli_table_ptr->block_size & 0xffffff;
+	num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
+	lli_table_ptr = (struct sep_lli_entry_t *)
+				(lli_table_ptr->physical_address);
+
+	DEBUG_PRINT_3(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:phys table_data_size is %lu num_table_entries is \
+	%lu lli_table_ptr is%lu\n",
+	table_data_size, num_table_entries, (unsigned long)lli_table_ptr);
+
+	if ((unsigned long)lli_table_ptr != 0xffffffff)
+	lli_table_ptr = (struct sep_lli_entry_t *)sep_shared_area_phys_to_virt(
+					(unsigned long)lli_table_ptr);
+
+	table_count++;
+  }
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_debug_print_lli_tables end\n");
+}
+
+
+/*
+  This function locks all the physical pages of the application virtual buffer
+  and construct a basic lli  array, where each entry holds the physical page
+  address and the size that application data holds in this physical pages
+*/
+int sep_lock_user_pages(unsigned long		app_virt_addr,
+			unsigned long		data_size,
+			unsigned long		*num_pages_ptr,
+			struct sep_lli_entry_t		**lli_array_ptr,
+			struct page		***page_array_ptr)
+
+{
+  /* error */
+  int				error;
+
+  /* the the page of the end address of the user space buffer */
+  unsigned long		end_page;
+
+  /* the page of the start address of the user space buffer */
+  unsigned long		start_page;
+
+  /* the range in pages */
+  unsigned long		num_pages;
+
+  /* array of pointers ot page */
+  struct page		**page_array;
+
+  /* array of lli */
+  struct sep_lli_entry_t		*lli_array;
+
+  /* count */
+  unsigned long		count;
+
+  /* result */
+  int				result;
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_lock_user_pages start\n");
+
+  error = 0;
+
+  /* set start and end pages  and num pages */
+  end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
+  start_page = app_virt_addr >> PAGE_SHIFT;
+  num_pages = end_page - start_page + 1;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: app_virt_addr is %08lx\n",
+	app_virt_addr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: data_size is %lu\n",
+	data_size);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: start_page is %lu\n",
+	start_page);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: end_page is %lu\n",
+	end_page);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: num_pages is %lu\n",
+	num_pages);
+
+  /* allocate array of pages structure pointers */
+  page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
+  if (!page_array) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: kmalloc for page_array failed\n");
+
+	error = -ENOMEM;
+	goto end_function;
+  }
+
+  lli_array = kmalloc(sizeof(struct sep_lli_entry_t) * num_pages, GFP_ATOMIC);
+  if (!lli_array) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: kmalloc for lli_array failed\n");
+
+	error = -ENOMEM;
+	goto end_function_with_error1;
+  }
+
+  /* convert the application virtual address into a set of physical */
+  down_read(&current->mm->mmap_sem);
+  result = get_user_pages(current, current->mm, app_virt_addr, num_pages, 1, 0,
+	page_array,
+	0);
+  up_read(&current->mm->mmap_sem);
+
+  /* check the number of pages locked - if not all then exit with error */
+  if (result != num_pages) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver: not all pages locked by get_user_pages\n");
+
+	error = -ENOMEM;
+	goto end_function_with_error2;
+  }
+
+  /* flush the cache */
+  for (count = 0; count < num_pages; count++)
+	flush_dcache_page(page_array[count]);
+
+  /* set the start address of the first page - app data may start not at
+	the beginning of the page */
+  lli_array[0].physical_address = (
+			(unsigned long)page_to_phys(page_array[0])) +
+			(app_virt_addr & (~PAGE_MASK)) ;
+
+  /* check that not all the data is in the first page only */
+  if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
+	lli_array[0].block_size = data_size;
+  else
+	lli_array[0].block_size = PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
+
+  /* debug print */
+  DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+  "lli_array[0].physical_address is %08lx, lli_array[0].block_size is %lu\n",
+	lli_array[0].physical_address,
+	lli_array[0].block_size);
+
+  /* go from the second page to the prev before last */
+  for (count = 1; count < (num_pages - 1); count++) {
+	lli_array[count].physical_address =
+		(unsigned long)page_to_phys(page_array[count]);
+	lli_array[count].block_size = PAGE_SIZE;
+
+	DEBUG_PRINT_4(SEP_DEBUG_LEVEL_EXTENDED,
+	"lli_array[%lu].physical_address is %08lx, \
+	lli_array[%lu].block_size is %lu\n",
+	count, lli_array[count].physical_address,
+	count,
+	lli_array[count].block_size);
+  }
+
+  /* if more then 1 pages locked - then update for the last page size needed */
+  if (num_pages > 1) {
+	/* update the address of the last page */
+	lli_array[count].physical_address =
+		(unsigned long)page_to_phys(page_array[count]);
+
+	/* set the size of the last page */
+	lli_array[count].block_size = (app_virt_addr + data_size) &
+					(~PAGE_MASK);
+
+	if (lli_array[count].block_size == 0) {
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC,
+	"app_virt_addr is %08lx\n",
+	app_virt_addr);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC, "data_size is %lu\n", data_size);
+	  while (1);
+	}
+	DEBUG_PRINT_4(SEP_DEBUG_LEVEL_EXTENDED,
+	"lli_array[%lu].physical_address is %08lx, \
+		lli_array[%lu].block_size is %lu\n",
+	count, lli_array[count].physical_address,
+	count,
+	lli_array[count].block_size);
+  }
+
+  /* set output params */
+  *lli_array_ptr = lli_array;
+  *num_pages_ptr = num_pages;
+  *page_array_ptr = page_array;
+
+  goto end_function;
+
+end_function_with_error2:
+
+  /* release the cache */
+  for (count = 0; count < num_pages; count++)
+	page_cache_release(page_array[count]);
+
+  /* free lli array */
+  kfree(lli_array);
+
+end_function_with_error1:
+
+  /* free page array */
+  kfree(page_array);
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_lock_user_pages end\n");
+
+  return 0;
+}
+
+/*
+  This function locks all the physical pages of the kernel virtual buffer
+  and construct a basic lli  array, where each entry holds the physical
+  page address and the size that application data holds in this physical pages
+*/
+int sep_lock_kernel_pages(unsigned long		kernel_virt_addr,
+			unsigned long		data_size,
+			unsigned long		*num_pages_ptr,
+			struct sep_lli_entry_t		**lli_array_ptr,
+			struct page		***page_array_ptr)
+
+{
+  /* error */
+  int				error;
+
+  /* the the page of the end address of the user space buffer */
+  unsigned long		end_page;
+
+  /* the page of the start address of the user space buffer */
+  unsigned long		start_page;
+
+  /* the range in pages */
+  unsigned long		num_pages;
+
+  /* array of lli */
+  struct sep_lli_entry_t		*lli_array;
+
+  /* next kernel address to map */
+  unsigned long		next_kernel_address;
+
+  /* count */
+  unsigned long		count;
+
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_lock_kernel_pages start\n");
+
+  error = 0;
+
+  /* set start and end pages  and num pages */
+  end_page = (kernel_virt_addr + data_size - 1) >> PAGE_SHIFT;
+  start_page = kernel_virt_addr >> PAGE_SHIFT;
+  num_pages = end_page - start_page + 1;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: kernel_virt_addr is %08lx\n",
+	kernel_virt_addr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: data_size is %lu\n",
+	data_size);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: start_page is %lx\n",
+	start_page);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: end_page is %lx\n",
+	end_page);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver: num_pages is %lu\n",
+	num_pages);
+
+  lli_array = kmalloc(sizeof(struct sep_lli_entry_t) * num_pages, GFP_ATOMIC);
+  if (!lli_array) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver: kmalloc for lli_array failed\n");
+
+	error = -ENOMEM;
+	goto end_function;
+  }
+
+  /* set the start address of the first page - app data may start not at
+  the beginning of the page */
+  lli_array[0].physical_address =
+	(unsigned long)virt_to_phys((unsigned long *)kernel_virt_addr);
+
+  /* check that not all the data is in the first page only */
+  if ((PAGE_SIZE - (kernel_virt_addr & (~PAGE_MASK))) >= data_size)
+	lli_array[0].block_size = data_size;
+  else
+	lli_array[0].block_size =
+		PAGE_SIZE - (kernel_virt_addr & (~PAGE_MASK));
+
+  /* debug print */
+  DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+  "lli_array[0].physical_address is %08lx, lli_array[0].block_size is %lu\n",
+	lli_array[0].physical_address,
+	lli_array[0].block_size);
+
+  /* advance the address to the start of the next page */
+  next_kernel_address = (kernel_virt_addr & PAGE_MASK) + PAGE_SIZE;
+
+  /* go from the second page to the prev before last */
+  for (count = 1; count < (num_pages - 1); count++) {
+	lli_array[count].physical_address =
+	(unsigned long)virt_to_phys((unsigned long *)next_kernel_address);
+	lli_array[count].block_size = PAGE_SIZE;
+
+	DEBUG_PRINT_4(SEP_DEBUG_LEVEL_EXTENDED,
+	"lli_array[%lu].physical_address is %08lx, \
+	lli_array[%lu].block_size is %lu\n",
+	count, lli_array[count].physical_address, count,
+	lli_array[count].block_size);
+
+	next_kernel_address += PAGE_SIZE;
+  }
+
+  /* if more then 1 pages locked - then update for the last page size needed */
+  if (num_pages > 1) {
+	/* update the address of the last page */
+	lli_array[count].physical_address =
+	(unsigned long)virt_to_phys((unsigned long *)next_kernel_address);
+
+	/* set the size of the last page */
+	lli_array[count].block_size =
+		(kernel_virt_addr + data_size) & (~PAGE_MASK);
+
+	if (lli_array[count].block_size == 0) {
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC,
+	"app_virt_addr is %08lx\n",
+	kernel_virt_addr);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_BASIC, "data_size is %lu\n", data_size);
+	  while (1);
+	}
+
+	DEBUG_PRINT_4(SEP_DEBUG_LEVEL_EXTENDED,
+	"lli_array[%lu].physical_address is %08lx, \
+	lli_array[%lu].block_size is %lu\n",
+	count, lli_array[count].physical_address,
+	count,
+	lli_array[count].block_size);
+  }
+
+  /* set output params */
+  *lli_array_ptr = lli_array;
+  *num_pages_ptr = num_pages;
+  *page_array_ptr = 0;
+
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_lock_kernel_pages end\n");
+
+  return 0;
+}
+
+/*
+  This function releases all the application virtual buffer physical pages,
+	that were previously locked
+*/
+int sep_free_dma_pages(struct page	**page_array_ptr,
+					unsigned long num_pages,
+					unsigned long dirtyFlag)
+{
+  /* count */
+  unsigned long count;
+
+  /*-------------------
+	CODE
+  ---------------------*/
+
+  if (dirtyFlag) {
+	for (count = 0; count < num_pages; count++) {
+	  /* the out array was written, therefore the data was changed */
+	if (!PageReserved(page_array_ptr[count]))
+		SetPageDirty(page_array_ptr[count]);
+	  page_cache_release(page_array_ptr[count]);
+	}
+  } else {
+	/* free in pages - the data was only read, therefore no update was done
+		on those pages */
+	for (count = 0; count < num_pages; count++)
+	  page_cache_release(page_array_ptr[count]);
+  }
+
+  if (page_array_ptr)
+	/* free the array */
+	kfree(page_array_ptr);
+
+  return 0;
+}
+
+/*
+  This function raises interrupt to SEP that signals that is has a new
+	command from HOST
+*/
+static void sep_send_command_handler()
+{
+
+  unsigned long count;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_send_command_handler start\n");
+
+  sep_set_time(0, 0);
+
+#ifdef DX_CC52_SUPPORT
+  /* set the current caller if  - if exists */
+  sep_set_current_caller_id();
+#endif
+
+  /* flash cache */
+  flush_cache_all();
+
+  for (count = 0; count < 12 * 4; count += 4)
+	DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+	"Word %lu of the message is %lu\n",
+	count,
+	*((unsigned long *)(sep_context.shared_area_addr + count)));
+
+  /* update counter */
+  sep_context.host_to_sep_send_counter++;
+
+  /* send interrupt to SEP */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+			HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_send_command_handler end\n");
+
+  return;
+}
+
+/*
+  This function raises interrupt to SEPm that signals that is has a
+  new command from HOST
+*/
+static void sep_send_reply_command_handler()
+{
+  unsigned long count;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_send_reply_command_handler start\n");
+
+  /* flash cache */
+  flush_cache_all();
+
+  for (count = 0; count < 12 * 4; count += 4)
+	DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+	"Word %lu of the message is %lu\n",
+	count,
+	*((unsigned long *)(sep_context.shared_area_addr + count)));
+
+
+  /* update both counters counter */
+  sep_context.host_to_sep_send_counter++;
+
+  sep_context.sep_to_host_reply_counter++;
+
+  /* send the interrupt to SEP */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+				HW_HOST_HOST_SEP_GPR2_REG_ADDR,
+				sep_context.host_to_sep_send_counter);
+
+  /* update host to sep counter */
+  sep_context.host_to_sep_send_counter++;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_send_reply_command_handler end\n");
+
+  return;
+}
+
+
+
+/*
+  This function handles the allocate data pool memory request
+  This function returns calculates the physical address of the
+  allocated memory, and the offset of this area from the mapped address.
+  Therefore, the FVOs in user space can calculate the exact virtual
+  address of this allocated memory
+*/
+static int sep_allocate_data_pool_memory_handler(unsigned long arg)
+{
+  /* error */
+  int				error;
+
+  /* command paramaters */
+  struct sep_driver_alloc_t  command_args;
+
+  /*-------------------------
+	CODE
+  ----------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_allocate_data_pool_memory_handler start\n");
+
+
+  error = copy_from_user(&command_args,
+	(void *)arg,
+	sizeof(struct sep_driver_alloc_t));
+  if (error)
+	goto end_function;
+
+  /* allocate memory */
+  if (
+	(sep_context.data_pool_bytes_allocated + command_args.num_bytes) >
+	SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
+	error = -ENOTTY;
+	goto end_function;
+  }
+
+  /* set the virtual and physical address */
+  command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
+			sep_context.data_pool_bytes_allocated;
+  command_args.phys_address = sep_context.phys_shared_area_addr +
+			SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
+			sep_context.data_pool_bytes_allocated;
+
+  /* write the memory back to the user space */
+  error = copy_to_user((void *)arg,
+	(void *)&command_args,
+	sizeof(struct sep_driver_alloc_t));
+  if (error)
+	goto end_function;
+
+  /* set the allocation */
+  sep_context.data_pool_bytes_allocated += command_args.num_bytes;
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:<-------- sep_allocate_data_pool_memory_handler end\n");
+
+  return error;
+}
+
+/*
+  This function  handles write into allocated data pool command
+*/
+static int sep_write_into_data_pool_handler(unsigned long arg)
+{
+  /* error */
+  int			error;
+
+  /* virtual address */
+  unsigned long	virt_address;
+
+  /* application in address */
+  unsigned long	app_in_address;
+
+  /* number of bytes */
+  unsigned long	num_bytes;
+
+  /* address of the data pool */
+  unsigned long	data_pool_area_addr;
+
+  /*--------------------------
+	CODE
+  -----------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_write_into_data_pool_handler start\n");
+
+  /* get the application address */
+  error = get_user(app_in_address,
+		&(((struct sep_driver_write_t *)arg)->app_address));
+  if (error)
+	goto end_function;
+
+  /* get the virtual kernel address address */
+  error = get_user(virt_address,
+		&(((struct sep_driver_write_t *)arg)->datapool_address));
+  if (error)
+	goto end_function;
+
+  /* get the number of bytes */
+  error = get_user(num_bytes, &(((struct sep_driver_write_t *)arg)->num_bytes));
+  if (error)
+	goto end_function;
+
+  /* calculate the start of the data pool */
+  data_pool_area_addr = sep_context.shared_area_addr +
+			SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES;
+
+
+  /* check that the range of the virtual kernel address is correct */
+  if ((virt_address < data_pool_area_addr) ||
+	  (virt_address > (data_pool_area_addr +
+	  SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES))) {
+	error = -ENOTTY;
+	goto end_function;
+  }
+
+  /* copy the application data */
+  error = copy_from_user((void *)virt_address,
+	(void *)app_in_address,
+	num_bytes);
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_write_into_data_pool_handler end\n");
+
+  return error;
+}
+
+/*
+  this function handles the read from data pool command
+*/
+static int sep_read_from_data_pool_handler(unsigned long arg)
+{
+  /* error */
+  int			error;
+
+  /* virtual address of dest application buffer */
+  unsigned long	app_out_address;
+
+  /* virtual address of the data pool */
+  unsigned long	virt_address;
+
+  /* number bytes */
+  unsigned long	num_bytes;
+
+  /* address of the data pool */
+  unsigned long	data_pool_area_addr;
+
+  /*------------------------
+	CODE
+  -----------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_read_from_data_pool_handler start\n");
+
+  /* get the application address */
+  error = get_user(app_out_address,
+		&(((struct sep_driver_write_t *)arg)->app_address));
+  if (error)
+	goto end_function;
+
+  /* get the virtual kernel address address */
+  error = get_user(virt_address,
+	&(((struct sep_driver_write_t *)arg)->datapool_address));
+  if (error)
+	goto end_function;
+
+  /* get the number of bytes */
+  error = get_user(num_bytes, &(((struct sep_driver_write_t *)arg)->num_bytes));
+  if (error)
+	goto end_function;
+
+  /* calculate the start of the data pool */
+  data_pool_area_addr = sep_context.shared_area_addr +
+			SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES;
+
+  /* check that the range of the virtual kernel address is correct */
+  if ((virt_address < data_pool_area_addr) ||
+	  (virt_address > (data_pool_area_addr +
+	  SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES))) {
+	error = -ENOTTY;
+	goto end_function;
+  }
+
+  /* copy the application data */
+  error = copy_to_user((void *)app_out_address, (void *)virt_address,
+  num_bytes);
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_read_from_data_pool_handler end\n");
+
+  return error;
+}
+
+
+/*
+  this function handles tha request for creation of the DMA table
+  for the synchronic symmetric operations (AES,DES)
+*/
+static int sep_create_sync_dma_tables_handler(unsigned long arg)
+{
+  /* error */
+  int							error;
+
+  /* command arguments */
+  struct sep_driver_build_sync_table_t command_args;
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_create_sync_dma_tables_handler start\n");
+
+  error = copy_from_user(&command_args,
+	(void *)arg,
+	sizeof(struct sep_driver_build_sync_table_t));
+  if (error)
+	goto end_function;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"app_in_address is %08lx\n",
+	command_args.app_in_address);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"app_out_address is %08lx\n",
+	command_args.app_out_address);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"data_size is %lu\n",
+	command_args.data_in_size);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"block_size is %lu\n",
+	command_args.block_size);
+
+
+  /* check if we need to build only input table or input/output */
+  if (command_args.app_out_address)
+	/* prepare input and output tables */
+	error = sep_prepare_input_output_dma_table(command_args.app_in_address,
+					command_args.app_out_address,
+					command_args.data_in_size,
+					command_args.block_size,
+					&command_args.in_table_address,
+					&command_args.out_table_address,
+					&command_args.in_table_num_entries,
+					&command_args.out_table_num_entries,
+					&command_args.table_data_size,
+					command_args.isKernelVirtualAddress);
+  else
+	/* prepare input tables */
+	error = sep_prepare_input_dma_table(command_args.app_in_address,
+					command_args.data_in_size,
+					command_args.block_size,
+					&command_args.in_table_address,
+					&command_args.in_table_num_entries,
+					&command_args.table_data_size,
+					command_args.isKernelVirtualAddress);
+
+  if (error)
+	goto end_function;
+
+  /* copy to user */
+  error = copy_to_user((void *)arg,
+	(void *)&command_args,
+	sizeof(struct sep_driver_build_sync_table_t));
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:<-------- sep_create_sync_dma_tables_handler end\n");
+
+  return error;
+}
+
+
+/*
+  this function handles the request for freeing dma table for synhronic actions
+*/
+int sep_free_dma_table_data_handler()
+{
+  /*-------------------------
+	CODE
+  -----------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_free_dma_table_data_handler start\n");
+
+  /* free input pages array */
+  sep_free_dma_pages(sep_context.in_page_array,
+					sep_context.in_num_pages,
+					 0);
+
+  /* free output pages array if needed */
+  if (sep_context.out_page_array)
+	sep_free_dma_pages(sep_context.out_page_array,
+						sep_context.out_num_pages,
+						1);
+
+  /* reset all the values */
+  sep_context.in_page_array = 0;
+  sep_context.out_page_array = 0;
+  sep_context.in_num_pages = 0;
+  sep_context.out_num_pages = 0;
+
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_free_dma_table_data_handler end\n");
+
+  return 0;
+}
+
+
+/*
+  this function returns the physical and virtual addresses of the static pool
+*/
+static int sep_get_static_pool_addr_handler(unsigned long arg)
+{
+  /* error */
+  int							error;
+
+  /* command arguments */
+  struct sep_driver_static_pool_addr_t	command_args;
+
+  /*-----------------------------
+	CODE
+  ------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_get_static_pool_addr_handler start\n");
+
+  /*prepare the output parameters in the struct */
+  command_args.physical_static_address = sep_context.phys_shared_area_addr +
+				SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
+  command_args.virtual_static_address = sep_context.shared_area_addr +
+				SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
+
+  DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+ "SEP Driver:physical_static_address is %08lx, virtual_static_address %08lx\n",
+	command_args.physical_static_address,
+	command_args.virtual_static_address);
+
+  /* send the parameters to user application */
+  error = copy_to_user((void *)arg,
+	&command_args,
+	sizeof(struct sep_driver_static_pool_addr_t));
+  if (error)
+	goto end_function;
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_get_static_pool_addr_handler end\n");
+
+  return error;
+}
+
+/*
+  this address gets the offset of the physical address from the start
+  of the mapped area
+*/
+static int sep_get_physical_mapped_offset_handler(unsigned long arg)
+{
+  /* error */
+  int							error;
+
+  /* command arguments */
+  struct sep_driver_get_mapped_offset_t	command_args;
+
+  /*-----------------------------
+	CODE
+  ------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_get_physical_mapped_offset_handler start\n");
+
+  error = copy_from_user(&command_args,
+	(void *)arg,
+	sizeof(struct sep_driver_get_mapped_offset_t));
+  if (error)
+	goto end_function;
+
+  if (command_args.physical_address < sep_context.phys_shared_area_addr) {
+	error = -ENOTTY;
+	goto end_function;
+  }
+
+  /*prepare the output parameters in the struct */
+  command_args.offset = command_args.physical_address -
+					sep_context.phys_shared_area_addr;
+
+  DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
+  "SEP Driver:physical_address is %08lx, offset is %lu\n",
+	command_args.physical_address,
+	command_args.offset);
+
+  /* send the parameters to user application */
+  error = copy_to_user((void *)arg,
+	&command_args,
+	sizeof(struct sep_driver_get_mapped_offset_t));
+  if (error)
+	goto end_function;
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:<-------- sep_get_physical_mapped_offset_handler end\n");
+
+  return error;
+}
+
+
+/*
+  ?
+*/
+static int sep_start_handler(void)
+{
+  /* reg val */
+  unsigned long reg_val;
+
+  /* error */
+  unsigned long error;
+
+  /*-----------------------------
+	CODE
+  ------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_start_handler start\n");
+
+  error = 0;
+
+  /* wait in polling for message from SEP */
+  do {
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+			HW_HOST_SEP_HOST_GPR3_REG_ADDR, reg_val);
+  } while (!reg_val);
+
+  /* check the value */
+  if (reg_val == 0x1) {
+	/* fatal error - read erro status from GPRO */
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+				HW_HOST_SEP_HOST_GPR0_REG_ADDR, error);
+	goto end_function;
+  }
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_start_handler end\n");
+
+  return error;
+}
+
+/*
+  this function handles the request for SEP initialization
+*/
+static int sep_init_handler(unsigned long arg)
+{
+  /* word from message */
+  unsigned long	 message_word;
+
+  /* message ptr */
+  unsigned long		*message_ptr;
+
+  /* command arguments */
+  struct sep_driver_init_t command_args;
+
+  /* counter */
+  unsigned long	counter;
+
+  /* error */
+  unsigned long	error;
+
+  /* reg val */
+  unsigned long	reg_val;
+
+  /*-------------------
+	CODE
+  ---------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_init_handler start\n");
+
+  error = 0;
+
+  error = copy_from_user(&command_args, (void *)arg,
+			sizeof(struct sep_driver_init_t));
+  if (error)
+	goto end_function;
+
+  /* PATCH - configure the DMA to single -burst instead of multi-burst */
+  sep_configure_dma_burst();
+
+  message_ptr = (unsigned long *)command_args.message_addr;
+
+  /* set the base address of the SRAM  */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+					HW_SRAM_ADDR_REG_ADDR,
+					command_args.sep_sram_addr);
+
+  for (counter = 0 ;
+		counter < command_args.message_size_in_words;
+		counter++, message_ptr++) {
+	get_user(message_word, message_ptr);
+
+	/* write data to SRAM */
+	SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_SRAM_DATA_REG_ADDR,
+						message_word);
+
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+					"SEP Driver:message_word is %lu\n",
+					message_word);
+
+		/* wait for write complete */
+	SEP_WAIT_SRAM_WRITE_COMPLETE();
+  }
+
+  /* signal SEP */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+					HW_HOST_HOST_SEP_GPR0_REG_ADDR,
+					0x1);
+
+  do {
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+			HW_HOST_SEP_HOST_GPR3_REG_ADDR, reg_val);
+  } while (!(reg_val & 0xFFFFFFFD));
+
+  /* check the value */
+  if (reg_val == 0x1) {
+	DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
+		"SEP Driver:init failed\n");
+
+	SEP_READ_REGISTER(sep_context.reg_base_address + 0x8060, error);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+			"SEP Driver:sw monitor is %lu\n",
+			error);
+
+	/* fatal error - read erro status from GPRO */
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+				HW_HOST_SEP_HOST_GPR0_REG_ADDR,
+				error);
+	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+			"SEP Driver:error is %lu\n", error);
+	goto end_function;
+  }
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_init_handler end\n");
+
+  return error;
+
+}
+
+/*
+  this function handles the request cache and resident reallocation
+*/
+static int sep_realloc_cache_resident_handler(unsigned long arg)
+{
+  /* error */
+  int			        error;
+
+  /* reg val */
+  unsigned long       reg_val;
+
+  /* physical cache addr */
+  unsigned long		phys_cache_address;
+
+  /* physical resident addr */
+  unsigned long		phys_resident_address;
+
+  /* physical d-cache addr */
+  unsigned long        phys_dcache_address;
+
+  /* command arguments */
+  struct sep_driver_realloc_cache_resident_t command_args;
+
+  /*------------------
+	CODE
+  ---------------------*/
+
+  /* check if SEP already initialized */
+  SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_HOST_GPR3_REG_ADDR ,
+					reg_val);
+
+  /* check old boot finished or warm boot finished or cold-warm boot finished */
+  if ((reg_val == 0x4) ||
+      (reg_val == 0x8) ||
+      (reg_val == 0x10)) {
+      error =  SEP_ALREADY_INITIALIZED_ERR;
+      goto end_function;
+  }
+
+  /* copy the data */
+  error = copy_from_user(&command_args,
+			(void *)arg,
+			sizeof(struct sep_driver_realloc_cache_resident_t));
+  if (error)
+	goto end_function;
+
+  /* copy cache and resident to the their intended locations */
+  error = sep_copy_cache_resident_to_area(command_args.cache_addr,
+				command_args.cache_size_in_bytes,
+				command_args.resident_addr,
+				command_args.resident_size_in_bytes,
+				command_args.dcache_size_in_bytes,
+				&phys_cache_address,
+				&phys_resident_address,
+				&phys_dcache_address);
+  if (error)
+	goto end_function;
+
+#if SEP_DRIVER_LOCK_RAR_MODE
+
+  error = sep_copy_ext_cache_to_area(command_args.extcache_addr,
+				command_args.extcache_size_in_bytes,
+				0);
+
+  if (error)
+    goto end_function;
+
+
+#endif
+
+  /* lock the area (if needed) */
+  sep_lock_cache_resident_area();
+
+  command_args.new_base_addr = sep_context.phys_shared_area_addr;
+
+  /* find the new base address according to the lowest address between
+	cache, resident and shared area */
+  if (phys_resident_address < command_args.new_base_addr)
+	    command_args.new_base_addr = phys_resident_address;
+
+  if (phys_cache_address < command_args.new_base_addr)
+	    command_args.new_base_addr = phys_cache_address;
+
+  if (phys_dcache_address < command_args.new_base_addr)
+		command_args.new_base_addr = phys_dcache_address;
+
+  /* set the return parameters */
+  command_args.new_cache_addr = phys_cache_address;
+  command_args.new_resident_addr = phys_resident_address;
+  command_args.new_dcache_addr = phys_dcache_address;
+
+
+  /* set the new shared area */
+  command_args.new_shared_area_addr = sep_context.phys_shared_area_addr;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:command_args.new_shared_area_addr is %08lx\n",
+	command_args.new_shared_area_addr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:command_args.new_base_addr is %08lx\n",
+	command_args.new_base_addr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:command_args.new_resident_addr is %08lx\n",
+	command_args.new_resident_addr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+	"SEP Driver:command_args.new_cache_addr is %08lx\n",
+	command_args.new_cache_addr);
+
+  /* return to user */
+  error = copy_to_user((void *)arg,
+	(void *)&command_args,
+	sizeof(struct sep_driver_realloc_cache_resident_t));
+
+end_function:
+
+  return error;
+}
+
+
+
+/*
+  this function handles the request for get time
+*/
+static int sep_get_time_handler(unsigned long arg)
+{
+  /* error */
+  int error;
+
+  /* command arguments */
+  struct sep_driver_get_time_t	command_args;
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  error = sep_set_time(&command_args.time_physical_address,
+			&command_args.time_value);
+
+  /* return to user */
+  error = copy_to_user((void *)arg,
+	(void *)&command_args,
+	sizeof(struct sep_driver_get_time_t));
+
+  return error;
+
+}
+
+
+/*
+  This function will retrieve the RAR buffer physical addresses, type
+  and size corresponding to the RAR handles provided in the buffers vector.
+*/
+static int sep_rar_prepare_output_msg_handler(unsigned long arg)
+{
+  /* error return code */
+  int error;
+
+  struct RAR_buffer command_args;
+
+  /* holds the RAR address in the system memory offset */
+  unsigned long rar_addr;
+
+  /*------------------
+	CODE
+  ---------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:--------> sep_rar_prepare_output_msg_handler start\n");
+
+  /* copy the data */
+  error = copy_from_user(&command_args,
+	(void *)arg,
+	sizeof(struct RAR_buffer));
+  if (error)
+	goto end_function;
+
+#ifdef DX_RAR_SUPPORT
+  /* call to the RAR kernel module API */
+  error = rar_handle_to_buf(&command_args, 1);
+  if (error)
+    goto end_function;
+
+#ifdef DX_DEBUG_RAR_SUPPORT
+   command_args.physical_address = 0x82002000;
+   g_rar_handle_virt = (unsigned long)command_args.info.handle;
+   memset((unsigned long *)(sep_context.shared_area_addr +
+				SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES),
+				0,
+				0x1000);
+#endif /* DX_DEBUG_RAR_SUPPORT */
+
+#else
+  command_args.info.handle = 0x0;
+  command_args.bus_address = 0x0;
+  g_rar_handle_virt = 0x0;
+#endif
+
+  /* set value in the SYSTEM MEMORY offset */
+  rar_addr = sep_context.shared_area_addr +
+			 SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES;
+
+  /* copy the physical address to the System Area.
+     The SEP will follow this address */
+  *(unsigned long *)rar_addr = SEP_RAR_VAL_TOKEN;
+  *(unsigned long *)(rar_addr + sizeof(unsigned long)) =
+				command_args.bus_address;
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+	"SEP Driver:<-------- sep_rar_prepare_output_msg_handler end\n");
+
+  return error;
+}
+
+/*
+  This api handles the setting of API mode to blocking or non-blocking
+*/
+static int sep_set_api_mode_handler(unsigned long arg)
+{
+  /* error */
+  int			error;
+
+  /* flag */
+  unsigned long mode_flag;
+
+  /*----------------------------
+	CODE
+  -----------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_set_api_mode_handler start\n");
+
+  error = get_user(
+	  mode_flag, &(((struct sep_driver_set_api_mode_t *)arg)->mode));
+  if (error)
+	goto end_function;
+
+  /* set the global flag */
+  sep_context.block_mode_flag = mode_flag;
+
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_set_api_mode_handler end\n");
+
+  return error;
+}
+
+/*
+  This API handles the end transaction request
+*/
+static int sep_end_transaction_handler(unsigned long arg)
+{
+  /*----------------------------
+	CODE
+  -----------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_end_transaction_handler start\n");
+
+#if 0/*!SEP_DRIVER_POLLING_MODE*/
+  /* close IMR */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address + HW_HOST_IMR_REG_ADDR, 0x7FFF);
+
+  /* release IRQ line */
+  free_irq(SEP_DIRVER_IRQ_NUM, &sep_context.reg_base_address);
+
+  /* unlock the sep mutex */
+  mutex_unlock(&sep_mutex);
+#endif
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_end_transaction_handler end\n");
+
+  return 0;
+}
+
+
+/*
+  calculates time and sets it at the predefined address
+*/
+static int sep_set_time(unsigned long		*address_ptr,
+			unsigned long		*time_in_sec_ptr)
+{
+  /*  time struct */
+  struct timeval  time;
+
+  /* address of time in the kernel */
+  unsigned long	time_addr;
+
+
+  /*------------------------
+	CODE
+  --------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:--------> sep_set_time start\n");
+
+
+  do_gettimeofday(&time);
+
+  /* set value in the SYSTEM MEMORY offset */
+  time_addr = sep_context.shared_area_addr +
+			SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
+
+  *(unsigned long *)time_addr = SEP_TIME_VAL_TOKEN;
+  *(unsigned long *)(time_addr + 4) = time.tv_sec;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+			"SEP Driver:time.tv_sec is %lu\n",
+			time.tv_sec);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+			"SEP Driver:time_addr is %lu\n",
+			time_addr);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
+			"SEP Driver:g_sep_shared_area_addr is %lu\n",
+			sep_context.shared_area_addr);
+
+  /* set the output parameters if needed */
+  if (address_ptr)
+	*address_ptr = sep_shared_area_virt_to_phys(time_addr);
+
+  if (time_in_sec_ptr)
+	*time_in_sec_ptr = time.tv_sec;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC,
+		"SEP Driver:<-------- sep_set_time end\n");
+
+  return 0;
+}
+
+/*
+  PATCH for configuring the DMA to single burst instead of multi-burst
+*/
+static void sep_configure_dma_burst(void)
+{
+
+#define 	 HW_AHB_RD_WR_BURSTS_REG_ADDR 		 0x0E10UL
+
+  unsigned long	regVal;
+
+  /* request access to registers from SEP */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+					HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2UL);
+
+  SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_BUSY_REG_ADDR, regVal);
+  while (regVal)
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_BUSY_REG_ADDR, regVal);
+
+  /* set the DMA burst register to single burst*/
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+					HW_AHB_RD_WR_BURSTS_REG_ADDR, 0x0UL);
+
+  /* release the sep busy */
+  SEP_WRITE_REGISTER(sep_context.reg_base_address +
+					HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x0UL);
+  SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_BUSY_REG_ADDR, regVal);
+  while (regVal != 0x0)
+	SEP_READ_REGISTER(sep_context.reg_base_address +
+					HW_HOST_SEP_BUSY_REG_ADDR, regVal);
+}
+
+
+#ifdef DX_CC52_SUPPORT
+/*
+   open function for the singleton driver
+*/
+static int sep_singleton_open(struct inode *inode_ptr , struct file *file_ptr)
+{
+  /* return value */
+  int             error;
+
+  /*-----------------
+    CODE
+  ---------------------*/
+
+  error = 0;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:--------> sep_singleton_open start\n");
+
+  if (g_singleton_access_flag) {
+    DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:trybing to access singleton more then once");
+    error = -ENODEV;
+
+    goto end_function;
+  }
+
+  sep_context.singleton_access_flag = 1;
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:<-------- sep_singleton_open end\n");
+
+  return error;
+}
+
+/*
+  singleton ioctl
+*/
+static int sep_singleton_ioctl(struct inode *inode,
+							struct file  *filp,
+							unsigned int    cmd,
+							unsigned long   arg)
+{
+
+  /* error */
+  int             error;
+
+  /*------------------------
+    CODE
+  ------------------------*/
+  error = 0;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"------------>SEP Driver: sep_singleton_ioctl start\n");
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED , "SEP Driver: cmd is %x\n" , cmd);
+
+  /* check that the command is for sep device */
+  if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
+	error =  -ENOTTY;
+
+
+	switch (cmd) {
+	case SEP_IOCTLSINGLETONLOCK:
+
+      error = sep_singleton_lock_handler();
+
+      break;
+
+	case SEP_IOCTLSETCALLERID:
+
+      error = sep_set_caller_id_handler(arg);
+
+      break;
+
+	default:
+
+      error = sep_ioctl(inode , filp , cmd , arg);
+
+      break;
+  }
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:<-------- sep_singleton_ioctl end\n");
+
+  return error;
+}
+
+/*
+  initializes the caller id functionality
+*/
+static int sep_init_caller_id(void)
+{
+  /* return value */
+  int   ret_val;
+
+  /* counter */
+  int   counter;
+
+  struct cb_id caller_id;
+
+
+  /*----------------------------
+      CODE
+  ---------------------------------*/
+
+  ret_val = 0;
+
+  /* init cb_id struct */
+  caller_id.idx = CN_IDX_PROC;
+  caller_id.val = CN_VAL_PROC;
+
+  /* init caller id table */
+  for (counter = 0; counter < SEP_CALLER_ID_TABLE_NUM_ENTRIES; counter++)
+	g_caller_id_table[counter].pid = 0;
+
+
+  /* init access flag */
+  g_singleton_access_flag = 0;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED ,
+		"SEP Driver: caller id table init finished \n");
+
+  /* register to netlink connector */
+  /*ret_val = cn_add_callback(&caller_id, "sep_caller_id", &sep_cn_callback);*/
+
+
+  return ret_val;
+}
+
+/*
+  callback for the netlink connector registration
+*/
+static void sep_cn_callback(void *data)
+{
+  /* counter */
+  int                 counter;
+
+  /* message */
+  struct cn_msg	*msg;
+
+  /* event */
+  struct proc_event	*ev;
+
+  /* process id */
+  int                 pid;
+
+  /*--------------------
+      CODE
+  ----------------------*/
+
+  msg = data;
+
+  /* get the proc event pointer */
+  ev = (struct proc_event *)msg->data;
+
+  /* check the event */
+	switch (ev->what) {
+	case PROC_EVENT_EXEC:
+
+      /* get the pid */
+      pid = ev->event_data.exec.process_pid;
+
+      break;
+
+	case PROC_EVENT_EXIT:
+
+      /* get the pid */
+      pid = ev->event_data.exit.process_pid;
+
+      break;
+
+	default:
+      /* not interested in the rest of the events */
+      goto end_function;
+  }
+
+  /* check if the pid is relevant */
+  for (counter = 0; counter < SEP_CALLER_ID_TABLE_NUM_ENTRIES; counter++) {
+    /* if the pid is found - remove it from the table */
+    if (g_caller_id_table[counter].pid == pid)
+		g_caller_id_table[counter].pid = 0;
+
+  }
+
+
+end_function:
+
+  return;
+}
+
+/*
+  this function handles the request for ext(3rd party)cache reallocation
+*/
+static int sep_realloc_ext_cache_handler(unsigned long arg)
+{
+  /* error */
+  int                                 error;
+
+  /* physical ext cache addr */
+  unsigned long                       phys_ext_cache_address;
+
+  /* command arguments */
+  struct sep_driver_realloc_ext_cache_t      command_args;
+
+  /*------------------
+      CODE
+  ---------------------*/
+
+  /* copy the data */
+  error = copy_from_user(&command_args ,
+				(void *)arg ,
+				sizeof(struct sep_driver_realloc_ext_cache_t));
+  if (error)
+	goto end_function;
+
+
+#if SEP_DRIVER_LOCK_RAR_MODE
+
+  /* if we are in RAR mode - then the ext cache was already copied
+  and we just need to receive back its' physical address */
+  command_args.ext_cache_size_in_bytes = 0;
+
+#endif
+  /* copy cache and resident to the their intended locations */
+  error = sep_copy_ext_cache_to_area(command_args.ext_cache_addr,
+					command_args.ext_cache_size_in_bytes,
+					&phys_ext_cache_address);
+  if (error)
+	goto end_function;
+
+
+
+  command_args.new_ext_cache_addr = phys_ext_cache_address;
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED ,
+		"SEP Driver:command_args.new_ext_cache_addr is %lu\n",
+		command_args.new_ext_cache_addr);
+
+  /* return to user */
+  error = copy_to_user((void *)arg ,
+				(void *)&command_args ,
+				sizeof(struct sep_driver_realloc_ext_cache_t));
+
+end_function:
+
+  return error;
+}
+
+/*
+  this function handles the request from signleton to lock access
+*/
+static int sep_singleton_lock_handler(void)
+{
+  /* error */
+  int error;
+
+  /*--------------------
+      CODE
+  ----------------------*/
+
+  error = 0;
+    /* lock mutex */
+  mutex_lock(&sep_mutex);
+
+  return error;
+}
+
+/*
+  inserts the data into the caller id table
+*/
+static int sep_set_caller_id_handler(unsigned long arg)
+{
+  /* error */
+  int                         error;
+
+  /* counter */
+  int                         i;
+
+  /* command arguments */
+  struct sep_driver_set_caller_id_t  command_args;
+
+  /*----------------------------
+      CODE
+  ------------------------------*/
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:--------> sep_set_caller_id_handler start\n");
+
+  error = 0;
+
+  for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
+    if (g_caller_id_table[i].pid == 0)
+		break;
+  }
+
+  if (i == SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
+    DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED ,
+		"SEP Driver:i == SEP_CALLER_ID_TABLE_NUM_ENTRIES\n");
+    error = -ENOMEM;
+    goto end_function;
+  }
+
+  /* copy the data */
+  error = copy_from_user(&command_args ,
+				(void *)arg ,
+				sizeof(struct sep_driver_set_caller_id_t));
+  if (error) {
+    DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED ,
+		"SEP Driver:copy_from_user failed\n");
+    goto end_function;
+  }
+
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED ,
+				"SEP Driver:pid is %lu\n" ,
+				command_args.pid);
+  DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED ,
+				"SEP Driver:callerIdSizeInBytes is %lu\n" ,
+				command_args.callerIdSizeInBytes);
+
+  g_caller_id_table[i].pid = command_args.pid;
+
+  if (command_args.callerIdSizeInBytes > SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {
+    error = -EINVAL;
+    goto end_function;
+  }
+
+  error = copy_from_user(g_caller_id_table[i].callerIdHash ,
+				(void *)command_args.callerIdAddress ,
+				command_args.callerIdSizeInBytes);
+
+end_function:
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+			"SEP Driver:<-------- sep_set_caller_id_handler end\n");
+
+  return error;
+}
+
+/*
+  set the caller id (if exists) of the current process that send request to SeP
+*/
+static int sep_set_current_caller_id(void)
+{
+ int i;
+
+  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:--------> sep_set_current_caller_id start\n");
+
+ DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED ,
+		"current process is %d\n", current->pid);
+
+ for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
+	if (g_caller_id_table[i].pid == current->pid) {
+		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED ,
+				"Caller Id found \n");
+
+		memcpy((void *)(g_sep_shared_area_addr +
+			SEP_DRIVER_SYSTEM_CALLER_ID_MEMORY_OFFSET_IN_BYTES),
+			(void *)(g_caller_id_table[i].callerIdHash) ,
+			SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
+    break;
+  }
+ }
+
+ DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC ,
+		"SEP Driver:<-------- sep_set_current_caller_id end\n");
+
+ return 0;
+
+}
+
+
+#endif /*DX_CC52_SUPPORT*/
+
+module_init(sep_init);
+module_exit(sep_exit);
+
+MODULE_LICENSE("GPL");

