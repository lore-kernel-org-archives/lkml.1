Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZEMCcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZEMCcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZEMCbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:31:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57564 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZEMCbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:31:55 -0400
Message-ID: <4A0A310E.6060806@garzik.org>
Date: Tue, 12 May 2009 22:31:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
References: <20090508184838.GA11157@havoc.gtf.org> <200905122304.52395.rusty@rustcorp.com.au> <20090512140344.GO8633@ZenIV.linux.org.uk> <200905131142.27484.rusty@rustcorp.com.au>
In-Reply-To: <200905131142.27484.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> sched: avoid flexible array member inside struct (gcc extension)
> 
> struct sched_group and struct sched_domain end in 'unsigned long
> cpumask[]' which Jeff Garzik notes is not legal to place inside
> another struct.  It upsets sparse and clang (LLVM's C front end).
> 
> Al Viro pointed out that a union is the Right Way to do this.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Reported-by: Jeff Garzik <jeff@garzik.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  kernel/sched.c |   32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7756,22 +7756,24 @@ int sched_smt_power_savings = 0, sched_m
>   * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
>   * for nr_cpu_ids < CONFIG_NR_CPUS.
>   */
> -struct static_sched_group {
> +union static_sched_group {
>  	struct sched_group sg;
> -	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
> -};
> -
> -struct static_sched_domain {
> +	char _sg_and_cpus[sizeof(struct sched_group) +
> +			  BITS_TO_LONGS(CONFIG_NR_CPUS) * sizeof(long)];
> +};
> +
> +union static_sched_domain {
>  	struct sched_domain sd;
> -	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
> +	char _sd_and_cpus[sizeof(struct sched_domain) +
> +			  BITS_TO_LONGS(CONFIG_NR_CPUS) * sizeof(long)];
>  };

Looks good to me...  thanks!

	Jeff



