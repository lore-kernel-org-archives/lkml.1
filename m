Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYDHK5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYDHK5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYDHK5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:57:03 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:26880 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYDHK5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:57:01 -0400
Date: Tue, 8 Apr 2008 12:54:30 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: cleanup boot-heap usage
Message-ID: <20080408105430.GA11595@mailshack.com>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408082354.GA13940@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408082354.GA13940@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 08 Apr 2008 12:56:36 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.132; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel decompressor wrapper uses memory located beyond the
end of the image. This might lead to hard to debug problems,
but even if it can be proven to be safe, it is at the very
least unclean. I don't see any advantages either, unless you
count it not being zeroed out as an advantage. This patch
moves the boot-heap area to the bss segment.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Tue, Apr 08, 2008 at 10:23:54AM +0200, Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > I did see that the malloc space that the inflate code is using is 
> > taken from _after_ the end of the bss. I don't see how this is 
> > protected from being used/overwritten. Changing the stack size changes 
> > the memory layout a bit... maybe you were so unlucky to create a 
> > vmlinux image that was just barely smaller than some threshold and 
> > increasing the stack size made the decompression/relocation area be 
> > located somewhere else?
> > 
> > Test patch follows.
> 
> that's a really interesting theory.
> 
> FWIIW, i've been booting allyesconfig bzImages for a long time (with 
> only minimal amount of drivers disabled - mostly old ISA ones that 
> assume the presence of the real hardware), and they boot and work fine 
> on both 32-bit and 64-bit typical whitebox PCs. That means huge bzImages 
> that decompresses into a ~41 MB kernel image. I'd expect that to be a 
> rather severe test of the decompressor.
> 
> 	Ingo

Hi Ingo,

Even if this patch might not solve the problem, I think it
is a good clean-up that is suitable for -x86? qemu is happy
with it.

Greetings,
	Alexander

 arch/x86/boot/compressed/head_32.S |   15 +++++++++------
 arch/x86/boot/compressed/head_64.S |   22 +++++++++++++---------
 arch/x86/boot/compressed/misc.c    |    8 +-------
 include/asm-x86/boot.h             |    8 ++++++++
 4 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 036e635..ba7736c 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -130,7 +130,7 @@ relocated:
 /*
  * Setup the stack for the decompressor
  */
-	leal stack_end(%ebx), %esp
+	leal boot_stack_end(%ebx), %esp
 
 /*
  * Do the decompression, and jump to the new kernel..
@@ -142,8 +142,8 @@ relocated:
 	pushl %eax	# input_len
 	leal input_data(%ebx), %eax
 	pushl %eax	# input_data
-	leal _end(%ebx), %eax
-	pushl %eax	# end of the image as third argument
+	leal boot_heap(%ebx), %eax
+	pushl %eax	# heap area as third argument
 	pushl %esi	# real mode pointer as second arg
 	call decompress_kernel
 	addl $20, %esp
@@ -181,7 +181,10 @@ relocated:
 	jmp *%ebp
 
 .bss
+/* Stack and heap for uncompression */
 .balign 4
-stack:
-	.fill 4096, 1, 0
-stack_end:
+boot_heap:
+	.fill BOOT_HEAP_SIZE, 1, 0
+boot_stack:
+	.fill BOOT_STACK_SIZE, 1, 0
+boot_stack_end:
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index e8657b9..7a212a6 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -28,6 +28,7 @@
 #include <asm/segment.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
+#include <asm/boot.h>
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
 
@@ -62,7 +63,7 @@ startup_32:
 	subl	$1b, %ebp
 
 /* setup a stack and make sure cpu supports long mode. */
-	movl	$user_stack_end, %eax
+	movl	$boot_stack_end, %eax
 	addl	%ebp, %eax
 	movl	%eax, %esp
 
@@ -274,7 +275,7 @@ relocated:
 	stosb
 
 	/* Setup the stack */
-	leaq	user_stack_end(%rip), %rsp
+	leaq	boot_stack_end(%rip), %rsp
 
 	/* zero EFLAGS after setting rsp */
 	pushq	$0
@@ -285,7 +286,7 @@ relocated:
  */
 	pushq	%rsi			# Save the real mode argument
 	movq	%rsi, %rdi		# real mode address
-	leaq	_heap(%rip), %rsi	# _heap
+	leaq	boot_heap(%rip), %rsi	# malloc area for uncompression
 	leaq	input_data(%rip), %rdx  # input_data
 	movl	input_len(%rip), %eax
 	movq	%rax, %rcx		# input_len
@@ -310,9 +311,12 @@ gdt:
 	.quad	0x0080890000000000	/* TS descriptor */
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
-	.bss
-/* Stack for uncompression */
-	.balign 4
-user_stack:
-	.fill 4096,4,0
-user_stack_end:
+
+.bss
+/* Stack and heap for uncompression */
+.balign 4
+boot_heap:
+	.fill BOOT_HEAP_SIZE, 1, 0
+boot_stack:
+	.fill BOOT_STACK_SIZE, 1, 0
+boot_stack_end:
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dad4e69..90456ce 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -217,12 +217,6 @@ static void putstr(const char *);
 static memptr free_mem_ptr;
 static memptr free_mem_end_ptr;
 
-#ifdef CONFIG_X86_64
-#define HEAP_SIZE             0x7000
-#else
-#define HEAP_SIZE             0x4000
-#endif
-
 static char *vidmem;
 static int vidport;
 static int lines, cols;
@@ -449,7 +443,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 
 	window = output;		/* Output buffer (Normally at 1M) */
 	free_mem_ptr     = heap;	/* Heap */
-	free_mem_end_ptr = heap + HEAP_SIZE;
+	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 	inbuf  = input_data;		/* Input buffer */
 	insize = input_len;
 	inptr  = 0;
diff --git a/include/asm-x86/boot.h b/include/asm-x86/boot.h
index ed8affb..2faed7e 100644
--- a/include/asm-x86/boot.h
+++ b/include/asm-x86/boot.h
@@ -17,4 +17,12 @@
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
+#ifdef CONFIG_X86_64
+#define BOOT_HEAP_SIZE	0x7000
+#define BOOT_STACK_SIZE	0x4000
+#else
+#define BOOT_HEAP_SIZE	0x4000
+#define BOOT_STACK_SIZE	0x1000
+#endif
+
 #endif /* _ASM_BOOT_H */

