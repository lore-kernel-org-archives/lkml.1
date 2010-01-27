Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002Ab0A0Gfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0A0Gfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089Ab0A0Gfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:35:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39932 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0A0Gfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:35:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jan 2010 15:32:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH v4 1/2] sysctl clean up vm related variable declarations
Message-Id: <20100127153232.f8efc531.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100127153053.b8a8a1a1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100127153053.b8a8a1a1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Change log:
 - 2010/01/27 (new)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm.h     |    5 +++++
 include/linux/mmzone.h |    1 +
 include/linux/oom.h    |    5 +++++
 kernel/sysctl.c        |   16 ++--------------
 mm/mmap.c              |    5 +++++
 5 files changed, 18 insertions(+), 14 deletions(-)

Index: mmotm-2.6.33-Jan15-2/include/linux/mm.h
===================================================================
--- mmotm-2.6.33-Jan15-2.orig/include/linux/mm.h
+++ mmotm-2.6.33-Jan15-2/include/linux/mm.h
@@ -1432,6 +1432,7 @@ int in_gate_area_no_task(unsigned long a
 #define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+extern int sysctl_drop_caches;
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
@@ -1476,5 +1477,9 @@ extern int soft_offline_page(struct page
 
 extern void dump_page(struct page *page);
 
+#ifndef CONFIG_NOMMU
+extern int sysctl_nr_trim_pages;
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
Index: mmotm-2.6.33-Jan15-2/include/linux/mmzone.h
===================================================================
--- mmotm-2.6.33-Jan15-2.orig/include/linux/mmzone.h
+++ mmotm-2.6.33-Jan15-2/include/linux/mmzone.h
@@ -747,6 +747,7 @@ int min_free_kbytes_sysctl_handler(struc
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+extern int percpu_pagelist_fraction; /* for sysctl */
 int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
Index: mmotm-2.6.33-Jan15-2/kernel/sysctl.c
===================================================================
--- mmotm-2.6.33-Jan15-2.orig/kernel/sysctl.c
+++ mmotm-2.6.33-Jan15-2/kernel/sysctl.c
@@ -51,6 +51,8 @@
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
 #include <linux/rcustring.h>
+#include <linux/mman.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -67,11 +69,6 @@
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
@@ -80,14 +77,9 @@ extern unsigned int core_pipe_limit;
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
@@ -198,10 +190,6 @@ extern struct ctl_table inotify_table[];
 extern struct ctl_table epoll_table[];
 #endif
 
-#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
-int sysctl_legacy_va_layout;
-#endif
-
 extern int prove_locking;
 extern int lock_stat;
 
Index: mmotm-2.6.33-Jan15-2/include/linux/oom.h
===================================================================
--- mmotm-2.6.33-Jan15-2.orig/include/linux/oom.h
+++ mmotm-2.6.33-Jan15-2/include/linux/oom.h
@@ -43,5 +43,10 @@ static inline void oom_killer_enable(voi
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
Index: mmotm-2.6.33-Jan15-2/mm/mmap.c
===================================================================
--- mmotm-2.6.33-Jan15-2.orig/mm/mmap.c
+++ mmotm-2.6.33-Jan15-2/mm/mmap.c
@@ -87,6 +87,11 @@ int sysctl_overcommit_ratio = 50;	/* def
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

