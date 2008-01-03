Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYACUEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYACUEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYACUEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:04:32 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:58434 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYACUEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:04:32 -0500
Date: Thu, 3 Jan 2008 21:04:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>
Cc: pavel@suse.cz
Subject: [PATCH] i386 : Make arch/x86/kernel/acpi/wakeup_32.S use a separate
 text section
Message-Id: <20080103210426.35543645.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While examining vmlinux namelist on i386 (nm -v vmlinux) I noticed :

c01021d0 t es7000_rename_gsi
c010221a T es7000_start_cpu
<Big Hole>
c0103000 T thread_saved_pc

and 

c0113218 T acpi_restore_state_mem
c0113219 T acpi_save_state_mem
<Big Hole>
c0114000 t wakeup_code

This is because arch/x86/kernel/acpi/wakeup_32.S forces a .text alignment
of 4096 bytes. (I have no idea if it is really needed, since 
arch/x86/kernel/acpi/wakeup_64.S uses a 16 bytes alignment *only*)

So arch/x86/kernel/built-in.o also has this alignment

arch/x86/kernel/built-in.o:     file format elf32-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00018c94  00000000  00000000  00001000  2**12
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE

But as arch/x86/kernel/acpi/wakeup_32.o is not the first object linked
into arch/x86/kernel/built-in.o, linker had to build several holes to meet
alignement requirements, because of .o nestings in the kbuild process.

This can be solved by using a special section, .text.page_aligned, so that
no holes are needed.


# size vmlinux.before vmlinux.after
   text    data     bss     dec     hex filename
4619942  422838  458752 5501532  53f25c vmlinux.before
4610534  422838  458752 5492124  53cd9c vmlinux.after

This saves 9408 bytes

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 1e931aa..f53e327 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -1,4 +1,4 @@
-.text
+	.section .text.page_aligned
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 7d72cce..113a831 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -44,6 +44,8 @@ SECTIONS
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
+	. = ALIGN(4096); /* not really needed, already page aligned */
+	*(.text.page_aligned)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT

