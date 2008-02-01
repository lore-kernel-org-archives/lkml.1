Return-Path: <linux-kernel-owner+w=401wt.eu-S1764913AbYBBAem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764913AbYBBAem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763667AbYBBAcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:32:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36432 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764852AbYBBAcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:32:50 -0500
Date: Fri, 1 Feb 2008 23:07:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: x86/.../trampoline_64.S racy?
Message-ID: <20080201220716.GA8597@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to reuse trampoline_64.S for wakeup from ACPI s3... but I'm
getting some badness: If I insert delay loops into trampoline_64.S,
machine fails to boot; but I already increased cpu bootup delay to 200
seconds...

Is it possible that bootup is subtly racy somewhere?

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index aaf4e12..3961bcb 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -188,7 +188,7 @@ void __cpuinit smp_callin(void)
 	/*
 	 * Waiting 2s total for startup (udelay is not yet working)
 	 */
-	timeout = jiffies + 2*HZ;
+	timeout = jiffies + 200*HZ;
 	while (time_before(jiffies, timeout)) {
 		/*
 		 * Has the boot CPU finished it's STARTUP sequence?
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 4aedd0b..34fe9a7 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -24,12 +24,48 @@
  *	entries.
  */
 
+
 #include <linux/linkage.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/msr.h>
 #include <asm/segment.h>
 
+
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
+#define DISPLAY(x) \
+	pushl	%eax		; \
+	movb	$x, %al;	\
+	outb	%al, $0x80; \
+	popl	%eax
+
+#define DISPLAY_UNSAFE(x) \
+	movb	$x, %al;	\
+	outb	%al, $0x80; \
+
+#define DELAY_OK \
+	movl	$0x30000000,%ecx	; \
+9:	loopl	9b		; 
+
+#define DELAY \
+	movl	$1,%ecx	; \
+9:	loopl	9b		; 
+	
+
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
 .section .init.data, "aw", @progbits
@@ -55,6 +91,9 @@ r_base = .
 					# Setup stack
 	movw	$(trampoline_stack_end - r_base), %sp
 
+	DISPLAY(0x70)
+	DELAY
+	
 	call	verify_cpu		# Verify the cpu supports long mode
 	testl   %eax, %eax		# Check for return code
 	jnz	no_longmode
@@ -78,6 +117,9 @@ r_base = .
 	lidtl	tidt - r_base	# load idt with 0, 0
 	lgdtl	tgdt - r_base	# load gdt with whatever is appropriate
 
+	DISPLAY(0x71)
+	DELAY
+
 	xor	%ax, %ax
 	inc	%ax		# protected mode (PE) bit
 	lmsw	%ax		# into protected mode
@@ -91,6 +133,9 @@ startup_32:
 	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
 	movl	%eax, %ds
 
+	DISPLAY_UNSAFE(0x72)
+	DELAY
+
 	xorl	%eax, %eax
 	btsl	$5, %eax		# Enable PAE mode
 	movl	%eax, %cr4
@@ -109,6 +154,9 @@ startup_32:
 	btsl	$0, %eax		# Enable protected mode
 	movl	%eax, %cr0
 
+	DISPLAY_UNSAFE(0x73)
+	DELAY
+
 	/*
 	 * At this point we're in long mode but in 32bit compatibility mode
 	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
@@ -120,6 +168,9 @@ startup_32:
 	.code64
 	.balign 4
 startup_64:
+	DISPLAY_UNSAFE(0x74)
+	DELAY
+
 	# Now jump into the kernel using virtual addresses
 	movq	$secondary_startup_64, %rax
 	jmp	*%rax



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
