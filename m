Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZCEPiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZCEPiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZCEPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:38:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbZCEPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:38:09 -0500
Date: Thu, 5 Mar 2009 16:34:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090305153436.GA3939@redhat.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304121937.GE9855@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Arun R Bharadwaj wrote:
>
> @@ -628,7 +629,7 @@ __mod_timer(struct timer_list *timer, un
>  {
>  	struct tvec_base *base, *new_base;
>  	unsigned long flags;
> -	int ret;
> +	int ret, current_cpu, preferred_cpu;
>  
>  	ret = 0;
>  
> @@ -649,6 +650,16 @@ __mod_timer(struct timer_list *timer, un
>  
>  	new_base = __get_cpu_var(tvec_bases);
>  
> +	current_cpu = smp_processor_id();
> +	preferred_cpu = get_nohz_load_balancer();
> +	if (enable_timer_migration && !tbase_get_pinned(timer->base) &&
> +			idle_cpu(current_cpu) && preferred_cpu != -1) {
> +		new_base = per_cpu(tvec_bases, preferred_cpu);
> +		timer_set_base(timer, new_base);
> +		timer->expires = expires;
> +		internal_add_timer(new_base, timer);
> +		goto out_unlock;

I didn't read the whole series, but this looks very wrong.

We can not do internal_add_timer/etc until we lock new_base, please
look how the current code does this under "if (base != new_base)".

I think you can do something like

	-	new_base = __get_cpu_var(tvec_bases);
	+
	+	new_cpu = smp_processor_id();
	+	if (enable_timer_migration && ....)
	+		new_cpu = preferred_cpu;
	+
	+	new_base = per_cpu(tvec_bases, new_cpu);

		if (base != new_base) {

Oleg.

