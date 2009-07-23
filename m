Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZGWJF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZGWJF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 05:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZGWJF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 05:05:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57161 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZGWJF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:05:58 -0400
Message-ID: <4A682795.8050609@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 17:04:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>	<20090722111538.58a126e3.akpm@linux-foundation.org> <adad47smsb5.fsf@cisco.com>
In-Reply-To: <adad47smsb5.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > >  1. ioctl() to register/unregister an address range to watch in the
>  > >     kernel (cf struct ummunot_register_ioctl in <linux/ummunot.h>).
>  > > 
>  > >  2. read() to retrieve events generated when a mapping in a watched
>  > >     address range is invalidated (cf struct ummunot_event in
>  > >     <linux/ummunot.h>).  select()/poll()/epoll() and SIGIO are handled
>  > >     for this IO.
>  > > 
>  > >  3. mmap() one page at offset 0 to map a kernel page that contains a
>  > >     generation counter that is incremented each time an event is
>  > >     generated.  This allows userspace to have a fast path that checks
>  > >     that no events have occurred without a system call.
>  > 
>  > If you stand back and squint, each of 1, 2 and 3 are things which the
>  > kernel already provides for the delivery of ftrace events to userspace.
>  > 
>  > Did you look at reusing all that stuff?
> 
> No, not really... will investigate a bit further.  Any pointers to how
> the ftrace stuff might work?

This can be implemented as a tracer or trace events, though I'm
not sure if it can fully meet your requirements or not.

To implement it as trace events, we add tracepoints in mmu_inlivadate_xxx(),
and define some TRACE_EVENT() macros.

And below shows how to use it:

  # mount -t debugfs xxx /mnt
  # cd /mnt/tracing/
  # echo 1 > events/mmu/enable
  # echo '(start >= 10000000 && end <= 10004096) || \
	(start >= 20000000 && end <= 20004096)' > events/mmu/filter
  # cat trace_pipe
        bash-2066  [001]   795.239077: mmu_invalidate_range_start: start=10000000 end=10000100
        bash-2066  [001]   795.239091: mmu_invalidate_range_start: start=10000000 end=10000100
        bash-2066  [001]   795.239098: mmu_invalidate_range_start: start=10000000 end=10000100
         cat-2189  [001]   795.239502: mmu_invalidate_page: start=20000000 end=20003000
         cat-2189  [001]   795.239578: mmu_invalidate_page: start=20000000 end=20003000
        bash-2066  [001]   795.239626: mmu_invalidate_page: start=20000000 end=20003000

The patch is extremely simple:

---
 include/linux/mmu_notifier.h |    4 +++
 include/trace/events/mmu.h   |   55 ++++++++++++++++++++++++++++++++++++++++++
 mm/mmu_notifier.c            |    3 ++
 3 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/mmu.h

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index b77486d..49ff4cc 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -5,6 +5,8 @@
 #include <linux/spinlock.h>
 #include <linux/mm_types.h>
 
+#include <trace/events/mmu.h>
+
 struct mmu_notifier;
 struct mmu_notifier_ops;
 
@@ -178,6 +180,7 @@ static inline int mmu_notifier_clear_flush_young(struct mm_struct *mm,
 static inline void mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address)
 {
+	trace_mmu_invalidate_page(address);
 	if (mm_has_notifiers(mm))
 		__mmu_notifier_invalidate_page(mm, address);
 }
@@ -185,6 +188,7 @@ static inline void mmu_notifier_invalidate_page(struct mm_struct *mm,
 static inline void mmu_notifier_invalidate_range_start(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
 {
+	trace_mmu_invalidate_range_start(start, end);
 	if (mm_has_notifiers(mm))
 		__mmu_notifier_invalidate_range_start(mm, start, end);
 }
diff --git a/include/trace/events/mmu.h b/include/trace/events/mmu.h
new file mode 100644
index 0000000..0d6bbcd
--- /dev/null
+++ b/include/trace/events/mmu.h
@@ -0,0 +1,55 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mmu
+
+#if !defined(_TRACE_MMU_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MMU_H
+
+#include <linux/tracepoint.h>
+
+#ifdef CONFIG_MMU_NOTIFIER
+
+TRACE_EVENT(mmu_invalidate_page,
+
+	TP_PROTO(unsigned long addr),
+
+	TP_ARGS(addr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start	= addr;
+		__entry->end	= addr + PAGE_SIZE;
+	),
+
+	TP_printk("start=%lu end=%lu", __entry->start, __entry->end)
+);
+
+TRACE_EVENT(mmu_invalidate_range_start,
+
+	TP_PROTO(unsigned long start, unsigned long end),
+
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start	= start;
+		__entry->end	= end;
+	),
+
+	TP_printk("start=%lu end=%lu", __entry->start, __entry->end)
+);
+
+#endif /* CONFIG_MMU_NOTIFIER */
+
+#endif /* _TRACE_MMU_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 5f4ef02..685ffdc 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -17,6 +17,9 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mmu.h>
+
 /*
  * This function can't run concurrently against mmu_notifier_register
  * because mm->mm_users > 0 during mmu_notifier_register and exit_mmap
-- 
1.6.3

