Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZHYS6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZHYS6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZHYS6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:58:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36698 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZHYS6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:58:39 -0400
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4A942BDD.70303@nets.rwth-aachen.de>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>
	 <4A94161A.2020609@nets.rwth-aachen.de>
	 <1251219129.4852.1.camel@penberg-laptop>
	 <4A94242E.30309@nets.rwth-aachen.de>
	 <1251223399.13451.5.camel@penberg-laptop>
	 <4A942BDD.70303@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 21:58:39 +0300
Message-Id: <1251226720.13451.15.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 20:22 +0200, Arnd Hannemann wrote:
> Pekka Enberg wrote:
> > On Tue, 2009-08-25 at 19:49 +0200, Arnd Hannemann wrote:
> >> Hi Pekka,
> >>
> >> Pekka Enberg wrote:
> >>> On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
> >>>>> Thanks for doing the bisect! Can we also see your .config
> >>>>> also?
> >>>> Config for -rc7 is attached. My bisect configs were based on
> >>>> that
> >>> Thanks! While we wait for the Xen people, you can try the
> >>> following patch to see if we can narrow the bug down to
> >>> trap_init().
> >> Yes seems to be trap_init(). -rc7 with this patch applied boots up
> >> to the prompt.
> >
> > Thanks for testing! Ingo, what do you think of the following patch?
> > AFAICT, x86-32 is the only architecture playing with traps in
> > mem_init() so this should be the safest fix for 2.6.31.
> 
> Hmm, -rc7 + this fix does not work for me :-/
> Still hangs before any output...

Arnd, does this work for you?

			Pekka

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..b86472d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -50,6 +50,7 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_ARCH_KMEMCHECK
+	select HAVE_ARCH_MEM_INIT_LATE if X86_32
 
 config OUTPUT_FORMAT
 	string
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3cd7711..488ed4b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -956,13 +956,17 @@ void __init mem_init(void)
 	BUG_ON(VMALLOC_START				>= VMALLOC_END);
 	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
 
-	if (boot_cpu_data.wp_works_ok < 0)
-		test_wp_bit();
-
 	save_pg_dir();
 	zap_low_mappings(true);
 }
 
+void __init mem_init_late(void)
+{
+	/* Interrupts are enabled at this point. */
+	if (boot_cpu_data.wp_works_ok < 0)
+		test_wp_bit();
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9a72cc7..eefcfbe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1052,6 +1052,14 @@ extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
 
+#ifdef CONFIG_HAVE_ARCH_MEM_INIT_LATE
+extern void mem_init_late(void);
+#else
+static inline void mem_init_late(void)
+{
+}
+#endif
+
 #ifdef CONFIG_NUMA
 extern void setup_per_cpu_pageset(void);
 #else
diff --git a/init/main.c b/init/main.c
index 2d9d6bd..45d8dbd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -643,6 +643,7 @@ asmlinkage void __init start_kernel(void)
 	set_gfp_allowed_mask(__GFP_BITS_MASK);
 
 	kmem_cache_init_late();
+	mem_init_late();
 
 	/*
 	 * HACK ALERT! This is early. We're enabling the console before


