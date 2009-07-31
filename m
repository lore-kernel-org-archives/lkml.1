Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZGaXNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZGaXNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 19:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZGaXNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 19:13:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:16880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZGaXNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 19:13:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,304,1246863600"; 
   d="scan'208";a="479759792"
From: Ossama Othman <ossama.othman@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ossama Othman <ossama.othman@intel.com>
Subject: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Date: Fri, 31 Jul 2009 16:20:19 -0700
Message-Id: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver implements an allocator interface for Moorestown
restricted access regions (RAR), which are regions of RAM that are
inaccessible by the CPU when locked down.  It is implemented in the
kernel space since both user space applications and kernel drivers
will be allocating buffers in Moorestown RARs.

The canonical kernel allocators (slab, etc) are not used since they
are too tightly coupled with paging.  The CPU will not be accessing
the memory, meaning an allocation mechanism that does not place
metadata in the RAR memory area in question was needed.  The simple
allocator included in this patch satisfies my needs.  However, I was
recently made aware of the existence of the lib/genalloc.c allocator.
It appears promising in terms of the RAR handler driver needs, so I
may use it instead.

Work is still ongoing with this driver so I appreciate any
constructive feedback regarding the implementation, particularly with
respect to the allocator (or alternatives) since it is a critical part
of the functionality.  Thanks!!

Note this driver depends on the (previously submitted) Moorestown
rar_register driver (RAR_REGISTER).

Signed-off-by: Ossama Othman <ossama.othman@intel.com>
---
 drivers/misc/Kconfig            |   12 +
 drivers/misc/Makefile           |    2 +
 drivers/misc/memrar_allocator.c |  337 ++++++++++++++++++++
 drivers/misc/memrar_allocator.h |  162 ++++++++++
 drivers/misc/memrar_handler.c   |  669 +++++++++++++++++++++++++++++++++++++++
 include/linux/rar/memrar.h      |  172 ++++++++++
 kernel-mrst-alpha2.config       |    8 +-
 7 files changed, 1361 insertions(+), 1 deletions(-)
 create mode 100644 drivers/misc/memrar_allocator.c
 create mode 100644 drivers/misc/memrar_allocator.h
 create mode 100644 drivers/misc/memrar_handler.c
 create mode 100644 include/linux/rar/memrar.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b9e5010..3e36269 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -150,6 +150,18 @@ config ATMEL_SSC
 
 	  If unsure, say N.
 
+config MRST_RAR_HANDLER
+	tristate "RAR handler driver for Intel Moorestown platform"
+	depends on X86
+	select RAR_REGISTER
+	default n
+	---help---
+	  This driver provides a memory management interface to
+	  restricted access regions available in the Intel Moorestown
+	  platform.
+
+	  If unsure, say N.
+
 config MRST_VIB
 	tristate "vibrator driver for Intel Moorestown platform"
 	help
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 0238835..a69bc26 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -14,6 +14,8 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_MSTWN_POWER_MGMT)	+= moorestown/
+obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar.o
+memrar-objs			:= memrar_allocator.o memrar_handler.o
 obj-$(CONFIG_MRST_VIB)		+= mrst_vib.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
