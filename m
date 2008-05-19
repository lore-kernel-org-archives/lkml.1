Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbYESUCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbYESUCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbYESUCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:02:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:53004 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbYESUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=UJ6VnEPhI4znlz/qYd1pG7mT3rn7/9edCJ2UFBM2tsy+5qtQV6Fndcn88jl6CGvqNjrSLcYR1Q0WvJbtk2s8cAtFNIaMXceiMIKXUst9SyDGHOlxBDnmgC7DmlCLSBpu48SUDL9ZyVJ1JAONNDylT07TZY0ybemkeE2z5t2r0dk=
Date: Mon, 19 May 2008 22:02:30 +0200
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] x86: don't destroy %rbp on kernel-mode faults
Message-ID: <20080519200230.GA12210@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The RFC part of this patch is: Does anybody see why touching %rcx would
be bad? It certainly looks like %ecx is free. This fixes the stacktrace
problem I was seeing, and Pekka tested a bootup to userspace. (Pekka also
did half of the debugging. When will git allow multiple authors for a
patch? :-))


Vegard


>From b1cbf24fcd05aa5ed2e610c80c06bc519d3188f7 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 19 May 2008 21:39:44 +0200
Subject: [PATCH] x86: don't destroy %rbp on kernel-mode faults

>From the code:

    B stepping K8s sometimes report an truncated RIP for IRET exceptions
    returning to compat mode. Check for these here too.

The code then proceeds to truncate the upper 32 bits of %rbp. This means
that when do_page_fault() is finally called, its prologue,

    do_page_fault:
        push %rbp
        movl %rsp, %rbp

will put the truncated base pointer on the stack. This means that the
stack tracer will not be able to follow the base-pointer changes and
will see all subsequent stack frames as unreliable.

This patch changes the code to use a different register (%rcx) for the
checking and leaves %rbp untouched.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/entry_64.S |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1edd9ac..ff53692 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -926,11 +926,11 @@ error_kernelspace:
 	   iret run with kernel gs again, so don't set the user space flag.
 	   B stepping K8s sometimes report an truncated RIP for IRET 
 	   exceptions returning to compat mode. Check for these here too. */
-	leaq irq_return(%rip),%rbp
-	cmpq %rbp,RIP(%rsp) 
+	leaq irq_return(%rip),%rcx
+	cmpq %rcx,RIP(%rsp) 
 	je   error_swapgs
-	movl %ebp,%ebp	/* zero extend */
-	cmpq %rbp,RIP(%rsp) 
+	movl %ecx,%ecx	/* zero extend */
+	cmpq %rcx,RIP(%rsp) 
 	je   error_swapgs
 	cmpq $gs_change,RIP(%rsp)
         je   error_swapgs
-- 
1.5.4.1

