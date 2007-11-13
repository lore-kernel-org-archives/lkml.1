Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXKMQyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXKMQyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbXKMQyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:54:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759191AbXKMQyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:54:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Arrange things such that BRA can reach from the trap
	table
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 13 Nov 2007 16:53:36 +0000
Message-ID: <20071113165336.18722.27037.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Arrange the sections in the FRV arch so that a BRA instruction with a 16-bit
displacement can always reach from the trap table to entry.S, tlb-miss.S and
break.S.

The problem otherwise is that the linker can insert sufficient code between
the slots in the trap table and the targets of the branch instructions in
those slots that the displacement field in the instruction isn't sufficiently
large.  This is because the branch targets were in the .text section along
with most of the other code in the kernel.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/break.S       |    2 +-
 arch/frv/kernel/entry.S       |    2 +-
 arch/frv/kernel/vmlinux.lds.S |   27 +++++++++++++++------------
 arch/frv/mm/tlb-miss.S        |    2 +-
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/frv/kernel/break.S b/arch/frv/kernel/break.S
index dac4a5f..bd0bdf9 100644
--- a/arch/frv/kernel/break.S
+++ b/arch/frv/kernel/break.S
@@ -63,7 +63,7 @@ __break_trace_through_exceptions:
 # entry point for Break Exceptions/Interrupts
 #
 ###############################################################################
-	.text
+	.section	.text.break
 	.balign		4
 	.globl		__entry_break
 __entry_break:
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 1e74f3c..f926c70 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -38,7 +38,7 @@
 
 #define nr_syscalls ((syscall_table_size)/4)
 
-	.text
+	.section	.text.entry
 	.balign		4
 
 .macro LEDS val
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index a62b245..a372e34 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -76,6 +76,12 @@ SECTIONS
 	  *(.data.init_task)
   }
 
+  . = ALIGN(4096);
+  .data.page_aligned : { *(.data.idt) }
+
+  . = ALIGN(L1_CACHE_BYTES);
+  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
 	. = ALIGN(8192);
@@ -86,28 +92,25 @@ SECTIONS
 	*(.trap.break)
   }
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
-
-  . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
   /* Text and read-only data */
   . = ALIGN(4);
   _text = .;
   _stext = .;
   .text : {
-	*(
-		.text.start .text.*
+	*(.text.start)
+	*(.text.entry)
+	*(.text.break)
+	*(.text.tlbmiss)
+	TEXT_TEXT
+	SCHED_TEXT
+	LOCK_TEXT
 #ifdef CONFIG_DEBUG_INFO
+	*(
 	.init.text
 	.exit.text
 	.exitcall.exit
-#endif
 	)
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
+#endif
 	*(.fixup)
 	*(.gnu.warning)
 	*(.exitcall.exit)
diff --git a/arch/frv/mm/tlb-miss.S b/arch/frv/mm/tlb-miss.S
index 04da674..0764348 100644
--- a/arch/frv/mm/tlb-miss.S
+++ b/arch/frv/mm/tlb-miss.S
@@ -16,7 +16,7 @@
 #include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
-	.section	.text
+	.section	.text.tlbmiss
 	.balign		4
 
 	.globl		__entry_insn_mmu_miss

