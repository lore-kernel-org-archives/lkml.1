Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZEOLYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZEOLYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZEOLYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:24:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:47859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZEOLYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:24:01 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: Rework the perf counter
 disable/enable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com
In-Reply-To: <18957.19594.735792.15284@cargo.ozlabs.ibm.com>
References: <new-submission>
	 <tip-9e35ad388bea89f7d6f375af4c0ae98803688666@git.kernel.org>
	 <18957.19594.735792.15284@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 13:23:47 +0200
Message-Id: <1242386627.6642.1751.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 21:05 +1000, Paul Mackerras wrote:
> tip-bot for Peter Zijlstra writes:
> 
> > x86 NMI/INT throttling has non-nested use of this, breaking things. Therefore
> > provide a reference counter disable/enable interface, where the first disable
> > disables the hardware, and the last enable enables the hardware again.
> 
> It looks to me like what you've done for powerpc enables the hardware
> again on the first enable, not the last one:
> 
> > @@ -436,7 +435,7 @@ u64 hw_perf_save_disable(void)
> >   * If we were previously disabled and counters were added, then
> >   * put the new config on the PMU.
> >   */
> > -void hw_perf_restore(u64 disable)
> > +void hw_perf_enable(void)
> >  {
> >  	struct perf_counter *counter;
> >  	struct cpu_hw_counters *cpuhw;
> > @@ -448,9 +447,12 @@ void hw_perf_restore(u64 disable)
> >  	int n_lim;
> >  	int idx;
> >  
> > -	if (disable)
> > -		return;
> >  	local_irq_save(flags);
> > +	if (!cpuhw->disabled) {
> > +		local_irq_restore(flags);
> > +		return;
> > +	}
> > +
> >  	cpuhw = &__get_cpu_var(cpu_hw_counters);
> >  	cpuhw->disabled = 0;
> 
> I do rely on nesting the disable/enable calls and only having the
> hardware re-enabled on the last enable.  I can't see anything here
> that detects the last enable.  Have I missed it somewhere?

+void perf_disable(void)
+{
+       __perf_disable();
+       hw_perf_disable();
+}

+void perf_enable(void)
+{
+       if (__perf_enable())
+               hw_perf_enable();
+}



