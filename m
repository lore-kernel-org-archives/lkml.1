Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYBSOXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYBSOXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYBSOX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:23:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYBSOX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:23:26 -0500
Date: Tue, 19 Feb 2008 15:22:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vgoyal@redhat.com, rostedt@goodmis.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ftrace and kexec
Message-ID: <20080219142239.GE9965@elte.hu>
References: <20080219132746.GC13780@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219132746.GC13780@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Hi,
> 
> I've been running ftrace on the sched-devel tree. I just built a 
> kernel and tried rebooting using kexec and I get this,

hm, it's not a good idea to keep using the data structures of the tracer 
while we kexec. Does the patch below resolve the problem?

	Ingo

-------------------------->
Subject: x86: patches/ftrace-kexec-fix.patch
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Feb 19 15:13:56 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/machine_kexec_32.c |    4 ++++
 arch/x86/kernel/machine_kexec_64.c |    4 ++++
 include/linux/ftrace.h             |    7 +++++++
 3 files changed, 15 insertions(+)

Index: linux/arch/x86/kernel/machine_kexec_32.c
===================================================================
--- linux.orig/arch/x86/kernel/machine_kexec_32.c
+++ linux/arch/x86/kernel/machine_kexec_32.c
@@ -11,6 +11,8 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/numa.h>
+#include <linux/ftrace.h>
+
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -107,6 +109,8 @@ NORET_TYPE void machine_kexec(struct kim
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
 
+	tracer_disable();
+
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
Index: linux/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux/arch/x86/kernel/machine_kexec_64.c
@@ -11,6 +11,8 @@
 #include <linux/string.h>
 #include <linux/reboot.h>
 #include <linux/numa.h>
+#include <linux/ftrace.h>
+
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -184,6 +186,8 @@ NORET_TYPE void machine_kexec(struct kim
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
 
+	tracer_disable();
+
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
Index: linux/include/linux/ftrace.h
===================================================================
--- linux.orig/include/linux/ftrace.h
+++ linux/include/linux/ftrace.h
@@ -68,6 +68,13 @@ extern void ftrace_call(void);
 extern void mcount_call(void);
 #endif
 
+static inline void tracer_disable(void)
+{
+#ifdef CONFIG_FTRACE
+	ftrace_enabled = 0;
+#endif
+}
+
 #ifdef CONFIG_FRAME_POINTER
 /* TODO: need to fix this for ARM */
 # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
