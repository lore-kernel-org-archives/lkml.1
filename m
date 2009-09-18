Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZIRJAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZIRJAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZIRJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:00:40 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37741 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZIRJAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SR4n3fB0VGCw4sW3FCa1H1XChBvDwWjJkgZO0uLTpSafiB1m7lkOvG3/MMjgdKE9+2
         bkw1CbkLzA7G95wEv4l9hvZ6LrCoQ2TTuPNfWcwZgHDuz6+NUqQd/4+bPx7Xv+V2dwab
         m+kwGUkOHMTnato/8F5esGUXx656kCZq1DH6Q=
MIME-Version: 1.0
In-Reply-To: <4AB32377.9020601@cn.fujitsu.com>
References: <4AB32364.7020602@cn.fujitsu.com> <4AB32377.9020601@cn.fujitsu.com>
Date: Fri, 18 Sep 2009 11:00:41 +0200
Message-ID: <c62985530909180200w3e560d23kef9571213b143369@mail.gmail.com>
Subject: Re: [PATCH 2/3][RESEND] tracing: remove max_tracer_type_len
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/18 Li Zefan <lizf@cn.fujitsu.com>:
> Limit the length of a tracer's name within 100 chars, and then we
> don't have to play with max_tracer_type_len.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/trace.c |   49 ++++++++++++++++---------------------------------
>  1 files changed, 16 insertions(+), 33 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index fd52a19..8613080 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -125,13 +125,13 @@ int ftrace_dump_on_oops;
>
>  static int tracing_set_tracer(const char *buf);
>
> -#define BOOTUP_TRACER_SIZE             100
> -static char bootup_tracer_buf[BOOTUP_TRACER_SIZE] __initdata;
> +#define MAX_TRACER_SIZE                100
> +static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
>  static char *default_bootup_tracer;
>
>  static int __init set_ftrace(char *str)
>  {
> -       strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
> +       strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
>        default_bootup_tracer = bootup_tracer_buf;
>        /* We are using ftrace early, expand it */
>        ring_buffer_expanded = 1;
> @@ -242,13 +242,6 @@ static struct tracer               *trace_types __read_mostly;
>  static struct tracer           *current_trace __read_mostly;
>
>  /*
> - * max_tracer_type_len is used to simplify the allocating of
> - * buffers to read userspace tracer names. We keep track of
> - * the longest tracer name registered.
> - */
> -static int                     max_tracer_type_len;
> -
> -/*
>  * trace_types_lock is used to protect the trace_types list.
>  * This lock is also used to keep user access serialized.
>  * Accesses from userspace will grab this lock while userspace
> @@ -619,7 +612,6 @@ __releases(kernel_lock)
>  __acquires(kernel_lock)
>  {
>        struct tracer *t;
> -       int len;
>        int ret = 0;
>
>        if (!type->name) {
> @@ -627,6 +619,11 @@ __acquires(kernel_lock)
>                return -1;
>        }
>
> +       if (strlen(type->name) > MAX_TRACER_SIZE) {
> +               pr_info("Tracer has a name longer than %d\n", MAX_TRACER_SIZE);
> +               return -1;
> +       }
> +
>        /*
>         * When this gets called we hold the BKL which means that
>         * preemption is disabled. Various trace selftests however
> @@ -641,7 +638,7 @@ __acquires(kernel_lock)
>        for (t = trace_types; t; t = t->next) {
>                if (strcmp(type->name, t->name) == 0) {
>                        /* already found */
> -                       pr_info("Trace %s already registered\n",
> +                       pr_info("Tracer %s already registered\n",
>                                type->name);
>                        ret = -1;
>                        goto out;
> @@ -692,9 +689,6 @@ __acquires(kernel_lock)
>
>        type->next = trace_types;
>        trace_types = type;
> -       len = strlen(type->name);
> -       if (len > max_tracer_type_len)
> -               max_tracer_type_len = len;
>
>  out:
>        tracing_selftest_running = false;
> @@ -703,7 +697,7 @@ __acquires(kernel_lock)
>        if (ret || !default_bootup_tracer)
>                goto out_unlock;
>
> -       if (strncmp(default_bootup_tracer, type->name, BOOTUP_TRACER_SIZE))
> +       if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
>                goto out_unlock;
>
>        printk(KERN_INFO "Starting tracer '%s'\n", type->name);
> @@ -725,14 +719,13 @@ __acquires(kernel_lock)
>  void unregister_tracer(struct tracer *type)
>  {
>        struct tracer **t;
> -       int len;
>
>        mutex_lock(&trace_types_lock);
>        for (t = &trace_types; *t; t = &(*t)->next) {
>                if (*t == type)
>                        goto found;
>        }
> -       pr_info("Trace %s not registered\n", type->name);
> +       pr_info("Tracer %s not registered\n", type->name);
>        goto out;
>
>  found:
> @@ -745,17 +738,7 @@ void unregister_tracer(struct tracer *type)
>                        current_trace->stop(&global_trace);
>                current_trace = &nop_trace;
>        }
> -
> -       if (strlen(type->name) != max_tracer_type_len)
> -               goto out;
> -
> -       max_tracer_type_len = 0;
> -       for (t = &trace_types; *t; t = &(*t)->next) {
> -               len = strlen((*t)->name);
> -               if (len > max_tracer_type_len)
> -                       max_tracer_type_len = len;
> -       }
> - out:
> +out:
>        mutex_unlock(&trace_types_lock);
>  }
>
> @@ -2604,7 +2587,7 @@ static ssize_t
>  tracing_set_trace_read(struct file *filp, char __user *ubuf,
>                       size_t cnt, loff_t *ppos)
>  {
> -       char buf[max_tracer_type_len+2];
> +       char buf[MAX_TRACER_SIZE+2];
>        int r;
>
>        mutex_lock(&trace_types_lock);
> @@ -2754,15 +2737,15 @@ static ssize_t
>  tracing_set_trace_write(struct file *filp, const char __user *ubuf,
>                        size_t cnt, loff_t *ppos)
>  {
> -       char buf[max_tracer_type_len+1];
> +       char buf[MAX_TRACER_SIZE+1];
>        int i;
>        size_t ret;
>        int err;
>
>        ret = cnt;
>
> -       if (cnt > max_tracer_type_len)
> -               cnt = max_tracer_type_len;
> +       if (cnt > MAX_TRACER_SIZE)
> +               cnt = MAX_TRACER_SIZE;
>
>        if (copy_from_user(&buf, ubuf, cnt))
>                return -EFAULT;
> --
> 1.6.3
>
>
