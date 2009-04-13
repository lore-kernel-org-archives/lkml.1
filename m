Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZDMWmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZDMWmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZDMWm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:42:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:63640 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZDMWmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DJ9AGj1E85DL0jguAjd9sXC9nySq4OuM4QZUXplwd3D5+bWBn4FmF0OZSOaj9wmzkM
         NYS0EFmDYcNxNRAi7paszKbQpGmNF4LsLg60FmzXb3J46b8hMFrRH4WXXCsftQNxbkKZ
         TSGI/P88eIVxsFsrH7t3gtj2kuHT/oHOsTFTk=
Date: Tue, 14 Apr 2009 00:42:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090413224219.GK5977@nowhere>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:36:06AM +0200, Frederic Weisbecker wrote:
> Impact: allow filtering by lock name / fix module tracing
> 
> Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> But we can't use the char * type for the name without risking to
> dereference a freed pointer. A lock name can come from a module
> towards lockdep and it is risky to only store its address because we
> defer its name printing.
> 
> That's why this patch uses a fixed array size and copy the name.
> Also it lets us filter the lock name because the event filtering
> doesn't handle the char pointers. Such support is not needed yet since
> the events don't use it for now because it is rarely easy to keep track
> of a string while we defer its output.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/trace/lockdep_event_types.h |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
> index 863f1e4..68f84f4 100644
> --- a/include/trace/lockdep_event_types.h
> +++ b/include/trace/lockdep_event_types.h
> @@ -32,18 +32,27 @@ TRACE_FORMAT(lock_contended,
>  	TP_FMT("%s", lock->name)
>  	);
>  
> +#define LOCK_NAME_SIZE	25



This constant may look a bit weird.
I just started with the assumption that a full lock name
will rarely exceed this length.

If you agree with it, I will expand the conversion of lockdep
TRACE_FORMAT to TRACE_EVENTS with the same assumption.
So that we will be able to use filters with locks events.

Thanks.



> +
> +/*
> + * We might loose the name if it comes from a module
> + * so we keep a fixed array size of 25, enough for most
> + * usecases.
> + */
> +
>  TRACE_EVENT(lock_acquired,
>  	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
>  
>  	TP_ARGS(lock, ip, waittime),
>  
>  	TP_STRUCT__entry(
> -		__field(const char *, name)
> +		__array(char, name, LOCK_NAME_SIZE)
>  		__field(unsigned long, wait_usec)
>  		__field(unsigned long, wait_nsec_rem)
>  	),
>  	TP_fast_assign(
> -		__entry->name = lock->name;
> +		strncpy(__entry->name, lock->name, LOCK_NAME_SIZE - 1);
> +		__entry->name[LOCK_NAME_SIZE - 1] = 0;
>  		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
>  		__entry->wait_usec = (unsigned long) waittime;
>  	),
> -- 
> 1.6.1
> 

