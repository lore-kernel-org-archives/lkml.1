Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZEOLGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZEOLGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZEOLFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:05:50 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47835 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbZEOLFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:05:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18957.19594.735792.15284@cargo.ozlabs.ibm.com>
Date: Fri, 15 May 2009 21:05:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Subject: Re: [tip:perfcounters/core] perf_counter: Rework the perf counter disable/enable
In-Reply-To: <tip-9e35ad388bea89f7d6f375af4c0ae98803688666@git.kernel.org>
References: <new-submission>
	<tip-9e35ad388bea89f7d6f375af4c0ae98803688666@git.kernel.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Peter Zijlstra writes:

> x86 NMI/INT throttling has non-nested use of this, breaking things. Therefore
> provide a reference counter disable/enable interface, where the first disable
> disables the hardware, and the last enable enables the hardware again.

It looks to me like what you've done for powerpc enables the hardware
again on the first enable, not the last one:

> @@ -436,7 +435,7 @@ u64 hw_perf_save_disable(void)
>   * If we were previously disabled and counters were added, then
>   * put the new config on the PMU.
>   */
> -void hw_perf_restore(u64 disable)
> +void hw_perf_enable(void)
>  {
>  	struct perf_counter *counter;
>  	struct cpu_hw_counters *cpuhw;
> @@ -448,9 +447,12 @@ void hw_perf_restore(u64 disable)
>  	int n_lim;
>  	int idx;
>  
> -	if (disable)
> -		return;
>  	local_irq_save(flags);
> +	if (!cpuhw->disabled) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
>  	cpuhw = &__get_cpu_var(cpu_hw_counters);
>  	cpuhw->disabled = 0;

I do rely on nesting the disable/enable calls and only having the
hardware re-enabled on the last enable.  I can't see anything here
that detects the last enable.  Have I missed it somewhere?

Paul.
