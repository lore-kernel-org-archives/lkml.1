Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZFCJsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZFCJsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFCJsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:48:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52461 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZFCJsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:48:42 -0400
Message-ID: <4A26474C.1000900@cn.fujitsu.com>
Date: Wed, 03 Jun 2009 17:50:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: trace: fix multiple use of __print_flags and __print_symbolic
References: <1244019900.29604.588.camel@localhost.localdomain>
In-Reply-To: <1244019900.29604.588.camel@localhost.localdomain>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Whitehouse wrote:
> When using multiple calls to __print_symbolic and __print_flags in
> the same tracer, I noticed that the output was incorrect. I think
> the following patch is the correct fix (it works for me) but please
> check it carefully since I'm not that familiar with this code,
> and I may well have made a mistake somewhere.
> 

I don't see there's bug in __print_symbolic() or __print_flags():

enum print_line_t
ftrace_raw_output_##call(struct trace_iterator *iter, int flags)
{
	...
	p = &get_cpu_var(ftrace_event_seq);
	/* here we call ftrace_print_flags_seq(p, ...) */
	ret = trace_seq_printf(s, #call ": " print);
	put_cpu();
	...
}

ftrace_event_seq is percpu data, and here is used with preempt-disabled,
so there shouldn't be problem of concurrent accessing.


> The patch is vs. the latest -tip tree which doesn't yet seem to
> contain the EXPORT_SYMBOL() fix that I sent earlier.
> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> 
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index c12d95d..ac6ced1 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -222,10 +222,9 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>  {
>  	unsigned long mask;
>  	const char *str;
> +	const char *ret = p->buffer + p->len;
>  	int i;
>  
> -	trace_seq_init(p);
> -

This is wrong. Without reseting, the seq buffer will quickly be filled.

>  	for (i = 0;  flag_array[i].name && flags; i++) {
>  
>  		mask = flag_array[i].mask;
> @@ -248,7 +247,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>  
>  	trace_seq_putc(p, 0);
>  
> -	return p->buffer;
> +	return ret;
>  }
>  
>  const char *
> @@ -256,8 +255,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  			 const struct trace_print_flags *symbol_array)
>  {
>  	int i;
> -
> -	trace_seq_init(p);
> +	const char *ret = p->buffer + p->len;
>  
>  	for (i = 0;  symbol_array[i].name; i++) {
>  
> @@ -273,7 +271,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  		
>  	trace_seq_putc(p, 0);
>  
> -	return p->buffer;
> +	return ret;
>  }
>  
>  #ifdef CONFIG_KRETPROBES
> 
