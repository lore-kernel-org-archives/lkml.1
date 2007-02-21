Return-Path: <linux-kernel-owner+w=401wt.eu-S1423165AbXBUVYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423165AbXBUVYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423144AbXBUVYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:24:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423150AbXBUVUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:20:52 -0500
Date: Wed, 21 Feb 2007 22:15:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 08/13] syslets: x86, add move_user_context() method
Message-ID: <20070221211537.GH7579@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add the move_user_context() method to move the user-space
context of one kernel thread to another kernel thread.
User-space might notice the changed TID, but execution,
stack and register contents (general purpose and FPU) are
still the same.

An architecture must implement this interface before it can turn
CONFIG_ASYNC_SUPPORT on.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/kernel/process.c |   21 +++++++++++++++++++++
 include/asm-i386/system.h  |    7 +++++++
 2 files changed, 28 insertions(+)

Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -820,6 +820,27 @@ unsigned long get_wchan(struct task_stru
 }
 
 /*
+ * Move user-space context from one kernel thread to another.
+ * This includes registers and FPU state. Callers must make
+ * sure that neither task is running user context at the moment:
+ */
+void
+move_user_context(struct task_struct *new_task, struct task_struct *old_task)
+{
+	struct pt_regs *old_regs = task_pt_regs(old_task);
+	struct pt_regs *new_regs = task_pt_regs(new_task);
+	union i387_union *tmp;
+
+	*new_regs = *old_regs;
+	/*
+	 * Flip around the FPU state too:
+	 */
+	tmp = new_task->thread.i387;
+	new_task->thread.i387 = old_task->thread.i387;
+	old_task->thread.i387 = tmp;
+}
+
+/*
  * sys_alloc_thread_area: get a yet unused TLS descriptor index.
  */
 static int get_free_idx(void)
Index: linux/include/asm-i386/system.h
===================================================================
--- linux.orig/include/asm-i386/system.h
+++ linux/include/asm-i386/system.h
@@ -33,6 +33,13 @@ extern struct task_struct * FASTCALL(__s
 		      "2" (prev), "d" (next));				\
 } while (0)
 
+/*
+ * Move user-space context from one kernel thread to another.
+ * This includes registers and FPU state for now:
+ */
+extern void
+move_user_context(struct task_struct *new_task, struct task_struct *old_task);
+
 #define _set_base(addr,base) do { unsigned long __pr; \
 __asm__ __volatile__ ("movw %%dx,%1\n\t" \
 	"rorl $16,%%edx\n\t" \
