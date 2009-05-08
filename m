Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZEHJFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZEHJFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZEHJEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:04:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZEHJEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:04:52 -0400
Date: Fri, 8 May 2009 11:04:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
Message-ID: <20090508090424.GB28455@elte.hu>
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
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


* Shaohua Li <shaohua.li@intel.com> wrote:

> lockdep report below warning when I try to offline one cpu:
> [  110.835487] =================================
> [  110.835616] [ INFO: inconsistent lock state ]
> [  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
> [  110.835757] ---------------------------------
> [  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b
> 
> smp_call_function_single() will disable interrupt. moving mce reenable/disable
> to workqueue, so no irq is disabled.
> 
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
> index 6fb0b35..739c824 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_64.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
> @@ -1057,30 +1057,32 @@ static __cpuinit void mce_remove_device(unsigned int cpu)
>  }
>  
>  /* Make sure there are no machine checks on offlined CPUs. */
> -static void mce_disable_cpu(void *h)
> +static long mce_disable_cpu(void *h)
>  {
>  	int i;
>  	unsigned long action = *(unsigned long *)h;
>  
>  	if (!mce_available(&current_cpu_data))
> -		return;
> +		return 0;
>  	if (!(action & CPU_TASKS_FROZEN))
>  		cmci_clear();
>  	for (i = 0; i < banks; i++)
>  		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
> +	return 0;
>  }
>  
> -static void mce_reenable_cpu(void *h)
> +static long mce_reenable_cpu(void *h)
>  {
>  	int i;
>  	unsigned long action = *(unsigned long *)h;
>  
>  	if (!mce_available(&current_cpu_data))
> -		return;
> +		return 0;
>  	if (!(action & CPU_TASKS_FROZEN))
>  		cmci_reenable();
>  	for (i = 0; i < banks; i++)
>  		wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
> +	return 0;
>  }
>  
>  /* Get notified when a cpu comes on/off. Be hotplug friendly. */
> @@ -1106,14 +1108,14 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
>  		del_timer_sync(t);
> -		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
> +		work_on_cpu(cpu, mce_disable_cpu, &action);
>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
>  		t->expires = round_jiffies(jiffies +
>  						__get_cpu_var(next_interval));
>  		add_timer_on(t, cpu);
> -		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
> +		work_on_cpu(cpu, mce_reenable_cpu, &action);
>  		break;

No, this needs a real fix - not a 'shut up lockdep' workaround.

One problem is that cmci_discover_lock is taken irq-unsafe, which is 
obviously a bad idea ...

Could you please try the fix for that from Hidetoshi-san, attached 
below (also available in latest -tip).

Thanks,

	Ingo

------------------>
>From e5299926d7459d9fa7c7f856983147817aedb10e Mon Sep 17 00:00:00 2001
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Fri, 8 May 2009 17:28:40 +0900
Subject: [PATCH] x86: MCE: make cmci_discover_lock irq-safe

Lockdep reports the warning below when Li tries to offline one cpu:

[  110.835487] =================================
[  110.835616] [ INFO: inconsistent lock state ]
[  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
[  110.835757] ---------------------------------
[  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b

cmci_clear() can be called via smp_call_function_single().

It is better to disable interrupt while holding cmci_discover_lock,
to turn it into an irq-safe lock - we can deadlock otherwise.

[ Impact: fix possible deadlock in the MCE code ]

Reported-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A03ED38.8000700@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Shaohua Li<shaohua.li@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..cef3ee3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -151,10 +151,11 @@ static void print_update(char *type, int *hdr, int num)
 static void cmci_discover(int banks, int boot)
 {
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	unsigned long flags;
 	int hdr = 0;
 	int i;
 
-	spin_lock(&cmci_discover_lock);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -184,7 +185,7 @@ static void cmci_discover(int banks, int boot)
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock(&cmci_discover_lock);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
 		printk(KERN_CONT "\n");
 }
@@ -211,13 +212,14 @@ void cmci_recheck(void)
  */
 void cmci_clear(void)
 {
+	unsigned long flags;
 	int i;
 	int banks;
 	u64 val;
 
 	if (!cmci_supported(&banks))
 		return;
-	spin_lock(&cmci_discover_lock);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
 			continue;
@@ -227,7 +229,7 @@ void cmci_clear(void)
 		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
-	spin_unlock(&cmci_discover_lock);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
