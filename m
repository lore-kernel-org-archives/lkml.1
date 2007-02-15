Return-Path: <linux-kernel-owner+w=401wt.eu-S1030219AbXBOQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219AbXBOQ71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966155AbXBOQ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:56:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966148AbXBOQ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:56:08 -0500
Date: Thu, 15 Feb 2007 17:52:04 +0100
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
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 01/14] syslets: add async.h include file, kernel-side API definitions
Message-ID: <20070215165204.GB4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_20 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0899]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add include/linux/async.h which contains the kernel-side API
declarations.

it also provides NOP stubs for the !CONFIG_ASYNC_SUPPORT case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

Index: linux/include/linux/async.h
===================================================================
--- /dev/null
+++ linux/include/linux/async.h
@@ -0,0 +1,96 @@
+#ifndef _LINUX_ASYNC_H
+#define _LINUX_ASYNC_H
+
+#include <linux/completion.h>
+#include <linux/compiler.h>
+
+/*
+ * The syslet subsystem - asynchronous syscall execution support.
+ *
+ * Generic kernel API definitions:
+ */
+
+struct syslet_uatom;
+struct async_thread;
+struct async_head;
+
+/*
+ * The syslet subsystem - asynchronous syscall execution support.
+ *
+ * Syslet-subsystem internal definitions:
+ */
+
+/*
+ * The kernel-side copy of a syslet atom - with arguments expanded:
+ */
+struct syslet_atom {
+	unsigned long				flags;
+	unsigned long				nr;
+	long __user				*ret_ptr;
+	struct syslet_uatom	__user		*next;
+	unsigned long				args[6];
+};
+
+/*
+ * The 'async head' is the thread which has user-space context (ptregs)
+ * 'below it' - this is the one that can return to user-space:
+ */
+struct async_head {
+	spinlock_t				lock;
+	struct task_struct			*user_task;
+
+	struct list_head			ready_async_threads;
+	struct list_head			busy_async_threads;
+
+	long					events_left;
+	wait_queue_head_t			wait;
+
+	struct async_head_user	__user		*ahu;
+	struct syslet_uatom	__user		**completion_ring;
+	unsigned long				curr_ring_idx;
+	unsigned long				max_ring_idx;
+	unsigned long				ring_size_bytes;
+
+	unsigned int				nr_threads;
+	unsigned int				max_nr_threads;
+
+	unsigned long		__user		*new_stack;
+	unsigned long				new_eip;
+	struct completion			start_done;
+	struct completion			exit_done;
+};
+
+/*
+ * The 'async thread' is either a newly created async thread or it is
+ * an 'ex-head' - it cannot return to user-space and only has kernel
+ * context.
+ */
+struct async_thread {
+	struct task_struct			*task;
+	struct syslet_uatom	__user		*work;
+	unsigned long				user_stack;
+	unsigned long				user_eip;
+	struct async_head			*ah;
+
+	struct list_head			entry;
+
+	unsigned int				exit;
+};
+
+#ifdef CONFIG_ASYNC_SUPPORT
+extern void async_init(struct task_struct *t);
+extern void async_exit(struct task_struct *t);
+extern void __async_schedule(struct task_struct *t);
+#else /* !CONFIG_ASYNC_SUPPORT */
+static inline void async_init(struct task_struct *t)
+{
+}
+static inline void async_exit(struct task_struct *t)
+{
+}
+static inline void __async_schedule(struct task_struct *t)
+{
+}
+#endif /* !CONFIG_ASYNC_SUPPORT */
+
+#endif
