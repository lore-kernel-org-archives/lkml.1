Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZDXEcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZDXEcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZDXEbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:31:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZDXEbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:31:15 -0400
Message-Id: <20090424043113.953250145@goodmis.org>
References: <20090424043005.338878133@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 24 Apr 2009 00:30:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 4/6] x86: use native register access for native tlb flushing
Content-Disposition: inline; filename=0004-x86-use-native-register-access-for-native-tlb-flush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

currently these are paravirtulaized, doesn't appear any callers rely on
this (no pv_ops backends are using native_tlb and overriding cr3/4
access).

[ Impact: fix lockdep warning with paravirt and function tracer ]

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
LKML-Reference: <20090423172138.GR3036@sequoia.sous-sol.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/tlbflush.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index d3539f9..e2927c5 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,7 +17,7 @@
 
 static inline void __native_flush_tlb(void)
 {
-	write_cr3(read_cr3());
+	native_write_cr3(native_read_cr3());
 }
 
 static inline void __native_flush_tlb_global(void)
@@ -32,11 +32,11 @@ static inline void __native_flush_tlb_global(void)
 	 */
 	raw_local_irq_save(flags);
 
-	cr4 = read_cr4();
+	cr4 = native_read_cr4();
 	/* clear PGE */
-	write_cr4(cr4 & ~X86_CR4_PGE);
+	native_write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
-	write_cr4(cr4);
+	native_write_cr4(cr4);
 
 	raw_local_irq_restore(flags);
 }
-- 
1.6.2.1

-- 
