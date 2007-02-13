Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXBMOXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXBMOXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbXBMOXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:23:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbXBMOXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:23:22 -0500
Date: Tue, 13 Feb 2007 15:20:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 04/11] syslets: core, data structures
Message-ID: <20070213142031.GE638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060529212109.GA2058@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

this adds the data structures used by the syslet / async system calls
infrastructure.

This is used only if CONFIG_ASYNC_SUPPORT is enabled.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.h |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

Index: linux/kernel/async.h
===================================================================
--- /dev/null
+++ linux/kernel/async.h
@@ -0,0 +1,58 @@
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
+	unsigned long				events_left;
+	wait_queue_head_t			wait;
+
+	struct async_head_user	__user		*uah;
+	struct syslet_uatom	__user		**completion_ring;
+	unsigned long				curr_ring_idx;
+	unsigned long				max_ring_idx;
+	unsigned long				ring_size_bytes;
+
+	unsigned int				nr_threads;
+	unsigned int				max_nr_threads;
+
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
+	struct async_head			*ah;
+
+	struct list_head			entry;
+
+	unsigned int				exit;
+};
