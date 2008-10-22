Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYJVVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYJVVgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYJVVfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:35:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYJVVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:35:53 -0400
Message-Id: <20081022213551.897787817@goodmis.org>
References: <20081022212721.167005680@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 17:27:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/13 v2] ftrace: use probe_kernel
Content-Disposition: inline; filename=ftrace-use-probe-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton suggested using the proper API for reading and writing
kernel areas that might fault.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 15:24:15.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 15:26:07.000000000 -0400
@@ -74,8 +74,7 @@ ftrace_modify_code(unsigned long ip, uns
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
