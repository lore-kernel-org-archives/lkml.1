Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXL1ATq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXL1ATq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXL1AQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:16:30 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45705 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755223AbXL1AQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:16:18 -0500
Message-Id: <20071228001618.285109000@sgi.com>
References: <20071228001617.597161000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Dec 2007 16:16:22 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>, tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH 05/10] x86_64: Use generic percpu
Content-Disposition: inline; filename=x86_64_use_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 provides an optimized way to determine the local per cpu area
offset through the pda and determines the base by accessing a remote
pda.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>


---
 include/asm-x86/percpu_64.h |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

--- a/include/asm-x86/percpu_64.h
+++ b/include/asm-x86/percpu_64.h
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
