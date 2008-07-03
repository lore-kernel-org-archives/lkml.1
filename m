Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYGCODi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYGCODi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYGCOD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:03:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYGCOD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:03:28 -0400
Date: Thu, 3 Jul 2008 16:03:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: move prefill_possible_map calling early
Message-ID: <20080703140311.GA24485@elte.hu>
References: <200806301834.59156.yhlu.kernel@gmail.com> <200807021851.02301.yinghai.lu@sun.com> <200807021854.40729.yhlu.kernel@gmail.com> <20080703135421.GA7603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703135421.GA7603@elte.hu>
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


FYI, this one needed the small fixlet below. (prefill_possible_map() is 
dependent on both CONFIG_SMP and CONFIG_HOTPLUG_CPU - not just 
CONFIG_SMP)

	Ingo

-------------->
commit bb42b7bdee9decad536c1e747e2ce2f3daebb76f
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jul 3 15:57:47 2008 +0200

    x86: move prefill_possible_map calling early, fix
    
    fix:
    
    arch/x86/kernel/built-in.o: In function `setup_arch':
    : undefined reference to `prefill_possible_map'
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index bf6b5ee..c2784b3 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -114,8 +114,6 @@ void native_send_call_func_single_ipi(int cpu);
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 
-extern void prefill_possible_map(void);
-
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
@@ -124,11 +122,15 @@ static inline int num_booting_cpus(void)
 {
 	return cpus_weight(cpu_callout_map);
 }
+#endif /* CONFIG_SMP */
+
+#if defined(CONFIG_SMP) && defined(CONFIG_HOTPLUG_CPU)
+extern void prefill_possible_map(void);
 #else
 static inline void prefill_possible_map(void)
 {
 }
-#endif /* CONFIG_SMP */
+#endif
 
 extern unsigned disabled_cpus __cpuinitdata;
 
