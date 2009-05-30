Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZE3BBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZE3BBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZE3BBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 21:01:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58991 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZE3BBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 21:01:06 -0400
Message-ID: <4A208538.3040406@ti.com>
Date: Fri, 29 May 2009 20:00:40 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
References: <4A1D52E3.3040204@ti.com>  <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain> <1243455615.7440.17.camel@localhost.localdomain> <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain> <4A1EF244.5040108@ti.com> <alpine.LFD.2.00.0905282231500.3397@localhost.localdomain> <4A1EFDBD.8040007@ti.com>
In-Reply-To: <4A1EFDBD.8040007@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jon Hunter wrote:
> +		 * Calculate the time delta for the next timer event.
> +		 * If the time delta exceeds the maximum time delta
> +		 * permitted by the current clocksource then adjust
> +		 * the time delta accordingly to ensure the
> +		 * clocksource does not wrap.
> +		 */
> +		time_delta = tick_period.tv64 * delta_jiffies;

Thinking about this more, although it is very unlikely, for 64-bit 
machines there is a chance that the above multiply could overflow if 
delta_jiffies is very large.

tick_period.tv64 should always be less than NSEC_PER_SEC and so you 
would need delta_jiffies to be greater than 2^32 to cause overflow. On a 
32-bit machine an unsigned long will not be greater than 2^32 as it is 
only 32-bits but this would be possible on a 64-bit machines.

So to be safe we should make sure that delta_jiffies is not greater than 
  NEXT_TIMER_MAX_DELTA (2^30 - 1) before doing the multiply. If you 
think that this is a valid concern, then I can re-work and re-post. 
Sorry for not catching this before.

Jon

