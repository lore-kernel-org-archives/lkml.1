Return-Path: <linux-kernel-owner+w=401wt.eu-S933444AbXFEWa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbXFEWa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764930AbXFEWaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:30:20 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:54471 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764032AbXFEWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:30:18 -0400
Message-ID: <4665E3BB.2010401@cosmosbay.com>
Date: Wed, 06 Jun 2007 00:29:15 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
References: <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com> <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu> <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org> <20070604122857.1399e3fc.dada1@cosmosbay.com> <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com> <20070604152540.985c186a.dada1@cosmosbay.com> <20070604141235.GA24352@elte.hu> <20070604162721.500211c9.dada1@cosmosbay.com> <20070605203720.GA5519@elte.hu>
In-Reply-To: <20070605203720.GA5519@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050606000005030904010103"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 06 Jun 2007 00:29:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050606000005030904010103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Ingo Molnar a écrit :
> 
> no, i just wanted to make a demonstration that one can be pretty nasty 
> in on-lkml replies while being technically correct :-) I think you went 
> a bit overboard in your replies to Davide. Lets move this back into 
> constructive channels, ok? :)

In any case, here is one preliminary patch to show what I had in mind.

I only had time to compile it (its very late here), not even boot tested, so 
dont try it !

[PATCH] reduce max latency of get_unused_fd().

Goal is to scan at most 4096 bytes (or 32768 bits) in the open_fds bitmap.

Processes that have many file descriptors might have to scan 128 KB of ram to 
find a zero bit. Thats about 100 us on modern machines.

This patch introduces an array of counters. Each counter gives the number of 
'one' bits in a 4 KB section of the open_fds bitmap.

I chose to statically allocate this array of counters, being very small (64 
bytes), so a dynamic allocation would only add complexity.

As a result, max latency is 4 us (same latency on x86 when vm gives you a new 
page)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
  fs/fcntl.c                |   18 +++++++++++++++---
  fs/file.c                 |    6 +++---
  fs/open.c                 |   13 +++++++++++++
  include/linux/file.h      |   11 +++++++++++
  include/linux/fs.h        |    2 --
  include/linux/init_task.h |    1 +
  kernel/fork.c             |    1 +
  7 files changed, 44 insertions(+), 8 deletions(-)


--------------050606000005030904010103
Content-Type: text/plain;
 name="fds_counter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fds_counter.patch"

