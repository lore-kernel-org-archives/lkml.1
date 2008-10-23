Return-Path: <linux-kernel-owner+w=401wt.eu-S1750856AbYJWNjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856AbYJWNjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYJWNha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133723.452978178@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/12 v3] ftrace: use probe_kernel
Content-Disposition: inline; filename=ftrace-use-probe-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton suggested using the proper API for reading and writing
kernel areas that might fault.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-23 09:26:22.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-23 09:27:08.000000000 -0400
@@ -67,15 +67,14 @@ ftrace_modify_code(unsigned long ip, uns
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
 	 *  as well as code changing. We do this by using the
-	 *  __copy_*_user functions.
+	 *  probe_kernel_* functions.
 	 *
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
 
 	/* read the text we want to modify */
-	if (__copy_from_user_inatomic(replaced, (char __user *)ip,
-				      MCOUNT_INSN_SIZE))
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure it is what we expect it to be */
@@ -83,8 +82,7 @@ ftrace_modify_code(unsigned long ip, uns
 		return -EINVAL;
 
 	/* replace the text with the new text */
-	if (__copy_to_user_inatomic((char __user *)ip, new_code,
-				    MCOUNT_INSN_SIZE))
+	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	sync_core();

-- 