diff --git a/drivers/misc/memrar_allocator.c b/drivers/misc/memrar_allocator.c
new file mode 100644
index 0000000..5826cf4
--- /dev/null
+++ b/drivers/misc/memrar_allocator.c
@@ -0,0 +1,337 @@
+/*
+ *      memrar_allocator 0.1:  An allocator for Intel RAR.
+ *
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ *
+ *  ------------------------------------------------------------------
+ *
+ *      This simple allocator implementation provides a
+ *      malloc()/free()-like interface for reserving space within a
+ *      previously reserved block of memory.  It is not specific to
+ *      any hardware, nor is it coupled with the lower level paging
+ *      mechanism.
+ *
+ *      The primary goal of this implementation is to provide a means
+ *      to partition an arbitrary block of memory without actually
+ *      accessing the memory or incurring any hardware side-effects
+ *      (e.g. paging).  It is, in effect, a bookkeeping mechanism for
+ *      buffers.
+ */
+
+
+#include "memrar_allocator.h"
+#include <linux/slab.h>
+#include <linux/bug.h>
+
+
+struct memrar_allocator *memrar_create_allocator(unsigned long base,
+						 size_t capacity,
+						 size_t block_size)
+{
+	struct memrar_allocator *allocator = 0;
+
+	/* Validate parameters. */
+	if (/*
+	     * Make sure we can allocate the entire memory allocator
+	     * space.
+	     */
+		ULONG_MAX - capacity >= base
+
+		/* Zero capacity or block size are obviously invalid. */
+		&& capacity != 0
+		&& block_size != 0) {
+		/*
+		 * There isn't much point in creating a memory
+		 * allocator that is only capable of holding one block
+		 * but we'll allow, and issue a diagnostic.
+		 */
+		WARN(capacity < block_size * 2,
+		     "Memory allocator is only large enough to "
+		     "hold one block.\n");
+
+		allocator = kmalloc(sizeof(*allocator), GFP_KERNEL);
+
+		if (allocator != 0) {
+			struct memrar_free_list *first_node;
+;
+			mutex_init(&allocator->lock);
+			allocator->base = base;
+
+			/*
+			 * Round down the capacity to a multiple of
+			 * block_size.
+			 */
+			allocator->capacity =
+				(capacity / block_size) * block_size;
+
+			allocator->block_size = block_size;
+
+			allocator->largest_free_area =
+				allocator->capacity;
+
+			if (allocator->capacity != capacity)
+				pr_info("RAR memory allocator capacity "
+					"rounded down from %u to %u\n",
+					capacity,
+					allocator->capacity);
+
+			/* Initialize the free list. */
+			INIT_LIST_HEAD(&allocator->free_list.list);
+
+			first_node =
+				kmalloc(sizeof(*first_node), GFP_KERNEL);
+			if (first_node != 0) {
+				/* Full range of blocks is available. */
+				first_node->begin = base;
+				first_node->end =
+					base + allocator->capacity;
+				list_add(&first_node->list,
+					 &allocator->free_list.list);
+			} else {
+				kfree(allocator);
+				allocator = 0;
+			}
+		}
+	}
+
+	return allocator;
+}
+
+void memrar_destroy_allocator(struct memrar_allocator *allocator)
+{
+	/*
+	 * Assume that the memory allocator lock isn't held at this
+	 * point in time.  Caller must ensure that.
+	 */
+
+	struct memrar_free_list *pos;
+	struct memrar_free_list *n;
+
+	if (allocator == 0)
+		return;
+
+	mutex_lock(&allocator->lock);
+
+	/* Reclaim free list resources. */
+	list_for_each_entry_safe_reverse(pos,
+					 n,
+					 &allocator->free_list.list,
+					 list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+
+	mutex_unlock(&allocator->lock);
+
+	kfree(allocator);
+}
+
+struct memrar_handle *memrar_allocator_alloc(
+	struct memrar_allocator *allocator,
+	size_t size)
+{
+	struct memrar_free_list *pos = 0;
+	struct memrar_handle *handle = 0;
+
+	size_t num_blocks;
+	unsigned long reserved_bytes;
+
+	if (allocator == 0)
+		goto exit_memrar_alloc;
+
+	/* Reserve enough blocks to hold the amount of bytes requested. */
+	num_blocks =
+		(size + allocator->block_size - 1) / allocator->block_size;
+
+	reserved_bytes = num_blocks * allocator->block_size;
+
+	mutex_lock(&allocator->lock);
+
+	if (reserved_bytes > allocator->largest_free_area)
+		goto exit_memrar_alloc;
+
+	/*
+	 * Iterate through the free list to find a suitably sized
+	 * range of free contiguous memory blocks.
+	 */
+	list_for_each_entry(pos, &allocator->free_list.list, list) {
+		size_t const curr_size = pos->end - pos->begin;
+
+		if (curr_size >= reserved_bytes) {
+			handle = kmalloc(sizeof(*handle), GFP_KERNEL);
+
+			if (handle == 0)
+				goto exit_memrar_alloc;
+
+			handle->allocator  = allocator;
+			handle->end   = pos->end;
+			pos->end     -= reserved_bytes;
+			handle->begin = pos->end;
+
+			if (curr_size == allocator->largest_free_area)
+				allocator->largest_free_area -=
+					reserved_bytes;
+
+			break;
+		}
+	}
+
+exit_memrar_alloc:
+
+	if (allocator != 0)
+		mutex_unlock(&allocator->lock);
+
+	return handle;
+}
+
+int memrar_allocator_free(struct memrar_handle *handle)
+{
+	struct list_head *pos = 0;
+	struct list_head *tmp = 0;
+	struct memrar_free_list *new_node = 0;
+	struct memrar_allocator *allocator = 0;
+	int result = -1;
+
+	if (handle == 0)
+		goto exit_memrar_free;  /* Ignore free(0). */
+
+	allocator = handle->allocator;
+
+	mutex_lock(&allocator->lock);
+
+	/*
+	 * Coalesce adjacent chunks of memory if possible.
+	 *
+	 * @note This isn't full blown coalescing since we're only
+	 *       coalescing at most three chunks of memory.
+	 */
+	list_for_each_safe(pos, tmp, &allocator->free_list.list) {
+		/* @todo O(n) performance.  Optimize. */
+
+		struct memrar_free_list *const chunk =
+			list_entry(pos,
+				   struct memrar_free_list,
+				   list);
+
+		struct memrar_free_list *const next =
+			list_entry(pos->next,
+				   struct memrar_free_list,
+				   list);
+
+		/* Extend size of existing free adjacent chunk. */
+		if (chunk->end == handle->begin) {
+			/*
+			 * Chunk "less than" than the one we're
+			 * freeing is adjacent.
+			 */
+
+			unsigned long new_chunk_size;
+
+			chunk->end = handle->end;
+
+			/*
+			 * Now check if next free chunk is adjacent to
+			 * the current extended free chunk.
+			 */
+			if (pos != pos->next
+			    && chunk->end == next->begin) {
+				chunk->end = next->end;
+				list_del(pos->next);
+				kfree(next);
+			}
+
+			new_chunk_size = chunk->end - chunk->begin;
+
+			if (new_chunk_size > allocator->largest_free_area)
+				allocator->largest_free_area =
+					new_chunk_size;
+
+			result = 0;
+			goto exit_memrar_free;
+		} else if (chunk->begin == handle->end)	{
+			/*
+			 * Chunk "greater than" than the one we're
+			 * freeing is adjacent.
+			 */
+
+			unsigned long new_chunk_size;
+
+			chunk->begin = handle->begin;
+
+			/*
+			 * Now check if next free chunk is adjacent to
+			 * the current extended free chunk.
+			 */
+			if (pos != pos->next
+			    && chunk->begin == next->end) {
+				chunk->begin = next->begin;
+				list_del(pos->next);
+				kfree(next);
+			}
+
+			new_chunk_size = chunk->end - chunk->begin;
+
+			if (new_chunk_size > allocator->largest_free_area)
+				allocator->largest_free_area =
+					new_chunk_size;
+
+			result = 0;
+			goto exit_memrar_free;
+		}
+	}
+
+	/*
+	 * Memory being freed is not adjacent to existing free areas
+	 * of memory in the allocator.  Add a new item to the free list.
+	 */
+	new_node = kmalloc(sizeof(*new_node), GFP_KERNEL);
+	if (new_node != 0) {
+		unsigned long new_chunk_size;
+
+		new_node->begin = handle->begin;
+		new_node->end = handle->end;
+		list_add(&new_node->list,
+			 &allocator->free_list.list);
+
+		new_chunk_size = handle->end - handle->begin;
+
+		if (new_chunk_size > allocator->largest_free_area)
+			allocator->largest_free_area =
+				new_chunk_size;
+
+		result = 0;
+	}
+
+exit_memrar_free:
+
+	if (allocator != 0)
+		mutex_unlock(&allocator->lock);
+
+	kfree(handle);
+
+	return result;
+}
+
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/drivers/misc/memrar_allocator.h b/drivers/misc/memrar_allocator.h
new file mode 100644
index 0000000..cc6e0fa
--- /dev/null
+++ b/drivers/misc/memrar_allocator.h
@@ -0,0 +1,162 @@
+/*
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ */
+
+#ifndef MEMRAR_ALLOCATOR_H
+#define MEMRAR_ALLOCATOR_H
+
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+/*
+ * @struct memrar_free_list
+ *
+ * @brief List of available areas of memory.
+ */
+struct memrar_free_list {
+	/* Linked list of free memory allocator blocks. */
+	struct list_head list;
+
+	/* Beginning of available address range. */
+	unsigned long begin;
+
+	/*
+	 * End of available address range, one past the end,
+	 * i.e. [begin, end).
+	 */
+	unsigned long end;
+};
+
+/*
+ * @struct memrar_allocator
+ *
+ * @brief Encapsulation of the memory allocator state.
+ *
+ * This structure contains all memory allocator state, including the
+ * base address, capacity, free list, lock, etc.
+ */
+struct memrar_allocator {
+	/*
+	 * Lock used to synchronize access to the memory allocator
+	 * state.
+	 */
+	struct mutex lock;
+
+	/* Base (start) address of the memory allocator. */
+	unsigned long base;
+
+	/* Size of the memory allocator in bytes. */
+	size_t capacity;
+
+	/*
+	 * The size in bytes of individual blocks within the memory
+	 * allocator.
+	 */
+	size_t block_size;
+
+	/* Largest free area of memory in the allocator in bytes. */
+	size_t largest_free_area;
+
+	struct memrar_free_list free_list;
+};
+
+struct memrar_handle {
+	/*
+	 * Allocator from which the memory associated with this handle
+	 * was allocated.
+	 */
+	struct memrar_allocator *allocator;
+
+	/* Beginning of available address range. */
+	unsigned long begin;
+
+	/*
+	 * End of available address range, one past the end,
+	 * i.e. [begin, end).
+	 */
+	unsigned long end;
+};
+
+/*
+ * @function memrar_create_allocator
+ *
+ * @brief Create a memory allocator.
+ *
+ * Create a memory allocator with the given capacity and block size.
+ * The capacity will be reduced to be a multiple of the block size, if
+ * necessary.
+ *
+ * @param base       Address at which the memory allocator begins.
+ * @param capacity   Desired size of the memory allocator.  This value
+ *                   must be larger than the block_size, ideally more
+ *                   than twice as large since there wouldn't be much
+ *                   point in using a memory allocator otherwise.
+ * @param block_size The size of individual blocks within the memory
+ *                   allocator.  This value must smaller than the
+ *                   capacity.
+ * @return An instance of the memory allocator, if creation succeeds.
+ * @return Zero if creation fails.  Failure may occur if not enough
+ *         kernel memory exists to create the memrar_allocator
+ *         instance itself, or if the capacity and block_size
+ *         arguments are not compatible or make sense.
+ */
+struct memrar_allocator *memrar_create_allocator(unsigned long base,
+						 size_t capacity,
+						 size_t block_size);
+
+/*
+ * Reclaim resources held by the memory allocator.  The caller must
+ * explicitly free all memory reserved by memrar_allocator_alloc()
+ * prior to calling this function.  Otherwise leaks will occur.
+ */
+void memrar_destroy_allocator(struct memrar_allocator *allocator);
+
+/*
+ * Reserve chunk of memory of given size in the memory allocator.
+ */
+struct memrar_handle *memrar_allocator_alloc(
+	struct memrar_allocator *allocator,
+	size_t size);
+
+/*
+ * Reserve chunk of memory of given size in the memory allocator.
+ */
+int memrar_allocator_free(struct memrar_handle *handle);
+
+/*
+ * Retrived address from given handle.
+ *
+ * @return Address corresponding to given handle.  ULONG_MAX if handle
+ *         is invalid.
+ */
+static inline unsigned long memrar_get_address(struct memrar_handle *handle)
+{
+  return handle == 0 ? ULONG_MAX : handle->begin;
+}
+
+#endif  /* MEMRAR_ALLOCATOR_H */
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/drivers/misc/memrar_handler.c b/drivers/misc/memrar_handler.c
new file mode 100644
index 0000000..446b57c
--- /dev/null
+++ b/drivers/misc/memrar_handler.c
@@ -0,0 +1,669 @@
+/*
+ *      memrar_handler 1.0:  An Intel restricted access region handler device
+ *
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ * -------------------------------------------------------------------
+ *
+ *      Moorestown restricted access regions (RAR) provide isolated
+ *      areas of main memory that are only acceessible by authorized
+ *      devices.
+ *
+ *      The Intel Moorestown RAR handler module exposes a kernel space
+ *      RAR memory management mechanism.  It is essentially a
+ *      RAR-specific allocator.
+ *
+ *      Besides providing RAR buffer management, the RAR handler also
+ *      behaves in many ways like an OS virtual memory manager.  For
+ *      example, the RAR "handles" created by the RAR handler are
+ *      analogous to user space virtual addresses.
+ *
+ *      RAR memory itself is never accessed directly by the RAR
+ *      handler.
+ */
+
+
+#include "memrar_allocator.h"
+
+#include <linux/rar/memrar.h>
+#include <linux/rar/rar_register.h>
+
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <linux/mutex.h>
+#include <linux/device.h>  /* For device debugging macros. */
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+
+
+#define MEMRAR_VER "1.0"
+
+/*
+ * Moorestown supports three restricted access regions.
+ *
+ * We only care about the first two, video and audio.  The third,
+ * reserved for Chaabi and the P-unit, will be handled by their
+ * respective drivers.
+ */
+#define MRST_NUM_RAR 2
+
+/* ---------------- -------------------- ------------------- */
+
+#define mrdbg(format, messg...) dev_dbg(mrdev, format, messg);
+
+
+/* Lock used to synchronize access to global memrar data structures. */
+static DEFINE_MUTEX(memrar_mutex);
+
+/*
+ * Pointer to the underlying "device" structure.  Used mostly for
+ * debugging.
+ */
+static struct device *mrdev;
+
+/*
+ * List structure that keeps track of all RAR buffers.
+ */
+struct memrar_buffer_info {
+	/* Linked list of memrar_buffer_info objects. */
+	struct list_head list;
+
+	/* Core RAR buffer information. */
+	struct RAR_buffer buffer;
+
+	/* Reference count */
+	struct kref refcount;
+
+	/*
+	 * File handle corresponding to process that reserved the
+	 * block of memory in RAR.  This will be zero for buffers
+	 * allocated by other drivers instead of by a user space
+	 * process.
+	 */
+	struct file *owner;
+};
+
+/*
+ * Table that keeps track of all reserved RAR buffers.
+ */
+static struct memrar_buffer_info memrar_buffers;
+
+
+static struct memrar_allocator *memrar_allocators[MRST_NUM_RAR];
+
+/* ---------------- -------------------- ------------------- */
+
+/*
+ * Core block release code.
+ *
+ * @note This code removes the node from a list.  Make sure any list
+ *       iteration is performed using list_for_each_safe().
+ */
+static void memrar_release_block_i(struct kref *ref)
+{
+	/*
+	 * Last reference is being released.  Remove from the table,
+	 * and reclaim resources.
+	 */
+
+	struct memrar_buffer_info * const node =
+		container_of(ref, struct memrar_buffer_info, refcount);
+
+	struct RAR_block_info * const user_info =
+		&node->buffer.info;
+
+	list_del(&node->list);
+
+	memrar_allocator_free(user_info->handle);
+
+	kfree(node);
+}
+
+/*
+ * Initialize RAR parameters, such as bus addresses, etc.
+ */
+static int memrar_init_rar_resources(void)
+{
+	/* ---- Sanity Checks ----
+	 * 1. RAR bus addresses in both Lincroft and Langwell RAR
+	 *    registers should be the same.
+	 * 2. Secure device ID in Langwell RAR registers should be set
+	 *    appropriately, i.e. only LPE DMA for the audio RAR, and
+	 *    Chaabi for the other Langwell based RAR register.  The
+	 *    video RAR is not accessed from the Langwell side,
+	 *    meaning its corresponding Langwell RAR should only be
+	 *    accessible by Chaabi.
+	 * 3. Audio and video RAR register and RAR access should be
+	 *    locked.  If not, lock them.  There is no reason for them
+	 *    to be unlocked, meaning both the register and
+	 *    corresponding region can be locked in the SMIP header
+	 *    RAR fields.
+	 *
+	 * @todo Should the RAR handler driver even be aware of audio
+	 *       and video RAR settings?
+	 */
+
+	int z;
+	int found_rar = 0;
+
+	/*
+	 * Initialize the process table before we reach any code that
+	 * exit on failure since the finalization code requires an
+	 * initializer list.
+	 */
+	INIT_LIST_HEAD(&memrar_buffers.list);
+
+	for (z = 0; z != MRST_NUM_RAR; ++z) {
+		u32 low, high;
+
+		BUG_ON(z != RAR_TYPE_AUDIO && z != RAR_TYPE_VIDEO);
+
+		if (rar_get_address(z, &low, &high) != 0) {
+			/* No RAR is available. */
+			break;
+		} else if (low  == 0 || high == 0) {
+			/*
+			 * We don't immediately break out of the loop
+			 * since the next type of RAR may be enabled.
+			 */
+			memrar_allocators[z] = 0;
+			continue;
+		}
+
+		/*
+		 * @todo Verify that LNC and LNW RAR register contents
+		 *       addresses, security, etc are compatible).
+		 */
+
+		found_rar = 1;
+
+		/* Initialize corresponding memory allocator. */
+		memrar_allocators[z] = memrar_create_allocator(
+			low,
+			high - low + 1,
+			4096);  /* 4 KiB blocks */
+		if (memrar_allocators[z] == 0)
+			return -1;
+
+
+		/*
+		 * -------------------------------------------------
+		 * Make sure all RARs handled by us are locked down.
+		 * -------------------------------------------------
+		 */
+
+		/* Enable RAR protection on the Lincroft side. */
+		if (0) {
+			/* @todo Enable once LNW A2 is widely available. */
+			rar_lock(z);
+		} else {
+			WARN(1, "LNC RAR lock sanity check not performed.\n");
+		}
+
+		/* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ */
+		/* |||||||||||||||||||||||||||||||||||||||||||||||||| */
+
+		/*
+		 * Enable RAR protection on the Langwell side.
+		 *
+		 * Ideally Langwell side RAR protection should already
+		 * have been enabled by the OEM in the SMIP header but
+		 * we perform a sanity check, just in case.
+		 *
+		 * @todo Set appropriate "lock"/"valid" bits in LNW
+		 *       {LOW,UP}RAR[12] SCCB registers **and** LNW
+		 *       {LOW,UP}RAR[01] cDMI registers only if a
+		 *       suitable SDID (i.e. for security or LPE DMA)
+		 *       is set.
+		 */
+		WARN(1, "LNW RAR lock sanity check not performed.\n");
+
+
+		pr_info("BRAR[%u]\n"
+			 "\tlow  address: 0x%x\n"
+			 "\thigh address: 0x%x\n"
+			 "\tsize        : %u KiB\n",
+			 z,
+			 low,
+			 high,
+			 memrar_allocators[z]->capacity / 1024);
+	}
+
+	if (!found_rar)	{
+		/*
+		 * No RAR support.  Don't bother continuing.
+		 *
+		 * Note that this is not a failure.
+		 */
+		pr_info("memrar: No Moorestown RAR support available.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * Finalize RAR resources.
+ */
+static void memrar_fini_rar_resources(void)
+{
+	int z;
+	struct memrar_buffer_info *pos;
+	struct memrar_buffer_info *tmp;
+
+	/*
+	 * @todo Do we need to hold a lock at this point in time?
+	 *       (module initialization failure or exit?)
+	 */
+
+	/* Clean up remaining resources. */
+	list_for_each_entry_safe_reverse(pos,
+					 tmp,
+					 &memrar_buffers.list,
+					 list) {
+		kref_put(&pos->refcount, memrar_release_block_i);
+	}
+
+	/* Destroy the memory allocators. */
+	for (z = MRST_NUM_RAR; z-- != 0; ) {
+		memrar_destroy_allocator(memrar_allocators[z]);
+		memrar_allocators[z] = 0;
+	}
+}
+
+static long memrar_reserve_block(struct RAR_buffer *request,
+				 struct file *filp)
+{
+	long result = -ENOMEM;  /* Assume failure by default. */
+	struct RAR_block_info * const rinfo = &request->info;
+	struct RAR_buffer *buffer;
+	struct memrar_buffer_info *buffer_info;
+	struct memrar_handle *handle;
+	struct memrar_allocator * const allocator =
+		memrar_allocators[rinfo->type];
+
+	/* Prevent array overflow. */
+	if ((rinfo->type != RAR_TYPE_AUDIO
+	     && rinfo->type != RAR_TYPE_VIDEO)
+	    || rinfo->size > allocator->capacity)
+		goto memrar_reserve_exit;  /* -EINVAL */
+
+
+	/* Reserve memory in RAR. */
+	handle = memrar_allocator_alloc(allocator, rinfo->size);
+	if (handle == 0)
+		goto memrar_reserve_exit;
+
+	buffer_info =
+		kmalloc(sizeof(*buffer_info), GFP_KERNEL);
+
+	if (buffer_info == 0) {
+		memrar_allocator_free(handle);
+		goto memrar_reserve_exit;
+	}
+
+	buffer = &buffer_info->buffer;
+	buffer->info.type = rinfo->type;
+	buffer->info.size = rinfo->size;
+
+	/*
+	 * Memory handle corresponding to the bus address.
+	 */
+	buffer->info.handle = handle;
+	buffer->bus_address = memrar_get_address(handle);
+
+	buffer_info->owner = filp;
+	kref_init(&buffer_info->refcount);
+
+	mutex_lock(&memrar_mutex);
+	list_add(&buffer_info->list, &memrar_buffers.list);
+	mutex_unlock(&memrar_mutex);
+
+	rinfo->handle = buffer->info.handle;
+	request->bus_address = buffer->bus_address;
+
+	result = 0;  /* Success! */
+
+memrar_reserve_exit:
+
+	return result;
+}
+
+static long memrar_release_block(void *handle)
+{
+	struct memrar_buffer_info *pos;
+	struct memrar_buffer_info *tmp;
+	int result = -EINVAL;
+
+	mutex_lock(&memrar_mutex);
+
+	/*
+	 * Iterate through the buffer list to find the corresponding
+	 * buffer to be released.
+	 *
+	 * We assume that the most recently reserved buffers will
+	 * likely be the ones to be released the earliest with
+	 * optimization in mind.
+	 */
+	list_for_each_entry_safe_reverse(pos,
+					 tmp,
+					 &memrar_buffers.list,
+					 list) {
+		if (handle == pos->buffer.info.handle) {
+			kref_put(&pos->refcount, memrar_release_block_i);
+			result = 0;
+			break;
+		}
+	}
+
+	mutex_unlock(&memrar_mutex);
+
+	return result;
+}
+
+static long memrar_get_stat(struct RAR_stat *r)
+{
+	long result = -EINVAL;
+
+	if (r->type < ARRAY_SIZE(memrar_allocators)) {
+		struct memrar_allocator * const allocator =
+			memrar_allocators[r->type];
+
+		/*
+		 * Allocator capacity doesn't change over time.  No
+		 * need to synchronize.
+		 */
+		r->capacity = allocator->capacity;
+
+		mutex_lock(&allocator->lock);
+
+		r->largest_block_size = allocator->largest_free_area;
+
+		mutex_unlock(&allocator->lock);
+
+		result = 0;
+	}
+
+	return result;
+}
+
+static long memrar_ioctl(struct file *filp,
+			 unsigned int cmd,
+			 unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	long result = 0;
+
+	struct RAR_buffer buffer;
+	struct RAR_block_info * const request = &buffer.info;
+	struct RAR_stat rar_info;
+	void *rar_handle;
+
+	pr_debug("%s(): enter\n", __func__);
+
+	switch (cmd) {
+	case RAR_HANDLER_RESERVE:
+		if (copy_from_user(request,
+				   argp,
+				   sizeof(*request)))
+			return -EFAULT;
+
+		result = memrar_reserve_block(&buffer, filp);
+		if (result != 0)
+			return result;
+
+		return copy_to_user(argp, request, sizeof(*request));
+
+	case RAR_HANDLER_RELEASE:
+		if (copy_from_user(&rar_handle,
+				   argp,
+				   sizeof(rar_handle)))
+			return -EFAULT;
+
+		return memrar_release_block(rar_handle);
+
+	case RAR_HANDLER_STAT:
+		if (copy_from_user(&rar_info,
+				   argp,
+				   sizeof(rar_info)))
+			return -EFAULT;
+
+		/*
+		 * Populate the RAR_stat structure based on the RAR
+		 * type given by the user
+		 */
+		if (memrar_get_stat(&rar_info) != 0)
+			return -EINVAL;
+
+		/*
+		 * @todo Do we need to verify destination pointer
+		 *       "argp" is non-zero?  Is that already done by
+		 *       copy_to_user()?
+		 */
+		return copy_to_user(argp,
+				    &rar_info,
+				    sizeof(rar_info)) ? -EFAULT : 0;
+
+	default:
+		return -ENOTTY;
+	}
+
+	pr_debug("%s(): exit\n", __func__);
+	return 0;
+}
+
+static int memrar_open(struct inode *inode, struct file *filp)
+{
+	/* Nothing to do yet. */
+
+	return 0;
+}
+
+static int memrar_release(struct inode *inode, struct file *filp)
+{
+	/* Free all regions associated with the current process. */
+
+	struct memrar_buffer_info *pos;
+	struct memrar_buffer_info *tmp;
+
+	mutex_lock(&memrar_mutex);
+
+	list_for_each_entry_safe_reverse(pos,
+					 tmp,
+					 &memrar_buffers.list,
+					 list) {
+		if (filp == pos->owner)
+			kref_put(&pos->refcount, memrar_release_block_i);
+	}
+
+	mutex_unlock(&memrar_mutex);
+
+	return 0;
+}
+
+/*
+ * @note This function is part of the kernel space memrar driver API.
+ */
+size_t rar_reserve(struct RAR_buffer *buffers, size_t count)
+{
+	struct RAR_buffer * const end =
+		(buffers == 0 ? buffers : buffers + count);
+	struct RAR_buffer *i;
+
+	size_t reserve_count = 0;
+
+	for (i = buffers; i != end; ++i) {
+		if (memrar_reserve_block(i, 0) == 0)
+			++reserve_count;
+		else
+			i->bus_address = 0;
+	}
+
+	return reserve_count;
+}
+EXPORT_SYMBOL(rar_reserve);
+
+/*
+ * @note This function is part of the kernel space memrar driver API.
+ */
+size_t rar_release(struct RAR_buffer *buffers, size_t count)
+{
+	struct RAR_buffer * const end =
+		(buffers == 0 ? buffers : buffers + count);
+	struct RAR_buffer *i;
+
+	size_t release_count = 0;
+
+	for (i = buffers; i != end; ++i) {
+		void ** const handle = &i->info.handle;
+		if (memrar_release_block(*handle) == 0) {
+			/*
+			 * @todo We assume we should do this each time
+			 *       the ref count is decremented.  Should
+			 *       we instead only do this when the ref
+			 *       count has dropped to zero, and the
+			 *       buffer has been completely
+			 *       released/unmapped?
+			 */
+			*handle = 0;
+			++release_count;
+		}
+	}
+
+	return release_count;
+}
+EXPORT_SYMBOL(rar_release);
+
+/*
+ * @note This function is part of the kernel space driver API.
+ */
+size_t rar_handle_to_bus(struct RAR_buffer *buffers, size_t count)
+{
+	struct RAR_buffer * const end =
+		(buffers == 0 ? buffers : buffers + count);
+	struct RAR_buffer *i;
+	struct memrar_buffer_info *pos;
+
+	size_t conversion_count = 0;
+
+	/*
+	 * @todo Not liking this nested loop.  Optimize.
+	 */
+	for (i = buffers; i != end; ++i) {
+		list_for_each_entry(pos, &memrar_buffers.list, list) {
+			struct RAR_block_info * const user_info =
+				&pos->buffer.info;
+
+			if (i->info.handle == user_info->handle) {
+				i->info.type = user_info->type;
+				i->info.size = user_info->size;
+				i->bus_address =
+					pos->buffer.bus_address;
+
+				/* Increment the reference count. */
+				kref_get(&pos->refcount);
+
+				++conversion_count;
+				break;
+			} else {
+				i->bus_address = 0;
+			}
+		}
+	}
+
+	return conversion_count;
+}
+EXPORT_SYMBOL(rar_handle_to_bus);
+
+static const struct file_operations memrar_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = memrar_ioctl,
+	.open           = memrar_open,
+	.release        = memrar_release,
+};
+
+static struct miscdevice memrar_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,    /* dynamic allocation */
+	.name = "memrar",               /* /dev/memrar */
+	.fops = &memrar_fops
+};
+
+static char const banner[] __initdata =
+	KERN_INFO
+	"Intel RAR Handler: " MEMRAR_VER " initialized.\n";
+
+static int __init memrar_init(void)
+{
+	int result = 0;
+
+	printk(banner);
+
+	/*
+	 * We initialize the RAR parameters early on so that we can
+	 * discontinue memrar device initialization and registration
+	 * if suitably configured RARs are not available.
+	 */
+	result = memrar_init_rar_resources();
+
+	if (result != 0)
+		goto memrar_init_exit;
+
+	result = misc_register(&memrar_miscdev);
+
+	if (result != 0) {
+		pr_err("memrar misc_register() failed.\n");
+
+		/* Clean up resources previously reserved. */
+		memrar_fini_rar_resources();
+
+		goto memrar_init_exit;
+	}
+
+	mrdev = memrar_miscdev.this_device;
+
+memrar_init_exit:
+
+	return result;
+}
+
+static void __exit memrar_exit(void)
+{
+	memrar_fini_rar_resources();
+
+	misc_deregister(&memrar_miscdev);
+}
+
+module_init(memrar_init);
+module_exit(memrar_exit);
+
+
+MODULE_AUTHOR("Ossama Othman <ossama.othman@intel.com>");
+MODULE_DESCRIPTION("Intel Restricted Access Region Handler");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(MISC_DYNAMIC_MINOR);
+MODULE_VERSION(MEMRAR_VER);
+
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/include/linux/rar/memrar.h b/include/linux/rar/memrar.h
new file mode 100644
index 0000000..a23d3e9
--- /dev/null
+++ b/include/linux/rar/memrar.h
@@ -0,0 +1,172 @@
+/*
+ *      RAR Handler (/dev/memrar) internal driver API.
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ */
+
+
+#ifndef _MEMRAR_H
+#define _MEMRAR_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+
+/*
+ * Constants that specify different kinds of RAR regions that could be
+ * set up.
+ */
+static __u32 const RAR_TYPE_VIDEO;  /* 0 */
+static __u32 const RAR_TYPE_AUDIO = 1;
+static __u32 const RAR_TYPE_IMAGE = 2;
+static __u32 const RAR_TYPE_DATA  = 3;
+
+/*
+ * @struct RAR_stat
+ *
+ * @brief This structure is used for @c RAR_HANDLER_STAT ioctl and for
+ *        @c RAR_get_stat() user space wrapper function.
+ */
+struct RAR_stat {
+	/* Type of RAR memory (e.g., audio vs. video) */
+	__u32 type;
+
+	/*
+	 * Total size of RAR memory region.
+	 */
+	__u32 capacity;
+
+	/* Size of the largest reservable block. */
+	__u32 largest_block_size;
+};
+
+
+/*
+ * @struct RAR_block_info
+ *
+ * @brief The argument for the @c RAR_HANDLER_RESERVE @c ioctl.
+ *
+ */
+struct RAR_block_info {
+	/* Type of RAR memory (e.g., audio vs. video) */
+	__u32 type;
+
+	/* Requested size of a block to be reserved in RAR. */
+	__u32 size;
+
+	/* Handle that can be used to refer to reserved block. */
+	void *handle;
+};
+
+/*
+ * @struct RAR_buffer
+ *
+ * Structure that contains all information related to a given block of
+ * memory in RAR.  It is generally only used when retrieving bus
+ * addresses.
+ *
+ * @note This structure is used only by RAR-enabled drivers, and is
+ *       not intended to be exposed to the user space.
+ */
+struct RAR_buffer {
+	/* Structure containing base RAR buffer information */
+	struct RAR_block_info info;
+
+	/* Buffer bus address */
+	__u32 bus_address;
+};
+
+
+#define RAR_IOCTL_BASE 0xE0
+
+/* Reserve RAR block. */
+#define RAR_HANDLER_RESERVE _IOWR(RAR_IOCTL_BASE, 0x00, struct RAR_block_info)
+
+/* Release previously reserved RAR block. */
+#define RAR_HANDLER_RELEASE _IOW(RAR_IOCTL_BASE, 0x01, void *)
+
+/* Get RAR stats. */
+#define RAR_HANDLER_STAT    _IOWR(RAR_IOCTL_BASE, 0x02, struct RAR_stat)
+
+
+/* -------------------------------------------------------------- */
+/*               Kernel Side RAR Handler Interface                */
+/* -------------------------------------------------------------- */
+
+/*
+ * @function rar_reserve
+ *
+ * @brief Reserve RAR buffers.
+ *
+ * This function will reserve buffers in the restricted access regions
+ * of given types.
+ *
+ * @return Number of successfully reserved buffers.
+ *         Successful buffer reservations will have the corresponding
+ *         @c bus_address field set to a non-zero value in the
+ *         given @a buffers vector.
+ */
+extern size_t rar_reserve(struct RAR_buffer *buffers,
+			  size_t count);
+
+/*
+ * @function rar_release
+ *
+ * @brief Release RAR buffers retrieved through call to
+ *        @c rar_reserve() or @c rar_handle_to_bus().
+ *
+ * This function will release RAR buffers that were retrieved through
+ * a call to @c rar_reserve() or @c rar_handle_to_bus() by
+ * decrementing the reference count.  The RAR buffer will be reclaimed
+ * when the reference count drops to zero.
+ *
+ * @return Number of successfully released buffers.
+ *         Successful releases will have their handle field set to
+ *         zero in the given @a buffers vector.
+ */
+extern size_t rar_release(struct RAR_buffer *buffers,
+			  size_t count);
+
+/*
+ * @function rar_handle_to_bus
+ *
+ * @brief Convert a vector of RAR handles to bus addresses.
+ *
+ * This function will retrieve the RAR buffer bus addresses, type and
+ * size corresponding to the RAR handles provided in the @a buffers
+ * vector.
+ *
+ * @return Number of successfully converted buffers.
+ *         The bus address will be set to @c 0 for unrecognized
+ *         handles.
+ *
+ * @note The reference count for each corresponding buffer in RAR will
+ *       be incremented.  Call @c rar_release() when done with the
+ *       buffers.
+ */
+extern size_t rar_handle_to_bus(struct RAR_buffer *buffers,
+				size_t count);
+
+
+#endif  /* _MEMRAR_H */
+
+
+/*
+  Local Variables:
+    c-file-style: "linux"
+  End:
+*/
diff --git a/kernel-mrst-alpha2.config b/kernel-mrst-alpha2.config
index 1f73364..8fb9626 100644
--- a/kernel-mrst-alpha2.config
+++ b/kernel-mrst-alpha2.config
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.31-rc1
-# Wed Jul 22 08:39:33 2009
+# Wed Jul 29 02:59:24 2009
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -832,6 +832,7 @@ CONFIG_MISC_DEVICES=y
 CONFIG_TIFM_CORE=m
 # CONFIG_TIFM_7XX1 is not set
 # CONFIG_ICS932S401 is not set
+CONFIG_MRST_RAR_HANDLER=y
 CONFIG_MRST_VIB=y
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_HP_ILO is not set
@@ -2489,6 +2490,11 @@ CONFIG_LINE6_USB=m
 CONFIG_X86_PLATFORM_DEVICES=y
 
 #
+# RAR Register Driver
+#
+CONFIG_RAR_REGISTER=y
+
+#
 # Firmware Drivers
 #
 # CONFIG_EDD is not set
-- 
1.6.0.4

