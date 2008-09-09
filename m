Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYIIHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYIIHrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYIIHrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:47:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYIIHrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:47:41 -0400
Date: Tue, 9 Sep 2008 09:47:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
Message-ID: <20080909074727.GA13747@elte.hu>
References: <48C13D1C.76E4.0078.0@novell.com> <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com> <20080908134019.GB11993@elte.hu> <20080908185417.GA17654@elte.hu> <48C64524.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C64524.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

thanks, i've applied the delta below.

	Ingo

---------->
>From b9397fe215791b4f83bda23b9f3c0d5200e94558 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 9 Sep 2008 09:45:32 +0200
Subject: [PATCH] x86: x86_{phys,virt}_bits field also for i386, fix

fix mismerge.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |   15 +++++----------
 arch/x86/mm/ioremap.c        |    2 +-
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index df6c387..b26c09e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -439,6 +439,11 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 			c->x86_cache_alignment = c->x86_clflush_size;
 		}
 	}
+
+#ifdef CONFIG_X86_32
+	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
+		c->x86_phys_bits = 36;
+#endif
 }
 
 static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
@@ -520,11 +525,6 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	cpu_detect(c);
 
-#ifdef CONFIG_X86_32
-	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
-		c->x86_phys_bits = 36;
-#endif
-
 	get_cpu_vendor(c);
 
 	get_cpu_cap(c);
@@ -667,11 +667,6 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	generic_identify(c);
 
-#ifdef CONFIG_X86_32
-	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
-		c->x86_phys_bits = 36;
-#endif
-
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 74d16f2..ce207ba 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -25,7 +25,7 @@
 static inline int phys_addr_valid(unsigned long addr)
 {
 #ifdef CONFIG_RESOURCES_64BIT
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+	return !(addr >> boot_cpu_data.x86_phys_bits);
 #else
 	return 1;
 #endif
