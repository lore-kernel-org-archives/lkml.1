Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYGQH20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYGQH20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYGQH2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:28:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbYGQH2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:28:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 01/23] tracehook: add linux/tracehook.h
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080717072755.E2FBC15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:27:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the new kernel-internal header file <linux/tracehook.h>.
This is not yet used at all.  The comments in the header introduce
what the following series of patches is about.

The aim is to formalize and consolidate all the places that the core
kernel code and the arch code now ties into the ptrace implementation.

These patches mostly don't cause any functional change.  They just
move the details of ptrace logic out of core code into tracehook.h
inlines, where they are mostly compiled away to the same as before.
All that changes is that everything is thoroughly documented and any
future reworking of ptrace, or addition of something new, would not
have to touch core code all over, just change the tracehook.h inlines.

The new linux/ptrace.h inlines are used by the following patches in the
new tracehook_*() inlines.  Using these helpers for the ptrace event
stops makes it simple to change or disable the old ptrace implementation
of these stops conditionally later.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h    |   33 ++++++++++++++++++++++++++++
 include/linux/tracehook.h |   52 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index c6f5f9d..c74abfc 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -121,6 +121,39 @@ static inline void ptrace_unlink(struct task_struct *child)
 int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 
+/**
+ * task_ptrace - return %PT_* flags that apply to a task
+ * @task:	pointer to &task_struct in question
+ *
+ * Returns the %PT_* flags that apply to @task.
+ */
+static inline int task_ptrace(struct task_struct *task)
+{
+	return task->ptrace;
+}
+
+/**
+ * ptrace_event - possibly stop for a ptrace event notification
+ * @mask:	%PT_* bit to check in @current->ptrace
+ * @event:	%PTRACE_EVENT_* value to report if @mask is set
+ * @message:	value for %PTRACE_GETEVENTMSG to return
+ *
+ * This checks the @mask bit to see if ptrace wants stops for this event.
+ * If so we stop, reporting @event and @message to the ptrace parent.
+ *
+ * Returns nonzero if we did a ptrace notification, zero if not.
+ *
+ * Called without locks.
+ */
+static inline int ptrace_event(int mask, int event, unsigned long message)
+{
+	if (mask && likely(!(current->ptrace & mask)))
+		return 0;
+	current->ptrace_message = message;
+	ptrace_notify((event << 8) | SIGTRAP);
+	return 1;
+}
+
 #ifndef force_successful_syscall_return
 /*
  * System call handlers that, upon successful completion, need to return a
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
new file mode 100644
index 0000000..bea0f3e
--- /dev/null
+++ b/include/linux/tracehook.h
@@ -0,0 +1,52 @@
+/*
+ * Tracing hooks
+ *
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * This file defines hook entry points called by core code where
+ * user tracing/debugging support might need to do something.  These
+ * entry points are called tracehook_*().  Each hook declared below
+ * has a detailed kerneldoc comment giving the context (locking et
+ * al) from which it is called, and the meaning of its return value.
+ *
+ * Each function here typically has only one call site, so it is ok
+ * to have some nontrivial tracehook_*() inlines.  In all cases, the
+ * fast path when no tracing is enabled should be very short.
+ *
+ * The purpose of this file and the tracehook_* layer is to consolidate
+ * the interface that the kernel core and arch code uses to enable any
+ * user debugging or tracing facility (such as ptrace).  The interfaces
+ * here are carefully documented so that maintainers of core and arch
+ * code do not need to think about the implementation details of the
+ * tracing facilities.  Likewise, maintainers of the tracing code do not
+ * need to understand all the calling core or arch code in detail, just
+ * documented circumstances of each call, such as locking conditions.
+ *
+ * If the calling core code changes so that locking is different, then
+ * it is ok to change the interface documented here.  The maintainer of
+ * core code changing should notify the maintainers of the tracing code
+ * that they need to work out the change.
+ *
+ * Some tracehook_*() inlines take arguments that the current tracing
+ * implementations might not necessarily use.  These function signatures
+ * are chosen to pass in all the information that is on hand in the
+ * caller and might conceivably be relevant to a tracer, so that the
+ * core code won't have to be updated when tracing adds more features.
+ * If a call site changes so that some of those parameters are no longer
+ * already on hand without extra work, then the tracehook_* interface
+ * can change so there is no make-work burden on the core code.  The
+ * maintainer of core code changing should notify the maintainers of the
+ * tracing code that they need to work out the change.
+ */
+
+#ifndef _LINUX_TRACEHOOK_H
+#define _LINUX_TRACEHOOK_H	1
+
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+
+#endif	/* <linux/tracehook.h> */
