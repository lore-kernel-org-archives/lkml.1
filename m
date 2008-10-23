Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYJWJkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYJWJkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYJWJkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:40:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYJWJkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:40:00 -0400
Date: Thu, 23 Oct 2008 11:40:36 +0200
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081023094036.GA7593@redhat.com>
References: <20081023005751.53973DDEFE@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023005751.53973DDEFE@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Rusty Russell wrote:
>
> +long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> +{
> +	struct work_for_cpu wfc;
> +
> +	INIT_WORK(&wfc.work, do_work_for_cpu);
> +	init_completion(&wfc.done);
> +	wfc.fn = fn;
> +	wfc.arg = arg;
> +	get_online_cpus();
> +	if (unlikely(!cpu_online(cpu))) {
> +		wfc.ret = -EINVAL;
> +		complete(&wfc.done);
> +	} else
> +		schedule_work_on(cpu, &wfc.work);

I do not claim this is wrong, but imho the code is a bit lisleading and
needs a comment (or the "fix", please see below).

Once we drop cpu_hotplug lock, CPU can go away and this work can migrate
to another cpu.

> +	put_online_cpus();
> +	wait_for_completion(&wfc.done);

Actually you don't need work_for_cpu->done, you can use flush_work().

IOW, I'd suggest

	long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
	{
		struct work_for_cpu wfc;

		INIT_WORK(&wfc.work, do_work_for_cpu);
		wfc.fn = fn;
		wfc.arg = arg;
		wfc.ret = -EINVAL;

		get_online_cpus();
		if (likely(cpu_online(cpu))) {
			schedule_work_on(cpu, &wfc.work);
			flush_work(&wfc.work);
		}
		put_online_cpus();

		return wfc.ret;
	}

Oleg.

