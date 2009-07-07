Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZGGGHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZGGGHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZGGGHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:07:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZGGGHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:07:35 -0400
Message-ID: <4A52E627.10507@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 14:07:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace_workqueue: add refcnt to struct cpu_workqueue_stats
References: <4A51B16F.6010608@cn.fujitsu.com>
In-Reply-To: <4A51B16F.6010608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The stat entries can be freed when the stat file is being read.
> The worse is, the ptr can be freed immediately after it's returned
> from workqueue_stat_start/next().
> 
> Add a refcnt to struct cpu_workqueue_stats to avoid use-after-free.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
...
> @@ -175,11 +184,14 @@ static void *workqueue_stat_next(void *prev, int idx)
>  				return NULL;
>  		} while (!(ret = workqueue_stat_start_cpu(cpu)));
>  		return ret;
> +	} else {
> +		ret = list_entry(prev_cws->list.next,
> +				 struct cpu_workqueue_stats, list);

I just realized accessing prev_cws->list.next can be invalid!

We can fix it by using list_del_init() to delete cws->list in
probe_workqueue_destruction(), but then if the race happened,
the next time stat_next() is called, NULL will be returned.
I guess this is Ok, since the race is rare.

(I never like the design of trace_stat..Fortunately we'll
probably switch to perfcounter for this kind of statistics
reporting)

> +		kref_get(&ret->kref);
>  	}
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  
> -	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
> -			  list);
> +	return ret;
>  }

