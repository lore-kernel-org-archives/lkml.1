Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab0BBUds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:33:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab0BBUdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:33:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: Re: s2disk hang update
Date: Tue, 2 Feb 2010 21:34:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com> <201001022138.42575.rjw@sisk.pl> <9b2b86521002020621n7c6a0582n66688d4e6810ca97@mail.gmail.com>
In-Reply-To: <9b2b86521002020621n7c6a0582n66688d4e6810ca97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022134.20366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010, Alan Jenkins wrote:
> On 1/2/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday 02 January 2010, Alan Jenkins wrote:
> > Hi,
> >
> >> I've been suffering from s2disk hangs again.  This time, the hangs
> >> were always before the hibernation image was written out.
> >>
> >> They're still frustratingly random.  I just started trying to work out
> >> whether doubling PAGES_FOR_IO makes them go away, but they went away
> >> on their own again.
> >>
> >> I did manage to capture a backtrace with debug info though.  Here it
> >> is for 2.6.33-rc2.  (It has also happened on rc1).  I was able to get
> >> the line numbers (using gdb, e.g.  "info line
> >> *stop_machine_create+0x27"), having built the kernel with debug info.
> >>
> >> [top of trace lost due to screen height]
> >> ? sync_page	(filemap.c:183)
> >> ? wait_on_page_bit	(filemap.c:506)
> >> ? wake_bit_function	(wait.c:174)
> >> ? shrink_page_list	(vmscan.c:696)
> >> ? __delayacct_blkio_end	(delayacct.c:94)
> >> ? finish_wait	(list.h:142)
> >> ? congestion_wait	(backing-dev.c:761)
> >> ? shrink_inactive_list	(vmscan.c:1193)
> >> ? scsi_request_fn	(spinlock.h:306)
> >> ? blk_run_queue	(blk-core.c:434)
> >> ? shrink_zone	(vmscan.c:1484)
> >> ? do_try_to_free_pages	(vmscan.c:1684)
> >> ? try_to_free_pages	(vmscan.c:1848)
> >> ? isolate_pages_global	(vmscan.c:980)
> >> ? __alloc_pages_nodemask	(page_alloc.c:1702)
> >> ? __get_free_pages	(page_alloc.c:1990)
> >> ? copy_process	(fork.c:237)
> >> ? do_fork	(fork.c:1443)
> >> ? rb_erase
> >> ? __switch_to
> >> ? kthread
> >> ? kernel_thread
> >> ? kthread
> >> ? kernel_thread_helper
> >> ? kthreadd
> >> ? kthreadd
> >> ? kernel_thread_helper
> >>
> >> INFO: task s2disk:2174 blocked for more than 120 seconds
> >
> > This looks like we have run out of memory while creating a new kernel thread
> > and we have blocked on I/O while trying to free some space (quite obviously,
> > because the I/O doesn't work at this point).
> 
> For context, the kernel thread being created here is the stop_machine
> thread.  It is created by disable_nonboot_cpus(), called from
> hibernation_snapshot().  See e.g. this hung task backtrace -
> 
> http://picasaweb.google.com/lh/photo/BkKUwZCrQ2ceBIM9ZOh7Ow?feat=directlink
> 
> > I think it should help if you increase PAGES_FOR_IO, then.
> 
> Ok, it's been happening again on 2.6.33-rc6.  Unfortunately increasing
> PAGES_FOR_IO doesn't help.
> 
> I've been using a test patch to make PAGES_FOR_IO tunable at run time.
>  I get the same hang if I increase it by a factor of 10, to 10240:
> 
> # cd /sys/module/kernel/parameters/
> # ls
> consoleblank  initcall_debug  PAGES_FOR_IO  panic  pause_on_oops  SPARE_PAGES
> # echo 10240 > PAGES_FOR_IO
> # echo 2560 > SPARE_PAGES
> # cat SPARE_PAGES
> 2560
> # cat PAGES_FOR_IO
> 10240
> 
> I also added a debug patch to try and understand the calculations with
> PAGES_FOR_IO in hibernate_preallocate_memory().  I still don't really
> understand them and there could easily be errors in my debug patch,
> but the output is interesting.
> 
> Increasing PAGES_FOR_IO by almost 10000 has the expected effect of
> decreasing "max_size" by the same amount.  However it doesn't appear
> to increase the number of free pages at the critical moment.
> 
> PAGES_FOR_IO = 1024:
> http://picasaweb.google.com/lh/photo/DYQGvB_4hvCvVuxZf2ibxg?feat=directlink
> 
> PAGES_FOR_IO = 10240:
> http://picasaweb.google.com/lh/photo/AIkV_ZBwt22nzN-JdOJCWA?feat=directlink
> 
> 
> You may remember that I was originally able to avoid the hang by
> reverting commit 5f8dcc2.  It doesn't revert cleanly any more.
> However, I tried applying my test&debug patches on top of 5f8dcc2~1
> (just before the commit that triggered the hang).  That kernel
> apparently left ~5000 pages free at hibernation time, v.s. ~1200 when
> testing the same scenario on 2.6.33-rc6.  (As before, the number of
> free pages remained the same if I increased PAGES_FOR_IO to 10240).

I think the hang may be avoided by using this patch
http://patchwork.kernel.org/patch/74740/
but the hibernation will fail instead.

Can you please repeat your experiments with the patch below applied and
report back?

Rafael

---
 kernel/power/snapshot.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1179,6 +1179,10 @@ static void free_unnecessary_pages(void)
 		to_free_normal -= save_highmem - alloc_highmem;
 	}
 
+	printk(KERN_CONT
+		"Freeing %lu normal and %lu highmem preallocated pages\n",
+		to_free_normal, to_free_highmem);
+
 	memory_bm_position_reset(&copy_bm);
 
 	while (to_free_normal > 0 && to_free_highmem > 0) {
@@ -1300,8 +1304,16 @@ int hibernate_preallocate_memory(void)
 	/* Compute the maximum number of saveable pages to leave in memory. */
 	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
 	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
+
+	printk(KERN_CONT "Requested image size: %lu pages\n", size);
+
 	if (size > max_size)
 		size = max_size;
+
+	printk(KERN_CONT
+		"count = %lu, highmem = %lu, max_size = %lu, saveable = %lu\n",
+		count, highmem, max_size, saveable);
+
 	/*
 	 * If the maximum is not less than the current number of saveable pages
 	 * in memory, allocate page frames for the image and we're done.
@@ -1312,10 +1324,14 @@ int hibernate_preallocate_memory(void)
 		goto out;
 	}
 
+	printk(KERN_CONT "Target image size: %lu pages\n", size);
+
 	/* Estimate the minimum size of the image. */
 	pages = minimum_image_size(saveable);
-	if (size < pages)
-		size = min_t(unsigned long, pages, max_size);
+	/* if (size < pages)
+		size = min_t(unsigned long, pages, max_size); */
+
+	printk(KERN_CONT "Minimum image size: %lu pages\n", pages);
 
 	/*
 	 * Let the memory management subsystem know that we're going to need a
@@ -1325,6 +1341,9 @@ int hibernate_preallocate_memory(void)
 	 */
 	shrink_all_memory(saveable - size);
 
+	pages = minimum_image_size(count_data_pages() + count_highmem_pages());
+	printk(KERN_CONT "Minimum image size: %lu pages\n", pages);
+
 	/*
 	 * The number of saveable pages in memory was too high, so apply some
 	 * pressure to decrease it.  First, make room for the largest possible
@@ -1334,17 +1353,35 @@ int hibernate_preallocate_memory(void)
 	 */
 	pages_highmem = preallocate_image_highmem(highmem / 2);
 	alloc = (count - max_size) - pages_highmem;
+
+	printk(KERN_CONT "pages_highmem = %lu, alloc = %lu\n",
+		pages_highmem, alloc);
+
 	pages = preallocate_image_memory(alloc);
 	if (pages < alloc)
 		goto err_out;
+
+	printk(KERN_CONT "pages = %lu\n", pages);
+
 	size = max_size - size;
 	alloc = size;
+
 	size = preallocate_highmem_fraction(size, highmem, count);
+
+	printk(KERN_CONT "alloc_highmem = %lu, alloc = %lu\n", size, alloc);
+
 	pages_highmem += size;
 	alloc -= size;
 	pages += preallocate_image_memory(alloc);
+
+	printk(KERN_CONT "pages = %lu\n", pages);
+
 	pages += pages_highmem;
 
+	printk(KERN_CONT
+		"pages = %lu, pages_highmem = %lu, count - pages = %lu\n",
+		pages, pages_highmem, count - pages);
+
 	/*
 	 * We only need as many page frames for the image as there are saveable
 	 * pages in memory, but we have allocated more.  Release the excessive

