Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXIXLFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXIXLFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXIXLF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:05:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXIXLFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:05:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86_64 vDSO linker script cleanup
X-Fcc: ~/Mail/linus
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Message-Id: <20070924110417.BD06A4D0325@magilla.localdomain>
Date: Mon, 24 Sep 2007 04:04:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I can't see the reason ". = VDSO_PRELINK + 0x900;" was ever there in the
linker script for the x86_64 vDSO.  I can't find anything that depends on
this magic offset, or that should care at all about the particular location
of of the .data section (all from vvar.c) in the vDSO image.  If it is
really desireable to place .data at 0x900, then it should be after all the
other sections so they fill in the space up to 0x900.

This removes the 0x900 magic and cleans up the output sections generally in
the vDSO linker script.  This saves a few hundred bytes in the size of the
vDSO file, bringing it back well under 4kb total so that its vma only needs
one page.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/vdso/vdso.lds.S |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86_64/vdso/vdso.lds.S b/arch/x86_64/vdso/vdso.lds.S
index b9a60e6..667d324 100644
--- a/arch/x86_64/vdso/vdso.lds.S
+++ b/arch/x86_64/vdso/vdso.lds.S
@@ -26,13 +26,16 @@ SECTIONS
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
 
-  .text           : { *(.text) }		:text
-  .text.ptr       : { *(.text.ptr) }		:text
-  . = VDSO_PRELINK + 0x900;
-  .data           : { *(.data) }		:text
-  .bss            : { *(.bss) }			:text
+  .text           : { *(.text*) }		:text
+  .rodata         : { *(.rodata*) }		:text
+  .data		  : {
+	*(.data*)
+	*(.sdata*)
+	*(.bss*)
+	*(.dynbss*)
+  }						:text
 
-  .altinstructions : { *(.altinstructions) }			:text
+  .altinstructions : { *(.altinstructions) }		:text
   .altinstr_replacement  : { *(.altinstr_replacement) }	:text
 
   .note		  : { *(.note.*) }		:text :note
@@ -42,7 +45,6 @@ SECTIONS
   .useless        : {
   	*(.got.plt) *(.got)
 	*(.gnu.linkonce.d.*)
-	*(.dynbss)
 	*(.gnu.linkonce.b.*)
   }						:text
 }
