Return-Path: <linux-kernel-owner+w=401wt.eu-S1763228AbZFLIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763228AbZFLIvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZFLIvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:51:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55200 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZFLIvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:51:01 -0400
Date: Fri, 12 Jun 2009 18:51:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: rr-latest-cpumask/sparc tree build failure
Message-Id: <20090612185102.2d1391e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next build (sparc64 defconfig) failed like this:

arch/sparc/mm/init_64.c: In function 'paging_init':
arch/sparc/mm/init_64.c:1802: error: 'CPU_MASK_ALL_PTR' undeclared (first use in this function)
arch/sparc/kernel/smp_64.c: In function 'setup_per_cpu_areas':
arch/sparc/kernel/smp_64.c:1541: error: 'CPU_MASK_ALL_PTR' undeclared (first use in this function)

Caused by commit b46586049330222ccab229a1a1e498e94c5fa5dc
("cpumask:remove-CPU_MASK_ALL_PTR") from the rr-latest-cpumask tree
interacting with commits 21bc149d59288fe43d1ba18a59d874ba6a5f1db9
("sparc64: Make mdesc_fill_in_cpu_data take a cpumask_t pointer") and
63750a3dc53a87a1f5ca42101ea88578b934ab52 ("sparc64: Defer cpu_data()
setup until end of per-cpu data initialization") from the sparc tree.

I applied this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Jun 2009 18:43:54 +1000
Subject: [PATCH] sparc: replace uses of CPU_MASK_ALL_PTR

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/smp_64.c |    2 +-
 arch/sparc/mm/init_64.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 1de47d2..f3a83b0 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1538,5 +1538,5 @@ void __init setup_per_cpu_areas(void)
 
 	of_fill_in_cpu_data();
 	if (tlb_type == hypervisor)
-		mdesc_fill_in_cpu_data(CPU_MASK_ALL_PTR);
+		mdesc_fill_in_cpu_data(cpu_all_mask);
 }
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b5a5932..ca92e2f 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1799,7 +1799,7 @@ void __init paging_init(void)
 
 	if (tlb_type == hypervisor) {
 		sun4v_mdesc_init();
-		mdesc_populate_present_mask(CPU_MASK_ALL_PTR);
+		mdesc_populate_present_mask(cpu_all_mask);
 	}
 
 	/* Once the OF device tree and MDESC have been setup, we know
-- 
1.6.3.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
