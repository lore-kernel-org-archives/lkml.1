Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbYDTUKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbYDTUKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbYDTUKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:10:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665AbYDTUKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:10:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: compat_ptrace_request siginfo
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Wishy-washy dice
   (2) Geopolitical swindlers
   (3) Persuasive winters
   (4) Petulant sugar
Message-Id: <20080420201012.6B69F27037E@magilla.localdomain>
Date: Sun, 20 Apr 2008 13:10:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this before, but I hope it can go in now.
It's a prerequisite for some x86 ptrace cleanups I'd like to submit.

For powerpc, it requires this patch that's in Paul's queue:

	commit 9c0c44dbd9bc380bee53e2f768c4ad5410b8aae2
	Author: Roland McGrath <roland@redhat.com>
	Date:   Sun Apr 20 08:19:24 2008 +1000

	    [POWERPC] Define copy_siginfo_from_user32

Note: that change plus the patch below obviates the need for this one:

	commit e4cc58944c1e2ce41e3079d4eb60c95e7ce04b2b
	Author: Andreas Schwab <schwab@suse.de>
	Date:   Sun Apr 20 02:25:13 2008 +1000

	    [POWERPC] Add compat handler for PTRACE_GETSIGINFO


Thanks,
Roland

---
[PATCH] ptrace: compat_ptrace_request siginfo

This adds support for PTRACE_GETSIGINFO and PTRACE_SETSIGINFO in
compat_ptrace_request.  It relies on existing arch definitions for
copy_siginfo_to_user32 and copy_siginfo_from_user32.

On powerpc, this fixes a longstanding regression of 32-bit ptrace
calls on 64-bit kernels vs native calls (64-bit calls or 32-bit
kernels).  This can be seen in a 32-bit call using PTRACE_GETSIGINFO
to examine e.g. siginfo_t.si_addr from a signal that sets it.
(This was broken as of 2.6.24 and, I presume, many or all prior versions.)

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |   48 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index fdb34e8..67e392e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -323,9 +323,8 @@ static int ptrace_setoptions(struct task_struct *child, long data)
 	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
 }
 
-static int ptrace_getsiginfo(struct task_struct *child, siginfo_t __user * data)
+static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
-	siginfo_t lastinfo;
 	int error = -ESRCH;
 
 	read_lock(&tasklist_lock);
@@ -333,31 +332,25 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t __user * data)
 		error = -EINVAL;
 		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
-			lastinfo = *child->last_siginfo;
+			*info = *child->last_siginfo;
 			error = 0;
 		}
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
-	if (!error)
-		return copy_siginfo_to_user(data, &lastinfo);
 	return error;
 }
 
-static int ptrace_setsiginfo(struct task_struct *child, siginfo_t __user * data)
+static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 {
-	siginfo_t newinfo;
 	int error = -ESRCH;
 
-	if (copy_from_user(&newinfo, data, sizeof (siginfo_t)))
-		return -EFAULT;
-
 	read_lock(&tasklist_lock);
 	if (likely(child->sighand != NULL)) {
 		error = -EINVAL;
 		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
-			*child->last_siginfo = newinfo;
+			*child->last_siginfo = *info;
 			error = 0;
 		}
 		spin_unlock_irq(&child->sighand->siglock);
@@ -424,6 +417,7 @@ int ptrace_request(struct task_struct *child, long request,
 		   long addr, long data)
 {
 	int ret = -EIO;
+	siginfo_t siginfo;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -442,12 +436,22 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_GETEVENTMSG:
 		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
 		break;
+
 	case PTRACE_GETSIGINFO:
-		ret = ptrace_getsiginfo(child, (siginfo_t __user *) data);
+		ret = ptrace_getsiginfo(child, &siginfo);
+		if (!ret)
+			ret = copy_siginfo_to_user((siginfo_t __user *) data,
+						   &siginfo);
 		break;
+
 	case PTRACE_SETSIGINFO:
-		ret = ptrace_setsiginfo(child, (siginfo_t __user *) data);
+		if (copy_from_user(&siginfo, (siginfo_t __user *) data,
+				   sizeof siginfo))
+			ret = -EFAULT;
+		else
+			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
+
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
 		break;
@@ -616,6 +620,7 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 {
 	compat_ulong_t __user *datap = compat_ptr(data);
 	compat_ulong_t word;
+	siginfo_t siginfo;
 	int ret;
 
 	switch (request) {
@@ -638,6 +643,23 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 		ret = put_user((compat_ulong_t) child->ptrace_message, datap);
 		break;
 
+	case PTRACE_GETSIGINFO:
+		ret = ptrace_getsiginfo(child, &siginfo);
+		if (!ret)
+			ret = copy_siginfo_to_user32(
+				(struct compat_siginfo __user *) datap,
+				&siginfo);
+		break;
+
+	case PTRACE_SETSIGINFO:
+		memset(&siginfo, 0, sizeof siginfo);
+		if (copy_siginfo_from_user32(
+			    &siginfo, (struct compat_siginfo __user *) datap))
+			ret = -EFAULT;
+		else
+			ret = ptrace_setsiginfo(child, &siginfo);
+		break;
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 	}
