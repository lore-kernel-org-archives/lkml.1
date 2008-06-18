Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYFRUKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYFRUKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYFRUK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:10:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbYFRUKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:10:23 -0400
Date: Wed, 18 Jun 2008 13:09:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes
In-Reply-To: <20080618194917.GC2741@infomag.infomag.iguana.be>
Message-ID: <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
References: <20080618194917.GC2741@infomag.infomag.iguana.be>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Wim Van Sebroeck wrote:
> 
>     Revert "[WATCHDOG] hpwdt: Fix NMI handling."
>     
>     To get this driver working we need the CFLAGS_hpwdt.o += -O in the Makefile.
>
>     The driver needs the asmlinkage tag and the CFLAGS line in the Makefile.
>     Without it the driver doesn't work.

The driver is unbelievable shit, and should just be removed, I think.

The reason for all the games with CFLAGS and asmlinkage and utter crud 
seems to be that the driver is just BROKEN. It will work purely by luck, 
and depend entirely on the compiler not doing anything else AT ALL in that 
asm function.

Could somebody please just fix the piece-of-sh*t thing?

Here's a totally untested patch that may or may not work. At least it 
removes the assembler code that assumes that it controls the whole 
function from anything that gcc will then create a function prologue and 
epilogue for. Quite frankly, this is *not* the right thing to do either: 
the proper thing to do is to just move the low-level call into the "asm" 
statement, and leave all the function prologue/epilogue entirely to the 
compiler.

But this way it isn't actively _broken_ by design, at least.

No promises. I don't have the hardware. But somebody should *really* do 
this correctly.

		Linus

---
 drivers/watchdog/hpwdt.c |  155 ++++++++++++++++++++++++----------------------
 1 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 2686f3e..eaa3f2a 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -140,49 +140,53 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
+extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs, unsigned long *pRomEntry);
+
 #ifndef CONFIG_X86_64
 /* --32 Bit Bios------------------------------------------------------------ */
 
 #define HPWDT_ARCH	32
 
-asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
-			       unsigned long *pRomEntry)
-{
-	asm("pushl       %ebp               \n\t"
-	    "movl        %esp, %ebp         \n\t"
-	    "pusha                          \n\t"
-	    "pushf                          \n\t"
-	    "push        %es                \n\t"
-	    "push        %ds                \n\t"
-	    "pop         %es                \n\t"
-	    "movl        8(%ebp),%eax       \n\t"
-	    "movl        4(%eax),%ebx       \n\t"
-	    "movl        8(%eax),%ecx       \n\t"
-	    "movl        12(%eax),%edx      \n\t"
-	    "movl        16(%eax),%esi      \n\t"
-	    "movl        20(%eax),%edi      \n\t"
-	    "movl        (%eax),%eax        \n\t"
-	    "push        %cs                \n\t"
-	    "call        *12(%ebp)          \n\t"
-	    "pushf                          \n\t"
-	    "pushl       %eax               \n\t"
-	    "movl        8(%ebp),%eax       \n\t"
-	    "movl        %ebx,4(%eax)       \n\t"
-	    "movl        %ecx,8(%eax)       \n\t"
-	    "movl        %edx,12(%eax)      \n\t"
-	    "movl        %esi,16(%eax)      \n\t"
-	    "movl        %edi,20(%eax)      \n\t"
-	    "movw        %ds,24(%eax)       \n\t"
-	    "movw        %es,26(%eax)       \n\t"
-	    "popl        %ebx               \n\t"
-	    "movl        %ebx,(%eax)        \n\t"
-	    "popl        %ebx               \n\t"
-	    "movl        %ebx,28(%eax)      \n\t"
-	    "pop         %es                \n\t"
-	    "popf                           \n\t"
-	    "popa                           \n\t"
-	    "leave                          \n\t" "ret");
-}
+asm(".text                          \n\t"
+    ".align 4                       \n"
+    "asminline_call:                \n\t"
+    "pushl       %ebp               \n\t"
+    "movl        %esp, %ebp         \n\t"
+    "pusha                          \n\t"
+    "pushf                          \n\t"
+    "push        %es                \n\t"
+    "push        %ds                \n\t"
+    "pop         %es                \n\t"
+    "movl        8(%ebp),%eax       \n\t"
+    "movl        4(%eax),%ebx       \n\t"
+    "movl        8(%eax),%ecx       \n\t"
+    "movl        12(%eax),%edx      \n\t"
+    "movl        16(%eax),%esi      \n\t"
+    "movl        20(%eax),%edi      \n\t"
+    "movl        (%eax),%eax        \n\t"
+    "push        %cs                \n\t"
+    "call        *12(%ebp)          \n\t"
+    "pushf                          \n\t"
+    "pushl       %eax               \n\t"
+    "movl        8(%ebp),%eax       \n\t"
+    "movl        %ebx,4(%eax)       \n\t"
+    "movl        %ecx,8(%eax)       \n\t"
+    "movl        %edx,12(%eax)      \n\t"
+    "movl        %esi,16(%eax)      \n\t"
+    "movl        %edi,20(%eax)      \n\t"
+    "movw        %ds,24(%eax)       \n\t"
+    "movw        %es,26(%eax)       \n\t"
+    "popl        %ebx               \n\t"
+    "movl        %ebx,(%eax)        \n\t"
+    "popl        %ebx               \n\t"
+    "movl        %ebx,28(%eax)      \n\t"
+    "pop         %es                \n\t"
+    "popf                           \n\t"
+    "popa                           \n\t"
+    "leave                          \n\t"
+    "ret                            \n\t"
+    ".previous");
+
 
 /*
  *	cru_detect
@@ -333,43 +337,44 @@ static int __devinit detect_cru_service(void)
 
 #define HPWDT_ARCH	64
 
-asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
-			       unsigned long *pRomEntry)
-{
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
-}
+asm(".text                      \n\t"
+    ".align 4                   \n"
+    "asminline_call:            \n\t"
+    "pushq      %rbp            \n\t"
+    "movq       %rsp, %rbp      \n\t"
+    "pushq      %rax            \n\t"
+    "pushq      %rbx            \n\t"
+    "pushq      %rdx            \n\t"
+    "pushq      %r12            \n\t"
+    "pushq      %r9             \n\t"
+    "movq       %rsi, %r12      \n\t"
+    "movq       %rdi, %r9       \n\t"
+    "movl       4(%r9),%ebx     \n\t"
+    "movl       8(%r9),%ecx     \n\t"
+    "movl       12(%r9),%edx    \n\t"
+    "movl       16(%r9),%esi    \n\t"
+    "movl       20(%r9),%edi    \n\t"
+    "movl       (%r9),%eax      \n\t"
+    "call       *%r12           \n\t"
+    "pushfq                     \n\t"
+    "popq        %r12           \n\t"
+    "popfq                      \n\t"
+    "movl       %eax, (%r9)     \n\t"
+    "movl       %ebx, 4(%r9)    \n\t"
+    "movl       %ecx, 8(%r9)    \n\t"
+    "movl       %edx, 12(%r9)   \n\t"
+    "movl       %esi, 16(%r9)   \n\t"
+    "movl       %edi, 20(%r9)   \n\t"
+    "movq       %r12, %rax      \n\t"
+    "movl       %eax, 28(%r9)   \n\t"
+    "popq       %r9             \n\t"
+    "popq       %r12            \n\t"
+    "popq       %rdx            \n\t"
+    "popq       %rbx            \n\t"
+    "popq       %rax            \n\t"
+    "leave                      \n\t"
+    "ret                        \n\t"
+    ".previous");
 
 /*
  *	dmi_find_cru
