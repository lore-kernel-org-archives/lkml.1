Return-Path: <linux-kernel-owner+w=401wt.eu-S965743AbXEDIVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743AbXEDIVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965737AbXEDIVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:21:31 -0400
Received: from gw.goop.org ([64.81.55.164]:40592 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965730AbXEDIV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:21:29 -0400
Message-ID: <463AED07.1000505@goop.org>
Date: Fri, 04 May 2007 01:21:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: always clear bss
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the paravirt dispatcher gets run immediately on entry to
startup_32, the bss isn't cleared.  This happens to work if the
hypervisor's domain builder loaded the complete kernel image and
cleared the bss for us, but this may not always be true (for example,
if we're running out of a decompressed bzImage).

Change head.S so that it unconditionally clears the bss before doing
the paravirt dispatch or continuing on to normal native boot.

There are a couple of points to note:
 - We can't, in general, load the segment registers before paravirt
   dispatch, because we could be running with a non-standard gdt and
   segment selectors.  In practice though, all code which ends up
   jumping into startup_32 will have already set the segment registers
   up to sane values, so we don't need to do it again.
 - Paging may or may not be enabled, and if enabled we may or may not
   be mapped to the proper kernel virtual address.  To deal with this,
   we compare the kernel's linked address with where we're actually
   running, and use that to offset the bss pointer.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>

---
 arch/i386/kernel/head.S |   48 ++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -70,6 +70,33 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + 
  */
 .section .text.head,"ax",@progbits
 ENTRY(startup_32)
+/*
+ * Clear BSS first so that there are no surprises...
+ * This relies on the the segment registers to be set
+ * to something sensible, which will have already happened.
+ */
+	cld
+	xorl %eax,%eax
+	movl $__bss_start,%edi
+	movl $__bss_stop,%ecx
+	subl %edi,%ecx
+	shrl $2,%ecx
+	/*
+	 * Work out whether we're running mapped or not:
+	 * - call a local label
+	 * - pop the return address to get the actual eip
+	 * - subtract local label from %edi (= bss pointer)
+	 * - add in actual eip
+	 *
+	 * This will result in %edi being a virtual pointer if
+	 * we're currently mapped, or a physical pointer if we're
+	 * not (either no paging or 1:1 mapping).
+	 */
+	call 1f
+1:	popl %ebx
+	subl $1b, %edi
+	addl %ebx, %edi
+	rep ; stosl
 
 #ifdef CONFIG_PARAVIRT
         movl %cs, %eax
@@ -77,27 +104,6 @@ ENTRY(startup_32)
         jnz startup_paravirt
 #endif
 
-/*
- * Set segments to known values.
- */
-	cld
-	lgdt boot_gdt_descr - __PAGE_OFFSET
-	movl $(__BOOT_DS),%eax
-	movl %eax,%ds
-	movl %eax,%es
-	movl %eax,%fs
-	movl %eax,%gs
-
-/*
- * Clear BSS first so that there are no surprises...
- * No need to cld as DF is already clear from cld above...
- */
-	xorl %eax,%eax
-	movl $__bss_start - __PAGE_OFFSET,%edi
-	movl $__bss_stop - __PAGE_OFFSET,%ecx
-	subl %edi,%ecx
-	shrl $2,%ecx
-	rep ; stosl
 /*
  * Copy bootup parameters out of the way.
  * Note: %esi still has the pointer to the real-mode data.

