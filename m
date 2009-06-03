Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZFCBBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZFCBBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 21:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZFCBBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 21:01:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58532 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZFCBBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 21:01:31 -0400
Date: Tue, 2 Jun 2009 21:01:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix bug in ring_buffer_discard_commit
In-Reply-To: <4A25BE9E.5090909@am.sony.com>
Message-ID: <alpine.DEB.2.00.0906022100560.14994@gandalf.stny.rr.com>
References: <4A25BE9E.5090909@am.sony.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, Tim Bird wrote:

> There's a bug in ring_buffer_discard_commit.  The wrong
> pointer is being compared in order to check if the event
> can be freed from the buffer rather than discarded
> (i.e. marked as PAD).
> 
> I noticed this when I was working on duration filtering.
> The bug is not deadly - it just results in lots of wasted
> space in the buffer.  All filtered events are left in
> the buffer and marked as discarded, rather than being
> removed from the buffer to make space for other events.
> 
> Unfortunately, when I fixed this bug, I got errors doing a
> filtered function trace.  Multiple TIME_EXTEND
> events pile up in the buffer, and trigger the
> following loop overage warning in rb_iter_peek():
> 
> again:
> 	...
> 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
> 		return NULL;
> 
> I'm not sure what the best way is to fix this. I don't
> know if I should extend the loop threshhold, or if I should
> make the test more complex (ignore TIME_EXTEND
> events), or just get rid of this loop check completely.
> 
> Note that if I implement a workaround for this, then I
> see another problem from rb_advance_iter().  I haven't
> tracked that one down yet.
> 
> In general, it seems like the case of removing filtered
> events has not been working properly, and so some assumptions
> about buffer invariant conditions need to be revisited.
> 
> Here's the patch for the simple fix:
> 
> Compare correct pointer for checking if an event can be
> freed rather than left as discarded in the buffer.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com

Thanks Tim! I'll queue it up.

I'll take a look at the code to see what other issues might be happening.

-- Steve

> ---
>  kernel/trace/ring_buffer.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1711,7 +1711,7 @@ void ring_buffer_discard_commit(struct r
> 
>  	bpage = cpu_buffer->tail_page;
> 
> -	if (bpage == (void *)addr && rb_page_write(bpage) == old_index) {
> +	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
>  		/*
>  		 * This is on the tail page. It is possible that
>  		 * a write could come in and move the tail page
> 
> 
