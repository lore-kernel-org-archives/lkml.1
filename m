Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZGAMwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZGAMwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZGAMvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:51:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:44253 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZGAMvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:51:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,323,1243839600"; 
   d="scan'208";a="160458607"
Date: Wed, 1 Jul 2009 20:50:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: fio sync read 4k block size 35% regression
Message-ID: <20090701125027.GA28347@localhost>
References: <1246418733.2560.468.camel@ymzhang> <20090701041010.GB22364@localhost> <1246424635.2560.470.camel@ymzhang>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246424635.2560.470.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 01, 2009 at 01:03:55PM +0800, Zhang, Yanmin wrote:
> On Wed, 2009-07-01 at 12:10 +0800, Wu Fengguang wrote:
> > On Wed, Jul 01, 2009 at 11:25:33AM +0800, Zhang, Yanmin wrote:
> > > Comapraing with 2.6.30, fio sync read (block size 4k) has about 35% regression
> > > with kernel 2.6.31-rc1 ﻿on my stoakley machine with a JBOD (13 SCSI disks).
> > > 
> > > Every disk has 1 partition and 4 1-GB files. Start 10 processes per disk to
> > > do sy﻿nc read sequentinally.
> > > 
> > > Bisected down to below patch.
> > > 
> > > 51daa88ebd8e0d437289f589af29d4b39379ea76 is first bad commit
> > > commit 51daa88ebd8e0d437289f589af29d4b39379ea76
> > > Author: Wu Fengguang <fengguang.wu@intel.com>
> > > Date:   Tue Jun 16 15:31:24 2009 -0700
> > > 
> > >     readahead: remove sync/async readahead call dependency
> > > 
> > >     The readahead call scheme is error-prone in that it expects the call sites
> > >     to check for async readahead after doing a sync one.  I.e.
> > > 
> > >                         if (!page)
> > >                                 page_cache_sync_readahead();
> > >                         page = find_get_page();
> > >                         if (page && PageReadahead(page))
> > >                                 page_cache_async_readahead();
> > > 
> > > 
> > > I also test block size 64k and 128k, but they don't have regression. Perhaps
> > > the default read_ahead_kb is equal to 128?
> > > 
> > > Other 2 machines have no such regression. The JBODS of the 2 machines consists
> > > of 12 and 7 SATA/SAS disks while every disk has 2 partitions.
> > 
> > Yanmin, thanks for the tests!
> > 
> > Maybe the patch posted here can restore the performance:
> > 
> > http://lkml.org/lkml/2009/5/21/319
> I tried it and it doesn't help.

Then let's check what's happening behind the scene :)

Please apply the attached patch and run

        echo 1 > /debug/readahead/trace_enable
        # do benchmark
        echo 0 > /debug/readahead/trace_enable

and send the dmesg which will contain lots of lines like

        [   54.738105] readahead-initial0(pid=3290(zsh), dev=00:10(0:10), ino=105910(dmesg), req=0+1, ra=0+4-3, async=0) = 2
        [   54.751801] readahead-subsequent(pid=3290(dmesg), dev=00:10(0:10), ino=105910(dmesg), req=1+60, ra=4+8-8, async=1, miss=0) = 0


Thank you very much,
Fengguang

--UlVJffcvxoiEqYs2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="readahead-trace-2.6.31-rc1.patch"

--- linux.orig/mm/readahead.c
+++ linux/mm/readahead.c
@@ -16,6 +16,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
+#include <linux/marker.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -225,6 +226,10 @@ int force_page_cache_readahead(struct ad
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
 	}
+
+	trace_mark(readahead_fadvise, "%p %p %lu %lu %d",
+			mapping, filp, offset, nr_to_read, ret);
+
 	return ret;
 }
 
