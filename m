Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZHYQwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZHYQwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZHYQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:52:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57805 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZHYQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:52:09 -0400
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A94161A.2020609@nets.rwth-aachen.de>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>
	 <4A94161A.2020609@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 19:52:08 +0300
Message-Id: <1251219129.4852.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
> > Thanks for doing the bisect! Can we also see your .config also?
> 
> Config for -rc7 is attached. My bisect configs were based on that

Thanks! While we wait for the Xen people, you can try the following
patch to see if we can narrow the bug down to trap_init().

			Pekka

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3cd7711..7e8e4e4 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -956,8 +956,10 @@ void __init mem_init(void)
 	BUG_ON(VMALLOC_START				>= VMALLOC_END);
 	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
 
+#if 0
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
+#endif
 
 	save_pg_dir();
 	zap_low_mappings(true);
diff --git a/init/main.c b/init/main.c
index 2d9d6bd..5c4dacb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -603,7 +603,6 @@ asmlinkage void __init start_kernel(void)
 	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
-	trap_init();
 	mm_init();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
@@ -621,6 +620,7 @@ asmlinkage void __init start_kernel(void)
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
+	trap_init();
 	rcu_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();


