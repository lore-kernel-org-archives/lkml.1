Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYKMLLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYKMLLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYKMLLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:11:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYKMLK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:10:59 -0500
Date: Thu, 13 Nov 2008 12:10:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] accelerate newidle balancing in relax_domain
Message-ID: <20081113111040.GA26461@elte.hu>
References: <491C0A01.5040106@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491C0A01.5040106@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Increasing the value of 'sched_relax_domain_level' in cpuset expands 
> the searching range of task balancing on some schedule events. As 
> the result it makes the task balancing in the range more aggressive, 
> so it will benefit some situation, such as where the latency is 
> required even it sacrifices cache hit rate etc. (for such situation, 
> it would be ideally best that cpus do not be idle until there are no 
> runnable task.)
> 
> This patch aimed to accelerate the balancing in the relax_domain.
> 
> The newidle balancing is kicked when tasks in a runqueue run out. It 
> finds and pulls runnable tasks from other busy cpus, checking load 
> imbalance between cpus.  Considering above situation, using loads in 
> short term is preferred than that in long term because it makes 
> balancing more aggressive otherwise it becomes relatively 
> conservative. The referenced load is selected by the newidle_idx 
> parameter of scheduler domains, so this patch tunes the parameters 
> only when domains are in the relax_domain's range.  There are no 
> effects if you don't use relax_domain.
> 
> Following is a result of my short-lightweight-transaction test, showing
> average of requester's latency (ms), 300 couple of threads running 30 sec
> on 8cpu/Itanium:
> 
>   1) v2.6.28-rc4
>      Average 0.748783 Std Div 1.688022 Throughput 165313
>   2) v2.6.28-rc4 + relax_domain
>      Average 0.536867 Std Div 1.115383 Throughput 168492
>   3) v2.6.28-rc4 + relax_domain + patch
>      Average 0.385164 Std Div 0.801875 Throughput 170069

that improvement in metric looks good.

> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 57c933f..c970239 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7366,6 +7366,8 @@ static void set_domain_attribute(struct sched_domain *sd,
>  	} else {
>  		/* turn on idle balance on this domain */
>  		sd->flags |= (SD_WAKE_IDLE_FAR|SD_BALANCE_NEWIDLE);
> +		/* make newidle balancing more aggressive */
> +		sd->newidle_idx = 0;

I agree with making it more sensitive to momentary load fluctuations. 
(as long as other metrics do not degrade).

But this solutin basically overrides the newidle_idx tuning in 
topology.h.

Is there a strong reason to do this tuning dynamically, or could we 
just decrease newidle_idx in the appropriate templates in the 
topology.h files?

	Ingo
