Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYGQHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYGQHcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbYGQHac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbYGQHa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 09/23] tracehook: tracehook_expect_breakpoints
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: Lovecraft was an optimist.
Message-Id: <20080717072954.C4CD015411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:29:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds tracehook_expect_breakpoints() as a formal hook for
the nommu code to use for its, "Is text-poking likely?" check
at mmap time.  This names the actual semantics the code means
to test, and documents it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   15 +++++++++++++++
 mm/nommu.c                |    4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6468ca0..e113e09 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -52,6 +52,21 @@
 struct linux_binprm;
 
 /**
+ * tracehook_expect_breakpoints - guess if task memory might be touched
+ * @task:		current task, making a new mapping
+ *
+ * Return nonzero if @task is expected to want breakpoint insertion in
+ * its memory at some point.  A zero return is no guarantee it won't
+ * be done, but this is a hint that it's known to be likely.
+ *
+ * May be called with @task->mm->mmap_sem held for writing.
+ */
+static inline int tracehook_expect_breakpoints(struct task_struct *task)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
+/**
  * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
  * @task:		current task doing exec
  *
diff --git a/mm/nommu.c b/mm/nommu.c
index 4462b6a..5edccd9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -22,7 +22,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
@@ -745,7 +745,7 @@ static unsigned long determine_vm_flags(struct file *file,
 	 * it's being traced - otherwise breakpoints set in it may interfere
 	 * with another untraced process
 	 */
-	if ((flags & MAP_PRIVATE) && (current->ptrace & PT_PTRACED))
+	if ((flags & MAP_PRIVATE) && tracehook_expect_breakpoints(current))
 		vm_flags &= ~VM_MAYSHARE;
 
 	return vm_flags;
