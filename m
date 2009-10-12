Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZJLJKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZJLJKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZJLJKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:10:13 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37734 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZJLJKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ncp6YnfPug9PnMBOSUb+GCn1TX2EVjyeRY0NDHr5YKnOiA1Kd8MnV6fRws5ZsuSu4N
         LinlAQ7C5LeiwaEytfgf2wrUq/qK+Zcaw3V3LaaopaELf+z9ZXyVsIeUzppv5cMtvp0C
         bEMAxoNG/HCZTJ/QrvvPjQrfDJEZ4wozxlIbM=
MIME-Version: 1.0
In-Reply-To: <4AD2DEB9.2@redhat.com>
References: <4AD2DEB9.2@redhat.com>
Date: Mon, 12 Oct 2009 11:09:33 +0200
Message-ID: <c62985530910120209t3d263d5eh5aeba14fcecc9072@mail.gmail.com>
Subject: Re: [PATCH] ftrace: add kernel command line graph function filtering
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Stefan Assmann <sassmann@redhat.com>
Cc: rostedt@goodmis.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/12 Stefan Assmann <sassmann@redhat.com>:
> From 894e934e782ddaa33eb6d156d8326cdf479b5f62 Mon Sep 17 00:00:00 2001
> From: Stefan Assmann <sassmann@redhat.com>
> Date: Mon, 12 Oct 2009 09:11:47 +0200
> Subject: [PATCH] ftrace: add kernel command line graph function filtering
>
> Add a command line parameter to allow limiting the function graphs that
> are traced on boot up, when ftrace=function_graph is specified.
>
> This patch adds the following command line option:
> ftrace_graph_filter=function-list


If we use this parameter, we undoubtedly want to launch the function
graph tracer.
I'd then suggest to arm ftrace=function_graph automatically if we have
ftrace_graph_filter
set.


>
> Where function-list is a comma separated list of functions to filter.
>
> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |    9 ++++++++-
>  kernel/trace/ftrace.c               |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9107b38..144eb83 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -771,7 +771,14 @@ and is between 256 and 4096 characters. It is defined in the file
>                        tracer at boot up. function-list is a comma separated
>                        list of functions. This list can be changed at run
>                        time by the set_ftrace_filter file in the debugfs
> -                       tracing directory.
> +                       tracing directory.
> +
> +       ftrace_graph_filter=[function-list]
> +                       [FTRACE] Limit the functions traced by the function
> +                       graph tracer at boot up. function-list is a comma
> +                       separated list of functions. This list can be changed
> +                       at run time by the set_graph_function file in the
> +                       debugfs tracing directory.



May be you should use a more detailed definition of this parameter.
Limiting a function traced by the function graph tracer is ambiguous.

It means we can have either:

    function_to_trace();

or:

    function_to_trace() {
         foo() {
             bar();
         }
    }

We want the second thing.
May be instead you can write:

"Limit the top level callers functions traced by the function
 graph tracer at boot up."

Otherwise, looks good to me:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.

>        ftrace_notrace=[function-list]
>                        [FTRACE] Do not trace the functions specified in
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3724756..a5cae5c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -78,6 +78,10 @@ ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
>  ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
>  ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
>
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
> +#endif
> +
>  static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
>  {
>        struct ftrace_ops *op = ftrace_list;
> @@ -2302,6 +2306,7 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
>  #define FTRACE_FILTER_SIZE             COMMAND_LINE_SIZE
>  static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
>  static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
> +static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
>
>  static int __init set_ftrace_notrace(char *str)
>  {
> @@ -2317,6 +2322,31 @@ static int __init set_ftrace_filter(char *str)
>  }
>  __setup("ftrace_filter=", set_ftrace_filter);
>
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static int __init set_graph_function(char *str)
> +{
> +       strncpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
> +       return 1;
> +}
> +__setup("ftrace_graph_filter=", set_graph_function);
> +
> +static void __init set_ftrace_early_graph(char *buf)
> +{
> +       int ret;
> +       char *func;
> +
> +       while (buf) {
> +               func = strsep(&buf, ",");
> +               /* we allow only one expression at a time */
> +               ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
> +                                     func);
> +               if (ret)
> +                       printk(KERN_DEBUG "ftrace: function %s not "
> +                                         "traceable\n", func);
> +       }
> +}
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
>  static void __init set_ftrace_early_filter(char *buf, int enable)
>  {
>        char *func;
> @@ -2333,6 +2363,10 @@ static void __init set_ftrace_early_filters(void)
>                set_ftrace_early_filter(ftrace_filter_buf, 1);
>        if (ftrace_notrace_buf[0])
>                set_ftrace_early_filter(ftrace_notrace_buf, 0);
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +       if (ftrace_graph_buf[0])
> +               set_ftrace_early_graph(ftrace_graph_buf);
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  }
>
>  static int
> --
> 1.6.2.5
>
>
