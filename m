Return-Path: <linux-kernel-owner+w=401wt.eu-S934172AbXK3LLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172AbXK3LLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbXK3LLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:11:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40273 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761627AbXK3LLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:11:24 -0500
Date: Fri, 30 Nov 2007 12:11:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, ak@suse.de
Subject: Re: [patch 04/10] x86_32: Use generic percpu.h
Message-ID: <20071130111100.GB32431@elte.hu>
References: <20071128210926.008783214@sgi.com> <20071128211526.880137420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128211526.880137420@sgi.com>
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


merge to x86.git below. Please check.

	Ingo

---->
Subject: x86_32: Use generic percpu.h
From: Christoph Lameter <clameter@sgi.com>

x86_32 only provides a special way to obtain the local per cpu area offset
via x86_read_percpu. Otherwise it can fully use the generic handling.

Cc: ak@suse.de
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/percpu_32.h |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

Index: linux-x86.q/include/asm-x86/percpu_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/percpu_32.h
+++ linux-x86.q/include/asm-x86/percpu_32.h
@@ -42,26 +42,7 @@
  */
 #ifdef CONFIG_SMP
 
-/* This is used for other cpus to find our section. */
-extern unsigned long __per_cpu_offset[];
-
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-/* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
-
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_indentifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
-
-#define __raw_get_cpu_var(var) (*({					\
-	extern int simple_indentifier_##var(void);			\
-	RELOC_HIDE(&per_cpu__##var, x86_read_percpu(this_cpu_off));	\
-}))
-
-#define __get_cpu_var(var) __raw_get_cpu_var(var)
+#define __my_cpu_offset x86_read_percpu(this_cpu_off)
 
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
@@ -74,11 +55,18 @@ do {								\
 
 /* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
+
 #else  /* !SMP */
-#include <asm-generic/percpu.h>
+
 #define __percpu_seg ""
+
 #endif	/* SMP */
 
+#include <asm-generic/percpu.h>
+
+/* We can use this directly for local CPU (faster). */
+DECLARE_PER_CPU(unsigned long, this_cpu_off);
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
