Return-Path: <linux-kernel-owner+w=401wt.eu-S964985AbXBLRAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985AbXBLRAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965023AbXBLRAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:00:39 -0500
Received: from mx1.suse.de ([195.135.220.2]:47925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXBLQvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:33 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Jeff Dike <jdike@addtoit.com>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [12/29] x86_64: 32-bit ptrace mangles sixth system call argument
Message-Id: <20070212165132.6518713F45@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeff Dike <jdike@addtoit.com>

The 32-bit sysenter entry point mangles the sixth system call argument for
both 32-bit and 64-bit ptrace.  In both cases, strace shows the frame
pointer (ebp) as the sixth argument.

Here's a snippet of a 64-bit strace of a 32-bit test program which
calls mmap through sysenter:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xfff00fcc) = 0xfffffffff7f7a000
fstat64(0x1, 0xfff008d8)                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xfff0089c) = 0xfffffffff7f79000
write(1, "mmap returns 0xf7f7a000\n", 24mmap returns 0xf7f7a000
) = 24

Here's a 32-bit strace of the same program:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xffc224ec) = 0xf7fcb000
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0xffc21dbc) = 0xf7fca000
write(1, "mmap returns 0xf7fcb000\n", 24mmap returns 0xf7fcb000
) = 24

The first mmap is the one made by the test - its final argument (the
offset) is 0, but strace shows 0xfff00fcc, which is the value of ebp.
The second is a guilty bystander which is also showing the bug.

The patch below copies %r9 (where the sixth argument has been
stashed) into the RBP slot of pt_regs before syscall_trace_enter is
called.  This fixes ptrace.

To allow a successful return to userspace, the original value of rbp
must be restored.  This is done by storing the current value of rbp
into the RBP slot of pt_regs before the RESTORE_REST.

With this patch, the straces now look like this:

64-bit:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7f5a000
fstat64(0x1, 0xff926ee8)                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7f59000
write(1, "mmap returns 0xf7f5a000\n", 24mmap returns 0xf7f5a000
) = 24

32-bit:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xf7fa9000
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xf7fa8000
write(1, "mmap returns 0xf7fa9000\n", 24mmap returns 0xf7fa9000
) = 24

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32entry.S
+++ linux/arch/x86_64/ia32/ia32entry.S
@@ -148,11 +148,23 @@ sysenter_do_call:	
 sysenter_tracesys:
 	CFI_RESTORE_STATE
 	SAVE_REST
+	/*
+	 * We need the 6th system call argument to be in regs->rbp at
+	 * this point so that ptrace will see it.  It's in r9 now, so copy
+	 * it to the rbp slot now.
+	 */
+	movq	%r9, RBP(%rsp)
 	CLEAR_RREGS
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	/*
+	 * Now, we need the correct value of rbp to be restored.  It
+	 * was never munged, so we can save it to the rbp slot and
+	 * just have it restored.
+	 */
+	movq	%rbp, RBP(%rsp)
 	RESTORE_REST
 	movl	%ebp, %ebp
 	/* no need to do an access_ok check here because rbp has been
