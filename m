Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYFSTj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYFSTj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 15:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYFSTjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 15:39:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:44209 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYFSTjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 15:39:14 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Wim Van Sebroeck <wim@iguana.be>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2008 19:38:20 +0000
Subject: RE: [WATCHDOG] v2.6.26 hpwdt.c fixes
Thread-Topic: [WATCHDOG] v2.6.26 hpwdt.c fixes
Thread-Index: AcjRgjQ95fouv7IlQY6ynNieA4ujfQAvyadg
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC1491BFC3282F5@GVW1091EXB.americas.hpqcorp.net>
References: <20080618194917.GC2741@infomag.infomag.iguana.be>
 <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806181327390.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806181327390.2907@woody.linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr. Torvalds, your changes to my inline assembly code worked fine without the -O flag for both 32 and 64 bit on ProLiant hardware. Hopefully the following will be acceptable.


Thanks for the input.


Tom


--- /home/linux-2.6.26-rc6/drivers/watchdog/hpwdt.c     2008-06-12 16:22:24.000000000 -0500
+++ hpwdt.c     2008-06-19 13:42:07.000000000 -0500
@@ -123,6 +123,9 @@
static unsigned long __iomem *hpwdt_timer_reg;
static unsigned long __iomem *hpwdt_timer_con;

+extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+                                       unsigned long *pRomEntry);
+
 static DEFINE_SPINLOCK(rom_lock);

 static void *cru_rom_addr;
@@ -145,44 +148,45 @@

 #define HPWDT_ARCH     32

