Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbYCXPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbYCXPIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbYCXPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:08:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:13339 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761105AbYCXPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NDgiHmIeJlLywn+wu+4mfzIjwfKcRoo/43I9GXqYN4AetW3lG1TCbKYZA9mxpHnfBgq8CB29Dota4avp3ugsUwFNCYynb+iPBTT6vEFk7rISfMQ1PdyP2XVJNSfQzQI0EDdy0A+LWyUnWvCIDUQLyk4xbHP5XfuJ9fRYerl6YEk=
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] compcache: block device - internal defs
Date: Mon, 24 Mar 2008 20:33:30 +0530
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242033.30782.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This contains header to be used internally by block device code.
It contains flags to enable/disable debugging, stats collection and also
defines default disk size (25% of total RAM).

Signed-off-by: Nitin Gupta <nitingupta910 at gmail dot com>
---
 drivers/block/compcache.h |  147 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/block/compcache.h b/drivers/block/compcache.h
new file mode 100644
index 0000000..b84b5d3
--- /dev/null
+++ b/drivers/block/compcache.h
@@ -0,0 +1,147 @@
+/*
+ * Compressed RAM based swap device
+ *
+ * (C) Nitin Gupta
+ *
+ * This RAM based block device acts as swap disk.
+ * Pages swapped to this device are compressed and
+ * stored in memory.
+ *
+ * Project home: http://code.google.com/p/compcache
+ */
+
+#ifndef _COMPCACHE_H_
+#define _COMPCACHE_H_
+
+#define K(x)	((x) >> 10)
+#define KB(x)	((x) << 10)
+
+#define SECTOR_SHIFT		9
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
+#define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
+
+/*-- Configurable parameters */
+/* Default compcache size: 25% of total RAM */
+#define DEFAULT_COMPCACHE_PERCENT	25
+#define INIT_SIZE			KB(16)
+#define GROW_SIZE			INIT_SIZE
+/*-- */
+
+/* Message prefix */
+#define C "compcache: "
+
+/* Debugging and Stats */
+#define NOP	do { } while(0)
+
+#if (1 || defined(CONFIG_DEBUG_COMPCACHE))
+#define DEBUG	1
+#define STATS	1
+#else
+#define DEBUG	0
+#define STATS	0
+#endif
+
+/* Create /proc/compcache? */
+/* If STATS is disabled, this will give minimal compcache info */
+#define CONFIG_COMPCACHE_PROC
+
+#if DEBUG
+#define CC_DEBUG(fmt,arg...) \
+	printk(KERN_DEBUG C fmt,##arg)
+#else
+#define CC_DEBUG(fmt,arg...) NOP
+#endif
+
+/*
+ * Verbose debugging:
+ * Enable basic debugging + verbose messages spread all over code
+ */
+#define DEBUG2	0
+
+#if DEBUG2
+#define DEBUG	1
+#define STATS	1
+#define CONFIG_COMPCACHE_PROC	1
+#define CC_DEBUG2((fmt,arg...) \
+	printk(KERN_DEBUG C fmt,##arg)
+#else /* DEBUG2 */
+#define CC_DEBUG2(fmt,arg...) NOP
+#endif
+
+/* Its useless to collect stats if there is no way to export it */
+#if (STATS && !defined(CONFIG_COMPCACHE_PROC))
+#error "compcache stats is enabled but not /proc/compcache."
+#endif
+
+#if STATS
+static inline void stat_inc_if_less(size_t *stat, const size_t val1,
+						const size_t val2)
+{
+	*stat += ((val1 < val2) ? 1 : 0);
+}
+
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
+static inline void stat_set(size_t *stat, const size_t val)
+{
+	*stat = val;
+}
+
+static inline void stat_setmax(size_t *max, const size_t cur)
+{
+	*max = (cur > *max) ? cur : *max;
+}
+#else	/* STATS */
+#define stat_inc(x)			NOP
+#define stat_dec(x)			NOP
+#define stat_set(x, v)			NOP
+#define stat_setmax(x, v)		NOP
+#define stat_inc_if_less(x, v1, v2)	NOP
+#endif	/* STATS */
+
+/*-- Data structures */
+/* Indexed by page no. */
+struct table {
+	void *addr;
+	unsigned short len;
+} __attribute__ ((packed));
+
+struct compcache {
+	void *mem_pool;
+	void *compress_workmem;
+	void *compress_buffer;
+	struct table *table;
+	struct mutex lock;
+	struct gendisk *disk;
+	size_t size;            /* In sectors */
+};
+
+#if STATS
+struct compcache_stats {
+	u32 num_reads;		/* failed + successful */
+	u32 num_writes;		/* --do-- */
+	u32 failed_reads;	/* can happen when memory is tooo low */
+	u32 failed_writes;	/* should NEVER! happen */
+	u32 invalid_io;		/* non-swap I/O requests */
+	u32 good_compress;	/* no. of pages with compression
+				 * ratio <= 50%. TODO: export full
+				 * compressed page size histogram */
+	u32 pages_expand;	/* no. of incompressible pages */
+	size_t curr_pages;	/* current no. of compressed pages */
+	size_t curr_mem;	/* current total size of compressed pages */
+	size_t peak_mem;
+};
+#endif
+/*-- */
+
+#endif
