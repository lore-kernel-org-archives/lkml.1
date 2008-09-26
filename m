Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYIZVWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYIZVWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYIZVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:21:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:26152 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbYIZVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=X0d58gk2OxQGWk69GJn8JmPL1U7vIWRh1U2jA05XgMnGR3ZENJAsNYqshDUDjcKBTd
         +To7it1b5H+/wS2khT7+u/sJbMqvpgnkas3YYeDTiInH9hqYu7YjJhIrNJYdBQUS8nrC
         osv9ASq8QSLs9yT+3vq5HbJeBE9n2ls9JWXfc=
Date: Sat, 27 Sep 2008 00:21:21 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new
 type of print_line
Message-ID: <20080927002121.0038cdfe@daedalus.pq.iki.fi>
In-Reply-To: <48DD0347.5070008@gmail.com>
References: <48DD0347.5070008@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 17:44:07 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Adapt mmiotrace to the new print_line type.
> By default, it refuses types it doesn't support.
> But a tracer needs to print something to the seq anyway. 
> That's why it needs to warn about unsupported types.
> 
> Pekka if you disagree with it, please don't hesitate to tell me.

Yes, I do disagree about printing stuff that doesn't belong there.
First, I doubt printing bogus text is a right way to fix the
early pipe EOF problem. Second, if you really have to do that,
do it so that it obeys the mmiotrace log format specification.
(I'd recommend a MARK entry.) The spec is in
Documentation/tracers/mmiotrace.txt.

This is just a very quick comment, and I should look at your two
patches better. I hope to do that during the weekend.

Was there supposed to be a third patch, as the subject suggests?

Thanks.


> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 2bbb7dd..69480a5 100644
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
> @@ -258,16 +258,16 @@ static int mmio_print_mark(struct trace_iterator *iter)
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
>  /* return 0 to abort printing without consuming current entry in pipe mode */
> -static int mmio_print_line(struct trace_iterator *iter)
> +static enum print_line_t mmio_print_line(struct trace_iterator *iter)
>  {
>  	switch (iter->ent->type) {
>  	case TRACE_MMIO_RW:
> @@ -277,7 +277,9 @@ static int mmio_print_line(struct trace_iterator *iter)
>  	case TRACE_PRINT:
>  		return mmio_print_mark(iter);
>  	default:
> -		return 0; /* ignore unknown entries whithout consuming */
> +		/* ignore unknown entries */
> +		trace_seq_printf(&iter->seq, "Unknown trace type\n");
> +		return TRACE_TYPE_HANDLED;
>  	}
>  }
>  
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
