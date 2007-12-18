Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXLRMNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXLRMNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXLRMNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:13:30 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46792 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754119AbXLRMN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:13:29 -0500
Message-ID: <397980013.15006@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 18 Dec 2007 20:13:22 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/9] mmap read-around and readahead
References: <397806667.28507@ustc.edu.cn> <alpine.LFD.0.9999.0712161535090.21557@woody.linux-foundation.org> <20071218114609.GA27778@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218114609.GA27778@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J4bK6-0001BG-Mp@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 07:46:09PM +0800, Fengguang Wu wrote:
> No timings for now... but I wrote a debug patch(attached) and watched
> it running for about a week.  Here are some interesting numbers:

Here are the (forgotten) readahead-debug.patch:

---
 include/linux/fs.h |   43 ++++++++++++++++++++++++++++++++++
 mm/Kconfig         |   19 +++++++++++++++
 mm/filemap.c       |    1 
 mm/readahead.c     |   54 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc4-mm1.orig/include/linux/fs.h
+++ linux-2.6.24-rc4-mm1/include/linux/fs.h
@@ -760,11 +760,54 @@ struct file_ra_state {
 	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
+	unsigned int flags;
 	unsigned int ra_pages;		/* Maximum readahead window */
 	int mmap_miss;			/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
+#define RA_CLASS_SHIFT		4
+#define RA_CLASS_MASK		((1 << RA_CLASS_SHIFT) - 1)
+/*
+ * Detailed classification of read-ahead behaviors.
+ */
+enum ra_class {
+	RA_CLASS_INIT0,
+	RA_CLASS_INIT,
+	RA_CLASS_SEQUENTIAL,
+	RA_CLASS_INTERLEAVED,
+	RA_CLASS_CONTEXT,
+	RA_CLASS_AROUND,
+	RA_CLASS_COUNT
+};
+
+static inline enum ra_class ra_class_new(struct file_ra_state *ra)
+{
+	return ra->flags & RA_CLASS_MASK;
+}
+
+static inline enum ra_class ra_class_old(struct file_ra_state *ra)
+{
+	return (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
+}
+
+/*
+ * Which method is issuing this read-ahead?
+ */
+static inline void ra_set_class(struct file_ra_state *ra, enum ra_class ra_class)
+{
+	unsigned long flags_mask;
+	unsigned long flags;
+	unsigned long old_ra_class;
+
+	flags_mask = ~(RA_CLASS_MASK | (RA_CLASS_MASK << RA_CLASS_SHIFT));
+	flags = ra->flags & flags_mask;
+
+	old_ra_class = ra_class_new(ra) << RA_CLASS_SHIFT;
+
+	ra->flags = flags | old_ra_class | ra_class;
+}
+
 /*
  * Check if @index falls in the readahead windows.
  */
--- linux-2.6.24-rc4-mm1.orig/mm/Kconfig
+++ linux-2.6.24-rc4-mm1/mm/Kconfig
@@ -194,3 +194,22 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config DEBUG_READAHEAD
+	bool "Readahead debug and accounting"
+	default y
+	select DEBUG_FS
+	help
+	  This option injects extra code to dump detailed debug traces and do
+	  readahead events accounting.
+
+	  To actually get the data:
+
+	  mkdir /debug
+	  mount -t debug none /debug
+
+	  After that you can do the following:
+
+	  echo > /debug/readahead/events # reset the counters
+	  cat /debug/readahead/events    # check the counters
+
--- linux-2.6.24-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc4-mm1/mm/readahead.c
@@ -16,6 +16,29 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
+#include <linux/debugfs.h>
+
+static const char * const ra_class_name[] = {
+	[RA_CLASS_INIT0]	= "init0",
+	[RA_CLASS_INIT]		= "init",
+	[RA_CLASS_SEQUENTIAL]	= "sequential",
+	[RA_CLASS_INTERLEAVED]	= "interleaved",
+	[RA_CLASS_CONTEXT]	= "context",
+	[RA_CLASS_AROUND]	= "around",
+};
+
+#ifdef CONFIG_DEBUG_READAHEAD
+static u32 readahead_debug_level = 1;
+#  define debug_option(o)		(o)
+#else
+#  define debug_option(o)		(0)
+#  define readahead_debug_level 	(0)
+#endif /* CONFIG_DEBUG_READAHEAD */
+
+#define dprintk(args...) \
+	do { if (readahead_debug_level >= 2) printk(KERN_DEBUG args); } while(0)
+#define ddprintk(args...) \
+	do { if (readahead_debug_level >= 3) printk(KERN_DEBUG args); } while(0)
 
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
@@ -220,6 +243,13 @@ unsigned long max_sane_readahead(unsigne
 
 static int __init readahead_init(void)
 {
+#ifdef CONFIG_DEBUG_READAHEAD
+	struct dentry *root;
+
+	root = debugfs_create_dir("readahead", NULL);
+
+	debugfs_create_u32("debug_level", 0644, root, &readahead_debug_level);
+#endif
 	return bdi_init(&default_backing_dev_info);
 }
 subsys_initcall(readahead_init);
@@ -235,6 +265,15 @@ unsigned long ra_submit(struct file_ra_s
 	actual = __do_page_cache_readahead(mapping, filp,
 					ra->start, ra->size, ra->async_size);
 
+	dprintk("readahead-%s(process: %s/%d, file: %s/%s, "
+			"offset=%ld:%ld, ra=%ld+%d-%d) = %d\n",
+			ra_class_name[ra_class_new(ra)],
+			current->comm, current->pid,
+			mapping->host->i_sb->s_id,
+			filp->f_path.dentry->d_iname,
+			(long)(filp->f_pos >> PAGE_CACHE_SHIFT),
+			(long)(ra->prev_pos >> PAGE_CACHE_SHIFT),
+			ra->start, ra->size, ra->async_size, actual);
 	return actual;
 }
 
@@ -337,6 +376,7 @@ ondemand_readahead(struct address_space 
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
+		ra_set_class(ra, RA_CLASS_SEQUENTIAL);
 		goto readit;
 	}
 
@@ -348,8 +388,15 @@ ondemand_readahead(struct address_space 
 	 * Read as is, and do not pollute the readahead state.
 	 */
 	if (!hit_readahead_marker && !sequential) {
-		return __do_page_cache_readahead(mapping, filp,
+		int actual = __do_page_cache_readahead(mapping, filp,
 						offset, req_size, 0);
+		dprintk("read-random(process: %s/%d, file: %s/%s, "
+			"req=%ld+%ld) = %d\n",
+				current->comm, current->pid,
+				mapping->host->i_sb->s_id,
+				filp->f_path.dentry->d_iname,
+				offset, req_size, actual);
+		return actual;
 	}
 
 	/*
@@ -372,6 +419,7 @@ ondemand_readahead(struct address_space 
 		ra->size = start - offset;	/* old async_size */
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
+		ra_set_class(ra, RA_CLASS_INTERLEAVED);
 		goto readit;
 	}
 
@@ -385,6 +433,10 @@ ondemand_readahead(struct address_space 
 	ra->start = offset;
 	ra->size = get_init_ra_size(req_size, max);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
+	if (offset)
+		ra_set_class(ra, RA_CLASS_INIT);
+	else
+		ra_set_class(ra, RA_CLASS_INIT0);
 
 readit:
 	/*
--- linux-2.6.24-rc4-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc4-mm1/mm/filemap.c
@@ -1340,6 +1340,7 @@ static void do_sync_mmap_readahead(struc
 		ra->start = max_t(long, 0, offset - ra_pages / 2);
 		ra->size = ra_pages;
 		ra->async_size = 0;
+		ra_set_class(ra, RA_CLASS_AROUND);
 		ra_submit(ra, mapping, file);
 	}
 }

