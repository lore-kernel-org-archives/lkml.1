Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZIXI3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZIXI3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIXI27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:28:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbZIXI2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:28:54 -0400
Date: Thu, 24 Sep 2009 01:27:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Simek <michal.simek@petalogix.com>
Cc: stefani@seibold.net, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       John Williams <john.williams@petalogix.com>
Subject: Re: Microblaze noMMU compilation fault - mm/Makefile
Message-Id: <20090924012756.69d858e2.akpm@linux-foundation.org>
In-Reply-To: <e6a72e5f0909240112n1f99e9bay150b9e52e6f34c34@mail.gmail.com>
References: <4ABB24F2.6070700@petalogix.com>
	<20090924005824.67b2d1a5.akpm@linux-foundation.org>
	<e6a72e5f0909240112n1f99e9bay150b9e52e6f34c34@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 10:12:20 +0200 Michal Simek <michal.simek@petalogix.com> wrote:

> 2009/9/24 Andrew Morton <akpm@linux-foundation.org>
> 
> > On Thu, 24 Sep 2009 09:51:14 +0200 Michal Simek <
> > michal.simek@petalogix.com> wrote:
> >
> > > Hi Stefani,
> > >
> > > Commit d899bf7b55f503ba7d3d07ed27c3a37e270fa7db break Microblaze noMMU
> > kernel
> > >
> > > There is problem that you setup compilation pagewalk.c which is MMU
> > specific.
> > >
> > > And Andrew add there this comment:
> > > [akpm@linux-foundation.org: fs/proc/array.c now needs walk_page_range()]
> > >
> > > that mean that the second problem is with compilation of proc/array.c for
> > noMMU.
> > >
> >
> > I don't understand.
> >
> > Please send us a copy of the compiler error messages.
> >
> >
> http://www.monstr.eu/wiki/doku.php?id=log:2009-09-24_09_51_35
> 
>   CC      mm/pagewalk.o
> mm/pagewalk.c: In function 'walk_pte_range':
> mm/pagewalk.c:11: error: implicit declaration of function 'pte_offset_map'
> mm/pagewalk.c:11: warning: assignment makes pointer from integer without a cast
> mm/pagewalk.c:22: error: implicit declaration of function 'pte_unmap'
> mm/pagewalk.c: In function 'walk_pmd_range':
> mm/pagewalk.c:35: error: implicit declaration of function 'pmd_addr_end'
> mm/pagewalk.c:36: error: implicit declaration of function
> 'pmd_none_or_clear_bad'
> mm/pagewalk.c: In function 'walk_pud_range':
> mm/pagewalk.c:61: error: implicit declaration of function 'pud_offset'
> mm/pagewalk.c:61: warning: assignment makes pointer from integer without a cast
> mm/pagewalk.c:63: error: implicit declaration of function 'pud_addr_end'
> mm/pagewalk.c:64: error: implicit declaration of function
> 'pud_none_or_clear_bad'
> mm/pagewalk.c: In function 'walk_page_range':
> mm/pagewalk.c:117: error: implicit declaration of function 'pgd_offset'
> mm/pagewalk.c:117: warning: assignment makes pointer from integer without a cast
> mm/pagewalk.c:119: error: implicit declaration of function 'pgd_addr_end'
> mm/pagewalk.c:120: error: implicit declaration of function
> 'pgd_none_or_clear_bad'
> make[1]: *** [mm/pagewalk.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 

OK, I wonder how that snuck through.

I suppose the feature isn't going to work at all on mmuless systems. 
Does this work OK?


 fs/proc/array.c |    7 +++++++
 mm/Makefile     |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~a fs/proc/array.c
--- a/fs/proc/array.c~a
+++ a/fs/proc/array.c
@@ -322,6 +322,8 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
+#ifdef CONFIG_MMU
+
 struct stack_stats {
 	struct vm_area_struct *vma;
 	unsigned long	startpage;
@@ -402,6 +404,11 @@ static inline void task_show_stack_usage
 		mmput(mm);
 	}
 }
+#else
+static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
+{
+}
+#endif		/* CONFIG_MMU */
 
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
diff -puN mm/Makefile~a mm/Makefile
--- a/mm/Makefile~a
+++ a/mm/Makefile
@@ -5,14 +5,14 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o
+			   vmalloc.o pagewalk.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o \
-			   pagewalk.o $(mmu-y)
+			   $(mmu-y)
 obj-y += init-mm.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
_

