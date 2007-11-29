Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbXK2GKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbXK2GKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXK2GK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:10:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36089 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbXK2GK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:10:26 -0500
Date: Wed, 28 Nov 2007 22:10:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <474E4E2F.9010801@goop.org>
Message-ID: <Pine.LNX.4.64.0711282208230.21631@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
 <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
 <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
 <474E1900.1010209@goop.org> <Pine.LNX.4.64.0711281800100.20125@schroedinger.engr.sgi.com>
 <474E4E2F.9010801@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Second portion. Add a new seg_offset macro to calculate the offset. This 
can be avoided if the linker relocates the per cpu area to zero. Includes 
a patch to read trickle count via both methods to verify that it actually 
works. Both patches on top of the per cpu cleanup patches that I sent 
today too.


x86_64: Make the x86_32 percpu operations usable on x86_64

Calculate the offset relative to gs in order to be able to address
per cpu data using the x86_64 per cpu macros.

The subtraction of __per_cpu_start will make the offset based
from the beginning of the per cpu area. That is where gs points to.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/char/random.c    |    2 +-
 include/asm-x86/percpu.h |   29 ++++++++++++++++++-----------
 init/main.c              |    5 +++++
 3 files changed, 24 insertions(+), 12 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu.h	2007-11-28 17:50:01.861182410 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu.h	2007-11-28 21:22:50.845872906 -0800
@@ -16,7 +16,13 @@
 #define __my_cpu_offset read_pda(data_offset)
 
 #define per_cpu_offset(x) (__per_cpu_offset(x))
+#define __percpu_seg "%%gs:"
+/* Calculate the offset to use with the segment register */
+#define seg_offset(name)   (*SHIFT_PTR(&per_cpu_var(name), - (unsigned long)__per_cpu_start))
 
+#else
+#define __percpu_seg ""
+#define seg_offset(name)   per_cpu_var(name)
 #endif
 #include <asm-generic/percpu.h>
 
@@ -64,16 +70,11 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-
 #define __my_cpu_offset x86_read_percpu(this_cpu_off)
-
 /* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
-
 #else  /* !SMP */
-
 #define __percpu_seg ""
-
 #endif	/* SMP */
 
 #include <asm-generic/percpu.h>
@@ -81,6 +82,13 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#define seg_offset(name)	per_cpu_var(name)
+
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+
+#ifndef __ASSEMBLY__
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
@@ -132,11 +140,10 @@ extern void __bad_percpu_size(void);
 		}						\
 		ret__; })
 
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
+#define x86_read_percpu(var) percpu_from_op("mov", seg_offset(var))
+#define x86_write_percpu(var,val) percpu_to_op("mov", seg_offset(var), val)
+#define x86_add_percpu(var,val) percpu_to_op("add", seg_offset(var), val)
+#define x86_sub_percpu(var,val) percpu_to_op("sub", seg_offset(var), val)
+#define x86_or_percpu(var,val) percpu_to_op("or", seg_offset(var), val)
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 #endif /* _ASM_X86_PERCPU_H_ */
Index: linux-2.6.24-rc3-mm2/drivers/char/random.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/drivers/char/random.c	2007-11-28 21:20:58.225804398 -0800
+++ linux-2.6.24-rc3-mm2/drivers/char/random.c	2007-11-28 21:28:38.967363573 -0800
@@ -272,7 +272,7 @@ static int random_write_wakeup_thresh = 
 
 static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
 
-static DEFINE_PER_CPU(int, trickle_count) = 0;
+DEFINE_PER_CPU(int, trickle_count) = 55;
 
 /*
  * A pool of size .poolwords is stirred with a primitive polynomial
Index: linux-2.6.24-rc3-mm2/init/main.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/init/main.c	2007-11-28 21:10:54.245804225 -0800
+++ linux-2.6.24-rc3-mm2/init/main.c	2007-11-28 21:22:17.769053628 -0800
@@ -504,6 +504,8 @@ void __init __attribute__((weak)) smp_se
 {
 }
 
+DECLARE_PER_CPU(int, trickle_count);
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -645,6 +647,9 @@ asmlinkage void __init start_kernel(void
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 
+	printk("Reading trickle cound =%lu. Is %lu\n",
+		x86_read_percpu(trickle_count),
+		__raw_get_cpu_var(trickle_count));
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }

