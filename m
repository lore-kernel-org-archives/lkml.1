Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZEONiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZEONiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbZEONhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:37:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:38018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbZEONhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:37:52 -0400
Subject: Re: [PATCH 3/4] perf_counter: frequency based adaptive irq_period
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090515132018.646195868@chello.nl>
References: <20090515131925.616419905@chello.nl>
	 <20090515132018.646195868@chello.nl>
Content-Type: text/plain
Date: Fri, 15 May 2009 15:37:47 +0200
Message-Id: <1242394667.6642.1887.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 15:19 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf_counter-freq.patch)
> Instead of specifying the irq_period for a counter, provide a target interrupt
> frequency and dynamically adapt the irq_period to match this frequency.
> 
> Paul, please verify ppc64, I only did a very quick pass over that code.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> ---

> @@ -2907,6 +2940,12 @@ perf_counter_alloc(struct perf_counter_h
>  
>  	pmu = NULL;
>  
> +	hwc = &counter->hw;
> +	if (hw_event->freq && hw_event->irq_freq)
> +		hwc->irq_period = TICK_NSEC / hw_event->irq_freq;
> +	else
> +		hwc->irq_period = hw_event->irq_period;
> +



kernel/built-in.o: In function `perf_counter_alloc':
perf_counter.c:(.text+0x7ddc7): undefined reference to `__udivdi3'

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2942,7 +2942,7 @@ perf_counter_alloc(struct perf_counter_h
 
 	hwc = &counter->hw;
 	if (hw_event->freq && hw_event->irq_freq)
-		hwc->irq_period = TICK_NSEC / hw_event->irq_freq;
+		hwc->irq_period = div64_u64(TICK_NSEC, hw_event->irq_freq);
 	else
 		hwc->irq_period = hw_event->irq_period;
 


