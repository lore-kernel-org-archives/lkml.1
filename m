Return-Path: <linux-kernel-owner+w=401wt.eu-S965968AbXFFXnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965968AbXFFXnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXFFXla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:41:30 -0400
Received: from 8.sub-75-209-226.myvzw.com ([75.209.226.8]:59410 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965830AbXFFXl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:41:28 -0400
Message-Id: <20070606230922.549990391@goop.org>
References: <20070606225837.654272428@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 15:58:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 7/7] i386: paravirt boot sequence
Content-Disposition: inline; filename=i386-paravirt-bootup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the updated boot protocol to do paravirtualized boot.
If the boot version is >= 2.07, then it will do two things:

 1. Check the bootparams loadflags to see if we should reload the
    segment registers and clear interrupts.  This is appropriate
    for normal native boot and some paravirtualized environments, but
    inappropraite for others.

 2. Check the hardware architecture, and dispatch to the appropriate
    kernel entrypoint.  If the bootloader doesn't set this, then we
    simply do the normal boot sequence.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/boot/header.S |    9 ++++++++-
 arch/i386/kernel/head.S |   47 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 51 insertions(+), 5 deletions(-)

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
@@ -209,6 +209,13 @@ cmdline_size:   .long   COMMAND_LINE_SIZ
                                                 #added with boot protocol
                                                 #version 2.06
 
+hardware_subarch:	.long 0			# subarchitecture, added with 2.07
+						# default to 0 for normal x86 PC
+
+hardware_subarch_data:	.quad 0
+
+kernel_payload:		.long blob_payload	# raw kernel data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -71,28 +71,37 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + 
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
@@ -120,6 +129,35 @@ 2:
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
@@ -132,6 +170,7 @@ 1:
  */
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
+default_entry:
 	movl $(pg0 - __PAGE_OFFSET), %edi
 	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
 	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */

-- 

