Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZCWIeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZCWIeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZCWIdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:33:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:60068 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbZCWIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j/hCH2RR19M6WTNqQgSNY83EHeInQwuG36Clbh500eZezIjYNmBtOojH6al+A51A4/
         b6KWOGCdHZlfMCOC93yN2xwfFrXcxDKm0a9iJlMVWw1OtsmmoImmeWhpKUjR4OE6+QXl
         F6SurYNBGwTM/Ylrj0XUBeh72yxbDXPHaAI6A=
Subject: Re: [PATCH v2] tracing/events: don't discard an event after commit
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1237763919-21505-1-git-send-email-fweisbec@gmail.com>
References: <1237763712-21423-1-git-send-email-fweisbec@gmail.com>
	 <1237763919-21505-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 03:33:03 -0500
Message-Id: <1237797183.7527.47.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Mon, 2009-03-23 at 00:18 +0100, Frederic Weisbecker wrote:
> Note: depends on "tracing/events: don't use wake up for events"
> 
> When we want to filter an event, the filter test is done after
> the event is commited to the ring-buffer to be discarded later if
> needed.
> 
> But a reader could be reading this event while we are trying to discard
> it. Other kind of racy events can even happen because the event is
> commited and can be read and/or consumed.
> 
> What we want is to discard the event before committing it.
> 

Thanks for fixing this - I had intend on doing this, but it completely
slipped my mind.

Thanks for all your other comments and fixes too...

Tom

> v2: add a reported-by Steven Rostedt
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_events_stage_3.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> index 9a3bd49..9d2fa78 100644
> --- a/kernel/trace/trace_events_stage_3.h
> +++ b/kernel/trace/trace_events_stage_3.h
> @@ -222,10 +222,11 @@ static void ftrace_raw_event_##call(proto)				\
>  									\
>  	assign;								\
>  									\
> -	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
> -									\
>  	if (call->preds && !filter_match_preds(call, entry))		\
>  		ring_buffer_event_discard(event);			\
> +									\
> +	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
> +									\
>  }									\
>  									\
>  static int ftrace_raw_reg_event_##call(void)				\

