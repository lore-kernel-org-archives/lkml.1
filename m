Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbXK1VSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbXK1VSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbXK1VPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:37 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38899 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755427AbXK1VP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:27 -0500
Message-Id: <20071128211527.128796367@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:31 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>, tglx@linutronix.de, mingo@redhat.com
Subject: [patch 05/10] x86_64: Use generic percpu
Content-Disposition: inline; filename=x86_64_use_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 provides an optimized way to determine the local per cpu area
offset through the pda and determines the base by accessing a remote
pda.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 include/asm-x86/percpu_64.h |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu_64.h	2007-11-28 12:51:42.452213062 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu_64.h	2007-11-28 12:51:50.496213423 -0800
@@ -8,35 +8,13 @@
    from %gs */
 
 #ifdef CONFIG_SMP
-
 #include <asm/pda.h>
 
 #define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset() read_pda(data_offset)
+#define __my_cpu_offset read_pda(data_offset)
 
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)); }))
-#define __get_cpu_var(var) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
-#define __raw_get_cpu_var(var) (*({			\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
-
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
-#endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
+#endif
+#include <asm-generic/percpu.h>
 #endif /* _ASM_X8664_PERCPU_H_ */

-- 