diff --git a/include/linux/file.h b/include/linux/file.h
index a59001e..ec6b120 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -36,6 +36,16 @@ struct fdtable {
 };
 
 /*
+ * To avoid big latencies in get_unused_fd(),
+ * we maintain counters of "one" bits in bitmap pages
+ * we define a 'page' here to contain 32768 bits,
+ * so that each counter is an unsigned short
+ * with MAX_NR_OPENS = 2^20, we get 32 counters : 64 bytes
+ */
+#define FDSBITS 32768
+#define MAX_NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
+
+/*
  * Open file table structure
  */
 struct files_struct {
@@ -50,6 +60,7 @@ struct files_struct {
    */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	int next_fd;
+	unsigned short fds_counter[(MAX_NR_OPEN + (FDSBITS - 1)) / FDSBITS];
 	struct embedded_fd_set close_on_exec_init;
 	struct embedded_fd_set open_fds_init;
 	struct file * fd_array[NR_OPEN_DEFAULT];
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 8e382a5..5257ba6 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -61,6 +61,7 @@ static int locate_fd(struct files_struct
 	unsigned int start;
 	int error;
 	struct fdtable *fdt;
+	unsigned int page_nr;
 
 	error = -EINVAL;
 	if (orig_start >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
@@ -77,11 +78,19 @@ repeat:
 		start = files->next_fd;
 
 	newfd = start;
-	if (start < fdt->max_fds)
+
+	error = -EMFILE;
+	if (start < fdt->max_fds) {
+		page_nr = start / FDSBITS;
+		while (files->fds_counter[page_nr] == FDSBITS) {
+			page_nr++;
+			start = page_nr * FDSBITS;
+			if (start >= fdt->max_fds)
+				goto out;
+		}
 		newfd = find_next_zero_bit(fdt->open_fds->fds_bits,
 					   fdt->max_fds, start);
-	
-	error = -EMFILE;
+	}	
 	if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
 		goto out;
 
@@ -122,6 +131,7 @@ static int dupfd(struct file *file, unsi
 		/* locate_fd() may have expanded fdtable, load the ptr */
 		fdt = files_fdtable(files);
 		FD_SET(fd, fdt->open_fds);
+		files->fds_counter[fd / FDSBITS]++;
 		FD_CLR(fd, fdt->close_on_exec);
 		spin_unlock(&files->file_lock);
 		fd_install(fd, file);
@@ -171,7 +181,9 @@ asmlinkage long sys_dup2(unsigned int ol
 
 	rcu_assign_pointer(fdt->fd[newfd], file);
 	FD_SET(newfd, fdt->open_fds);
+	files->fds_counter[newfd / FDSBITS]++;
 	FD_CLR(newfd, fdt->close_on_exec);
+
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
diff --git a/fs/file.c b/fs/file.c
index c5575de..7dbd9c5 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -147,8 +147,8 @@ static struct fdtable * alloc_fdtable(un
 	nr /= (1024 / sizeof(struct file *));
 	nr = roundup_pow_of_two(nr + 1);
 	nr *= (1024 / sizeof(struct file *));
-	if (nr > NR_OPEN)
-		nr = NR_OPEN;
+	if (nr > MAX_NR_OPEN)
+		nr = MAX_NR_OPEN;
 
 	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL);
 	if (!fdt)
@@ -233,7 +233,7 @@ int expand_files(struct files_struct *fi
 	if (nr < fdt->max_fds)
 		return 0;
 	/* Can we expand? */
-	if (nr >= NR_OPEN)
+	if (nr >= MAX_NR_OPEN)
 		return -EMFILE;
 
 	/* All good, so we try */
diff --git a/fs/open.c b/fs/open.c
index 0d515d1..340e69b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -860,12 +860,23 @@ int get_unused_fd(void)
 	struct files_struct * files = current->files;
 	int fd, error;
 	struct fdtable *fdt;
+	unsigned int page_nr;
 
   	error = -EMFILE;
 	spin_lock(&files->file_lock);
 
 repeat:
 	fdt = files_fdtable(files);
+	page_nr = files->next_fd / FDSBITS;
+	/*
+	 * We can avoid testing big chunks of memory if all bit are set
+ 	 */
+	while (files->fds_counter[page_nr] == FDSBITS) {
+		page_nr++;
+		files->next_fd = page_nr * FDSBITS;
+		if (files->next_fd >= fdt->max_fds)
+			break;
+	}
 	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
 				files->next_fd);
 
@@ -891,6 +902,7 @@ repeat:
 	}
 
 	FD_SET(fd, fdt->open_fds);
+	files->fds_counter[fd / FDSBITS]++;
 	FD_CLR(fd, fdt->close_on_exec);
 	files->next_fd = fd + 1;
 #if 1
@@ -913,6 +925,7 @@ static void __put_unused_fd(struct files
 {
 	struct fdtable *fdt = files_fdtable(files);
 	__FD_CLR(fd, fdt->open_fds);
+	files->fds_counter[fd / FDSBITS]--;
 	if (fd < files->next_fd)
 		files->next_fd = fd;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ae77c..9db2799 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -20,8 +20,6 @@ #include <linux/ioctl.h>
  */
 
 /* Fixed constants first: */
-#undef NR_OPEN
-#define NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 276ccaa..bd24190 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -26,6 +26,7 @@ #define INIT_FILES \
 	.fdtab		= INIT_FDTABLE,			\
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock), \
 	.next_fd	= 0, 				\
+	.fds_counter	= {0},				\
 	.close_on_exec_init = { { 0, } }, 		\
 	.open_fds_init	= { { 0, } }, 			\
 	.fd_array	= { NULL, } 			\
diff --git a/kernel/fork.c b/kernel/fork.c
index 73ad5cd..f4341c5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -641,6 +641,7 @@ static struct files_struct *alloc_files(
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
+	memset(newf->fds_counter, 0, sizeof(newf->fds_counter));
 	fdt = &newf->fdtab;
 	fdt->max_fds = NR_OPEN_DEFAULT;
 	fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;

--------------050606000005030904010103--
