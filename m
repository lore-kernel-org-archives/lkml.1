Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbXJBXhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbXJBXhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbXJBXhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:37:25 -0400
Received: from ozlabs.org ([203.10.76.45]:51239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbXJBXhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:37:24 -0400
Subject: [PATCH 3/5] i386: paravirt boot sequence
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1191368154.17826.44.camel@localhost.localdomain>
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
	 <1191368154.17826.44.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:36:57 +1000
Message-Id: <1191368217.17826.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the updated boot protocol to do paravirtualized boot.
If the boot version is >= 2.07, then it will do two things:

 1. Check the bootparams loadflags to see if we should reload the
    segment registers and clear interrupts.  This is appropriate
    for normal native boot and some paravirtualized environments, but
    inapproprate for others.

 2. Check the hardware architecture, and dispatch to the appropriate
    kernel entrypoint.  If the bootloader doesn't set this, then we
    simply do the normal boot sequence.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/i386/boot/compressed/head.S |   14 +++++++++--
 arch/i386/boot/compressed/misc.c |    4 +++
 arch/i386/boot/header.S          |    7 ++++-
 arch/i386/kernel/head.S          |   47 ++++++++++++++++++++++++++++++++++----
 4 files changed, 65 insertions(+), 7 deletions(-)

diff -r 5d471e4c931d arch/i386/boot/compressed/head.S
--- a/arch/i386/boot/compressed/head.S	Tue Oct 02 22:13:34 2007 +1000
+++ b/arch/i386/boot/compressed/head.S	Tue Oct 02 22:20:25 2007 +1000
@@ -27,19 +27,30 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/boot.h>
+#include <asm/asm-offsets.h>
 
 .section ".text.head","ax",@progbits
 	.globl startup_32
 
 startup_32:
-	cld
-	cli
+	/* check to see if KEEP_SEGMENTS flag is meaningful */
+	cmpw $0x207, BP_version(%esi)
+	jb 1f
+
+	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
+	 * us to not reload segments */
+	testb $(1<<6), BP_loadflags(%esi)
+	jnz 2f
+
+1:	cli
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
 	movl %eax,%ss
+
+2:	cld
 
 /* Calculate the delta between where we were compiled to run
  * at and where we were actually loaded at.  This can only be done
diff -r 5d471e4c931d arch/i386/boot/compressed/misc.c
--- a/arch/i386/boot/compressed/misc.c	Tue Oct 02 22:13:34 2007 +1000
+++ b/arch/i386/boot/compressed/misc.c	Tue Oct 02 22:13:34 2007 +1000
@@ -246,6 +246,9 @@ static void putstr(const char *s)
 {
 	int x,y,pos;
 	char c;
+
+	if (RM_SCREEN_INFO.orig_video_mode == 0 && lines == 0 && cols == 0)
+		return;
 
 	x = RM_SCREEN_INFO.orig_x;
 	y = RM_SCREEN_INFO.orig_y;
diff -r 5d471e4c931d arch/i386/boot/header.S
--- a/arch/i386/boot/header.S	Tue Oct 02 22:13:34 2007 +1000
+++ b/arch/i386/boot/header.S	Tue Oct 02 22:13:34 2007 +1000
@@ -119,7 +119,7 @@ 1:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0206		# header version number (>= 0x0105)
+		.word	0x0207		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -214,6 +214,11 @@ cmdline_size:   .long   COMMAND_LINE_SIZ
                                                 #added with boot protocol
                                                 #version 2.06
 
+hardware_subarch:	.long 0			# subarchitecture, added with 2.07
+						# default to 0 for normal x86 PC
+
+hardware_subarch_data:	.quad 0
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
diff -r 5d471e4c931d arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Tue Oct 02 22:13:34 2007 +1000
+++ b/arch/i386/kernel/head.S	Tue Oct 02 22:21:01 2007 +1000
@@ -70,22 +70,30 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + 
  */
 .section .text.head,"ax",@progbits
 ENTRY(startup_32)
+	/* check to see if KEEP_SEGMENTS flag is meaningful */
+	cmpw $0x207, BP_version(%esi)
+	jb 1f
+
+	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
+		us to not reload segments */
+	testb $(1<<6), BP_loadflags(%esi)
+	jnz 2f
 
 /*
  * Set segments to known values.
  */
-	cld
-	lgdt boot_gdt_descr - __PAGE_OFFSET
+1:	lgdt boot_gdt_descr - __PAGE_OFFSET
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+2:
 
 /*
  * Clear BSS first so that there are no surprises...
- * No need to cld as DF is already clear from cld above...
- */
+ */
+	cld
 	xorl %eax,%eax
 	movl $__bss_start - __PAGE_OFFSET,%edi
 	movl $__bss_stop - __PAGE_OFFSET,%ecx
@@ -119,6 +127,35 @@ 2:
 	movsl
 1:
 
+#ifdef CONFIG_PARAVIRT
+	cmpw $0x207, (boot_params + BP_version - __PAGE_OFFSET)
+	jb default_entry
+
+	/* Paravirt-compatible boot parameters.  Look to see what architecture
+		we're booting under. */
+	movl (boot_params + BP_hardware_subarch - __PAGE_OFFSET), %eax
+	cmpl $num_subarch_entries, %eax
+	jae bad_subarch
+
+	movl subarch_entries - __PAGE_OFFSET(,%eax,4), %eax
+	subl $__PAGE_OFFSET, %eax
+	jmp *%eax
+
+bad_subarch:
+WEAK(lguest_entry)
+WEAK(xen_entry)
+	/* Unknown implementation; there's really
+	   nothing we can do at this point. */
+	ud2a
+.data
+subarch_entries:
+	.long default_entry		/* normal x86/PC */
+	.long lguest_entry		/* lguest hypervisor */
+	.long xen_entry			/* Xen hypervisor */
+num_subarch_entries = (. - subarch_entries) / 4
+.previous
+#endif /* CONFIG_PARAVIRT */
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond _end.  The variable
@@ -131,6 +168,7 @@ 1:
  */
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
+default_entry:
 	movl $(pg0 - __PAGE_OFFSET), %edi
 	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
 	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */


