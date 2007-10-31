Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbXJaV7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbXJaV7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbXJaV7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:59:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbXJaV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:59:05 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/7] consolidate spinlock.h
Date: Wed, 31 Oct 2007 16:13:14 -0300
Message-Id: <11938580111179-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938580063444-git-send-email-gcosta@redhat.com>
References: <1193857999499-git-send-email-gcosta@redhat.com> <11938580063444-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cli and sti instructions need to be replaced by paravirt hooks.
For the i386 architecture, this is already done. The code requirements
aren't much different from x86_64 POV, so this part is consolidated in
the common header

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/spinlock.h    |   14 ++++++++++++++
 include/asm-x86/spinlock_32.h |    9 ---------
 include/asm-x86/spinlock_64.h |    8 +++++---
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
index d74d85e..e1d555a 100644
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -1,5 +1,19 @@
+#ifndef _X86_SPINLOCK_H_
+#define _X86_SPINLOCK_H_
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define CLI_STRING	"cli"
+#define STI_STRING	"sti"
+#define CLI_STI_CLOBBERS
+#define CLI_STI_INPUT_ARGS
+#endif /* CONFIG_PARAVIRT */
+
 #ifdef CONFIG_X86_32
 # include "spinlock_32.h"
 #else
 # include "spinlock_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/spinlock_32.h b/include/asm-x86/spinlock_32.h
index d3bcebe..ebbf371 100644
--- a/include/asm-x86/spinlock_32.h
+++ b/include/asm-x86/spinlock_32.h
@@ -7,15 +7,6 @@
 #include <asm/processor.h>
 #include <linux/compiler.h>
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define CLI_STRING	"cli"
-#define STI_STRING	"sti"
-#define CLI_STI_CLOBBERS
-#define CLI_STI_INPUT_ARGS
-#endif /* CONFIG_PARAVIRT */
-
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
diff --git a/include/asm-x86/spinlock_64.h b/include/asm-x86/spinlock_64.h
index 88bf981..e56b17e 100644
--- a/include/asm-x86/spinlock_64.h
+++ b/include/asm-x86/spinlock_64.h
@@ -48,12 +48,12 @@ static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long fla
 		"jns 5f\n"
 		"testl $0x200, %1\n\t"	/* interrupts were disabled? */
 		"jz 4f\n\t"
-	        "sti\n"
+		STI_STRING "\n"
 		"3:\t"
 		"rep;nop\n\t"
 		"cmpl $0, %0\n\t"
 		"jle 3b\n\t"
-		"cli\n\t"
+		CLI_STRING "\n\t"
 		"jmp 1b\n"
 		"4:\t"
 		"rep;nop\n\t"
@@ -61,7 +61,9 @@ static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long fla
 		"jg 1b\n\t"
 		"jmp 4b\n"
 		"5:\n\t"
-		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
+		: "+m" (lock->slock)
+		: "r" ((unsigned)flags) CLI_STI_INPUT_ARGS
+		: "memory" CLI_STI_CLOBBERS);
 }
 #endif
 
-- 
1.4.4.2

