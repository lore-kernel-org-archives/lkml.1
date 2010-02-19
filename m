Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0BSGjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:39:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48828 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0BSGjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:39:31 -0500
Date: Fri, 19 Feb 2010 17:39:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: linux-next: build failure after final merge (arm tree)
Message-Id: <20100219173929.01b9e85f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

After merging the scsi-post-merge tree, today's linux-next build (sparc32
defconfig) failed like this:

arch/sparc/mm/sun4c.c: In function 'sun4c_update_mmu_cache':
arch/sparc/mm/sun4c.c:1943: error: 'pte' undeclared (first use
 in this function)

Caused by commit 2dca0ca96ac340fbf4f9e0741dcf58ff3677e994 ("MM: Pass a
PTE pointer to update_mmu_cache() rather than the PTE itself").

I applied the following patch for today. It may not be correct.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Feb 2010 17:33:16 +1100
Subject: [PATCH] sparc: fix fallout from update_mmu_cache API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/mm/sun4c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index 171f823..1865253 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -1929,7 +1929,7 @@ void sun4c_update_mmu_cache(struct vm_area_struct *vma, unsigned long address, p
 			start += PAGE_SIZE;
 		}
 #ifndef SUN4C_PRELOAD_PSEG
-		sun4c_put_pte(address, pte_val(pte));
+		sun4c_put_pte(address, pte_val(*ptep));
 #endif
 		local_irq_restore(flags);
 		return;
@@ -1940,7 +1940,7 @@ void sun4c_update_mmu_cache(struct vm_area_struct *vma, unsigned long address, p
 		add_lru(entry);
 	}
 
-	sun4c_put_pte(address, pte_val(pte));
+	sun4c_put_pte(address, pte_val(*ptep));
 	local_irq_restore(flags);
 }
 
-- 
1.6.6.2


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

