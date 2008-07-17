Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYGQHaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYGQHaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYGQH3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:29:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbYGQH3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:29:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 06/23] tracehook: vfork-done
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Shopping-List: (1) Mexican Ambition guilt
   (2) Nonsensical ablutions
   (3) Stimulating surprise ashes
   (4) Giant beef checks
Message-Id: <20080717072906.45D9815422E@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:29:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the PTRACE_EVENT_VFORK_DONE tracing into a tracehook.h inline,
tracehook_report_vfork_done().  The change has no effect, just clean-up.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   18 ++++++++++++++++++
 kernel/fork.c             |    5 +----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 3ebc58b..830e6e1 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -210,4 +210,22 @@ static inline void tracehook_report_clone_complete(int trace,
 		ptrace_event(0, trace, pid);
 }
 
+/**
+ * tracehook_report_vfork_done - vfork parent's child has exited or exec'd
+ * @child:		child task, already running
+ * @pid:		new child's PID in the parent's namespace
+ *
+ * Called after a %CLONE_VFORK parent has waited for the child to complete.
+ * The clone/vfork system call will return immediately after this.
+ * The @child pointer may be invalid if a self-reaping child died and
+ * tracehook_report_clone() took no action to prevent it from self-reaping.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_report_vfork_done(struct task_struct *child,
+					       pid_t pid)
+{
+	ptrace_event(PT_TRACE_VFORK_DONE, PTRACE_EVENT_VFORK_DONE, pid);
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/fork.c b/kernel/fork.c
index 56b6ab0..5345b7d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1376,10 +1376,7 @@ long do_fork(unsigned long clone_flags,
 			freezer_do_not_count();
 			wait_for_completion(&vfork);
 			freezer_count();
-			if (unlikely (current->ptrace & PT_TRACE_VFORK_DONE)) {
-				current->ptrace_message = nr;
-				ptrace_notify ((PTRACE_EVENT_VFORK_DONE << 8) | SIGTRAP);
-			}
+			tracehook_report_vfork_done(p, nr);
 		}
 	} else {
 		nr = PTR_ERR(p);
