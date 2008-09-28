Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYI1QTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYI1QTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 12:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYI1QT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 12:19:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:38580 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYI1QT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 12:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=miM2P02oAqOnVAdVwSbOjLea3oppGEXTSUKriQ/JTjVH3dBGxMSWUiuFlO2t/6vNBJ
         Wf53icxa9Gvc0RyjUiNEYM7OFG9Hwm22iMoBUo98ZX6C93sbVTSe/CI99brItS+pGvfj
         QkFBYDf9siTCArRb+QPCIOElbTvC6kGQ5fLYQ=
Date: Sun, 28 Sep 2008 19:19:18 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [Path -tip 1/3] Tracing/ftrace: Change the type of the
 print_line callback
Message-ID: <20080928191918.1b26c0ab@daedalus.pq.iki.fi>
In-Reply-To: <48DCFEE1.4010102@gmail.com>
References: <48DCFEE1.4010102@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 17:25:21 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> We need a kind of disambiguation when a print_line callback returns 0.
> This value can significate both: 
> 
> _ There is not enough space to print all of the entry. Please flush the current seq and retry
> _ I can't handle this type of entry.
> 
> Such a confusion can break the pipe.
> 
> This patch changes the type of this callback for a better information.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Frederic, this looks good to me, except the very last hunk.
See below for some comments.


> ---
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b28bf88..73cd7c5 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -180,6 +180,14 @@ struct trace_array {
>  	struct trace_array_cpu	*data[NR_CPUS];
>  };
>  
> +
> +/* Return values for print_line callback */
> +enum print_line_t {
> +	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
> +	TRACE_TYPE_HANDLED	= 1,
> +	TRACE_TYPE_UNHANDLED	= 2	/* Relay to other output functions */
> +};
> +

I might have chosen names like TRACE_PRINT_{RETRY,DONE,DEFAULT_FORMAT},
but it's your call. I'm not sure which one is more self-explanatory
when you see a "return TRACE_...;" or "if (ret == TRACE_...)"


