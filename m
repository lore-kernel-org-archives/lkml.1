Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYI2TTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYI2TTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYI2TTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:19:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:24189 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYI2TTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=EymiGxk7dglHlVwmrnzOaeRowlQFimCl471gqbJOr5Fm9Bb5F3z1ZvAw7gHr25PbRX
         5Hhpzqto2azrSaWrmvAyI2DVd3ji+GdDrgaU9M/WVJgusM7uhz+cP7l12NOEt+a+euZj
         W6jsPgVR1i2AxgQe2ON5q3rgvGGxxI1IVk6P0=
Date: Mon, 29 Sep 2008 22:19:34 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new
 type of print_line
Message-ID: <20080929221934.260306dd@daedalus.pq.iki.fi>
In-Reply-To: <48E11E1E.7010001@gmail.com>
References: <48E11E1E.7010001@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 20:27:42 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Adapt mmiotrace to the new print_line type.
> By default, it ignores (and consumes) types it doesn't support.
> 
> Acked-by: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Ack!
All four patches looking good.


Cheers.

> ---
>  kernel/trace/trace_mmiotrace.c |   25 ++++++++++++-------------
>  1 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index a108c32..be0a6b0 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -171,7 +171,7 @@ print_out:
>  	return (ret == -EBUSY) ? 0 : ret;
>  }
>  
> -static int mmio_print_rw(struct trace_iterator *iter)
> +static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
>  	struct mmiotrace_rw *rw	= &entry->field.mmiorw;
> @@ -209,11 +209,11 @@ static int mmio_print_rw(struct trace_iterator *iter)
>  		break;
>  	}
>  	if (ret)
> -		return 1;
> -	return 0;
> +		return TRACE_TYPE_HANDLED;
> +	return TRACE_TYPE_PARTIAL_LINE;
>  }
>  
> -static int mmio_print_map(struct trace_iterator *iter)
> +static enum print_line_t mmio_print_map(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
>  	struct mmiotrace_map *m	= &entry->field.mmiomap;
> @@ -221,7 +221,7 @@ static int mmio_print_map(struct trace_iterator *iter)
>  	unsigned long long t	= ns2usecs(entry->field.t);
>  	unsigned long usec_rem	= do_div(t, 1000000ULL);
>  	unsigned secs		= (unsigned long)t;
> -	int ret = 1;
> +	int ret;
>  
>  	switch (entry->field.mmiorw.opcode) {
>  	case MMIO_PROBE:
> @@ -241,11 +241,11 @@ static int mmio_print_map(struct trace_iterator *iter)
>  		break;
>  	}
>  	if (ret)
> -		return 1;
> -	return 0;
> +		return TRACE_TYPE_HANDLED;
> +	return TRACE_TYPE_PARTIAL_LINE;
>  }
>  
> -static int mmio_print_mark(struct trace_iterator *iter)
> +static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
>  	const char *msg		= entry->field.print.buf;
> @@ -258,16 +258,15 @@ static int mmio_print_mark(struct trace_iterator *iter)
>  	/* The trailing newline must be in the message. */
>  	ret = trace_seq_printf(s, "MARK %lu.%06lu %s", secs, usec_rem, msg);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	if (entry->field.flags & TRACE_FLAG_CONT)
>  		trace_seq_print_cont(s, iter);
>  
> -	return 1;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
> -/* return 0 to abort printing without consuming current entry in pipe mode */
> -static int mmio_print_line(struct trace_iterator *iter)
> +static enum print_line_t mmio_print_line(struct trace_iterator *iter)
>  {
>  	switch (iter->ent->type) {
>  	case TRACE_MMIO_RW:
> @@ -277,7 +276,7 @@ static int mmio_print_line(struct trace_iterator *iter)
>  	case TRACE_PRINT:
>  		return mmio_print_mark(iter);
>  	default:
> -		return 1; /* ignore unknown entries */
> +		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
>  	}
>  }
>  
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
