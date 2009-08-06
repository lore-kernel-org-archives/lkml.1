Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZHFJMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZHFJMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZHFJML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:12:11 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:40144 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZHFJMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:12:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/urgent] ftrace: Fix perf-tracepoint OOPS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, chris.mason@oracle.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-af6af30c0fcd77e621638e53ef8b176bca8bd3b4@git.kernel.org>
References: <1249497664.5890.4.camel@laptop>
	 <tip-af6af30c0fcd77e621638e53ef8b176bca8bd3b4@git.kernel.org>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 11:11:50 +0200
Message-Id: <1249549910.32113.70.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [ v2: fix build error in the !CONFIG_EVENT_PROFILE case ]
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/linux/ftrace_event.h       |    8 +++-----
>  kernel/trace/trace_event_profile.c |    2 +-
>  kernel/trace/trace_events.c        |    2 +-
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5c093ff..d7cd193 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -119,11 +119,9 @@ struct ftrace_event_call {
>  	void			*filter;
>  	void			*mod;
>  
> -#ifdef CONFIG_EVENT_PROFILE
> -	atomic_t	profile_count;
> -	int		(*profile_enable)(struct ftrace_event_call *);
> -	void		(*profile_disable)(struct ftrace_event_call *);
> -#endif
> +	atomic_t		profile_count;
> +	int			(*profile_enable)(struct ftrace_event_call *);
> +	void			(*profile_disable)(struct ftrace_event_call *);
>  };

Ah, I would have added ifdefs around the below bit.

> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 23d2972..e75276a 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  		entry = trace_create_file("enable", 0644, call->dir, call,
>  					  enable);
>  
> -	if (call->id)
#ifdef CONFIG_EVENT_PROFILE
> +	if (call->id && call->profile_enable)
>  		entry = trace_create_file("id", 0444, call->dir, call,
>  					  id);
#endif

Like that, but I guess this works too ;-)

