Return-Path: <linux-kernel-owner+w=401wt.eu-S935569AbZLGRut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935569AbZLGRut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935518AbZLGRus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:50:48 -0500
Received: from www.tglx.de ([62.245.132.106]:56240 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935496AbZLGRur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:50:47 -0500
Date: Mon, 7 Dec 2009 18:50:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com
Subject: GCC 4.x random code generator for x86_64 ?
Message-ID: <alpine.LFD.2.00.0912071707540.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone shed some light on the following:

Applying a patch which adds a yet unused "extern int bla(void);" line
to a header file results in something which is beyond me.

The .i files differ as expected in exaclty _one_ line.

--- 1.i	2009-12-07 16:23:35.000000000 +0100
+++ 2.i	2009-12-07 16:23:19.000000000 +0100
@@ -6566,6 +6566,8 @@
 extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
 # 252 "/home/tglx/work/kernel/rt-new/linux-2.6-tip/include/linux/spinlock.h"
 # 1 "/home/tglx/work/kernel/rt-new/linux-2.6-tip/include/linux/rwlock.h" 1
+# 17 "/home/tglx/work/kernel/rt-new/linux-2.6-tip/include/linux/rwlock.h"
+extern int bla(void);
 # 253 "/home/tglx/work/kernel/rt-new/linux-2.6-tip/include/linux/spinlock.h" 2
 
One would expect that the generated code would be the same, but the
resulting code has following surprising deltas (removed the "offset:"
prefix to see the meat of the changes):

 	41 57                	push   %r15
 	41 56                	push   %r14
 	41 55                	push   %r13
+	4c 8d ad 30 ff ff ff 	lea    -0xd0(%rbp),%r13
 	41 54                	push   %r12
 	49 89 fc             	mov    %rdi,%r12
 	53                   	push   %rbx
....
 	48 85 c0             	test   %rax,%rax
 	49 89 c5             	mov    %rax,%r13
-	75 0c                	jne    85 <timecompare_offset+0x52>
-	bb 0a 00 00 00       	mov    $0xa,%ebx
+	75 0c                	jne    8c <timecompare_offset+0x59>
 	4c 8d ad 30 ff ff ff 	lea    -0xd0(%rbp),%r13
+	bb 0a 00 00 00       	mov    $0xa,%ebx
 	45 31 ff             	xor    %r15d,%r15d
 	45 31 f6             	xor    %r14d,%r14d
....
 	44 89 f3             	mov    %r14d,%ebx
 	4c 89 e9             	mov    %r13,%rcx
-	31 d2                	xor    %edx,%edx
 	31 c0                	xor    %eax,%eax
-	eb 09                	jmp    18f <timecompare_offset+0x15c>
+	31 d2                	xor    %edx,%edx
+	eb 09                	jmp    196 <timecompare_offset+0x163>
 	48 03 01             	add    (%rcx),%rax
 	ff c2                	inc    %edx
 	48 83 c1 10          	add    $0x10,%rcx

None of these changes makes any sense at all.

This is fully reproducible and the effect on the generated code
depends on the placement of the "extern int bla(void);" line in the
header file.

Note, I disabled BUG and printk and there is no code which might have
a __LINE__ reference which would be affected by the insertion of that
function declaration.

For enhanced fun the problem goes away, when I compile the same kernel
for 32bit with the very same GCC.

Looks to me that GCC has a builtin random code generator for
x86_64. I'd just like to know whether this can be turned off or if
there is some magic way to seed the RCG reliably.

Environment:
F11 x86_64 
gcc (GCC) 4.4.1 20090725 (Red Hat 4.4.1-2)

The effect is reproducible with the patch below on top of Linus tree
and just compiling kernel/time/timecompare.o

Also verified that other 4.x versions of GCC have similar
randomization effects just in different source files.

Peter just provided:

@@ -62837,8 +62837,8 @@
    3558a:      53                      push   %rbx
    3558b:      e8 00 00 00 00          callq  35590 <cleanup_srcu_struct+0x10>
    35590:      4c 8b 35 00 00 00 00    mov    0x0(%rip),%r14
-   35597:      83 c9 ff                or     $0xffffffffffffffff,%ecx
-   3559a:      45 31 ed                xor    %r13d,%r13d
+   35597:      45 31 ed                xor    %r13d,%r13d
+   3559a:      83 c9 ff                or     $0xffffffffffffffff,%ecx
    3559d:      49 89 fc                mov    %rdi,%r12
    355a0:      eb 14                   jmp    355b6 <cleanup_srcu_struct+0x36>

Thanks,

	tglx
---
 include/linux/spinlock.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -57,6 +57,8 @@
 
 #include <asm/system.h>
 
+extern int bla(void);
+
 /*
  * Must define these before including other files, inline functions need them
  */
