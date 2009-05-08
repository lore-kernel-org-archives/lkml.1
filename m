Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZEHISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZEHISW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZEHISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:18:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40773 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZEHISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:18:06 -0400
Message-ID: <4A03EA8C.9040104@jp.fujitsu.com>
Date: Fri, 08 May 2009 17:17:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
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

I want a confirmation.
Will this scheduled work be executed properly on the cpu which is going
to offline?

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
>  	case CPU_POST_DEAD:
>  		/* intentionally ignoring frozen here */
> 

I believe there is strong reason to have "1" in the last argument of
smp_call_function_single().


Thanks,
H.Seto

