Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbZIICvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbZIICvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZIICvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:51:47 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46336 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZIICvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:51:45 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@redhat.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 4/5] x86: Use section .data.page_aligned for the idt_table.
Date: Tue,  8 Sep 2009 22:48:17 -0400
Message-Id: <1252464498-26293-4-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
References: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .data.idt section is just squashed into the .data.page_aligned
output section by the linker script anyway, so it might as well be in
the .data.page_aligned section.

This eliminates all references to .data.idt on x86.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/traps.c       |    6 ++----
 arch/x86/kernel/vmlinux.lds.S |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5204332..dd04f86 100644
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
index 51a8478..dad5a59 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -112,7 +112,6 @@ SECTIONS
 #endif
 
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
-		*(.data.idt)
 
 		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
 
-- 
1.6.3.3

