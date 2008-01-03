Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYACBJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYACBJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbYACBIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:08:44 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:51267 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810AbYACBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a2XsQA/d/4TFdNPgyZbSz1GbHg17l70/iTGo17wEVXEKYsUe1M2vr2VhVD63MvwDnSTUaFxEkE1ld87JpYh4YF5yQJaTtjkd1ytQb39PTD9OYsfH3LCE6E8JzHfjXbLsaj08rj3zyRyXpBzuXhf6wYqftjrOskun+7xNOhtY11g=
Subject: [PATCH] x86: Use is_kprobe_fault to better match usage
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, qbarnes <qbarnes@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 17:05:23 -0800
Message-Id: <1199322323.6323.76.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the notify_page_fault helper is used to test it the page
fault was caused by a kprobe causing an early return from do_page_fault.

Change the name of the helper to is_kprobe_fault to match the usage and
remove the preempt_disable/enable pair around kprobe_running() with an
explicit test for preemption.  The idea for this comes from a patch
by Quentin Barnes to kprobes.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this may not be functionally equivalent, feel free to yank it out
if there is any trouble, but from what I've seen it should be OK.

Did you ever find a good kprobes test?

 arch/x86/mm/fault_32.c |   30 ++++++++++++++----------------
 arch/x86/mm/fault_64.c |   30 ++++++++++++++----------------
 2 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 051a4ec..5c48cc2 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -12,6 +12,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
+#include <linux/hardirq.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/tty.h>
@@ -42,23 +43,20 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-static inline int notify_page_fault(struct pt_regs *regs)
+static inline int is_kprobe_fault(struct pt_regs *regs)
 {
-#ifdef CONFIG_KPROBES
 	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode_vm(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-#else
-	return 0;
+#ifdef CONFIG_KPROBES
+	/*
+	 * If it is a kprobe fault we can not be premptible so return before
+	 * calling kprobe_running() as it will assert on smp_processor_id if
+	 * preemption is enabled.
+	 */
+	if (!user_mode_vm(regs) && !preemptible() && kprobe_running() &&
+	    kprobe_fault_handler(regs, 14))
+		ret = 1;
 #endif
+	return ret;
 }
 
 #ifdef CONFIG_X86_32
@@ -428,7 +426,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 				return;
 		}
 #endif
-		if (notify_page_fault(regs))
+		if (is_kprobe_fault(regs))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -437,7 +435,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (is_kprobe_fault(regs))
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 97b92b6..09008e5 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -13,6 +13,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
+#include <linux/hardirq.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/tty.h>
@@ -45,23 +46,20 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-static inline int notify_page_fault(struct pt_regs *regs)
+static inline int is_kprobe_fault(struct pt_regs *regs)
 {
-#ifdef CONFIG_KPROBES
 	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
-#else
-	return 0;
+#ifdef CONFIG_KPROBES
+	/*
+	 * If it is a kprobe fault we can not be premptible so return before
+	 * calling kprobe_running() as it will assert on smp_processor_id if
+	 * preemption is enabled.
+	 */
+	if (!user_mode_vm(regs) && !preemptible() && kprobe_running() &&
+	    kprobe_fault_handler(regs, 14))
+		ret = 1;
 #endif
+	return ret;
 }
 
 #ifdef CONFIG_X86_32
@@ -478,7 +476,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 				return;
 		}
 #endif
-		if (notify_page_fault(regs))
+		if (is_kprobe_fault(regs))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -487,7 +485,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (is_kprobe_fault(regs))
 		return;
 
 	if (likely(regs->flags & X86_EFLAGS_IF))
-- 
1.5.4.rc2.1097.gb6e0d



