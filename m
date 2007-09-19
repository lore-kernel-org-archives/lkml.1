Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXISRDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXISRDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXISRDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:03:06 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53141 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbXISRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:03:05 -0400
Date: Wed, 19 Sep 2007 13:02:22 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/11] UML - Eliminate hz()
Message-ID: <20070919170222.GA10161@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate hz() since its only purpose was to provide a kernel-space
constant to userspace code.  This can be done instead by providing the
constant directly through kernel_constants.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/common-offsets.h |    2 ++
 arch/um/include/kern_util.h      |    1 -
 arch/um/kernel/time.c            |    5 -----
 arch/um/os-Linux/skas/process.c  |    5 +++--
 arch/um/os-Linux/time.c          |    7 +++----
 5 files changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6.20/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.20.orig/arch/um/include/common-offsets.h	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/include/common-offsets.h	2007-09-19 12:25:05.000000000 -0400
@@ -32,3 +32,5 @@ DEFINE(UM_GFP_ATOMIC, GFP_ATOMIC);
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
 
 DEFINE(UM_THREAD_SIZE, THREAD_SIZE);
+
+DEFINE(UM_HZ, HZ);
Index: linux-2.6.20/arch/um/include/kern_util.h
===================================================================
--- linux-2.6.20.orig/arch/um/include/kern_util.h	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/include/kern_util.h	2007-09-19 12:25:05.000000000 -0400
@@ -64,7 +64,6 @@ extern void paging_init(void);
 extern void init_flush_vm(void);
 extern void *syscall_sp(void *t);
 extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
-extern int hz(void);
 extern unsigned int do_IRQ(int irq, struct uml_pt_regs *regs);
 extern void interrupt_end(void);
 extern void initial_thread_cb(void (*proc)(void *), void *arg);
Index: linux-2.6.20/arch/um/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/time.c	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/time.c	2007-09-19 12:25:05.000000000 -0400
@@ -11,11 +11,6 @@
 #include "kern_util.h"
 #include "os.h"
 
-int hz(void)
-{
-	return HZ;
-}
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
Index: linux-2.6.20/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/skas/process.c	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/skas/process.c	2007-09-19 12:25:05.000000000 -0400
@@ -392,8 +392,9 @@ int copy_context_skas0(unsigned long new
 	*data = ((struct stub_data) { .offset	= MMAP_OFFSET(new_offset),
 				      .fd	= new_fd,
 				      .timer    = ((struct itimerval)
-					            { { 0, 1000000 / hz() },
-						      { 0, 1000000 / hz() }})});
+					            { { 0, 1000000 / UM_HZ },
+						      { 0, 1000000 / UM_HZ }})
+				 });
 	err = ptrace_setregs(pid, thread_regs);
 	if (err < 0)
 		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
Index: linux-2.6.20/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/time.c	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/time.c	2007-09-19 12:25:05.000000000 -0400
@@ -8,14 +8,13 @@
 #include <signal.h>
 #include <time.h>
 #include <sys/time.h>
-#include "kern_util.h"
 #include "kern_constants.h"
 #include "os.h"
 #include "user.h"
 
 int set_interval(int is_virtual)
 {
-	int usec = 1000000/hz();
+	int usec = 1000000/UM_HZ;
 	int timer_type = is_virtual ? ITIMER_VIRTUAL : ITIMER_REAL;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
@@ -43,8 +42,8 @@ void disable_timer(void)
 void switch_timers(int to_real)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable = ((struct itimerval) { { 0, 1000000/hz() },
-							{ 0, 1000000/hz() }});
+	struct itimerval enable = ((struct itimerval) { { 0, 1000000/UM_HZ },
+							{ 0, 1000000/UM_HZ }});
 	int old, new;
 
 	if (to_real) {
