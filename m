Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbXGKS62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbXGKS62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXGKS6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:58:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXGKS6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:58:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/7] i386: Put allocated ELF notes in read-only data segment
X-Shopping-List: (1) Injured surfing longitudes
   (2) Malignant will-o'-the-wisps
   (3) Wry dirt
   (4) Devious ostentatious proportion bread
Message-Id: <20070711185744.B10014D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 11:57:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes the i386 linker script and the asm-generic macro it uses so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/i386/kernel/vmlinux.lds.S    |    6 +++---
 include/asm-generic/vmlinux.lds.h |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/i386/kernel/vmlinux.lds.S b/arch/i386/kernel/vmlinux.lds.S
index aa87b06..f5b1db5 100644
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -60,7 +60,9 @@ SECTIONS
   	__stop___ex_table = .;
   }
 
-  BUG_TABLE
+  NOTES :text :note
+
+  BUG_TABLE :text
 
   . = ALIGN(4);
   .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
@@ -206,6 +208,4 @@ SECTIONS
   STABS_DEBUG
 
   DWARF_DEBUG
-
-  NOTES
 }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 84155eb..d86c929 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -224,7 +224,11 @@
 	}
 
 #define NOTES								\
-	.notes : { *(.note.*) } :note
+	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__start_notes) = .;			\
+		*(.note.*)						\
+		VMLINUX_SYMBOL(__stop_notes) = .;			\
+	}
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
