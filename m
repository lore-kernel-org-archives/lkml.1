Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbZEAAM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbZEAAM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765200AbZEAACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:00 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61696 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554AbZEAAB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:01:59 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 02/11] x86: Use section .data.page_aligned for the idt_table.
Date: Thu, 30 Apr 2009 20:01:29 -0400
Message-Id: <1241136098-10376-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-2-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .data.idt section is just squashed into the .data.page_aligned
output section by the linker script anyway, so it might as well be in
the .data.page_aligned section.

This eliminates all references to .data.idt on x86.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/traps.c       |    6 ++----
 arch/x86/kernel/vmlinux.lds.S |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..d7affb7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -73,11 +73,9 @@ char ignore_fpu_irq;
 
 /*
  * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.. We have a special link segment
- * for this.
+ * F0 0F bug workaround.
  */
-gate_desc idt_table[256]
-	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+gate_desc idt_table[256] __page_aligned_data = { { { { 0, 0 } } }, };
 #endif
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 10edb97..037df73 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -131,7 +131,6 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 		*(.data.page_aligned)
-		*(.data.idt)
 	}
 
 #ifdef CONFIG_X86_32
-- 
1.6.2.1

