Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYF0PWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYF0PWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYF0PWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:22:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:35104 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYF0PWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ReYm/pEl1kl+vzNzkk9iXzssgctZN3hkCAlRHOw8p4juM6OiNxFex/iQuVmAeWQTAS
         vlPTxU709G1SW/5WWrWNUM4JdhrTpRCP5hO1JBHgTWP26lTKWUfCrFWnLuZc5O/wgxXf
         4ZLqJDGZpi0pztDfWBNZpIoTN1uWVXddQN0Wg=
Date: Fri, 27 Jun 2008 17:22:17 +0200
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH] x86: don't destroy %rbp on kernel-mode faults
Message-ID: <20080627152216.GA8852@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I sent this patch earlier, but it was never queued. It has been acked by
Arjan and acked informally by Andi. I hope this can make it for 2.6.27.

(It's been tested on two x86_64s.)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 26 Jun 2008 13:26:50 +0200
Subject: [PATCH] x86: don't destroy %rbp on kernel-mode faults

>From the code:

    "B stepping K8s sometimes report an truncated RIP for IRET exceptions
    returning to compat mode. Check for these here too."

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
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/entry_64.S |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 556a8df..fa1c9eb 100644
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