-static void asminline_call(struct cmn_registers *pi86Regs,
-                          unsigned long *pRomEntry)
-{
-       asm("pushl       %ebp               \n\t"
-           "movl        %esp, %ebp         \n\t"
-           "pusha                          \n\t"
-           "pushf                          \n\t"
-           "push        %es                \n\t"
-           "push        %ds                \n\t"
-           "pop         %es                \n\t"
-           "movl        8(%ebp),%eax       \n\t"
-           "movl        4(%eax),%ebx       \n\t"
-           "movl        8(%eax),%ecx       \n\t"
-           "movl        12(%eax),%edx      \n\t"
-           "movl        16(%eax),%esi      \n\t"
-           "movl        20(%eax),%edi      \n\t"
-           "movl        (%eax),%eax        \n\t"
-           "push        %cs                \n\t"
-           "call        *12(%ebp)          \n\t"
-           "pushf                          \n\t"
-           "pushl       %eax               \n\t"
-           "movl        8(%ebp),%eax       \n\t"
-           "movl        %ebx,4(%eax)       \n\t"
-           "movl        %ecx,8(%eax)       \n\t"
-           "movl        %edx,12(%eax)      \n\t"
-           "movl        %esi,16(%eax)      \n\t"
-           "movl        %edi,20(%eax)      \n\t"
-           "movw        %ds,24(%eax)       \n\t"
-           "movw        %es,26(%eax)       \n\t"
-           "popl        %ebx               \n\t"
-           "movl        %ebx,(%eax)        \n\t"
-           "popl        %ebx               \n\t"
-           "movl        %ebx,28(%eax)      \n\t"
-           "pop         %es                \n\t"
-           "popf                           \n\t"
-           "popa                           \n\t"
-           "leave                          \n\t" "ret");
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

 /*
  *     cru_detect
@@ -333,43 +337,44 @@

 #define HPWDT_ARCH     64

-static void asminline_call(struct cmn_registers *pi86Regs,
-                          unsigned long *pRomEntry)
-{
-       asm("pushq      %rbp            \n\t"
-           "movq       %rsp, %rbp      \n\t"
-           "pushq      %rax            \n\t"
-           "pushq      %rbx            \n\t"
-           "pushq      %rdx            \n\t"
-           "pushq      %r12            \n\t"
-           "pushq      %r9             \n\t"
-           "movq       %rsi, %r12      \n\t"
-           "movq       %rdi, %r9       \n\t"
-           "movl       4(%r9),%ebx     \n\t"
-           "movl       8(%r9),%ecx     \n\t"
-           "movl       12(%r9),%edx    \n\t"
-           "movl       16(%r9),%esi    \n\t"
-           "movl       20(%r9),%edi    \n\t"
-           "movl       (%r9),%eax      \n\t"
-           "call       *%r12           \n\t"
-           "pushfq                     \n\t"
-           "popq        %r12           \n\t"
-           "popfq                      \n\t"
-           "movl       %eax, (%r9)     \n\t"
-           "movl       %ebx, 4(%r9)    \n\t"
-           "movl       %ecx, 8(%r9)    \n\t"
-           "movl       %edx, 12(%r9)   \n\t"
-           "movl       %esi, 16(%r9)   \n\t"
-           "movl       %edi, 20(%r9)   \n\t"
-           "movq       %r12, %rax      \n\t"
-           "movl       %eax, 28(%r9)   \n\t"
-           "popq       %r9             \n\t"
-           "popq       %r12            \n\t"
-           "popq       %rdx            \n\t"
-           "popq       %rbx            \n\t"
-           "popq       %rax            \n\t"
-           "leave                      \n\t" "ret");
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
  *     dmi_find_cru

-----Original Message-----
From: Linus Torvalds [mailto:torvalds@linux-foundation.org]
Sent: Wednesday, June 18, 2008 3:30 PM
To: Wim Van Sebroeck
Cc: Andrew Morton; LKML; Mingarelli, Thomas
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes



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
-       asm("pushq      %rbp            \n\t"
-           "movq       %rsp, %rbp      \n\t"
-           "pushq      %rax            \n\t"
-           "pushq      %rbx            \n\t"
-           "pushq      %rdx            \n\t"
-           "pushq      %r12            \n\t"
-           "pushq      %r9             \n\t"
-           "movq       %rsi, %r12      \n\t"
-           "movq       %rdi, %r9       \n\t"
-           "movl       4(%r9),%ebx     \n\t"
-           "movl       8(%r9),%ecx     \n\t"
-           "movl       12(%r9),%edx    \n\t"
-           "movl       16(%r9),%esi    \n\t"
-           "movl       20(%r9),%edi    \n\t"
-           "movl       (%r9),%eax      \n\t"
-           "call       *%r12           \n\t"
-           "pushfq                     \n\t"
-           "popq        %r12           \n\t"
-           "popfq                      \n\t"
-           "movl       %eax, (%r9)     \n\t"
-           "movl       %ebx, 4(%r9)    \n\t"
-           "movl       %ecx, 8(%r9)    \n\t"
-           "movl       %edx, 12(%r9)   \n\t"
-           "movl       %esi, 16(%r9)   \n\t"
-           "movl       %edi, 20(%r9)   \n\t"
-           "movq       %r12, %rax      \n\t"
-           "movl       %eax, 28(%r9)   \n\t"
-           "popq       %r9             \n\t"
-           "popq       %r12            \n\t"
-           "popq       %rdx            \n\t"
-           "popq       %rbx            \n\t"
-           "popq       %rax            \n\t"
-           "leave                      \n\t" "ret");
+       asm("pushq %0 ; popfq ; call *%6; pushfq; popfq %0"
+               :"=r" (pi86Regs->reflags),
+                "=a" (pi86Regs->u1.reax),
+                "=b" (pi86Regs->u2.rebx),
+                "=c" (pi86Regs->u3.recx),
+                "=d" (pi86Regs->u4.redx),
+                "=S" (pi86Regs->resi),
+                "=D" (pi86Regs->redi)
+               :"r" (pRomEntry),
+                "0" (pi86Regs->reflags),
+                "1" (pi86Regs->u1.reax),
+                "2" (pi86Regs->u2.rebx),
+                "3" (pi86Regs->u3.recx),
+                "4" (pi86Regs->u4.redx),
+                "5" (pi86Regs->resi),
+                "6" (pi86Regs->redi)
+               :"cc", "memory");
 }

 /*
