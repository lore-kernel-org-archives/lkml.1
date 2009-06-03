Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZFCSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZFCSzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZFCSzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:55:41 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:3652 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752088AbZFCSzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:55:40 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1803O1432R98dR1805Mzz1202hzzz2fh6bh17ch62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
Message-ID: <4A26C6EC.30609@am.sony.com>
Date: Wed, 3 Jun 2009 11:54:36 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] ring-buffer: try to discard unneeded timestamps
References: <20090603141605.001049251@goodmis.org> <20090603141651.231310727@goodmis.org>
In-Reply-To: <20090603141651.231310727@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 18:54:37.0633 (UTC) FILETIME=[BE496B10:01C9E47C]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> There are times that a race may happen that we add a timestamp in a
> nested write. This timestamp would just contain a zero delta and serves
> no purpose.
> 
> Now that we have a way to discard events, this patch will try to discard
> the timestamp instead of just wasting the space in the ring buffer.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |   67 +++++++++++++++++++++++++++-----------------
>  1 files changed, 41 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9453023..5092660 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1335,6 +1335,38 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  	return event;
>  }
>  
> +static inline int
> +rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
> +		  struct ring_buffer_event *event)
> +{
> +	unsigned long new_index, old_index;
> +	struct buffer_page *bpage;
> +	unsigned long index;
> +	unsigned long addr;
> +
> +	new_index = rb_event_index(event);
> +	old_index = new_index + rb_event_length(event);
> +	addr = (unsigned long)event;
> +	addr &= PAGE_MASK;
> +
> +	bpage = cpu_buffer->tail_page;
> +
> +	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
> +		/*
> +		 * This is on the tail page. It is possible that
> +		 * a write could come in and move the tail page
> +		 * and write to the next page. That is fine
> +		 * because we just shorten what is on this page.
> +		 */
> +		index = local_cmpxchg(&bpage->write, old_index, new_index);
> +		if (index == old_index)
> +			return 1;
> +	}
> +
> +	/* could not discard */
> +	return 0;
> +}
> +

Is this new routine only for discarding uncommitted events,
or can it be used on committed events?

I assume the former, since I see nothing about adjusting the
commit position.

In the ring_buffer API I see that there's a function for
discarding events (committed ones), but not for free-ing them.
In function duration filtering, it is desirable to free the
last committed event, which for a function exit of short
duration will be it's entry event 99% of the time.
 -- Tim

P.S. I'm very sorry about the missing '>' on the Signed-off-by line.
I ran checkpatch and got a passing score, but missed this.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

