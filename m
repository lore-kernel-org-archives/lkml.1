Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZHaRIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZHaRIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZHaRIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:08:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:32931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbZHaRIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:08:36 -0400
Date: Mon, 31 Aug 2009 17:07:41 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, ehrhardt@linux.vnet.ibm.com, arnd@arndb.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       zippel@linux-m68k.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, paulus@samba.org, horsth@linux.vnet.ibm.com,
       davem@davemloft.net, benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       ehrhardt@linux.vnet.ibm.com, arnd@arndb.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       horsth@linux.vnet.ibm.com, davem@davemloft.net,
       benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090831124417.329662275@de.ibm.com>
References: <20090831124417.329662275@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, m68k: Calculate thread_info offset with asm offset
Message-ID: <tip-0ee000e5e8fa2e5c760250be0d78d5906e3eb94b@git.kernel.org>
Git-Commit-ID: 0ee000e5e8fa2e5c760250be0d78d5906e3eb94b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:07:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ee000e5e8fa2e5c760250be0d78d5906e3eb94b
Gitweb:     http://git.kernel.org/tip/0ee000e5e8fa2e5c760250be0d78d5906e3eb94b
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:49 +0200

locking, m68k: Calculate thread_info offset with asm offset

m68k has the thread_info structure embedded in its task struct.
Therefore its not possible to implement current_thread_info()
by looking at the stack pointer and do some simple calculations
like most other architectures do it.

To return the thread_info pointer for a task two defines are
used. This works until the spinlock function bodies get moved
into an own header file and CONFIG_SPINLOCK_DEBUG is turned on.
That results into this compile error:

  In file included from include/linux/spinlock.h:378,
                   from include/linux/seqlock.h:29,
                   from include/linux/time.h:8,
                   from include/linux/timex.h:56,
                   from include/linux/sched.h:54,
                   from arch/m68k/kernel/asm-offsets.c:12:
  include/linux/spinlock_api_smp.h: In function '__spin_unlock_irq':
  include/linux/spinlock_api_smp.h:371: error: 'current' undeclared (first use in this function)
  include/linux/spinlock_api_smp.h:371: error: (Each undeclared identifier is reported only once
  include/linux/spinlock_api_smp.h:371: error: for each function it appears in.)

Including asm/current.h to asm-offsets.c wouldn't help since
the definition of struct task is needed. So we end up with ugly
header file include dependencies.

To solve this calculate the offset of the thread_info structure
into the task struct in asm-offsets.h and use the offset in
task_thread_info(). This works just like it does for IA64 as
well.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <linux-arch@vger.kernel.org>
LKML-Reference: <20090831124417.329662275@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/m68k/include/asm/thread_info_mm.h |   11 ++++++++++-
 arch/m68k/kernel/asm-offsets.c         |    5 +++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
index 6ea5c33..b6da388 100644
--- a/arch/m68k/include/asm/thread_info_mm.h
+++ b/arch/m68k/include/asm/thread_info_mm.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_M68K_THREAD_INFO_H
 #define _ASM_M68K_THREAD_INFO_H
 
+#ifndef ASM_OFFSETS_C
+#include <asm/asm-offsets.h>
+#endif
+#include <asm/current.h>
 #include <asm/types.h>
 #include <asm/page.h>
 
@@ -31,7 +35,12 @@ struct thread_info {
 #define init_thread_info	(init_task.thread.info)
 #define init_stack		(init_thread_union.stack)
 
-#define task_thread_info(tsk)	(&(tsk)->thread.info)
+#ifdef ASM_OFFSETS_C
+#define task_thread_info(tsk)	((struct thread_info *) NULL)
+#else
+#define task_thread_info(tsk)	((struct thread_info *)((char *)tsk+TASK_TINFO))
+#endif
+
 #define task_stack_page(tsk)	((tsk)->stack)
 #define current_thread_info()	task_thread_info(current)
 
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index 0cffab8..25d6b72 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -8,6 +8,8 @@
  * #defines from the assembly-language output.
  */
 
+#define ASM_OFFSETS_C
+
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
@@ -27,6 +29,9 @@ int main(void)
 	DEFINE(TASK_INFO, offsetof(struct task_struct, thread.info));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
 	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
+#ifdef CONFIG_MMU
+	DEFINE(TASK_TINFO, offsetof(struct task_struct, thread.info));
+#endif
 
 	/* offsets into the thread struct */
 	DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
