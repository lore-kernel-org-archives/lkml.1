Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0BCCgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:36:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0BCCgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:36:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CPxxOLlqvXJZ7cGW5kcoOOJEdHizLDo+um82LLuKqA+9fcswT+RE7yk2/FNWAxOcJ
	VfKGJ5RLpG4kIecAh9IMg==
Date: Tue, 2 Feb 2010 18:36:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, minchan.kim@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] sysctl: clean up vm related variable declarations
In-Reply-To: <20100203111224.8fe0e20c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002021832160.5344@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <alpine.DEB.2.00.1002011523280.19457@chino.kir.corp.google.com> <201002022210.06760.l.lunak@suse.cz> <alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com> <20100203105236.b4a60754.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002021809220.15327@chino.kir.corp.google.com> <20100203111224.8fe0e20c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, there are many "extern" declaration in kernel/sysctl.c. "extern"
declaration in *.c file is not appreciated in general.
And Hmm...it seems there are a few redundant declarations.

Because most of sysctl variables are defined in its own header file,
they should be declared in the same style, be done in its own *.h file.

This patch removes some VM(memory management) related sysctl's
variable declaration from kernel/sysctl.c and move them to
proper places.

[rientjes@google.com: #ifdef fixlet]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mm.h     |    5 +++++
 include/linux/mmzone.h |    1 +
 include/linux/oom.h    |    5 +++++
 kernel/sysctl.c        |   16 ++--------------
 mm/mmap.c              |    5 +++++
 5 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1305,6 +1305,7 @@ int in_gate_area_no_task(unsigned long addr);
 #define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+extern int sysctl_drop_caches;
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
@@ -1347,5 +1348,9 @@ extern void shake_page(struct page *p, int access);
 extern atomic_long_t mce_bad_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
+#ifndef CONFIG_MMU
+extern int sysctl_nr_trim_pages;
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -760,6 +760,7 @@ int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+extern int percpu_pagelist_fraction; /* for sysctl */
 int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -43,5 +43,10 @@ static inline void oom_killer_enable(void)
 {
 	oom_killer_disabled = false;
 }
+/* for sysctl */
+extern int sysctl_panic_on_oom;
+extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_oom_dump_tasks;
+
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -50,6 +50,8 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/mman.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -66,11 +68,6 @@
 /* External variables not in a header file. */
 extern int C_A_D;
 extern int print_fatal_signals;
-extern int sysctl_overcommit_memory;
-extern int sysctl_overcommit_ratio;
-extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -79,14 +76,9 @@ extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
-extern int sysctl_drop_caches;
-extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
-#ifndef CONFIG_MMU
-extern int sysctl_nr_trim_pages;
-#endif
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
@@ -197,10 +189,6 @@ extern struct ctl_table inotify_table[];
 extern struct ctl_table epoll_table[];
 #endif
 
-#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
-int sysctl_legacy_va_layout;
-#endif
-
 extern int prove_locking;
 extern int lock_stat;
 
diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -87,6 +87,11 @@ int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 struct percpu_counter vm_committed_as;
 
+#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
+/* Used by each architecture's private code and sysctl. */
+int sysctl_legacy_va_layout;
+#endif
+
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
