Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZCMQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZCMQdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbZCMQar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:47 -0400
Received: from gw.goop.org ([64.81.55.164]:56787 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759063AbZCMQap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/15] x86: don't need "changed" parameter for set_io_bitmap()
Date: Fri, 13 Mar 2009 09:29:56 -0700
Message-Id: <1236961796-13407-16-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236961796-13407-1-git-send-email-jeremy@goop.org>
References: <1236961796-13407-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The "changed" parameter isn't really used, so don't bother passing it.
(xen_set_io_bitmap can keep track of it for itself, if it wants.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h  |    6 +++---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/ioport.c         |    9 +++------
 arch/x86/kernel/process.c        |    4 ++--
 arch/x86/xen/enlighten.c         |    5 +----
 5 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 02dad4e..b0cea28 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -157,7 +157,7 @@ struct pv_cpu_ops {
 
 	void (*set_iopl_mask)(unsigned mask);
 	void (*set_io_bitmap)(struct thread_struct *thread,
-	                      int changed, unsigned long bytes_updated);
+	                      unsigned long bytes_updated);
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
@@ -1005,9 +1005,9 @@ static inline void set_iopl_mask(unsigned mask)
 	PVOP_VCALL1(pv_cpu_ops.set_iopl_mask, mask);
 }
 static inline void set_io_bitmap(struct thread_struct *thread,
-                                 int changed, unsigned long bytes_updated)
+                                 unsigned long bytes_updated)
 {
-	PVOP_VCALL3(pv_cpu_ops.set_io_bitmap, thread, changed, bytes_updated);
+	PVOP_VCALL2(pv_cpu_ops.set_io_bitmap, thread, bytes_updated);
 }
 
 /* The paravirtualized I/O functions */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 86b90c8..f98d39b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -536,7 +536,7 @@ static inline void native_set_iopl_mask(unsigned mask)
 }
 
 extern void native_set_io_bitmap(struct thread_struct *thread,
-                                 int changed, unsigned long updated_bytes);
+                                 unsigned long updated_bytes);
 
 static inline void
 native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 55eebd2..040913e 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -31,7 +31,7 @@ static void set_bitmap(unsigned long *bitmap, unsigned int base,
 }
 
 void native_set_io_bitmap(struct thread_struct *t,
-                          int changed, unsigned long bytes_updated)
+                          unsigned long bytes_updated)
 {
 	struct tss_struct *tss;
 
@@ -54,7 +54,6 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 {
 	struct thread_struct *t = &current->thread;
 	unsigned int i, max_long, bytes, bytes_updated;
-	int changed;
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
@@ -75,9 +74,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 		memset(bitmap, 0xff, IO_BITMAP_BYTES);
 		t->io_bitmap_ptr = bitmap;
 		set_thread_flag(TIF_IO_BITMAP);
-		changed = 1;
-	} else
-		changed = 0;
+	}
 
 	/*
 	 * do it in the per-thread copy
@@ -103,7 +100,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	t->io_bitmap_max = bytes;
 
-	set_io_bitmap(t, changed, bytes_updated);
+	set_io_bitmap(t, bytes_updated);
 
 	preempt_enable();
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ba55f09..fbf0aae 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -74,7 +74,7 @@ void exit_thread(void)
 		kfree(t->io_bitmap_ptr);
 		t->io_bitmap_ptr = NULL;
 		clear_thread_flag(TIF_IO_BITMAP);
-		set_io_bitmap(t, 1, t->io_bitmap_max);
+		set_io_bitmap(t, t->io_bitmap_max);
 		t->io_bitmap_max = 0;
 		preempt_enable();
 	}
@@ -208,7 +208,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 
 	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP) ||
 	    test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
-		set_io_bitmap(next, 1,
+		set_io_bitmap(next,
 		              max(prev->io_bitmap_max, next->io_bitmap_max));
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 61ce3ae..f673cd8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -569,13 +569,10 @@ static void xen_set_iopl_mask(unsigned mask)
 }
 
 static void xen_set_io_bitmap(struct thread_struct *thread,
-                              int changed, unsigned long bytes_updated)
+                              unsigned long bytes_updated)
 {
 	struct physdev_set_iobitmap set_iobitmap;
 
-	if (!changed)
-		return;
-
 	set_xen_guest_handle(set_iobitmap.bitmap,
 	                     (char *)thread->io_bitmap_ptr);
 	set_iobitmap.nr_ports = thread->io_bitmap_ptr ? IO_BITMAP_BITS : 0;
-- 
1.6.0.6

