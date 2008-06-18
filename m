Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYFRUbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYFRUbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYFRUaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:30:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbYFRUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:30:54 -0400
Date: Wed, 18 Jun 2008 13:30:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes
In-Reply-To: <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806181327390.2907@woody.linux-foundation.org>
References: <20080618194917.GC2741@infomag.infomag.iguana.be> <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Linus Torvalds wrote:
> 
> Quite frankly, this is *not* the right thing to do either: the proper 
> thing to do is to just move the low-level call into the "asm" statement, 
> and leave all the function prologue/epilogue entirely to the compiler.

Something like the following.

AGAIN! This is totally untested. It's meant as an *example* of how to use 
inline asm properly, not meant to necessarily work or do the right thing. 
It may be buggy as hell, for all I know. And there are probably better 
ways to do this.

(This one does just the 64-bit version, because it's a bit easier: the 
32-bit version needs to probably do some of the loading and storing of 
registers manually in the inline asm just to avoid running out of them, 
since the register pressure is worse).

		Linus

---
 drivers/watchdog/hpwdt.c |   50 +++++++++++++++------------------------------
 1 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 2686f3e..028c957 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -336,39 +336,23 @@ static int __devinit detect_cru_service(void)
 asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
 			       unsigned long *pRomEntry)
 {
-	asm("pushq      %rbp            \n\t"
-	    "movq       %rsp, %rbp      \n\t"
-	    "pushq      %rax            \n\t"
-	    "pushq      %rbx            \n\t"
-	    "pushq      %rdx            \n\t"
-	    "pushq      %r12            \n\t"
-	    "pushq      %r9             \n\t"
-	    "movq       %rsi, %r12      \n\t"
-	    "movq       %rdi, %r9       \n\t"
-	    "movl       4(%r9),%ebx     \n\t"
-	    "movl       8(%r9),%ecx     \n\t"
-	    "movl       12(%r9),%edx    \n\t"
-	    "movl       16(%r9),%esi    \n\t"
-	    "movl       20(%r9),%edi    \n\t"
-	    "movl       (%r9),%eax      \n\t"
-	    "call       *%r12           \n\t"
-	    "pushfq                     \n\t"
-	    "popq        %r12           \n\t"
-	    "popfq                      \n\t"
-	    "movl       %eax, (%r9)     \n\t"
-	    "movl       %ebx, 4(%r9)    \n\t"
-	    "movl       %ecx, 8(%r9)    \n\t"
-	    "movl       %edx, 12(%r9)   \n\t"
-	    "movl       %esi, 16(%r9)   \n\t"
-	    "movl       %edi, 20(%r9)   \n\t"
-	    "movq       %r12, %rax      \n\t"
-	    "movl       %eax, 28(%r9)   \n\t"
-	    "popq       %r9             \n\t"
-	    "popq       %r12            \n\t"
-	    "popq       %rdx            \n\t"
-	    "popq       %rbx            \n\t"
-	    "popq       %rax            \n\t"
-	    "leave                      \n\t" "ret");
+	asm("pushq %0 ; popfq ; call *%6; pushfq; popfq %0"
+		:"=r" (pi86Regs->reflags),
+		 "=a" (pi86Regs->u1.reax),
+		 "=b" (pi86Regs->u2.rebx),
+		 "=c" (pi86Regs->u3.recx),
+		 "=d" (pi86Regs->u4.redx),
+		 "=S" (pi86Regs->resi),
+		 "=D" (pi86Regs->redi)
+		:"r" (pRomEntry),
+		 "0" (pi86Regs->reflags),
+		 "1" (pi86Regs->u1.reax),
+		 "2" (pi86Regs->u2.rebx),
+		 "3" (pi86Regs->u3.recx),
+		 "4" (pi86Regs->u4.redx),
+		 "5" (pi86Regs->resi),
+		 "6" (pi86Regs->redi)
+		:"cc", "memory");
 }
 
 /*
