Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbXFUAhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbXFUAhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbXFUAg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:36:58 -0400
Received: from bay-wan-b-65.sfo.dsl.cerfnet.com ([216.148.65.65]:39545 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755447AbXFUAg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:36:57 -0400
Message-Id: <20070620231853.164451916@goop.org>
References: <20070620231726.834538992@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 16:17:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 7/9] i386: paravirt boot sequence
Content-Disposition: inline; filename=i386-paravirt-bootup.patch
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
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/i386/boot/compressed/head.S |   14 +++++++++--
 arch/i386/boot/compressed/misc.c |    4 +++
 arch/i386/boot/header.S          |    7 ++++-
 arch/i386/kernel/head.S          |   47 ++++++++++++++++++++++++++++++++++----
 4 files changed, 65 insertions(+), 7 deletions(-)

===================================================================
--- a/arch/i386/boot/compressed/head.S
+++ b/arch/i386/boot/compressed/head.S
@@ -33,14 +33,24 @@
 	.globl blob_startup_32
 
 blob_startup_32:
-	cld
-	cli
+	/* check to see if KEEP_SEGMENTS flag is meaningful */
+	cmpw $0x207, BP_version(%esi)
+	jb 1f
+
+	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
+		us to not reload segments */
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
===================================================================
--- a/arch/i386/boot/compressed/misc.c
+++ b/arch/i386/boot/compressed/misc.c
@@ -245,6 +245,10 @@ static void putstr(const char *s)
 {
 	int x,y,pos;
 	char c;
+
+	if (RM_SCREEN_INFO.orig_video_mode == 0 &&
+	    lines == 0 && cols == 0)
+		return;
 
 	x = RM_SCREEN_INFO.orig_x;
 	y = RM_SCREEN_INFO.orig_y;
===================================================================
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -119,7 +119,7 @@ 1:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0206		# header version number (>= 0x0105)
+		.word	0x0207		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -209,6 +209,11 @@ cmdline_size:   .long   COMMAND_LINE_SIZ
                                                 #added with boot protocol
                                                 #version 2.06
 
+hardware_subarch:	.long 0			# subarchitecture, added with 2.07
+						# default to 0 for normal x86 PC
+
+hardware_subarch_data:	.quad 0
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -86,28 +86,37 @@ pg0_init_size = ROUNDUP(INIT_MAP_BEYOND_
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
 	subl %edi,%ecx
 	shrl $2,%ecx
 	rep ; stosl
+
 /*
  * Copy bootup parameters out of the way.
  * Note: %esi still has the pointer to the real-mode data.
@@ -135,6 +144,35 @@ 2:
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
@@ -147,6 +185,7 @@ 1:
  */
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
+default_entry:
 	movl $(pg0 - __PAGE_OFFSET), %edi
 	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
 	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */

-- 

