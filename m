Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbXKSWE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbXKSWE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXKSWEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:04:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbXKSWEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:04:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 04/18] x86 vDSO: new layout
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Shopping-List: (1) Fantastic rotation livers
   (2) Chromatic mauve logs
   (3) Periodical pincushions
Message-Id: <20071119220319.5C73426F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:03:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This revamps the vDSO linker script to lay things out with the best
packing of the data and good, separate alignment of the code.  The
rigid layout using VDSO_TEXT_OFFSET no longer matters to the kernel.
I've moved the layout parts of the linker script into a new include
file, vdso-layout.lds.S; this is in preparation for sharing the script
for the 32-bit vDSO builds too.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/vdso-layout.lds.S |   64 ++++++++++++++++++++++++
 arch/x86/vdso/vdso.lds.S        |  102 ++++++++++-----------------------------
 arch/x86/vdso/voffset.h         |    1 -
 3 files changed, 89 insertions(+), 78 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-layout.lds.S
 delete mode 100644 arch/x86/vdso/voffset.h

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
new file mode 100644
index 0000000..634a2cf
--- /dev/null
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -0,0 +1,64 @@
+/*
+ * Linker script for vDSO.  This is an ELF shared object prelinked to
+ * its virtual address, and with only one read-only segment.
+ * This script controls its layout.
+ */
+
+SECTIONS
+{
+	. = VDSO_PRELINK + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+	.data		: {
+	      *(.data*)
+	      *(.sdata*)
+	      *(.got.plt) *(.got)
+	      *(.gnu.linkonce.d.*)
+	      *(.bss*)
+	      *(.dynbss*)
+	      *(.gnu.linkonce.b.*)
+	}
+
+	.altinstructions	: { *(.altinstructions) }
+	.altinstr_replacement	: { *(.altinstr_replacement) }
+
+	/*
+	 * Align the actual code well away from the non-instruction data.
+	 * This is the best thing for the I-cache.
+	 */
+	. = ALIGN(0x100);
+
+	.text		: { *(.text*) }			:text	=0x90909090
+}
+
+/*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index d40d0e9..4e5dd3b 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -1,89 +1,37 @@
 /*
- * Linker script for vsyscall DSO.  The vsyscall page is an ELF shared
- * object prelinked to its virtual address, and with only one read-only
- * segment (that fits in one page).  This script controls its layout.
+ * Linker script for 64-bit vDSO.
+ * We #include the file to define the layout details.
+ * Here we only choose the prelinked virtual address.
+ *
+ * This file defines the version script giving the user-exported symbols in
+ * the DSO.  We can define local symbols here called VDSO* to make their
+ * values visible using the asm-x86/vdso.h macros from the kernel proper.
  */
-#include <asm/asm-offsets.h>
-#include "voffset.h"
 
 #define VDSO_PRELINK 0xffffffffff700000
+#include "vdso-layout.lds.S"
 
 /*
- * Symbols we define here called VDSO* get their values into vdso-syms.lds
- * and become visible to the kernel itself.
+ * This controls what userland symbols we export from the vDSO.
  */
-VDSO64_PRELINK = VDSO_PRELINK;
-
-#define VEXTERN(x)	VDSO64_ ## x = vdso_ ## x;
-#include "vextern.h"
-#undef	VEXTERN
-
-SECTIONS
-{
-  . = VDSO_PRELINK + SIZEOF_HEADERS;
-
-  .hash           : { *(.hash) }		:text
-  .gnu.hash       : { *(.gnu.hash) }
-  .dynsym         : { *(.dynsym) }
-  .dynstr         : { *(.dynstr) }
-  .gnu.version    : { *(.gnu.version) }
-  .gnu.version_d  : { *(.gnu.version_d) }
-  .gnu.version_r  : { *(.gnu.version_r) }
-
-  /* This linker script is used both with -r and with -shared.
-     For the layouts to match, we need to skip more than enough
-     space for the dynamic symbol table et al.  If this amount
-     is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
-
-  .text           : { *(.text*) }		:text
-  .rodata         : { *(.rodata*) }		:text
-  .data		  : {
-	*(.data*)
-	*(.sdata*)
-	*(.bss*)
-	*(.dynbss*)
-  }						:text
-
-  .altinstructions : { *(.altinstructions) }		:text
-  .altinstr_replacement  : { *(.altinstr_replacement) }	:text
-
-  .note		  : { *(.note.*) }		:text :note
-  .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
-  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
-  .dynamic        : { *(.dynamic) }		:text :dynamic
-  .useless        : {
-  	*(.got.plt) *(.got)
-	*(.gnu.linkonce.d.*)
-	*(.gnu.linkonce.b.*)
-  }						:text
+VERSION {
+	LINUX_2.6 {
+	global:
+		clock_gettime;
+		__vdso_clock_gettime;
+		gettimeofday;
+		__vdso_gettimeofday;
+		getcpu;
+		__vdso_getcpu;
+	local: *;
+	};
 }
 
-/*
- * We must supply the ELF program headers explicitly to get just one
- * PT_LOAD segment, and set the flags explicitly to make segments read-only.
- */
-PHDRS
-{
-  text PT_LOAD FILEHDR PHDRS FLAGS(5); /* PF_R|PF_X */
-  dynamic PT_DYNAMIC FLAGS(4); /* PF_R */
-  note PT_NOTE FLAGS(4); /* PF_R */
-  eh_frame_hdr 0x6474e550; /* PT_GNU_EH_FRAME, but ld doesn't match the name */
-}
+VDSO64_PRELINK = VDSO_PRELINK;
 
 /*
- * This controls what symbols we export from the DSO.
+ * Define VDSO64_x for each VEXTERN(x), for use via VDSO64_SYMBOL.
  */
-VERSION
-{
-  LINUX_2.6 {
-    global:
-	clock_gettime;
-	__vdso_clock_gettime;
-	gettimeofday;
-	__vdso_gettimeofday;
-	getcpu;
-	__vdso_getcpu;
-    local: *;
-  };
-}
+#define VEXTERN(x)	VDSO64_ ## x = vdso_ ## x;
+#include "vextern.h"
+#undef	VEXTERN
diff --git a/arch/x86/vdso/voffset.h b/arch/x86/vdso/voffset.h
deleted file mode 100644
index 4af67c7..0000000
--- a/arch/x86/vdso/voffset.h
+++ /dev/null
@@ -1 +0,0 @@
-#define VDSO_TEXT_OFFSET 0x600
