Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbXAaWwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbXAaWwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 17:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbXAaWwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 17:52:46 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:35352 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXAaWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 17:52:45 -0500
Date: Wed, 31 Jan 2007 17:45:04 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org, ak@suse.de
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] x86_64 32-bit ptrace mangles sixth system call argument
Message-ID: <20070131224504.GA7698@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is -mm only until Andi acks it ]

The 32-bit sysenter entry point mangles the sixth system call argument
for both 32-bit and 64-bit ptrace.  In both cases, strace shows the
frame pointer (ebp) as the sixth argument.

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
--
 arch/x86_64/ia32/ia32entry.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6/arch/x86_64/ia32/ia32entry.S
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

-- 
Work email - jdike at linux dot intel dot com
