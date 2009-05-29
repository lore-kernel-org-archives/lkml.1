Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbZE2NvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbZE2NvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbZE2NvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:51:13 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:45055 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053AbZE2NvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M1Cx8hTssAteKdLIE9fHunPEE9ywd3Z2STfr9UcnrRA3qic6SiOFq4kL12fc+d6Epn
         iW4MoKWqK6PdtNFUIeuA/kDAMtzJOJSUfDfmERcDeZXtxzl13lfy+rPTIgphMqORrlBA
         JXeJjKaw6AE4hlNRFtc54nNl9HlzRW5RY6a14=
MIME-Version: 1.0
In-Reply-To: <4A1F9FAC.6020506@cn.fujitsu.com>
References: <4A1F9FAC.6020506@cn.fujitsu.com>
Date: Fri, 29 May 2009 15:51:10 +0200
Message-ID: <c62985530905290651id2435bfx7f57ec561fe366e3@mail.gmail.com>
Subject: Re: [PATCH 2/2] tracing/filters: use strcmp() instead of strncmp()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/29 Li Zefan <lizf@cn.fujitsu.com>:
> Trace filter is not working normally:
>
>  # echo 'name == et' > tracing/events/irq/irq_handler_entry/filter
>  # echo 1 > tracing/events/irq/irq_handler_entry/enable
>  # cat trace_pipe
>      <idle>-0     [001]  1363.423175: irq_handler_entry: irq=18 handler=eth0
>      <idle>-0     [001]  1363.934528: irq_handler_entry: irq=18 handler=eth0
>      ...
>
> It's because we pass to trace_define_field() the information of
> __str_loc_##item, but not the actual string, so pred->str_len == field->size
> == sizeof(unsigned short), thus it always compare at most 2 bytes when
> filtering on __string() field.


Weird, I was about sure I set the size of each string() to FILTER_MAX_STRING (or
something like that).

Anyway this patch looks good but it does more than just fixing the
issue, it removes
the string len boundary security we had with strncmp() for every
string (static and
dynamic size).

The potential side effect that comes along this patch would disappear if
you just turn strncmp into strcmp only in filter_pred_strloc().

If you do that also for fixed size strings, then it should be done in
a second patch,
although I guess turning anything here into strcmp is fine because the
strings given
by the user are always limited in their size. But we never know...


Thanks,
Frederic.


> Since __string() is dynamic size, we are not able to set field->size to
> string length. Thus this patch uses strcmp() instead of strncmp().
>
> [ Impact: make filter facility working normally for __string() field ]
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.h               |    1 -
>  kernel/trace/trace_events_filter.c |    7 ++-----
>  2 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 6e735d4..ec8970b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -758,7 +758,6 @@ struct filter_pred {
>        filter_pred_fn_t fn;
>        u64 val;
>        char str_val[MAX_FILTER_STR_VAL];
> -       int str_len;
>        char *field_name;
>        int offset;
>        int not;
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index a854eed..8362586 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -158,7 +158,7 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
>        char *addr = (char *)(event + pred->offset);
>        int cmp, match;
>
> -       cmp = strncmp(addr, pred->str_val, pred->str_len);
> +       cmp = strcmp(addr, pred->str_val);
>
>        match = (!cmp) ^ pred->not;
>
> @@ -182,7 +182,7 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
>        char *addr = (char *)(event + str_loc);
>        int cmp, match;
>
> -       cmp = strncmp(addr, pred->str_val, pred->str_len);
> +       cmp = strcmp(addr, pred->str_val);
>
>        match = (!cmp) ^ pred->not;
>
> @@ -341,7 +341,6 @@ static void filter_clear_pred(struct filter_pred *pred)
>  {
>        kfree(pred->field_name);
>        pred->field_name = NULL;
> -       pred->str_len = 0;
>  }
>
>  static int filter_set_pred(struct filter_pred *dest,
> @@ -576,7 +575,6 @@ static int filter_add_pred(struct filter_parse_state *ps,
>                        fn = filter_pred_string;
>                else
>                        fn = filter_pred_strloc;
> -               pred->str_len = field->size;
>                if (pred->op == OP_NE)
>                        pred->not = 1;
>                return filter_add_pred_fn(ps, call, pred, fn);
> @@ -957,7 +955,6 @@ static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
>        }
>
>        strcpy(pred->str_val, operand2);
> -       pred->str_len = strlen(operand2);
>
>        pred->op = op;
>
> --
> 1.5.4.rc3
>
>
