Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZIJUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZIJUfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZIJUfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:35:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZIJUfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:35:32 -0400
Subject: Re: [PATCHv2 2/3] tracing - buf iterator support for set_event
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1252113181-3325-3-git-send-email-jolsa@redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
	 <1252113181-3325-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 16:35:33 -0400
Message-Id: <1252614934.18996.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 03:13 +0200, jolsa@redhat.com wrote:
> Updated 'set_event' write method to use the 'trace_get_user' function.
> 
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ---
>  kernel/trace/trace_events.c |   58 +++++++++---------------------------------
>  1 files changed, 13 insertions(+), 45 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index d33bcde..7e5703c 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -230,11 +230,9 @@ static ssize_t
>  ftrace_event_write(struct file *file, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
> +	struct trace_biter biter;

s/biter/parser/g

>  	size_t read = 0;
> -	int i, set = 1;
>  	ssize_t ret;
> -	char *buf;
> -	char ch;
>  
>  	if (!cnt || cnt < 0)
>  		return 0;
> @@ -243,60 +241,30 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = get_user(ch, ubuf++);
> -	if (ret)
> -		return ret;
> -	read++;
> -	cnt--;
> -
> -	/* skip white space */
> -	while (cnt && isspace(ch)) {
> -		ret = get_user(ch, ubuf++);
> -		if (ret)
> -			return ret;
> -		read++;
> -		cnt--;
> -	}
> -
> -	/* Only white space found? */
> -	if (isspace(ch)) {
> -		file->f_pos += read;
> -		ret = read;
> -		return ret;
> -	}
> -
> -	buf = kmalloc(EVENT_BUF_SIZE+1, GFP_KERNEL);
> -	if (!buf)
> +	if (trace_biter_alloc(&biter, EVENT_BUF_SIZE + 1))
>  		return -ENOMEM;
>  
> -	if (cnt > EVENT_BUF_SIZE)
> -		cnt = EVENT_BUF_SIZE;
> +	read = trace_get_user(&biter, ubuf, cnt, ppos);
> +
> +	if (TRACE_BITER_LOADED((&biter))) {
> +		char *buf = biter.buffer;

If you have encapsulated the access to parser with trace_parser_loaded,
might as well do the same for getting the buffer:

static inline char *trace_parser_buffer(struct trace_parser *parser)
{
	return parser->buffer;
}


> +		int set = 1;
>  
> -	i = 0;
> -	while (cnt && !isspace(ch)) {
> -		if (!i && ch == '!')
> +		if (*buf == '!') {
>  			set = 0;
> -		else
> -			buf[i++] = ch;
> +			buf++;

I had a funny trick in my patches to instead of incrementing buf here, I
passed in below a:

	ftrace_set_clr_event(buf + !!set, set);

But whatever ;-)

> +		}
> +		biter.buffer[biter.idx] = 0;

here you are accessing both the buffer and idx directly. Might as well
do it everywhere like this and don't use the helper functions.

-- Steve

>  
> -		ret = get_user(ch, ubuf++);
> +		ret = ftrace_set_clr_event(buf, set);
>  		if (ret)
>  			goto out_free;
> -		read++;
> -		cnt--;
>  	}
> -	buf[i] = 0;
> -
> -	file->f_pos += read;
> -
> -	ret = ftrace_set_clr_event(buf, set);
> -	if (ret)
> -		goto out_free;
>  
>  	ret = read;
>  
>   out_free:
> -	kfree(buf);
> +	trace_biter_free(&biter);
>  
>  	return ret;
>  }