>  /*
>   * A specific tracer, represented by methods that operate on a trace array:
>   */
> @@ -200,7 +208,7 @@ struct tracer {
>  	int			(*selftest)(struct tracer *trace,
>  					    struct trace_array *tr);
>  #endif
> -	int			(*print_line)(struct trace_iterator *iter);
> +	enum print_line_t	(*print_line)(struct trace_iterator *iter);
>  	struct tracer		*next;
>  	int			print_max;
>  };
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 50ac334..ca95ec3 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1510,7 +1510,7 @@ void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
>  		trace_seq_putc(s, '\n');
>  }
>  
> -static int
> +static enum print_line_t
>  print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
>  {
>  	struct trace_seq *s = &iter->seq;
> @@ -1530,7 +1530,7 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
>  		next_entry = entry;
>  
>  	if (entry->type == TRACE_CONT)
> -		return 1;
> +		return TRACE_TYPE_HANDLED;
>  
>  	rel_usecs = ns2usecs(next_entry->field.t - entry->field.t);
>  	abs_usecs = ns2usecs(entry->field.t - iter->tr->time_start);
> @@ -1601,10 +1601,10 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
>  	default:
>  		trace_seq_printf(s, "Unknown type %d\n", entry->type);
>  	}
> -	return 1;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
> -static int print_trace_fmt(struct trace_iterator *iter)
> +static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
> @@ -1621,7 +1621,7 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  	entry = iter->ent;
>  
>  	if (entry->type == TRACE_CONT)
> -		return 1;
> +		return TRACE_TYPE_HANDLED;
>  
>  	field = &entry->field;
>  
> @@ -1633,24 +1633,24 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  
>  	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	switch (entry->type) {
>  	case TRACE_FN:
>  		ret = seq_print_ip_sym(s, field->fn.ip, sym_flags);
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
>  						field->fn.parent_ip) {
>  			ret = trace_seq_printf(s, " <-");
>  			if (!ret)
> -				return 0;
> +				return TRACE_TYPE_PARTIAL_LINE;
>  			if (kretprobed(field->fn.parent_ip))
>  				ret = trace_seq_puts(s, KRETPROBE_MSG);
>  			else
> @@ -1658,11 +1658,11 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  						       field->fn.parent_ip,
>  						       sym_flags);
>  			if (!ret)
> -				return 0;
> +				return TRACE_TYPE_PARTIAL_LINE;
>  		}
>  		ret = trace_seq_printf(s, "\n");
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_CTX:
>  	case TRACE_WAKE:
> @@ -1680,7 +1680,7 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  				       field->ctx.next_prio,
>  				       T);
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_SPECIAL:
>  		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
> @@ -1688,23 +1688,23 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  				 field->special.arg2,
>  				 field->special.arg3);
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_STACK:
>  		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
>  			if (i) {
>  				ret = trace_seq_puts(s, " <= ");
>  				if (!ret)
> -					return 0;
> +					return TRACE_TYPE_PARTIAL_LINE;
>  			}
>  			ret = seq_print_ip_sym(s, field->stack.caller[i],
>  					       sym_flags);
>  			if (!ret)
> -				return 0;
> +				return TRACE_TYPE_PARTIAL_LINE;
>  		}
>  		ret = trace_seq_puts(s, "\n");
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_PRINT:
>  		seq_print_ip_sym(s, field->print.ip, sym_flags);
> @@ -1713,10 +1713,10 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  			trace_seq_print_cont(s, iter);
>  		break;
>  	}
> -	return 1;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
> -static int print_raw_fmt(struct trace_iterator *iter)
> +static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry;
> @@ -1727,14 +1727,14 @@ static int print_raw_fmt(struct trace_iterator *iter)
>  	entry = iter->ent;
>  
>  	if (entry->type == TRACE_CONT)
> -		return 1;
> +		return TRACE_TYPE_HANDLED;
>  
>  	field = &entry->field;
>  
>  	ret = trace_seq_printf(s, "%d %d %llu ",
>  		field->pid, iter->cpu, field->t);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	switch (entry->type) {
>  	case TRACE_FN:
> @@ -1742,7 +1742,7 @@ static int print_raw_fmt(struct trace_iterator *iter)
>  					field->fn.ip,
>  					field->fn.parent_ip);
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_CTX:
>  	case TRACE_WAKE:
> @@ -1761,7 +1761,7 @@ static int print_raw_fmt(struct trace_iterator *iter)
>  				       field->ctx.next_prio,
>  				       T);
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_SPECIAL:
>  	case TRACE_STACK:
> @@ -1770,7 +1770,7 @@ static int print_raw_fmt(struct trace_iterator *iter)
>  				 field->special.arg2,
>  				 field->special.arg3);
>  		if (!ret)
> -			return 0;
> +			return TRACE_TYPE_PARTIAL_LINE;
>  		break;
>  	case TRACE_PRINT:
>  		trace_seq_printf(s, "# %lx %s",
> @@ -1779,7 +1779,7 @@ static int print_raw_fmt(struct trace_iterator *iter)
>  			trace_seq_print_cont(s, iter);
>  		break;
>  	}
> -	return 1;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  #define SEQ_PUT_FIELD_RET(s, x)				\
> @@ -1794,7 +1794,7 @@ do {							\
>  		return 0;				\
>  } while (0)
>  
> -static int print_hex_fmt(struct trace_iterator *iter)
> +static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	unsigned char newline = '\n';
> @@ -1805,7 +1805,7 @@ static int print_hex_fmt(struct trace_iterator *iter)
>  	entry = iter->ent;
>  
>  	if (entry->type == TRACE_CONT)
> -		return 1;
> +		return TRACE_TYPE_HANDLED;
>  
>  	field = &entry->field;
>  
> @@ -1843,10 +1843,10 @@ static int print_hex_fmt(struct trace_iterator *iter)
>  	}
>  	SEQ_PUT_FIELD_RET(s, newline);
>  
> -	return 1;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
> -static int print_bin_fmt(struct trace_iterator *iter)
> +static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry;
> @@ -1855,7 +1855,7 @@ static int print_bin_fmt(struct trace_iterator *iter)
>  	entry = iter->ent;
>  
>  	if (entry->type == TRACE_CONT)
> -		return 1;
> +		return TRACE_TYPE_HANDLED;
>  
>  	field = &entry->field;
>  
> @@ -1883,7 +1883,7 @@ static int print_bin_fmt(struct trace_iterator *iter)
>  		SEQ_PUT_FIELD_RET(s, field->special.arg3);
>  		break;
>  	}
> -	return 1;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_empty(struct trace_iterator *iter)
> @@ -1904,27 +1904,42 @@ static int trace_empty(struct trace_iterator *iter)
>  
>  static int print_trace_line(struct trace_iterator *iter)

