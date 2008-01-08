Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYAHVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYAHVLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYAHVK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:10:29 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60534 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751462AbYAHVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:10:25 -0500
Message-Id: <20080108211024.505265000@sgi.com>
References: <20080108211023.923047000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 13:10:27 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH 04/10] x86_32: Use generic percpu.h
Content-Disposition: inline; filename=x86_32_use_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_32 only provides a special way to obtain the local per cpu area offset
via x86_read_percpu. Otherwise it can fully use the generic handling.

Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: ak@suse.de
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

---
 include/asm-x86/percpu_32.h |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/include/asm-x86/percpu_32.h
+++ b/include/asm-x86/percpu_32.h
@@ -42,34 +42,22 @@
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

-- 
