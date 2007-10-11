Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbXJKHkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbXJKHkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbXJKHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:40:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbXJKHkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:40:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Andrew Morton <akpm@linux-foundation.org>Andi Kleen" <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 vDSO linker script cleanup
In-Reply-To: Roland McGrath's message of  Monday, 24 September 2007 04:04:17 -0700 <20070924110417.BD06A4D0325@magilla.localdomain>
References: <20070924110417.BD06A4D0325@magilla.localdomain>
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Judicious distenders
   (2) Apocalyptic ablution admonishers
   (3) Scary horsie
Message-Id: <20071011074037.9C15C4D026B@magilla.localdomain>
Date: Thu, 11 Oct 2007 00:40:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces my earlier patch by the same title:
x86_64-vdso-linker-script-cleanup.patch


Thanks,
Roland

---

[PATCH] x86_64 vDSO linker script cleanup

This reorganizes the x86_64 vDSO layout to pack the contents better.
This yields a smaller image, while keeping code cache-aligned away
from data, and leaving more room to grow both in the .note section
(where --build-id can add some), and in the code (.text) section,
before the image grows past one 4kb page.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/vdso/vdso.lds.S |   47 +++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86_64/vdso/vdso.lds.S b/arch/x86_64/vdso/vdso.lds.S
index b9a60e6..726bc6d 100644
--- a/arch/x86_64/vdso/vdso.lds.S
+++ b/arch/x86_64/vdso/vdso.lds.S
@@ -20,30 +20,47 @@ SECTIONS
   .gnu.version_d  : { *(.gnu.version_d) }
   .gnu.version_r  : { *(.gnu.version_r) }
 
+  /* The kernel does not need to know these addresses,
+     so they don't need to be before VDSO_TEXT_OFFSET.
+     Pack these in here to sop up the space used for the alignment.  */
+  .note		  : { *(.note.*) }		:text :note
+  .useless        : {
+  	*(.got.plt) *(.got)
+	*(.gnu.linkonce.d.*)
+	*(.gnu.linkonce.b.*)
+  }						:text
+
   /* This linker script is used both with -r and with -shared.
      For the layouts to match, we need to skip more than enough
      space for the dynamic symbol table et al.  If this amount
-     is insufficient, ld -shared will barf.  Just increase it here.  */
+     is insufficient, ld -shared will barf.
+     Just increase VDSO_TEXT_OFFSET (in voffset.h).  */
   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
 
-  .text           : { *(.text) }		:text
-  .text.ptr       : { *(.text.ptr) }		:text
-  . = VDSO_PRELINK + 0x900;
-  .data           : { *(.data) }		:text
-  .bss            : { *(.bss) }			:text
+  .rodata         : { *(.rodata*) }		:text
+  .data		  : {
+	*(.data*)
+	*(.sdata*)
+	*(.bss*)
+	*(.dynbss*)
+  }						:text
 
-  .altinstructions : { *(.altinstructions) }			:text
-  .altinstr_replacement  : { *(.altinstr_replacement) }	:text
+  .dynamic        : { *(.dynamic) }		:text :dynamic
 
-  .note		  : { *(.note.*) }		:text :note
   .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
   .eh_frame       : { KEEP (*(.eh_frame)) }	:text
-  .dynamic        : { *(.dynamic) }		:text :dynamic
-  .useless        : {
-  	*(.got.plt) *(.got)
-	*(.gnu.linkonce.d.*)
-	*(.dynbss)
-	*(.gnu.linkonce.b.*)
+
+  .altinstructions : { *(.altinstructions) }		:text
+  .altinstr_replacement  : { *(.altinstr_replacement) }	:text
+
+  /* Separate actual executed code from other data for happy caches.  */
+  . = ALIGN(128);
+
+  .text           : {
+  	FILL(0x90909090);
+	*(.text .stub .text.* .gnu.linkonce.t.*)
+    	KEEP (*(.text.*personality*))
+  	. = ALIGN(128);
   }						:text
 }
 
