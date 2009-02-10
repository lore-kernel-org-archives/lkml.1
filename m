Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZBJSTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZBJSTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZBJSTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:19:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZBJSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:19:33 -0500
Date: Tue, 10 Feb 2009 13:19:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: git pull request for tip/tracing/urgent
Message-ID: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The bug that is fixed by this change can affect users. Most likely it will 
not, since the fault should never happen. But this is a protective 
mechanism, where if it does, that means there is a bug in the tracer.

As you have previously told me, a bug in the tracer should never crash the 
kernel. Since the detection of a fault in the function graph tracer can 
lead to a kernel crash (without this change) I think this qualifies as 
something for 29.

-- Steve


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/urgent


Steven Rostedt (1):
      tracing, x86: fix fixup section to return to original code

----
 arch/x86/kernel/ftrace.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)
---------------------------
commit e3944bfac961cd7fc82f3b3143c55dc375748569
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Feb 10 13:07:13 2009 -0500

    tracing, x86: fix fixup section to return to original code
    
    Impact: fix to prevent a kernel crash on fault
    
    If for some reason the pointer to the parent function on the
    stack takes a fault, the fix up code will not return back to
    the original faulting code. This can lead to unpredictable
    results and perhaps even a kernel panic.
    
    A fault should not happen, but if it does, we should simply
    disable the tracer, warn, and continue running the kernel.
    It should not lead to a kernel crash.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b43086..9d549e4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -491,13 +491,15 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
 		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
 		"   movl $0, %[faulted]\n"
+		"3:\n"
 
 		".section .fixup, \"ax\"\n"
-		"3: movl $1, %[faulted]\n"
+		"4: movl $1, %[faulted]\n"
+		"   jmp 3b\n"
 		".previous\n"
 
-		_ASM_EXTABLE(1b, 3b)
-		_ASM_EXTABLE(2b, 3b)
+		_ASM_EXTABLE(1b, 4b)
+		_ASM_EXTABLE(2b, 4b)
 
 		: [parent_replaced] "=r" (parent), [old] "=r" (old),
 		  [faulted] "=r" (faulted)

