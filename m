Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbXK3LMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbXK3LMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXK3LMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:12:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59287 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778AbXK3LMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:12:14 -0500
Date: Fri, 30 Nov 2007 12:11:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [patch 05/10] x86_64: Use generic percpu
Message-ID: <20071130111142.GC32431@elte.hu>
References: <20071128210926.008783214@sgi.com> <20071128211527.128796367@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128211527.128796367@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


had rejects - hand-merged to x86.git - please check.

	Ingo

---------------->
Subject: x86_64: Use generic percpu
From: Christoph Lameter <clameter@sgi.com>

x86_64 provides an optimized way to determine the local per cpu area
offset through the pda and determines the base by accessing a remote
pda.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/percpu_64.h |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

Index: linux-x86.q/include/asm-x86/percpu_64.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/percpu_64.h
+++ linux-x86.q/include/asm-x86/percpu_64.h
@@ -8,25 +8,13 @@
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
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
@@ -36,16 +24,6 @@ do {								\
 		       (src), (size));				\
 } while (0)
 
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
