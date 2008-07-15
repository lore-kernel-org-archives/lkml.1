Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYGOUaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYGOUaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGOUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:30:03 -0400
Received: from www.tglx.de ([62.245.132.106]:37068 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbYGOUaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:30:01 -0400
Date: Tue, 15 Jul 2008 22:28:46 +0200
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] mm: fix build on non-mmu machines
Message-ID: <20080715202846.GA8867@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1ea0704e0d aka
 [mm: add a ptep_modify_prot transaction abstraction]

caused:

|  CC      init/main.o
|In file included from include2/asm/pgtable.h:68,
|                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/mm.h:39,
|                 from include2/asm/uaccess.h:8,
|                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/poll.h:13,
|                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/rtc.h:113,
|                 from /home/bigeasy/git/linux-2.6-m68k/include/linux/efi.h:19,
|                 from /home/bigeasy/git/linux-2.6-m68k/init/main.c:43:
|/linux-2.6/include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
|/linux-2.6/include/asm-generic/pgtable.h:209: error: implicit declaration of function 'ptep_get_and_clear'
|/linux-2.6/include/asm-generic/pgtable.h:209: error: incompatible types in return
|/linux-2.6/include/asm-generic/pgtable.h: In function '__ptep_modify_prot_commit':
|/linux-2.6/include/asm-generic/pgtable.h:220: error: implicit declaration of function 'set_pte_at'
|make[2]: *** [init/main.o] Error 1
|make[1]: *** [init] Error 2
|make: *** [sub-make] Error 2

on my m68knommu box.
Now I'm, not sure If this is the right solution, but with this
patch applied I am able to boot the kernel I've build.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 include/asm-generic/pgtable.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 4fce3db..ef87f88 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -195,7 +195,6 @@ static inline int pmd_none_or_clear_bad(pmd_t *pmd)
 	}
 	return 0;
 }
-#endif /* CONFIG_MMU */
 
 static inline pte_t __ptep_modify_prot_start(struct mm_struct *mm,
 					     unsigned long addr,
@@ -253,6 +252,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
 	__ptep_modify_prot_commit(mm, addr, ptep, pte);
 }
 #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
+#endif /* CONFIG_MMU */
 
 /*
  * A facility to provide lazy MMU batching.  This allows PTE updates and
-- 
1.5.5.2

