Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXB0AL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXB0AL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXB0AL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:11:57 -0500
Received: from mga07.intel.com ([143.182.124.22]:42344 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965268AbXB0ALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:11:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,221,1170662400"; 
   d="scan'208"; a="187440847:sNHT23982896"
Message-Id: <20070227001605.424385110@sodium.jf.intel.com>
References: <20070227001338.344233745@sodium.jf.intel.com>
User-Agent: quilt/0.45-1
Date: Mon, 26 Feb 2007 16:13:39 -0800
From: inaky@linux.intel.com
To: Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/2] semaphores: Add down_interruptible_timeout()
Content-Disposition: inline; filename=semaphores-add-down-interruptible-timeout.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was in a situation where I could really simplify many things by
using down_interruptible() with a timeout. I went around looking for
how could one be implemented and ran away from the asm code in arch/.

At the end I realized I could make a simple one by setting up a timer
that would 'fake' a sigpending situation (setting the task's TIF_SIGPENDING
bit) so that the __down_interruptible_failed() path would quit when 
the timer went off.

I gave it a quick try (must admit, not too tested) and it seems that
the setting of TIF_SIGPENDING without really having a signal queued
is not having easily visible ugly consequences.

If the timeout arrives right after a signal was delivered but before
the thread returns from down_interruptible, then it will also look
like a timeout (as the code in the if statement will kick in) -- to
some extent, it is 'right' theoretically, as it didn't get the sem
before the time expired. TIF_SIGPENDING is still set, so the signal is
not lost (unless I miss something else about the signal delivery
engine).

IF the timeout arrives after the signal and after down_interruptible
returns, no side effects happen. There is a window where the timer
could still execute before it is deleted and it would look like a
timeout [which theoretically could be right too].  Maybe the result <
0 && data.result < 0 check should be done before
del_timer(). Suggestions accepted.

Arjan van de Ven suggested I moved the declaration into
asm-generic/semaphore.h to lay the egg for a saner sharing of
semaphore code between arches. This patch also introduces that witn
the down_interruptible_timeout() decl and the next adds the inclusion
to all the arches' semaphore.h [note: haven't been able to compile
test all of them, just i386].

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

---
 include/asm-generic/semaphore.h |   15 ++++++++++
 lib/semaphore-sleepers.c        |   60 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

Index: linux.hg/lib/semaphore-sleepers.c
===================================================================
--- linux.hg.orig/lib/semaphore-sleepers.c	2007-02-26 14:45:15.000000000 -0800
+++ linux.hg/lib/semaphore-sleepers.c	2007-02-26 14:46:36.000000000 -0800
@@ -174,3 +174,63 @@
 	spin_unlock_irqrestore(&sem->wait.lock, flags);
 	return 1;
 }
+
+
+struct dit_data
+{
+	struct task_struct *task;
+	int result;
+};
+
+
+/**
+ * dit_kick_process - set a fake 'signal pending' and kick
+ *
+ * Helper for down_interruptible_timeout(). Sets the signal pending
+ * flag on the task that is waiting for a semaphore and kicks it. That
+ * tells the down_interruptible() code to quit waiting.
+ */
+static
+void dit_kick_process(unsigned long _data)
+{
+	struct dit_data *data = (void *) _data;
+	set_tsk_thread_flag(data->task, TIF_SIGPENDING);
+	data->result = -ETIMEDOUT;
+	kick_process(data->task);
+}
+
+
+/*
+ * Interruptible try to acquire a semaphore.
+ *
+ * If we obtained it, return zero.  If we were interrupted, returns
+ * -EINTR. If we timedout, we return -ETIMEDOUT;
+ *
+ * Note the ugly hack, using a helper timer and function to wake up
+ * the waiter. We need to distinguish, if we get an error, if it was
+ * because we were woken up (-ETIMEDOUT) or for other reason (-EINTR),
+ * hence the last if block.
+ *
+ * There is some fine print if a signal arrives at a time close to the
+ * timeout, being the most confusing case if the timeout arrives AFTER
+ * the signal but before del_timer() get's called. In that case
+ * down_interruptible_timeout() will return -ETIMEDOUT even when the
+ * signal arrived first. However, the signal pending condition is not
+ * cleared.
+ */
+int down_interruptible_timeout(struct semaphore *sem, unsigned long to)
+{
+	int result;
+	struct dit_data data = {
+		.task = get_current(), .result = 0
+	};
+	DEFINE_TIMER(dit_timer, dit_kick_process, to, (unsigned long) &data);
+	add_timer(&dit_timer);
+	result = down_interruptible(sem);
+	del_timer(&dit_timer);
+	if (result < 0 && data.result < 0)
+		result = data.result;
+	return result;
+}
+EXPORT_SYMBOL_GPL(down_interruptible_timeout);
+
Index: linux.hg/include/asm-generic/semaphore.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.hg/include/asm-generic/semaphore.h	2007-02-26 14:46:36.000000000 -0800
@@ -0,0 +1,32 @@
+/*
+ * Generic code for semaphores
+ *
+ * Copyright (C) 2007 Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
+ *   - down_interruptible_timeout()'s implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+#ifndef _GENERIC_SEMAPHORE_H
+#define _GENERIC_SEMAPHORE_H
+
+#ifdef __KERNEL__
+
+struct semaphore;
+extern void down_timeout_interruptible(struct semaphore *);
+
+#endif /* #ifdef __KERNEL__ */
+
+#endif /* #define _GENERIC_SEMAPHORE_H */

--

Inaky
