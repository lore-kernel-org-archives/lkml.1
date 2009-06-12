Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbZFLAYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbZFLAYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZFLAYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:24:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45210 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbZFLAYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:24:30 -0400
Date: Fri, 12 Jun 2009 10:24:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       Ingo Molnar <mingo@elte.hu>, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090612102427.32582baa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

include/linux/perf_counter.h:677: error: redefinition of 'perf_counter_do_pending'
arch/powerpc/include/asm/hw_irq.h:170: note: previous definition of 'perf_counter_do_pending' was here

Caused by commit 925d519ab82b6dd7aca9420d809ee83819c08db2 ("perf_counter:
unify and fix delayed counter wakeup") which added the former definitions
but forgot the remove the latter.

I applied the following patch.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Jun 2009 10:14:22 +1000
Subject: [PATCH] perfcounters: remove powerpc definitions of perf_counter_do_pending

Commit 925d519ab82b6dd7aca9420d809ee83819c08db2 ("perf_counter:
unify and fix delayed counter wakeup") added global definitions.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/hw_irq.h |    3 ---
 arch/powerpc/kernel/irq.c         |    1 +
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 20a44d0..5351237 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -156,8 +156,6 @@ static inline void clear_perf_counter_pending(void)
 		"i" (offsetof(struct paca_struct, perf_counter_pending)));
 }
 
-extern void perf_counter_do_pending(void);
-
 #else
 
 static inline unsigned long test_perf_counter_pending(void)
@@ -167,7 +165,6 @@ static inline unsigned long test_perf_counter_pending(void)
 
 static inline void set_perf_counter_pending(void) {}
 static inline void clear_perf_counter_pending(void) {}
-static inline void perf_counter_do_pending(void) {}
 #endif /* CONFIG_PERF_COUNTERS */
 
 #endif	/* __KERNEL__ */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index feff792..844d3f8 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -53,6 +53,7 @@
 #include <linux/bootmem.h>
 #include <linux/pci.h>
 #include <linux/debugfs.h>
+#include <linux/perf_counter.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-- 
1.6.3.1

