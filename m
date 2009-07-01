Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZGAVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZGAVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZGAVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:00:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZGAVAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:00:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip] x86: Fix fixmap page order in text_poke()
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
Date: Wed, 01 Jul 2009 17:02:46 -0400
Message-ID: <20090701210246.22089.65697.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the fixmap pages are assigned higher address to lower, text_poke()
has to use it with inverted order (FIX_TEXT_POKE1 to FIX_TEXT_POKE0).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/alternative.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..4d8b40b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -527,14 +527,18 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	}
 	BUG_ON(!pages[0]);
 	local_irq_save(flags);
-	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
+	/*
+	 * Since the fixmaps are assinged from higher address to lower,
+	 * we use FIX_TEXT_POKE1 first, and FIX_TEXT_POKE0 second.
+	 */
+	set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[0]));
 	if (pages[1])
-		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
-	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
+		set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[1]));
+	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE1);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	clear_fixmap(FIX_TEXT_POKE0);
+	clear_fixmap(FIX_TEXT_POKE1);
 	if (pages[1])
-		clear_fixmap(FIX_TEXT_POKE1);
+		clear_fixmap(FIX_TEXT_POKE0);
 	local_flush_tlb();
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
