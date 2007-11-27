Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbXK0AQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbXK0AQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbXK0AOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49137 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757000AbXK0AOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:31 -0500
Message-Id: <20071127001431.231176621@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:16 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>, tglx@linutronix.de, mingo@redhat.com
Subject: [patch 09/14] x86_64: Use generic percpu
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

Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-24 10:27:31.088350556 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-24 10:28:51.020600562 -0800
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
