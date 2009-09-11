Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZIKUIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZIKUIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbZIKUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:08:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbZIKUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:08:38 -0400
Subject: Re: [PATCH 4/6] tracing: create generic trace parser
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20090911193236.705944183@goodmis.org>
References: <20090911193153.444303577@goodmis.org>
	 <20090911193236.705944183@goodmis.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 16:08:39 -0400
Message-Id: <1252699720.18996.735.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 15:31 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-tracing-create-generic-trace-parser.patch)
> From: jolsa@redhat.com <jolsa@redhat.com>

Ug! I didn't realize that Jiri's email from line did not contain his
name. Thus his email became the author not his real name.

Ingo, do you want me to fix this? His SoB is correct though.

-- Steve

> 
> Create a "trace_parser" that can parse the user space input for
> separate words.
> 
> struct trace_parser is the descriptor.
> 
> Generic "trace_get_user" function that can be a helper to read multiple
> words passed in by user space.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> LKML-Reference: <1252682969-3366-2-git-send-email-jolsa@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.h |   35 ++++++++++++++++
>  2 files changed, 141 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 3b91828..45c3f03 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -339,6 +339,112 @@ static struct {
>  
>  int trace_clock_id;
>  
> +/*
> + * trace_parser_get_init - gets the buffer for trace parser
> + */
> +int trace_parser_get_init(struct trace_parser *parser, int size)
> +{
> +	memset(parser, 0, sizeof(*parser));
> +
> +	parser->buffer = kmalloc(size, GFP_KERNEL);
> +	if (!parser->buffer)
> +		return 1;
> +
> +	parser->size = size;
> +	return 0;
> +}
> +
> +/*
> + * trace_parser_put - frees the buffer for trace parser
> + */
> +void trace_parser_put(struct trace_parser *parser)
> +{
> +	kfree(parser->buffer);
> +}
> +
> +/*
> + * trace_get_user - reads the user input string separated by  space
> + * (matched by isspace(ch))
> + *
> + * For each string found the 'struct trace_parser' is updated,
> + * and the function returns.
> + *
> + * Returns number of bytes read.
> + *
> + * See kernel/trace/trace.h for 'struct trace_parser' details.
> + */
> +int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
> +	size_t cnt, loff_t *ppos)
> +{
> +	char ch;
> +	size_t read = 0;
> +	ssize_t ret;
> +
> +	if (!*ppos)
> +		trace_parser_clear(parser);
> +
> +	ret = get_user(ch, ubuf++);
> +	if (ret)
> +		goto out;
> +
> +	read++;
> +	cnt--;
> +
> +	/*
> +	 * The parser is not finished with the last write,
> +	 * continue reading the user input without skipping spaces.
> +	 */
> +	if (!parser->cont) {
> +		/* skip white space */
> +		while (cnt && isspace(ch)) {
> +			ret = get_user(ch, ubuf++);
> +			if (ret)
> +				goto out;
> +			read++;
> +			cnt--;
> +		}
> +
> +		/* only spaces were written */
> +		if (isspace(ch)) {
> +			*ppos += read;
> +			ret = read;
> +			goto out;
> +		}
> +
> +		parser->idx = 0;
> +	}
> +
> +	/* read the non-space input */
> +	while (cnt && !isspace(ch)) {
> +		if (parser->idx < parser->size)
> +			parser->buffer[parser->idx++] = ch;
> +		else {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		ret = get_user(ch, ubuf++);
> +		if (ret)
> +			goto out;
> +		read++;
> +		cnt--;
> +	}
> +
> +	/* We either got finished input or we have to wait for another call. */
> +	if (isspace(ch)) {
> +		parser->buffer[parser->idx] = 0;
> +		parser->cont = false;
> +	} else {
> +		parser->cont = true;
> +		parser->buffer[parser->idx++] = ch;
> +	}
> +
> +	*ppos += read;
> +	ret = read;
> +
> +out:
> +	return ret;
> +}
> +
>  ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
>  {
>  	int len;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b69697b..28247ce 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -616,6 +616,41 @@ static inline int ftrace_trace_task(struct task_struct *task)
>  #endif
>  
>  /*
> + * struct trace_parser - servers for reading the user input separated by spaces
> + * @cont: set if the input is not complete - no final space char was found
> + * @buffer: holds the parsed user input
> + * @idx: user input lenght
> + * @size: buffer size
> + */
> +struct trace_parser {
> +	bool		cont;
> +	char		*buffer;
> +	unsigned	idx;
> +	unsigned	size;
> +};
> +
> +static inline bool trace_parser_loaded(struct trace_parser *parser)
> +{
> +	return (parser->idx != 0);
> +}
> +
> +static inline bool trace_parser_cont(struct trace_parser *parser)
> +{
> +	return parser->cont;
> +}
> +
> +static inline void trace_parser_clear(struct trace_parser *parser)
> +{
> +	parser->cont = false;
> +	parser->idx = 0;
> +}
> +
> +extern int trace_parser_get_init(struct trace_parser *parser, int size);
> +extern void trace_parser_put(struct trace_parser *parser);
> +extern int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
> +	size_t cnt, loff_t *ppos);
> +
> +/*
>   * trace_iterator_flags is an enumeration that defines bit
>   * positions into trace_flags that controls the output.
>   *
> -- 
> 1.6.3.3
> 

