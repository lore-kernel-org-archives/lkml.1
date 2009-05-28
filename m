Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbZE1Oci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbZE1Oci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZE1Ocb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:32:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZE1Oca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:32:30 -0400
Date: Thu, 28 May 2009 10:32:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: report the time waited for a lock
In-Reply-To: <1238975373-15739-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0905281032010.27708@gandalf.stny.rr.com>
References: <1238975373-15739-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Frederic Weisbecker wrote:
> ---
>  include/trace/lockdep_event_types.h |   23 ++++++++++++++++++-----
>  kernel/lockdep.c                    |    8 ++++----
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
> index adccfcd..863f1e4 100644
> --- a/include/trace/lockdep_event_types.h
> +++ b/include/trace/lockdep_event_types.h
> @@ -32,11 +32,24 @@ TRACE_FORMAT(lock_contended,
>  	TP_FMT("%s", lock->name)
>  	);
>  
> -TRACE_FORMAT(lock_acquired,
> -	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
> -	TP_ARGS(lock, ip),
> -	TP_FMT("%s", lock->name)
> -	);
> +TRACE_EVENT(lock_acquired,
> +	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
> +
> +	TP_ARGS(lock, ip, waittime),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(unsigned long, wait_usec)
> +		__field(unsigned long, wait_nsec_rem)
> +	),
> +	TP_fast_assign(
> +		__entry->name = lock->name;
> +		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);

I know this is already accepted, but can you move the do_div into the 
print section.

Thanks,

-- Steve

> +		__entry->wait_usec = (unsigned long) waittime;
> +	),
> +	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
> +				       __entry->wait_nsec_rem)
> +);
>  
