Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZGTKzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZGTKzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZGTKzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:55:07 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:12576 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZGTKzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:55:06 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Always return the parent counter id to
 userspace
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090720103825.GA9029@kryten>
References: <20090720103825.GA9029@kryten>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 12:55:46 +0200
Message-Id: <1248087346.15751.8437.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 20:38 +1000, Anton Blanchard wrote:
> When inheriting counters new tasks get new counter ids. Since
> userspace only knows about the parent ids we need to return them
> and not the actual ids.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Please add -p to your diff args, or use
QUILT_DIFF_OPTS="--show-c-function".


> ---
> Index: linux.trees.git/kernel/perf_counter.c
> ===================================================================
> --- linux.trees.git.orig/kernel/perf_counter.c	2009-07-20 20:17:44.000000000 +1000
> +++ linux.trees.git/kernel/perf_counter.c	2009-07-20 20:36:13.000000000 +1000
> @@ -154,6 +154,20 @@
>  	}
>  }
>  
> +/* 
> + * If we inherit counters we want to return the parent counter id 
> + * to userspace.
> + */
> +static u64 primary_counter_id(struct perf_counter *counter)
> +{
> +	u64 id = counter->id;
> +
> +	if (counter->parent)
> +		id = counter->parent->id;
> +
> +	return id;
> +}
> +
>  /*
>   * Get the perf_counter_context for a task and lock it.
>   * This has to cope with with the fact that until it is locked,
> @@ -1705,7 +1719,7 @@
>  		values[n++] = counter->total_time_running +
>  			atomic64_read(&counter->child_total_time_running);
>  	if (counter->attr.read_format & PERF_FORMAT_ID)
> -		values[n++] = counter->id;
> +		values[n++] = primary_counter_id(counter);
>  	mutex_unlock(&counter->child_mutex);
>  
>  	if (count < n * sizeof(u64))

Its impossible to read() anything but the parent counter, right?

Hmm, maybe because the lazy context switch thing allows counters to
wander about?

> @@ -2548,7 +2562,7 @@
>  		lost_event.header.type = PERF_EVENT_LOST;
>  		lost_event.header.misc = 0;
>  		lost_event.header.size = sizeof(lost_event);
> -		lost_event.id          = counter->id;
> +		lost_event.id          = primary_counter_id(counter);
>  		lost_event.lost        = atomic_xchg(&data->lost, 0);
>  
>  		perf_output_put(handle, lost_event);

All output is already done to the parent counter:

perf_output_begin():
	/*
	 * For inherited counters we send all the output towards the parent.
	 */
	if (counter->parent)
		counter = counter->parent;

> @@ -2704,8 +2718,10 @@
>  	if (sample_type & PERF_SAMPLE_ADDR)
>  		perf_output_put(&handle, data->addr);
>  
> -	if (sample_type & PERF_SAMPLE_ID)
> -		perf_output_put(&handle, counter->id);
> +	if (sample_type & PERF_SAMPLE_ID) {
> +		u64 id = primary_counter_id(counter);
> +		perf_output_put(&handle, id);
> +	}
>  
>  	if (sample_type & PERF_SAMPLE_CPU)
>  		perf_output_put(&handle, cpu_entry);

This will actually wreck things.

It would be impossible to relate PERF_EVENT_PERIOD/THROTTLE (and maybe
others) to their respective counters.

If you have inherited counters and each task will have separate ones,
you need separate IDs in their sample stream to be able to related
PERIOD and THROTTLE events.

> @@ -2727,7 +2743,7 @@
>  			if (sub != counter)
>  				sub->pmu->read(sub);
>  
> -			group_entry.id = sub->id;
> +			group_entry.id = primary_counter_id(sub);
>  			group_entry.counter = atomic64_read(&sub->count);
>  
>  			perf_output_put(&handle, group_entry);

Right, this I think you're right about.

> @@ -2790,11 +2806,7 @@
>  		u64 id;
>  
>  		event.header.size += sizeof(u64);
> -		if (counter->parent)
> -			id = counter->parent->id;
> -		else
> -			id = counter->id;
> -
> +		id = primary_counter_id(counter);
>  		event.format[i++] = id;
>  	}

Indeed, when there are multiple cases, the new function makes sense.

> @@ -3209,7 +3221,7 @@
>  			.size = sizeof(event),
>  		},
>  		.time = sched_clock(),
> -		.id = counter->id,
> +		.id = primary_counter_id(counter),
>  		.period = period,
>  	};
>  

I'm assuming this is in perf_log_period(), for which, see the above
comment.

> @@ -3241,7 +3253,7 @@
>  			.size = sizeof(throttle_event),
>  		},
>  		.time	= sched_clock(),
> -		.id	= counter->id,
> +		.id	= primary_counter_id(counter),
>  	};
>  
>  	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 1, 0);

>From the context this appears to be perf_log_throttle(), again see the
above comment.

