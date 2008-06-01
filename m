Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYFAXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYFAXLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYFAXLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:11:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbYFAXLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:11:45 -0400
Date: Sun, 1 Jun 2008 16:11:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: mtk.manpages@gmail.com, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-Id: <20080601161133.ea344adf.akpm@linux-foundation.org>
In-Reply-To: <20080601230040.GC2255@elf.ucw.cz>
References: <Pine.LNX.4.64.0805301451020.19914@blonde.site>
	<20080530204307.GA4978@ucw.cz>
	<Pine.LNX.4.64.0805311925190.27293@blonde.site>
	<20080531173950.c4f04028.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806010752510.24919@blonde.site>
	<20080601011501.199af80c.akpm@linux-foundation.org>
	<20080601114008.GC16843@elf.ucw.cz>
	<20080601133727.4e62ae55.akpm@linux-foundation.org>
	<20080601222202.GA2255@elf.ucw.cz>
	<20080601154736.2e9f5905.akpm@linux-foundation.org>
	<20080601230040.GC2255@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 01:00:40 +0200 Pavel Machek <pavel@suse.cz> wrote:

> > How about this:
> > 
> > - Add a new SYNC_FILE_RANGE_NON_BLOCKING
> > 
> > - If userspace set that flag, turn on writeback_control.nonblocking
> >   in __filemap_fdatawrite_range().
> > 
> > - test it a lot.
> 
> Works for me. Is the expectation that I code this? I can certainly
> provide testing ;-).

Something like this:

 fs/sync.c          |    3 ++-
 include/linux/fs.h |    4 +++-
 mm/filemap.c       |    9 +++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/filemap.c~a mm/filemap.c
--- a/mm/filemap.c~a
+++ a/mm/filemap.c
@@ -207,7 +207,7 @@ static int sync_page_killable(void *word
  * be waited upon, and not just skipped over.
  */
 int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
-				loff_t end, int sync_mode)
+				loff_t end, int sync_mode, int nonblocking)
 {
 	int ret;
 	struct writeback_control wbc = {
@@ -215,6 +215,7 @@ int __filemap_fdatawrite_range(struct ad
 		.nr_to_write = mapping->nrpages * 2,
 		.range_start = start,
 		.range_end = end,
+		.nonblocking = !!nonblocking,
 	};
 
 	if (!mapping_cap_writeback_dirty(mapping))
@@ -227,7 +228,7 @@ int __filemap_fdatawrite_range(struct ad
 static inline int __filemap_fdatawrite(struct address_space *mapping,
 	int sync_mode)
 {
-	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
+	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode, 0);
 }
 
 int filemap_fdatawrite(struct address_space *mapping)
@@ -239,7 +240,7 @@ EXPORT_SYMBOL(filemap_fdatawrite);
 static int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 				loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
+	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL, 0);
 }
 
 /**
@@ -430,7 +431,7 @@ int filemap_write_and_wait_range(struct 
 
 	if (mapping->nrpages) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
-						 WB_SYNC_ALL);
+						 WB_SYNC_ALL, 0);
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO) {
 			int err2 = wait_on_page_writeback_range(mapping,
diff -puN fs/sync.c~a fs/sync.c
--- a/fs/sync.c~a
+++ a/fs/sync.c
@@ -268,7 +268,8 @@ int do_sync_mapping_range(struct address
 
 	if (flags & SYNC_FILE_RANGE_WRITE) {
 		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
-						WB_SYNC_NONE);
+					WB_SYNC_NONE,
+					flags & SYNC_FILE_RANGE_NONBLOCKING);
 		if (ret < 0)
 			goto out;
 	}
diff -puN include/linux/fs.h~a include/linux/fs.h
--- a/include/linux/fs.h~a
+++ a/include/linux/fs.h
@@ -268,6 +268,7 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WAIT_BEFORE	1
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
+#define SYNC_FILE_RANGE_NONBLOCKING	8
 
 #ifdef __KERNEL__
 
@@ -1740,7 +1741,8 @@ extern int filemap_write_and_wait_range(
 extern int wait_on_page_writeback_range(struct address_space *mapping,
 				pgoff_t start, pgoff_t end);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
-				loff_t start, loff_t end, int sync_mode);
+				loff_t start, loff_t end, int sync_mode,
+				int nonblocking);
 
 extern long do_fsync(struct file *file, int datasync);
 extern void sync_supers(void);


But it needs comment updates and it really would be nice to combine the
`sync_mode' and `nonblocking' flags to __filemap_fdatawrite_range() -
it's all getting a bit silly there.

> > It will be userspace's responsibility to avoid burning huge amounts of
> > CPU repeatedly calling sync_file_range() and having it not actually write
> > anything.
> 
> Ok... I guess doing 10x sync_file_range() when writing 400MB of data
> is not excessive?

Sounds very sane.
