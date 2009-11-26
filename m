Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbZKZRhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbZKZRhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZKZRhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:37:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:47974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZKZRhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:37:02 -0500
Subject: Re: [PATCH] perf_events: fix read() bogus counts when in error
 state
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net, eranian@gmail.com
In-Reply-To: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
References: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 18:36:56 +0100
Message-ID: <1259257016.31676.308.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 09:24 -0800, Stephane Eranian wrote:
> 	When a pinned group cannot be scheduled it goes into error state.
> 	Normally a group cannot go out of error state without being explicitly
> 	re-enabled or disabled. There was a bug in per-thread mode, whereby
> 	upon termination of the thread, the group would transition from error
> 	to off leading to bogus counts and timing information returned by
> 	read().

> 	Signed-off-by: Stephane Eranian <eranian@google.com>

Right, good catch, totally forgot about error state :/

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
	
> ---
>  perf_event.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 0b0d5f7..7a8bb5b 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -333,7 +333,16 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
>  		event->group_leader->nr_siblings--;
>  
>  	update_event_times(event);
> -	event->state = PERF_EVENT_STATE_OFF;
> +
> +	/*
> +	 * If event was in error state, then keep it
> +	 * that way, otherwise bogus counts will be
> +	 * returned on read(). The only way to get out
> +	 * of error state is by explicit re-enabling
> +	 * of the event
> +	 */
> +	if (event->state > PERF_EVENT_STATE_OFF)
> +		event->state = PERF_EVENT_STATE_OFF;
>  
>  	/*
>  	 * If this was a group event with sibling events then


