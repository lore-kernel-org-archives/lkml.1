Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZLFHgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZLFHgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZLFHf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35687 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbZLFHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:34:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wGeqksYlnBM50NlQVVCsaru1c0nhuVFsokonWWsUDqN8mKAI858DOpV4csVxAQ4unh
         39GvBKa/CuPJ7viMjNcCC0LMtKgk8BGW04zx+bkIfvs/KkuZMz2dUQuNoM/gTIA6ywJF
         M5x+LcjbetEBolKdt9KwePy1q2rqJkboAFKK4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 4/9] hw-breakpoints: Drop callback and task parameters from modify helper
Date: Sun,  6 Dec 2009 08:34:53 +0100
Message-Id: <1260084898-11686-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the callback and task parameters from modify_user_hw_breakpoint().
For now we have no user that need to modify a breakpoint to the point
of changing its handler or its task context.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/ptrace.c      |    4 ++--
 include/linux/hw_breakpoint.h |    9 ++-------
 kernel/hw_breakpoint.c        |    7 +++----
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 04d182a..dbb3955 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -618,7 +618,7 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 	attr.bp_type = gen_type;
 	attr.disabled = disabled;
 
-	return modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
+	return modify_user_hw_breakpoint(bp, &attr);
 }
 
 /*
@@ -740,7 +740,7 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
-		bp = modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
+		bp = modify_user_hw_breakpoint(bp, &attr);
 	}
 	/*
 	 * CHECKME: the previous code returned -EIO if the addr wasn't a
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index a03daed..d33096e 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -57,10 +57,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 
 /* FIXME: only change from the attr, and don't unregister */
 extern struct perf_event *
-modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr,
-			  perf_callback_t triggered,
-			  struct task_struct *tsk);
+modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
 
 /*
  * Kernel breakpoints are not associated with any particular thread.
@@ -97,9 +94,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline struct perf_event *
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr,
-			  perf_callback_t triggered,
-			  struct task_struct *tsk)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return NULL; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_callback_t triggered,
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index cf5ee16..2d10b01 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -312,9 +312,7 @@ EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
  */
 struct perf_event *
-modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr,
-			  perf_callback_t triggered,
-			  struct task_struct *tsk)
+modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
 {
 	/*
 	 * FIXME: do it without unregistering
@@ -323,7 +321,8 @@ modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr,
 	 */
 	unregister_hw_breakpoint(bp);
 
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	return perf_event_create_kernel_counter(attr, -1, bp->ctx->task->pid,
+						bp->callback);
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
-- 
1.6.2.3

