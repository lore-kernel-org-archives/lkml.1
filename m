Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZBDIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZBDIQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZBDIPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:15:54 -0500
Received: from ozlabs.org ([203.10.76.45]:59557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbZBDIPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:15:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections -fdata-sections
Date: Wed, 4 Feb 2009 18:45:47 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-2-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041845.48071.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:33:54 Jeff Arnold wrote:
> The purpose of this patch is to make it possible to build the kernel
> with "gcc -ffunction-sections -fdata-sections".
> 
> The problem is that with -ffunction-sections -fdata-sections, gcc
> creates sections like .text.head and .data.nosave whenever someone has
> innocuous code like this:
...
>  131 files changed, 356 insertions(+), 346 deletions(-)

OK, I updated this patch for latest Linus tree, and there are a few places you
missed, but the important q. is whether Linus will take this patch now?

There's no good time for this kind of invasive change; but it's not going to
get better.  And it's the only real roadblock for ksplice, plus it shrinks
my vmlinux by 12k when turned on.

Linus?

PS.  Here's the extra ones I found.  Since you only enable sections on x86,
it's not critical, but nice to cover them all.

diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -68,7 +68,7 @@ SECTIONS
 	_edata = . ;
 
 	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
-	.data.init_task : { *(.data.init_task) }
+	.kernel.data.init_task : { *(.kernel.data.init_task) }
 
 	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
 	__init_begin = .;
diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -23,7 +23,7 @@ __INITDATA
 /*
  * References to members of the boot_cpu_data structure.
  */
-.section .text.head, "ax"
+.section .kernel.text.head, "ax"
 	.global	start_kernel
 	.global __bss_start
 	.global _end
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .boot : { *(.boot) } = 0
   .text : {
-	*(.text.head)
+	*(.kernel.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -64,7 +64,7 @@ static union {
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __attribute__((__section__(".kernel.data.page_aligned")));
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /*
diff --git a/arch/s390/kernel/vdso32/vdso32_wrapper.S b/arch/s390/kernel/vdso32/vdso32_wrapper.S
--- a/arch/s390/kernel/vdso32/vdso32_wrapper.S
+++ b/arch/s390/kernel/vdso32/vdso32_wrapper.S
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".kernel.data.page_aligned"
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
diff --git a/arch/sparc/kernel/head_32.S b/arch/sparc/kernel/head_32.S
--- a/arch/sparc/kernel/head_32.S
+++ b/arch/sparc/kernel/head_32.S
@@ -72,7 +72,7 @@ sun4e_notsup:
 	.align 4
 
 	/* The Sparc trap table, bootloader gives us control at _start. */
-	.section .text.head,"ax"
+	.section .kernel.text.head,"ax"
 	.globl	start, _stext, _start, __stext
 	.globl  trapbase
 _start:   /* danger danger */
diff --git a/arch/sparc/kernel/init_task.c b/arch/sparc/kernel/init_task.c
--- a/arch/sparc/kernel/init_task.c
+++ b/arch/sparc/kernel/init_task.c
@@ -22,5 +22,5 @@ EXPORT_SYMBOL(init_task);
  * in etrap.S which assumes it.
  */
 union thread_union init_thread_union
-	__attribute__((section (".data.init_task")))
+	__attribute__((section (".kernel.data.init_task")))
 	= { INIT_THREAD_INFO(init_task) };
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -41,7 +41,7 @@ SECTIONS
 	.text TEXTSTART :
 	{
 		_text = .;
-		*(.text.head)
+		*(.kernel.text.head)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
