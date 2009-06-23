Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZFWHSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZFWHSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZFWHR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:17:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFWHR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:17:56 -0400
Message-ID: <4A408210.5000208@cn.fujitsu.com>
Date: Tue, 23 Jun 2009 15:19:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Wang Liming <liming.wang@windriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] tracing: reset iterator in t_start()
References: <4A3B3372.4040608@cn.fujitsu.com> <4A3B34A9.30602@cn.fujitsu.com> <4A407AB0.3000703@windriver.com>
In-Reply-To: <4A407AB0.3000703@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another version:
> Since we have saved current (struct tracer *) in m->private in .next, in
> .start, we don't need to call .next to find the one that should be
> printed in 2nd or nth time.
> 

I don't like this for 2 reasons.

1. It's strange that @pos is not incremented in next().

2. 
   t_stop()
     mutex_unlock()
                          unregister_tracer(t)
   t_start()
     mutex_lock()
       t = m->private
       ...
       t = t-next.

  We access t->next though @t was unregistered. This is not
  good, though it does no harm here.

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index cae34c6..02cdccc 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2055,8 +2055,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>         struct tracer *t = m->private;
> 
> -       (*pos)++;
> -
>         if (t)
>                 t = t->next;
> 
> @@ -2068,11 +2066,8 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  static void *t_start(struct seq_file *m, loff_t *pos)
>  {
>         struct tracer *t = m->private;
> -       loff_t l = 0;
> 
>         mutex_lock(&trace_types_lock);
> -       for (; t && l < *pos; t = t_next(m, t, &l))
> -               ;
> 
>         return t;
>  }
> 
> 
