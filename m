Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbXB1VsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbXB1VsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbXB1VsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:48:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbXB1VsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:48:15 -0500
Date: Wed, 28 Feb 2007 22:41:17 +0100
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
Subject: [patch 02/12] syslets: add syslet.h include file, user API/ABI definitions
Message-ID: <20070228214117.GB2305@elte.hu>
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

add include/linux/syslet.h which contains the user-space API/ABI
declarations. Add the new header to include/linux/Kbuild as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/Kbuild   |    1 
 include/linux/syslet.h |  155 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 156 insertions(+)

Index: linux/include/linux/Kbuild
===================================================================
--- linux.orig/include/linux/Kbuild
+++ linux/include/linux/Kbuild
@@ -141,6 +141,7 @@ header-y += sockios.h
 header-y += som.h
 header-y += sound.h
 header-y += synclink.h
+header-y += syslet.h
 header-y += telephony.h
 header-y += termios.h
 header-y += ticable.h
Index: linux/include/linux/syslet.h
===================================================================
--- /dev/null
+++ linux/include/linux/syslet.h
@@ -0,0 +1,155 @@
+#ifndef _LINUX_SYSLET_H
+#define _LINUX_SYSLET_H
+/*
+ * The syslet subsystem - asynchronous syscall execution support.
+ *
+ * Started by Ingo Molnar:
+ *
+ *  Copyright (C) 2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *
+ * User-space API/ABI definitions:
+ */
+
+#ifndef __user
+# define __user
+#endif
+
+/*
+ * This is the 'Syslet Atom' - the basic unit of execution
+ * within the syslet framework. A syslet always represents
+ * a single system-call plus its arguments, plus has conditions
+ * attached to it that allows the construction of larger
+ * programs from these atoms. User-space variables can be used
+ * (for example a loop index) via the special sys_umem*() syscalls.
+ *
+ * Arguments are implemented via pointers to arguments. This not
+ * only increases the flexibility of syslet atoms (multiple syslets
+ * can share the same variable for example), but is also an
+ * optimization: copy_uatom() will only fetch syscall parameters
+ * up until the point it meets the first NULL pointer. 50% of all
+ * syscalls have 2 or less parameters (and 90% of all syscalls have
+ * 4 or less parameters).
+ *
+ * [ Note: since the argument array is at the end of the atom, and the
+ *   kernel will not touch any argument beyond the final NULL one, atoms
+ *   might be packed more tightly. (the only special case exception to
+ *   this rule would be SKIP_TO_NEXT_ON_STOP atoms, where the kernel will
+ *   jump a full syslet_uatom number of bytes.) ]
+ */
+struct syslet_uatom {
+	u32		flags;
+	u32		nr;
+	u64		ret_ptr;
+	u64		next;
+	u64		arg_ptr[6];
+	/*
+	 * User-space can put anything in here, kernel will not
+	 * touch it:
+	 */
+	u64		private;
+};
+
+/*
+ * Flags to modify/control syslet atom behavior:
+ */
+
+/*
+ * Immediately queue this syslet asynchronously - do not even
+ * attempt to execute it synchronously in the user context:
+ */
+#define SYSLET_ASYNC				0x00000001
+
+/*
+ * Never queue this syslet asynchronously - even if synchronous
+ * execution causes a context-switching:
+ */
+#define SYSLET_SYNC				0x00000002
+
+/*
+ * Do not queue the syslet in the completion ring when done.
+ *
+ * ( the default is that the final atom of a syslet is queued
+ *   in the completion ring. )
+ *
+ * Some syscalls generate implicit completion events of their
+ * own.
+ */
+#define SYSLET_NO_COMPLETE			0x00000004
+
+/*
+ * Execution control: conditions upon the return code
+ * of the just executed syslet atom. 'Stop' means syslet
+ * execution is stopped and the atom is put into the
+ * completion ring:
+ */
+#define SYSLET_STOP_ON_NONZERO			0x00000008
+#define SYSLET_STOP_ON_ZERO			0x00000010
+#define SYSLET_STOP_ON_NEGATIVE			0x00000020
+#define SYSLET_STOP_ON_NON_POSITIVE		0x00000040
+
+#define SYSLET_STOP_MASK				\
+	(	SYSLET_STOP_ON_NONZERO		|	\
+		SYSLET_STOP_ON_ZERO		|	\
+		SYSLET_STOP_ON_NEGATIVE		|	\
+		SYSLET_STOP_ON_NON_POSITIVE		)
+
+/*
+ * Special modifier to 'stop' handling: instead of stopping the
+ * execution of the syslet, the linearly next syslet is executed.
+ * (Normal execution flows along atom->next, and execution stops
+ *  if atom->next is NULL or a stop condition becomes true.)
+ *
+ * This is what allows true branches of execution within syslets.
+ */
+#define SYSLET_SKIP_TO_NEXT_ON_STOP		0x00000080
+
+/*
+ * This is the (per-user-context) descriptor of the async completion
+ * ring. This gets passed in to sys_async_exec():
+ */
+struct async_head_user {
+	/*
+	 * Current completion ring index - managed by the kernel:
+	 */
+	u64		kernel_ring_idx;
+	/*
+	 * User-side ring index:
+	 */
+	u64		user_ring_idx;
+
+	/*
+	 * Ring of pointers to completed async syslets (i.e. syslets that
+	 * generated a cachemiss and went async, returning -EASYNCSYSLET
+	 * to the user context by sys_async_exec()) are queued here.
+	 * Syslets that were executed synchronously (cached) are not
+	 * queued here.
+	 *
+	 * Note: the final atom that generated the exit condition is
+	 * queued here. Normally this would be the last atom of a syslet.
+	 */
+	u64		completion_ring_ptr;
+
+	/*
+	 * Ring size in bytes:
+	 */
+	u64		ring_size_bytes;
+
+	/*
+	 * The head task can become a cachemiss thread later on
+	 * too, if it blocks - so it needs its separate thread
+	 * stack and start address too:
+	 */
+	u64		head_stack;
+	u64		head_ip;
+
+	/*
+	 * Newly started async kernel threads will take their
+	 * user stack and user start address from here. User-space
+	 * code has to check for new_thread_stack going to NULL
+	 * and has to refill it with a new stack if that happens.
+	 */
+	u64		new_thread_stack;
+	u64		new_thread_ip;
+};
+
+#endif
