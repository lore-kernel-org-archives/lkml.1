Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZCDQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZCDQdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZCDQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:33:12 -0500
Received: from fifo99.com ([67.223.236.141]:47438 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZCDQdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:33:12 -0500
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
From: Daniel Walker <dwalker@fifo99.com>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
In-Reply-To: <20090304121937.GE9855@linux.vnet.ibm.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com>
	 <20090304121937.GE9855@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 08:33:09 -0800
Message-Id: <1236184389.5937.40.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 17:49 +0530, Arun R Bharadwaj wrote:
> @@ -649,6 +650,16 @@ __mod_timer(struct timer_list *timer, un
>  
>         new_base = __get_cpu_var(tvec_bases);
>  
> +       current_cpu = smp_processor_id();
> +       preferred_cpu = get_nohz_load_balancer();
> +       if (enable_timer_migration && !tbase_get_pinned(timer->base)
> &&
> +                       idle_cpu(current_cpu) && preferred_cpu != -1)
> {
> +               new_base = per_cpu(tvec_bases, preferred_cpu);
> +               timer_set_base(timer, new_base);
> +               timer->expires = expires;
> +               internal_add_timer(new_base, timer);
> +               goto out_unlock;
> +       }

Are you sure this compiles w/ CONFIG_SMP=n ? It looks like
enable_timer_migration wouldn't exist in that case, but the chunks your
adding in the timer code are still using it.

Daniel

