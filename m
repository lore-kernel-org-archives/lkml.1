Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZIXQAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZIXQAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIXQAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:00:51 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:53607 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZIXQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:00:50 -0400
Date: Thu, 24 Sep 2009 18:00:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       tglx@tglx.de
Subject: Re: [RFC PATCH] timer: provide microaccounting for iowait in
 addition to idle time
Message-ID: <20090924180051.7792f285@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20090924133938.6d71db13@infradead.org>
References: <20090924133938.6d71db13@infradead.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 13:39:38 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> @@ -190,19 +195,61 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
>  u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
>  {
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +	ktime_t now, delta;
>  
>  	if (!tick_nohz_enabled)
>  		return -1;
>  
> -	if (ts->idle_active)
> -		*last_update_time = ktime_to_us(ts->idle_lastupdate);
> -	else
> -		*last_update_time = ktime_to_us(ktime_get());
> +	now = ktime_get();
> +	if (ts->idle_active) {
> +		delta = ktime_sub(now, ts->idle_entrytime);
> +		ts->idle_lastupdate = now;
> +		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> +		if (nr_iowait_cpu()>0)
> +			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
> +		ts->idle_entrytime = now;
> +	}
> +
> +	if (last_update_time) {
> +		if (ts->idle_active)
> +			*last_update_time = ktime_to_us(ts->idle_lastupdate);
> +		else
> +			*last_update_time = ktime_to_us(ktime_get());
> +	}
>  
>  	return ktime_to_us(ts->idle_sleeptime);
>  }
>  EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);

Is the second ktime_get() call really necessary? Why can't "now" be reused?

> +u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> +{
> +	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +	ktime_t now, delta;
> +
> +	if (!tick_nohz_enabled)
> +		return -1;
> +
> +	now = ktime_get();
> +	if (ts->idle_active) {
> +		delta = ktime_sub(now, ts->idle_entrytime);
> +		ts->idle_lastupdate = now;
> +		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> +		if (nr_iowait_cpu()>0)
> +			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
> +		ts->idle_entrytime = now;
> +	}
> +
> +	if (last_update_time) {
> +		if (ts->idle_active)
> +			*last_update_time = ktime_to_us(ts->idle_lastupdate);
> +		else
> +			*last_update_time = ktime_to_us(ktime_get());
> +	}
> +
> +	return ktime_to_us(ts->iowait_sleeptime);
> +}
> +EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);

Same here.

But except for the superfluous ktime_gets I have no objections.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

