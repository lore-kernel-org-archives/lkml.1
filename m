Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXB1VsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXB1VsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbXB1VsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:48:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbXB1VsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:48:09 -0500
Date: Wed, 28 Feb 2007 22:41:03 +0100
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
Subject: [patch 01/12] syslets: add async.h include file, kernel-side API definitions
Message-ID: <20070228214103.GA2305@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228213938.GA945@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add include/linux/async.h which contains the kernel-side API
declarations.

it also provides NOP stubs for the !CONFIG_ASYNC_SUPPORT case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

Index: linux/include/linux/async.h
===================================================================
--- /dev/null
+++ linux/include/linux/async.h
@@ -0,0 +1,88 @@
+#ifndef _LINUX_ASYNC_H
+#define _LINUX_ASYNC_H
+
+#include <linux/completion.h>
+#include <linux/compiler.h>
+#include <linux/syslet.h>
+#include <asm/unistd.h>
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
+	syscall_fn_t				*call_table;
+	unsigned int				nr_syscalls;
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
+	struct mutex				completion_lock;
+	long					events_left;
+	wait_queue_head_t			wait;
+
+	struct async_head_user	__user		*ahu;
+
+	unsigned long		__user		*new_stackp;
+	unsigned long				new_ip;
+	unsigned long				restore_stack;
+	unsigned long				restore_ip;
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
+	unsigned long				user_stack;
+	unsigned long				user_ip;
+	struct async_head			*ah;
+
+	struct list_head			entry;
+
+	unsigned int				exit;
+};
+
+/*
+ * Generic kernel API definitions:
+ */
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
