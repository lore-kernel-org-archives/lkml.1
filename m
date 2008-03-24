Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYCXPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYCXPK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760474AbYCXPKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:10:17 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:17054 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYCXPKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TeakayBDrUDdnUMdCBxtFBwy/Cwx1rzjidZ2m4yc5iSEmlcS3e4v2Y+NxrJX19BSzDoavfbalyInkA6lCBqlE+AMjkwPSHI0XO8djh+h31IWQnCHJgECLbEKFBKimlRiQPe8JHOtZHovpi3jVbal4MlhlW36K6UCf1RRDCGNPAY=
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] compcache: TLSF Allocator - internal defs
Date: Mon, 24 Mar 2008 20:35:32 +0530
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242035.32905.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This contains header to be used internally by TLSF.
It contains flags to enable/disable debugging, stats collection and
other important parameters like alignment requirement.

Signed-off-by: Nitin Gupta <nitingupta910 at gmail dot com>
---
 mm/tlsf_int.h |  179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 179 insertions(+), 0 deletions(-)

diff --git a/mm/tlsf_int.h b/mm/tlsf_int.h
new file mode 100644
index 0000000..626cb3e
--- /dev/null
+++ b/mm/tlsf_int.h
@@ -0,0 +1,179 @@
+/*
+ * To be used internally by TLSF allocator.
+ */
+
+#ifndef _TLSF_INT_H_
+#define _TLSF_INT_H_
+
+#include <linux/tlsf.h>
+#include <asm/types.h>
+
+/* Debugging and Stats */
+#if (1 || defined(CONFIG_DEBUG_TLSF))
+#define DEBUG	1
+#define STATS	1
+#else
+#define DEBUG	0
+#define STATS	0
+#endif
+
+/* Create /proc/tlsfinfo? */
+/* If STATS is disabled, this will give minimal memory usage info. */
+#define CONFIG_TLSFINFO
+
+/* It useless to collect stats if there is no way to export it */
+#if (STATS && !defined(CONFIG_TLSFINFO))
+#error "TLSF stats is enabled but not /proc/tlsfinfo."
+#endif
+
+#define NOP	do { } while(0)
+#if STATS
+static inline void stat_inc(size_t *stat)
+{
+	++*stat;
+}
+
+static inline void stat_dec(size_t *stat)
+{
+	BUG_ON(*stat == 0);
+	--*stat;
+}
+
+static inline void stat_set(size_t *stat, size_t val)
+{
+	*stat = val;
+}
+
+static inline void stat_setmax(size_t *max, size_t cur)
+{
+	*max = (cur > *max) ? cur : *max;
+}
+#else	/* STATS */
+
+#define stat_inc(x)		NOP
+#define stat_dec(x)		NOP
+#define stat_set(x, v)		NOP
+#define stat_setmax(x, v)	NOP
+#endif	/* STATS */
+
+/* Messsage prefix */
+#define T "TLSF: "
+
+#define K(x)			((x) >> 10)
+#define MAX_POOL_NAME_LEN	16
+
+/*-- TLSF structures */
+
+/* Some IMPORTANT TLSF parameters */
+#define MEM_ALIGN	(sizeof(void *) * 2)
+#define MEM_ALIGN_MASK	(~(MEM_ALIGN - 1))
+
+#define MAX_FLI		(30)
+#define MAX_LOG2_SLI	(5)
+#define MAX_SLI		(1 << MAX_LOG2_SLI)
+
+#define FLI_OFFSET	(6)
+/* tlsf structure just will manage blocks bigger than 128 bytes */
+#define SMALL_BLOCK	(128)
+#define REAL_FLI	(MAX_FLI - FLI_OFFSET)
+#define MIN_BLOCK_SIZE	(sizeof(struct free_ptr))
+#define BHDR_OVERHEAD	(sizeof(struct bhdr) - MIN_BLOCK_SIZE)
+
+#define	PTR_MASK	(sizeof(void *) - 1)
+#define BLOCK_SIZE_MASK	(0xFFFFFFFF - PTR_MASK)
+
+#define GET_NEXT_BLOCK(addr, r)	((struct bhdr *) \
+				((char *) (addr) + (r)))
+#define ROUNDUP_SIZE(r)		(((r) + MEM_ALIGN - 1) & MEM_ALIGN_MASK)
+#define ROUNDDOWN_SIZE(r)	((r) & MEM_ALIGN_MASK)
+#define ROUNDUP_PAGE(r)		(((r) + PAGE_SIZE - 1) & PAGE_MASK)
+
+#define BLOCK_STATE	(0x1)
+#define PREV_STATE	(0x2)
+
+/* bit 0 of the block size */
+#define FREE_BLOCK	(0x1)
+#define USED_BLOCK	(0x0)
+
+/* bit 1 of the block size */
+#define PREV_FREE	(0x2)
+#define PREV_USED	(0x0)
+
+#if DEBUG
+#define MAX_RETRY_EXPAND	10
+#endif
+
+struct free_ptr {
+	struct bhdr *prev;
+	struct bhdr *next;
+};
+
+struct bhdr {
+	/* All blocks in a region are linked in order of physical address */
+	struct bhdr *prev_hdr;
+	/*
+	 * The size is stored in bytes
+	 * 	bit 0: block is free, if set
+	 * 	bit 1: previous block is free, if set
+	 */
+	u32 size;
+	/* Free blocks in individual freelists are linked */
+	union {
+		struct free_ptr free_ptr;
+		u8 buffer[sizeof(struct free_ptr)];
+	} ptr;
+};
+
+struct pool {
+	/* First level bitmap (REAL_FLI bits) */
+	u32 fl_bitmap;
+
+	/* Second level bitmap */
+	u32 sl_bitmap[REAL_FLI];
+
+	/* Free lists */
+	struct bhdr *matrix[REAL_FLI][MAX_SLI];
+
+	struct mutex lock;
+
+	size_t init_size;
+	size_t max_size;
+	size_t grow_size;
+
+	/* Basic stats */
+	size_t used_size;
+	size_t num_regions;
+
+	/* User provided functions for expanding/shrinking pool */
+	get_memory *get_mem;
+	put_memory *put_mem;
+
+	struct list_head list;
+
+#if STATS
+	/* Extra stats */
+	size_t peak_used;
+	size_t peak_total;
+	size_t peak_extra;	/* MAX(Total - Used) */
+	size_t count_alloc;
+	size_t count_free;
+	size_t count_region_alloc;
+	size_t count_region_free;
+	size_t count_failed_alloc;
+#endif
+
+#if DEBUG
+	/*
+	 * Pool used size must be 0 when its destroyed.
+	 * When non-empty pool is destroyed, it suggests
+	 * memory leak. Such pools are marked invalid
+	 * and kept in pool list for later debugging.
+	 */
+	unsigned int valid;
+#endif
+	void *init_region;
+	char name[MAX_POOL_NAME_LEN];
+};
+/*-- TLSF structures end */
+
+#endif
