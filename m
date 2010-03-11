Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab0CKIc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:32:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:52445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab0CKIc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:32:58 -0500
Subject: Re: [PATCH] perf_events: fix X86 bogus counts when multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <1268288259-4011-1-git-send-email-eranian@google.com>
References: <1268288259-4011-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Mar 2010 09:32:41 +0100
Message-ID: <1268296361.5279.901.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 22:17 -0800, eranian@google.com wrote:
> This patch fixes a bug in 2.6.33 X86 event scheduling whereby
> all counts are bogus as soon as events need to be multiplexed
> because the PMU is overcommitted.
> 
> The code in hw_perf_enable() was causing multiplexed events
> to accumulate collected counts twice causing bogus results.
> 
> This is demonstrated on AMD Barcelona with the example
> below. First run, no conflict, you obtain the actual counts.
> Second run, PMU overcommitted, multiplexing, all events are
> over-counted. Third run, patch applied, you obtain the correct
> count through scaling.
> 

I'm a bit puzzled by this one, if we, during scheduling move an event
from idx 1 to idx 2, we need to stop it on 1 and start if on 2,
otherwise we do not properly transfer its count, right?

With the below patch it does no such thing.

I did fix some funnies I observed with hw_perf_enable() while doing the
PEBS stuff, and -tip does it wrong differently from what you illustrate,
so while there defenately is something to fix, I doubt the below is
correct.

> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> --
>  perf_event.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 97cddbf..ef5d63f 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -818,8 +818,6 @@ void hw_perf_enable(void)
>  			    match_prev_assignment(hwc, cpuc, i))
>  				continue;
>  
> -			x86_pmu_stop(event);
> -
>  			hwc->idx = -1;
>  		}



