Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbYGOUpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbYGOUpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763579AbYGOUo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:44:29 -0400
Received: from gw.goop.org ([64.81.55.164]:47252 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763092AbYGOUo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:44:28 -0400
Message-ID: <487D0AEB.6080304@goop.org>
Date: Tue, 15 Jul 2008 13:39:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: fix ptep_modify_* for no-MMU systems
References: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com>	 <486CF610.7000905@goop.org> <8bd0f97a0807150724x8f7095dl9b5d2e203053223f@mail.gmail.com>
In-Reply-To: <8bd0f97a0807150724x8f7095dl9b5d2e203053223f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build problem: 
 the functions added to asm-generic/pgtable.h are only used by
 mm/mprotect.c (a MMU-only file), but they were not added inside of the
 CONFIG_MMU ifdef block.  since the functions rely on things inside of
 CONFIG_MMU (the lines just above in pgtable.h), we get build failure
 on all no-mmu setups:
   CC      init/main.o
 In file included from include/asm/pgtable.h:94,
                  from include/linux/mm.h:39,
                  from include/asm/dma.h:39,
                  from include/linux/bootmem.h:8,
                  from init/main.c:27:
 include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
 include/asm-generic/pgtable.h:210: error: implicit declaration of
 function 'ptep_get_and_clear'
 include/asm-generic/pgtable.h:210: error: incompatible types in return
 make[1]: *** [init/main.o] Error 1
 make: *** [init/main.o] Error 2

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
---
 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -195,7 +195,6 @@
 	}
 	return 0;
 }
-#endif /* CONFIG_MMU */
 
 static inline pte_t __ptep_modify_prot_start(struct mm_struct *mm,
 					     unsigned long addr,
@@ -253,6 +252,7 @@
 	__ptep_modify_prot_commit(mm, addr, ptep, pte);
 }
 #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
+#endif /* CONFIG_MMU */
 
 /*
  * A facility to provide lazy MMU batching.  This allows PTE updates and