@@ -242,13 +247,20 @@ unsigned long max_sane_readahead(unsigne
  * Submit IO for the read-ahead request in file_ra_state.
  */
 unsigned long ra_submit(struct file_ra_state *ra,
-		       struct address_space *mapping, struct file *filp)
+			struct address_space *mapping,
+			struct file *filp,
+			pgoff_t offset,
+			unsigned long req_size,
+			int async)
 {
 	int actual;
 
 	actual = __do_page_cache_readahead(mapping, filp,
 					ra->start, ra->size, ra->async_size);
 
+	trace_mark(readahead_generic, "%p %p %lu %lu %p %d %d",
+			mapping, filp, offset, req_size, ra, actual, async);
+
 	return actual;
 }
 
@@ -375,6 +387,7 @@ static int try_context_readahead(struct 
 	if (size >= offset)
 		size *= 2;
 
+	ra_set_pattern(ra, RA_PATTERN_CONTEXT);
 	ra->start = offset;
 	ra->size = get_init_ra_size(size + req_size, max);
 	ra->async_size = ra->size;
@@ -396,8 +409,10 @@ ondemand_readahead(struct address_space 
 	/*
 	 * start of file
 	 */
-	if (!offset)
+	if (!offset) {
+		ra_set_pattern(ra, RA_PATTERN_INITIAL0);
 		goto initial_readahead;
+	}
 
 	/*
 	 * It's the expected callback offset, assume sequential access.
@@ -405,6 +420,7 @@ ondemand_readahead(struct address_space 
 	 */
 	if ((offset == (ra->start + ra->size - ra->async_size) ||
 	     offset == (ra->start + ra->size))) {
+		ra_set_pattern(ra, RA_PATTERN_SUBSEQUENT);
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
@@ -427,6 +443,7 @@ ondemand_readahead(struct address_space 
 		if (!start || start - offset > max)
 			return 0;
 
+		ra_set_pattern(ra, RA_PATTERN_HIT_MARKER);
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
 		ra->size += req_size;
@@ -438,14 +455,18 @@ ondemand_readahead(struct address_space 
 	/*
 	 * oversize read
 	 */
-	if (req_size > max)
+	if (req_size > max) {
+		ra_set_pattern(ra, RA_PATTERN_OVERSIZE);
 		goto initial_readahead;
+	}
 
 	/*
 	 * sequential cache miss
 	 */
-	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
+	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL) {
+		ra_set_pattern(ra, RA_PATTERN_INITIAL);
 		goto initial_readahead;
+	}
 
 	/*
 	 * Query the page cache and look for the traces(cached history pages)
@@ -456,9 +477,12 @@ ondemand_readahead(struct address_space 
 
 	/*
 	 * standalone, small random read
-	 * Read as is, and do not pollute the readahead state.
 	 */
-	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+	ra_set_pattern(ra, RA_PATTERN_RANDOM);
+	ra->start = offset;
+	ra->size = req_size;
+	ra->async_size = 0;
+	goto readit;
 
 initial_readahead:
 	ra->start = offset;
@@ -476,7 +500,8 @@ readit:
 		ra->size += ra->async_size;
 	}
 
-	return ra_submit(ra, mapping, filp);
+	return ra_submit(ra, mapping, filp, offset, req_size,
+			 hit_readahead_marker);
 }
 
 /**
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -885,11 +885,57 @@ struct file_ra_state {
 	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
+	unsigned int flags;
 	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
+#define	RA_FLAG_MMAP		0x100
+
+/*
+ * Which policy makes decision to do the current read-ahead IO?
+ */
+#define RA_PATTERN_SHIFT	0
+#define RA_PATTERN_MASK		0xf
+
+enum readahead_pattern {
+	RA_PATTERN_NONE,
+	RA_PATTERN_INITIAL0,	/* start of file */
+	RA_PATTERN_INITIAL,
+	RA_PATTERN_SUBSEQUENT,
+	RA_PATTERN_HIT_MARKER,
+	RA_PATTERN_CONTEXT,
+	RA_PATTERN_OVERSIZE,
+	RA_PATTERN_REVERSE,
+	RA_PATTERN_STRIDE,
+	RA_PATTERN_THRASH,
+	RA_PATTERN_MMAP_AROUND,
+	RA_PATTERN_FADVISE,
+	RA_PATTERN_RANDOM,
+	RA_PATTERN_ALL,		/* for summary stats */
+	RA_PATTERN_MAX
+};
+
+static inline int ra_pattern(struct file_ra_state *ra)
+{
+	int pattern = (ra->flags >> RA_PATTERN_SHIFT) & RA_PATTERN_MASK;
+
+	if (pattern > RA_PATTERN_MAX)
+		pattern = RA_PATTERN_NONE;
+
+	return pattern;
+}
+
+/*
+ * Which method is issuing this read-ahead?
+ */
+static inline void ra_set_pattern(struct file_ra_state *ra, int pattern)
+{
+	ra->flags = (ra->flags & ~RA_PATTERN_MASK) |
+			(pattern << RA_PATTERN_SHIFT);
+}
+
 /*
  * Check if @index falls in the readahead windows.
  */
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -1195,7 +1195,10 @@ void page_cache_async_readahead(struct a
 unsigned long max_sane_readahead(unsigned long nr);
 unsigned long ra_submit(struct file_ra_state *ra,
 			struct address_space *mapping,
-			struct file *filp);
+			struct file *filp,
+			pgoff_t offset,
+			unsigned long req_size,
+			int async);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- linux.orig/mm/filemap.c
+++ linux/mm/filemap.c
@@ -1020,7 +1020,7 @@ static void shrink_readahead_size_eio(st
  * This is really ugly. But the goto's actually try to clarify some
  * of the logic when it comes to error handling etc.
  */
-static void do_generic_file_read(struct file *filp, loff_t *ppos,
+void do_generic_file_read(struct file *filp, loff_t *ppos,
 		read_descriptor_t *desc, read_actor_t actor)
 {
 	struct address_space *mapping = filp->f_mapping;
@@ -1471,6 +1471,7 @@ static void do_sync_mmap_readahead(struc
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
+		ra->flags |= RA_FLAG_MMAP;
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1491,10 +1492,12 @@ static void do_sync_mmap_readahead(struc
 	 */
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	if (ra_pages) {
+		ra->flags |= RA_FLAG_MMAP;
+		ra_set_pattern(ra, RA_PATTERN_MMAP_AROUND);
 		ra->start = max_t(long, 0, offset - ra_pages/2);
 		ra->size = ra_pages;
 		ra->async_size = 0;
-		ra_submit(ra, mapping, file);
+		ra_submit(ra, mapping, file, offset, 1, 0);
 	}
 }
 
@@ -1515,9 +1518,11 @@ static void do_async_mmap_readahead(stru
 		return;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
-	if (PageReadahead(page))
+	if (PageReadahead(page)) {
+		ra->flags |= RA_FLAG_MMAP;
 		page_cache_async_readahead(mapping, ra, file,
 					   page, offset, ra->ra_pages);
+	}
 }
 
 /**
--- /dev/null
+++ linux/mm/readahead_trace.c
@@ -0,0 +1,514 @@
+/*
+ * Readahead I/O tracing and accounting
+ *
+ * Copyright 2008 Wu Fengguang, Intel Corporation
+ * Subject to the GNU Public License, version 2 or later.
+ *
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/kprobes.h>
+#include <linux/pagemap.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <asm/atomic.h>
+#include <linux/stringify.h>
+#include <linux/version.h>
+
+int option_read_jprobes;
+int option_trace_enable;
+u32 option_trace_pid;
+u32 option_trace_ino;
+
+struct readahead_trace_probe {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+	int pattern;
+};
+
+enum ra_account {
+	/* number of readaheads */
+	RA_ACCOUNT_COUNT,
+	RA_ACCOUNT_IOCOUNT,
+	RA_ACCOUNT_EOF,
+	RA_ACCOUNT_SYNC,
+	RA_ACCOUNT_MMAP,
+	/* number of pages */
+	RA_ACCOUNT_SIZE,
+	RA_ACCOUNT_ASIZE,
+	RA_ACCOUNT_ACTUAL,
+	/* end mark */
+	RA_ACCOUNT_MAX,
+};
+
+static const char * const ra_pattern_names[] = {
+	[RA_PATTERN_NONE]		= "none",
+	[RA_PATTERN_INITIAL0]		= "initial0",
+	[RA_PATTERN_INITIAL]		= "initial",
+	[RA_PATTERN_SUBSEQUENT]		= "subsequent",
+	[RA_PATTERN_HIT_MARKER]		= "marker",
+	[RA_PATTERN_CONTEXT]		= "context",
+	[RA_PATTERN_OVERSIZE]		= "oversize",
+	[RA_PATTERN_REVERSE]		= "reverse",
+	[RA_PATTERN_STRIDE]		= "stride",
+	[RA_PATTERN_THRASH]		= "thrash",
+	[RA_PATTERN_MMAP_AROUND]	= "around",
+	[RA_PATTERN_FADVISE]		= "fadvise",
+	[RA_PATTERN_RANDOM]		= "random",
+	[RA_PATTERN_ALL]		= "all",
+};
+
+static unsigned long ra_stats[RA_PATTERN_MAX][RA_ACCOUNT_MAX];
+
+/*
+ * readahead tracing
+ */
+
+static void do_readahead_stats(struct address_space *mapping,
+			       struct file_ra_state *ra,
+			       int actual,
+			       int async,
+			       int pattern)
+{
+	pgoff_t lastpage = (i_size_read(mapping->host) - 1) >> PAGE_CACHE_SHIFT;
+
+	ra_stats[pattern][RA_ACCOUNT_COUNT]++;
+	ra_stats[pattern][RA_ACCOUNT_SIZE] += ra->size;
+	ra_stats[pattern][RA_ACCOUNT_ASIZE] += ra->async_size;
+	ra_stats[pattern][RA_ACCOUNT_ACTUAL] += actual;
+
+	if (!actual)
+		return;
+
+	ra_stats[pattern][RA_ACCOUNT_IOCOUNT]++;
+	if (ra->start + ra->size > lastpage)
+		ra_stats[pattern][RA_ACCOUNT_EOF]++;
+	if (!async)
+		ra_stats[pattern][RA_ACCOUNT_SYNC]++;
+	if (ra->flags & RA_FLAG_MMAP)
+		ra_stats[pattern][RA_ACCOUNT_MMAP]++;
+}
+
+static void do_readahead_trace(struct address_space *mapping,
+			       struct file *filp,
+			       pgoff_t offset,
+			       unsigned long req_size,
+			       struct file_ra_state *ra,
+			       int actual,
+			       int async)
+{
+	int pattern = ra_pattern(ra);
+
+	do_readahead_stats(mapping, ra, actual, async, pattern);
+	do_readahead_stats(mapping, ra, actual, async, RA_PATTERN_ALL);
+
+	if (!option_trace_enable)
+		return;
+	if (option_trace_pid && option_trace_pid != current->pid)
+		return;
+	if (option_trace_ino && option_trace_ino != mapping->host->i_ino)
+		return;
+
+	BUILD_BUG_ON(ARRAY_SIZE(ra_pattern_names) != RA_PATTERN_MAX);
+	if (ra->flags & RA_FLAG_MMAP)
+		printk(KERN_DEBUG "readahead-%s(pid=%d(%s), dev=%02x:%02x(%s), "
+			"ino=%lu(%s), req=%lu+%lu, ra=%lu+%d-%d, async=%d, miss=%d) = %d\n",
+			ra_pattern_names[pattern],
+			current->pid, current->comm,
+			MAJOR(mapping->host->i_sb->s_dev),
+			MINOR(mapping->host->i_sb->s_dev),
+			mapping->host->i_sb->s_id,
+			mapping->host->i_ino,
+			filp->f_path.dentry->d_name.name,
+			offset, req_size,
+			ra->start, ra->size, ra->async_size,
+			async, ra->mmap_miss,
+			actual);
+	else
+		printk(KERN_DEBUG "readahead-%s(pid=%d(%s), dev=%02x:%02x(%s), "
+			"ino=%lu(%s), req=%lu+%lu, ra=%lu+%d-%d, async=%d) = %d\n",
+			ra_pattern_names[pattern],
+			current->pid, current->comm,
+			MAJOR(mapping->host->i_sb->s_dev),
+			MINOR(mapping->host->i_sb->s_dev),
+			mapping->host->i_sb->s_id,
+			mapping->host->i_ino,
+			filp->f_path.dentry->d_name.name,
+			offset, req_size,
+			ra->start, ra->size, ra->async_size,
+			async,
+			actual);
+}
+
+
+static void readahead_trace(void *readahead_trace_probe, void *call_data,
+			    const char *format, va_list *args)
+{
+	struct address_space *mapping;
+	struct file *filp;
+	pgoff_t offset;
+	unsigned long req_size;
+	struct file_ra_state *ra;
+	int actual;
+	int async;
+
+	mapping  = va_arg(*args, typeof(mapping));
+	filp     = va_arg(*args, typeof(filp));
+	offset   = va_arg(*args, typeof(offset));
+	req_size = va_arg(*args, typeof(req_size));
+	ra       = va_arg(*args, typeof(ra));
+	actual   = va_arg(*args, typeof(actual));
+	async    = va_arg(*args, typeof(async));
+
+	do_readahead_trace(mapping, filp, offset, req_size, ra, actual, async);
+}
+
+static void plain_readahead_trace(void *probe_private, void *call_data,
+				  const char *format, va_list *args)
+{
+	struct readahead_trace_probe *probe = probe_private;
+	struct address_space *mapping;
+	struct file *filp;
+	struct file_ra_state ra = {0};
+	int actual;
+
+	mapping  = va_arg(*args, typeof(mapping));
+	filp     = va_arg(*args, typeof(filp));
+	ra.start = va_arg(*args, typeof(ra.start));
+	ra.size  = va_arg(*args, typeof(ra.size));
+	actual   = va_arg(*args, typeof(actual));
+
+	ra_set_pattern(&ra, probe->pattern);
+
+	do_readahead_trace(mapping, filp, 0, 0, &ra, actual, 0);
+}
+
+/*
+ * read tracing
+ */
+
+static void read_trace(const char func_name[],
+		       struct file *file,
+		       loff_t pos, size_t count)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	if (!option_trace_enable)
+		return;
+	if (option_trace_pid && option_trace_pid != current->pid)
+		return;
+	if (option_trace_ino && option_trace_ino != inode->i_ino)
+		return;
+
+	printk(KERN_DEBUG "%s(pid=%d(%s), dev=%02x:%02x(%s), ino=%lu(%s), "
+			"pos=%llu, count=%lu)\n",
+			func_name,
+			current->pid, current->comm,
+			MAJOR(inode->i_sb->s_dev),
+			MINOR(inode->i_sb->s_dev),
+			inode->i_sb->s_id,
+			inode->i_ino,
+			file->f_path.dentry->d_name.name,
+			pos, count);
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
+static ssize_t jdo_generic_file_splice_read(struct file *in,
+					    loff_t *ppos,
+					    struct pipe_inode_info *pipe,
+					    size_t len,
+					    unsigned int flags)
+{
+	read_trace("generic_file_splice_read", in, *ppos, len);
+	jprobe_return();
+	return 0;
+}
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
+static void jdo_do_generic_file_read(struct file *filp,
+				     loff_t *ppos,
+				     read_descriptor_t *desc,
+				     read_actor_t actor)
+{
+	read_trace("do_generic_file_read", filp, *ppos, desc->count);
+	jprobe_return();
+}
+#else
+static void jdo_do_generic_mapping_read(struct address_space *mapping,
+					struct file_ra_state *_ra,
+					struct file *filp,
+					loff_t *ppos,
+					read_descriptor_t *desc,
+					read_actor_t actor)
+{
+	read_trace("do_generic_mapping_read", filp, *ppos, desc->count);
+	jprobe_return();
+}
+#endif
+
+/*
+ * jprobes
+ */
+
+#define jprobe_entry(func)			\
+{						\
+	.entry = jdo_##func,			\
+	.kp.symbol_name = __stringify(func)	\
+}
+
+static struct jprobe jprobe_array[] = {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
+	jprobe_entry(do_generic_file_read),
+#else
+	jprobe_entry(do_generic_mapping_read),
+#endif
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
+	jprobe_entry(generic_file_splice_read),
+#endif
+};
+
+static void insert_jprobes(void)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(jprobe_array); i++) {
+		err = register_jprobe(jprobe_array + i);
+		if (err)
+			printk(KERN_ERR "unable to register probe %s\n",
+					jprobe_array[i].kp.symbol_name);
+	}
+}
+
+static void remove_jprobes(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(jprobe_array); i++)
+		unregister_jprobe(jprobe_array + i);
+}
+
+/*
+ * marker probes
+ */
+
+static struct readahead_trace_probe probe_array[] =
+{
+	{
+		.name = "readahead_generic",
+		.format = "%p %p %lu %lu %p %d %d",
+		.probe_func = readahead_trace,
+	},
+	{
+		.name = "readahead_mmap",
+		.format = "%p %p %lu %lu %d",
+		.probe_func = plain_readahead_trace,
+		.pattern = RA_PATTERN_MMAP_AROUND,
+	},
+	{
+		.name = "readahead_fadvise",
+		.format = "%p %p %lu %lu %d",
+		.probe_func = plain_readahead_trace,
+		.pattern = RA_PATTERN_FADVISE,
+	},
+};
+
+static void insert_markers(void)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		err = marker_probe_register(probe_array[i].name,
+					    probe_array[i].format,
+					    probe_array[i].probe_func,
+					    probe_array + i);
+		if (err)
+			printk(KERN_ERR "unable to register probe %s\n",
+					probe_array[i].name);
+	}
+}
+
+static void remove_markers(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
+		marker_probe_unregister(probe_array[i].name,
+					probe_array[i].probe_func,
+					probe_array + i);
+
+	marker_synchronize_unregister();
+}
+
+/*
+ * file operations for readahead_stats
+ */
+
+static int readahead_stats_show(struct seq_file *s, void *_)
+{
+	unsigned long i;
+	unsigned long count, iocount;
+
+	seq_printf(s, "%-10s %10s %10s %10s %10s %10s %10s %10s %10s\n",
+			"pattern",
+			"readahead", "io", "sync_io", "mmap_io", "eof_io",
+			"ra_size", "async_size", "io_size");
+
+	for (i = 0; i < RA_PATTERN_MAX; i++) {
+		count = ra_stats[i][RA_ACCOUNT_COUNT];
+		if (count == 0)
+			count = 1;
+		iocount = ra_stats[i][RA_ACCOUNT_IOCOUNT];
+		if (iocount == 0)
+			iocount = 1;
+
+		seq_printf(s, "%-10s %10lu %10lu %10lu %10lu %10lu %10lu %10lu %10lu\n",
+				ra_pattern_names[i],
+				ra_stats[i][RA_ACCOUNT_COUNT],
+				ra_stats[i][RA_ACCOUNT_IOCOUNT],
+				ra_stats[i][RA_ACCOUNT_SYNC],
+				ra_stats[i][RA_ACCOUNT_MMAP],
+				ra_stats[i][RA_ACCOUNT_EOF],
+				ra_stats[i][RA_ACCOUNT_SIZE]   / count,
+				ra_stats[i][RA_ACCOUNT_ASIZE]  / count,
+				ra_stats[i][RA_ACCOUNT_ACTUAL] / iocount);
+	}
+
+	return 0;
+}
+
+static int readahead_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, readahead_stats_show, NULL);
+}
+
+static ssize_t readahead_stats_write(struct file *file, const char __user *buf,
+				     size_t size, loff_t *offset)
+{
+	memset(ra_stats, 0, sizeof(ra_stats));
+	return size;
+}
+
+static struct file_operations readahead_stats_fops = {
+	.owner		= THIS_MODULE,
+	.open		= readahead_stats_open,
+	.write		= readahead_stats_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/*
+ * file operations for read_jprobes
+ */
+
+static int read_jprobes_set(void *data, u64 val)
+{
+	if (val && !option_read_jprobes)
+		insert_jprobes();
+	else if (!val && option_read_jprobes)
+		remove_jprobes();
+
+	WARN_ON(data != &option_read_jprobes);
+	*(int *)data = val;
+
+	return 0;
+}
+static int read_jprobes_get(void *data, u64 *val)
+{
+	*val = *(int *)data;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(read_jprobes_fops,
+			read_jprobes_get, read_jprobes_set, "%llu\n");
+
+/*
+ * debugfs interface
+ */
+
+struct readahead_debug {
+	struct dentry *root;
+	struct dentry *stats;
+	struct dentry *trace_enable;
+	struct dentry *trace_pid;
+	struct dentry *read_jprobes;
+};
+static struct readahead_debug debug;
+
+static void remove_debugfs(void)
+{
+	debugfs_remove(debug.read_jprobes);
+	debugfs_remove(debug.trace_enable);
+	debugfs_remove(debug.trace_pid);
+	debugfs_remove(debug.stats);
+	debugfs_remove(debug.root);
+}
+
+static int create_debugfs(void)
+{
+	debug.root = debugfs_create_dir("readahead", NULL);
+	if (!debug.root)
+		goto out;
+
+	debug.stats = debugfs_create_file("stats", 0644, debug.root,
+					  NULL, &readahead_stats_fops);
+	if (!debug.stats)
+		goto out;
+
+	debug.trace_enable = debugfs_create_bool("trace_enable", 0644,
+						 debug.root,
+						 &option_trace_enable);
+	if (!debug.trace_enable)
+		goto out;
+
+	debug.trace_pid = debugfs_create_u32("trace_pid", 0644, debug.root,
+					     &option_trace_pid);
+	if (!debug.trace_pid)
+		goto out;
+
+	debug.read_jprobes = debugfs_create_file("read_jprobes", 0644,
+						 debug.root,
+						 &option_read_jprobes,
+						 &read_jprobes_fops);
+	if (!debug.read_jprobes)
+		goto out;
+
+	return 0;
+
+out:
+	printk(KERN_ERR "readahead: failed to create debugfs entries\n");
+	return -ENOMEM;
+}
+
+/*
+ * module init/exit
+ */
+
+static int __init readahead_trace_init(void)
+{
+	create_debugfs();
+	insert_markers();
+	return 0;
+}
+
+static void __exit readahead_trace_exit(void)
+{
+	remove_jprobes();
+	remove_markers();
+	remove_debugfs();
+}
+
+module_init(readahead_trace_init);
+module_exit(readahead_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Wu Fengguang <fengguang.wu@intel.com>");
+MODULE_DESCRIPTION("Readahead Tracing and Accounting");
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -260,3 +260,22 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  of 1 says that all excess pages should be trimmed.
 
 	  See Documentation/nommu-mmap.txt for more information.
+
+config READAHEAD_TRACE
+	tristate "Readahead tracing"
+	select MARKERS
+	select KPROBES
+	select DEBUGFS
+	default y
+	help
+	 This module injects code to show detailed readahead traces and do
+	 readahead events accounting.
+
+	 To actually get the data:
+
+	 # mount -t debugfs none /sys/kernel/debug
+
+	 After that you can do the following:
+
+	 # cat /sys/kernel/debug/readahead/stats     # check counters
+	 # echo > /sys/kernel/debug/readahead/stats  # reset counters
--- linux.orig/mm/Makefile
+++ linux/mm/Makefile
@@ -40,5 +40,4 @@ obj-$(CONFIG_SMP) += allocpercpu.o
 endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
-obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_READAHEAD_TRACE) += readahead_trace.o

--UlVJffcvxoiEqYs2--
