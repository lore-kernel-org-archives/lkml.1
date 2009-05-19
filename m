Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZESXn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZESXn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZESXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:43:19 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39702 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbZESXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n5tzbUZkcEML92VAk2dVEkgbLmD5YnVF172OFRTl3IDjlwrjsjEpkvRtvb+AB4TuJq
         KJm1oRO7JydyC+16HqHF0BndL4mEku4+Cfg9AFZ+Z15h4cbhS9LbPVOuZ/Qq110fnVye
         BPnwDKcClq52t8eb/Yqv7t8SQJ0KW1R/gp67w=
Date: Wed, 20 May 2009 01:43:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] tracing: use strlcpy instead of strncpy
Message-ID: <20090519234312.GC6066@nowhere>
References: <4A11480F.3030000@cn.fujitsu.com> <4A11CB5C.8070800@gmail.com> <4A1210B6.80605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1210B6.80605@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:51:50AM +0800, Lai Jiangshan wrote:
> strlcpy() will add '\0' for the copied string.
> 
> [Impact] cleanup



As Stefan said, the impact line and the changelog is omitting
a possible side effect.



> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 05b4747..9359e85 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -434,8 +434,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  	if (!buts->buf_size || !buts->buf_nr)
>  		return -EINVAL;
>  
> -	strncpy(buts->name, name, BLKTRACE_BDEV_SIZE);
> -	buts->name[BLKTRACE_BDEV_SIZE - 1] = '\0';
> +	strlcpy(buts->name, name, BLKTRACE_BDEV_SIZE);
>  
>  	/*
>  	 * some device names have larger paths - convert the slashes
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 665a915..2484555 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -133,7 +133,7 @@ static char *default_bootup_tracer;
>  
>  static int __init set_ftrace(char *str)
>  {
> -	strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
> +	strlcpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
>  	default_bootup_tracer = bootup_tracer_buf;
>  	/* We are using ftrace early, expand it */
>  	ring_buffer_expanded = 1;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 6e735d4..e08c952 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -155,8 +155,8 @@ struct trace_boot_ret {
>  struct trace_branch {
>  	struct trace_entry	ent;
>  	unsigned	        line;
> -	char			func[TRACE_FUNC_SIZE+1];
> -	char			file[TRACE_FILE_SIZE+1];
> +	char			func[TRACE_FUNC_SIZE];
> +	char			file[TRACE_FILE_SIZE];



Although I don't think this is that much risky, this is the possible
side effect: we are loosing a character.

I guess it's fine, the CPP constants here seem to be just magic
assumptions (func_size = 30, file_size = 20), it just needs to be
mentioned in the changelog for future possible bug tracking.

Thanks,
Frederic.



>  	char			correct;
>  };
>  
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 7a7a9fd..a84e036 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -67,10 +67,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  		p--;
>  	p++;
>  
> -	strncpy(entry->func, f->func, TRACE_FUNC_SIZE);
> -	strncpy(entry->file, p, TRACE_FILE_SIZE);
> -	entry->func[TRACE_FUNC_SIZE] = 0;
> -	entry->file[TRACE_FILE_SIZE] = 0;
> +	strlcpy(entry->func, f->func, TRACE_FUNC_SIZE);
> +	strlcpy(entry->file, p, TRACE_FILE_SIZE);
>  	entry->line = f->line;
>  	entry->correct = val == expect;
>  
> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
> index 5e32e37..2ae6679 100644
> --- a/kernel/trace/trace_event_types.h
> +++ b/kernel/trace/trace_event_types.h
> @@ -122,10 +122,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
>  TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
>  	TRACE_STRUCT(
>  		TRACE_FIELD(unsigned int, line, line)
> -		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
> -				    TRACE_FUNC_SIZE+1, func)
> -		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
> -				    TRACE_FUNC_SIZE+1, file)
> +		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE], func,
> +				    TRACE_FUNC_SIZE, func)
> +		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE], file,
> +				    TRACE_FUNC_SIZE, file)
>  		TRACE_FIELD(char, correct, correct)
>  	),
>  	TP_RAW_FMT("%u:%s:%s (%u)")
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

