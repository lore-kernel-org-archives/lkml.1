Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZIJUaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZIJUaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZIJUaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:30:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42336 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZIJU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:29:59 -0400
Subject: Re: [PATCHv2 1/3] tracing - buf iterator definition, parsing
 function
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1252113181-3325-2-git-send-email-jolsa@redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
	 <1252113181-3325-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 16:29:59 -0400
Message-Id: <1252614599.18996.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, after working with my old patches, I think I like yours better ;-)

But I still have some issues. I'll comment on them, and if you can send
out a v3 with the updates, I'll apply them.

On Sat, 2009-09-05 at 03:12 +0200, jolsa@redhat.com wrote:
> Defined 'trace_biter' structure to carry the properties of the input,
> through the multiple writes.
> 
> The 'trace_get_user' reads the user incput string separated by space
> (matched by isspace(ch). For each string found the 'struct trace_biter' 
> iterator is updated, and the function returns.
> 
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ---
>  kernel/trace/trace.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.h |   48 +++++++++++++++++++++++++++++
>  2 files changed, 131 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index af15008..8cf8f99 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -335,6 +335,89 @@ static struct {
>  
>  int trace_clock_id;
>  
> +/*
> + * trace_get_user - reads the user incput string separated by  space

typo - incput

> + * (matched by isspace(ch))
> + *
> + * For each string found the 'struct trace_biter' iterator is updated,

Call it trace_parser, I hate the sound of trace_biter (I keep
pronouncing it as bitter).

> + * and the function returns.
> + *
> + * Returns number of bytes read.
> + *
> + * see kernel/trace/trace.h for 'struct trace_biter' details.
> + */
> +int trace_get_user(struct trace_biter *biter, const char __user *ubuf,

s/biter/parser/g

> +	size_t cnt, loff_t *ppos)
> +{
> +	char ch;
> +	size_t read = 0;
> +	ssize_t ret;
> +
> +	if (!*ppos)
> +		TRACE_BITER_CLEAR(biter);

Don't do this with macros (explained below)

> +
> +	ret = get_user(ch, ubuf++);
> +	if (ret)
> +		goto out;
> +
> +	read++;
> +	cnt--;
> +
> +	/*
> +	 * If the parser haven't finished with the last write,

grammar nit - "If the parser is not finished ..."

> +	 * continue reading the user input without skipping spaces.
> +	 */
> +	if (!biter->cont) {
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
> +		biter->idx = 0;
> +	}
> +
> +	/* read the non-space input */
> +	while (cnt && !isspace(ch)) {
> +		if (biter->idx < biter->size)
> +			biter->buffer[biter->idx++] = ch;
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
> +		biter->buffer[biter->idx] = 0;
> +		biter->cont = 0;
> +	} else {
> +		biter->cont = 1;
> +		biter->buffer[biter->idx++] = ch;
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
> index d881015..d4e38e8 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -652,6 +652,54 @@ static inline int ftrace_trace_task(struct task_struct *task)
>  #endif
>  
>  /*
> + * struct trace_biter - servers for reading the user input separated by spaces

Again, rename to trace_parser.

> + * @cont: set if the input is not complete - no final space char was found
> + * @buffer: holds the parsed user input
> + * @idx: user input lenght
> + * @size: buffer size
> + */
> +struct trace_biter {
> +	bool		cont;
> +	char		*buffer;
> +	unsigned	idx;
> +	unsigned	size;
> +};
> +
> +#define TRACE_BITER_LOADED(biter) (biter->idx)
> +#define TRACE_BITER_CONT(biter)   (biter->cont)
> +#define TRACE_BITER_CLEAR(biter) \
> +do { \
> +	biter->cont = false; \
> +	biter->idx = 0; \
> +} while(0)

Ug, just use parser->idx directly. No need for macros. Or if you want to
encapsulate this, then use static inline functions. Avoid MACROS, they
just make the code ugly.

> +
> +/*
> + * trace_biter_alloc - allocates the buffer for trace buffer iterator
> + */
> +static inline int trace_biter_alloc(struct trace_biter *biter, int size)

Using alloc as the name here is confusing because you are passing in a
struct trace_parser already, so you are not allocating one. Rename it to
trace_parser_get_init().

> +{
> +	memset(biter, 0, sizeof(*biter));
> +
> +	biter->buffer = kmalloc(size, GFP_KERNEL);
> +	if (!biter->buffer)
> +		return 1;
> +
> +	biter->size = size;
> +	return 0;
> +}
> +
> +/*
> + * trace_biter_free - frees the buffer for trace buffer iterator
> + */
> +static inline void trace_biter_free(struct trace_biter *biter)

And again, you are not freeing the trace_parser. Lets rename this to
trace_parser_put(). This way we have a get/put pair that developers can
relate to. Maybe another name pair may be more appropriate, but when you
call something x_alloc/x_free, it refers to allocating and freeing x,
not a part of x.

-- Steve


> +{
> +	kfree(biter->buffer);
> +}
> +
> +extern int trace_get_user(struct trace_biter *biter, const char __user *ubuf,
> +	size_t cnt, loff_t *ppos);
> +
> +/*
>   * trace_iterator_flags is an enumeration that defines bit
>   * positions into trace_flags that controls the output.
>   *