Shouldn't the return type be bool?
If it's not, reading this function makes me wonder about the conversion
from enum to int, i.e. what is the meaning of the int.

>  {
> -	int ret;
> +	enum print_line_t ret;
>  
> -	if (iter->trace && iter->trace->print_line)
> -		if ((ret = iter->trace->print_line(iter)))
> +	if (iter->trace && iter->trace->print_line) {
> +		ret = iter->trace->print_line(iter);
> +		if (ret == TRACE_TYPE_HANDLED ||
> +		    ret == TRACE_TYPE_PARTIAL_LINE)
>  			return ret;

It would be shorter to write
if (ret != TRACE_TYPE_UNHANDLED)
and then one could even
return (ret == TRACE_TYPE_HANDLED);


> +	}
>  
> -	if (trace_flags & TRACE_ITER_BIN)
> -		if ((ret = print_bin_fmt(iter)))
> +	if (trace_flags & TRACE_ITER_BIN) {
> +		ret = print_bin_fmt(iter);
> +		if (ret == TRACE_TYPE_HANDLED ||
> +		    ret == TRACE_TYPE_PARTIAL_LINE)
>  			return ret;
> +	}

Do these actually need checking? I don't think
the default print functions would ever return
TRACE_TYPE_UNHANDLED, could they?
And even if they did, do all the different default print
functions not handle the same set of entry types?


> -	if (trace_flags & TRACE_ITER_HEX)
> -		if ((ret = print_hex_fmt(iter)))
> +	if (trace_flags & TRACE_ITER_HEX) {
> +		ret = print_hex_fmt(iter);
> +		if (ret == TRACE_TYPE_HANDLED ||
> +		    ret == TRACE_TYPE_PARTIAL_LINE)
>  			return ret;
> +	}
>  
> -	if (trace_flags & TRACE_ITER_RAW)
> -		if ((ret = print_raw_fmt(iter)))
> +	if (trace_flags & TRACE_ITER_RAW) {
> +		ret = print_raw_fmt(iter);
> +		if (ret == TRACE_TYPE_HANDLED ||
> +		    ret == TRACE_TYPE_PARTIAL_LINE)
>  			return ret;
> +	}
>  
> -	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
> -		if ((ret = print_lat_fmt(iter, iter->idx, iter->cpu)))
> +	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
> +		ret = print_lat_fmt(iter, iter->idx, iter->cpu);
> +		if (ret == TRACE_TYPE_HANDLED ||
> +		    ret == TRACE_TYPE_PARTIAL_LINE)
>  			return ret;
> +	}
>  
>  	return print_trace_fmt(iter);
>  }
> @@ -2722,11 +2737,11 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  	}
>  
>  	while (find_next_entry_inc(iter) != NULL) {
> -		int ret;
> +		enum print_line_t ret;
>  		int len = iter->seq.len;
>  
>  		ret = print_trace_line(iter);

Return value type mismatch.

> -		if (!ret) {
> +		if (ret == TRACE_TYPE_PARTIAL_LINE) {
>  			/* don't print partial lines */
>  			iter->seq.len = len;
>  			break;


> @@ -2738,6 +2753,10 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  			break;
>  	}
>  
> +	if (!iter->seq.len)
> +		/* Don't break the pipe */
> +		trace_seq_puts(&iter->seq, "Warning: empty seq\n");
> +
>  	for_each_cpu_mask(cpu, mask) {
>  		data = iter->tr->data[cpu];
>  		__raw_spin_unlock(&data->lock);

We have to find a proper way to prevent the pipe from closing
early. I'm trying to look into this. I'd like you to leave
that last hunk out. Other than that, very good.


Cheers.

btw. there might be a corner case, when a single line does not
fit even into an empty struct trace_seq in tracing_read_pipe(),
but I haven't thought of that yet. I'd expect it to hang.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
