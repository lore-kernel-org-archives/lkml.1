Return-Path: <linux-kernel-owner+w=401wt.eu-S966144AbXBOQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966144AbXBOQzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966145AbXBOQzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:55:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966144AbXBOQzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:55:36 -0500
Date: Thu, 15 Feb 2007 17:52:15 +0100
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
Subject: [patch 02/14] syslets: add syslet.h include file, user API/ABI definitions
Message-ID: <20070215165215.GC4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

add include/linux/syslet.h which contains the user-space API/ABI
declarations. Add the new header to include/linux/Kbuild as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/Kbuild   |    1 
 include/linux/syslet.h |  143 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

Index: linux/include/linux/Kbuild
===================================================================
--- linux.orig/include/linux/Kbuild
+++ linux/include/linux/Kbuild
@@ -140,6 +140,7 @@ header-y += sockios.h
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
@@ -0,0 +1,143 @@
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
+	unsigned long				flags;
+	unsigned long				nr;
+	long __user				*ret_ptr;
+	struct syslet_uatom	__user		*next;
+	unsigned long		__user		*arg_ptr[6];
+	/*
+	 * User-space can put anything in here, kernel will not
+	 * touch it:
+	 */
+	void __user				*private;
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
+ * ring. This gets registered via sys_async_register().
+ */
+struct async_head_user {
+	/*
+	 * Pointers to completed async syslets (i.e. syslets that
+	 * generated a cachemiss and went async, returning -EASYNCSYSLET
+	 * to the user context by sys_async_exec()) are queued here.
+	 * Syslets that were executed synchronously are not queued here.
+	 *
+	 * Note: the final atom that generated the exit condition is
+	 * queued here. Normally this would be the last atom of a syslet.
+	 */
+	struct syslet_uatom __user		**completion_ring;
+	/*
+	 * Ring size in bytes:
+	 */
+	unsigned long				ring_size_bytes;
+
+	/*
+	 * Maximum number of asynchronous contexts the kernel creates.
+	 *
+	 * -1UL has a special meaning: the kernel manages the optimal
+	 * size of the async pool.
+	 *
+	 * Note: this field should be valid for the lifetime of async
+	 * processing, because future kernels detect changes to this
+	 * field. (enabling user-space to control the size of the async
+	 * pool in a low-overhead fashion)
+	 */
+	unsigned long				max_nr_threads;
+	/*
+	 * The head task can become a cachemiss thread later on
+	 * too, if it blocks - so it needs its separate thread
+	 * stack and start address too:
+	 */
+	unsigned long				head_stack;
+	unsigned long				head_eip;
+};
+
+#endif
