Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZJLKr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZJLKr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZJLKr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:47:59 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57289 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZJLKr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EAsq5tAYs/xANRbRK9ZlDiXu6Hlgzg2fpSApdu3+ft+xiC5qQsFlsX4N71BiZf7Tpm
         vzl7SmhB2gx44jEjG/zGc9cIvdGahLt8ETWY5KfAyc84Mbn+Dr7DpRn0M72VGIGQdgt2
         rouvCJM1A3Q4sYdVB0Zl8oBfE7cRn2Wueck+g=
MIME-Version: 1.0
In-Reply-To: <4AD2FF6E.2090601@redhat.com>
References: <4AD2DEB9.2@redhat.com>
	 <c62985530910120209t3d263d5eh5aeba14fcecc9072@mail.gmail.com>
	 <4AD2FF6E.2090601@redhat.com>
Date: Mon, 12 Oct 2009 12:47:18 +0200
Message-ID: <c62985530910120347v2d0d30f1o4d7f7c62969f9b28@mail.gmail.com>
Subject: Re: [PATCH] ftrace: add kernel command line graph function filtering
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Stefan Assmann <sassmann@redhat.com>
Cc: rostedt@goodmis.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12 octobre 2009 12:05, Stefan Assmann <sassmann@redhat.com> a écrit :
> Thanks for reviewing Frédéric!
> I hope the following is what you had in mind.
>
>  Stefan
>
> From edeb75ce9c9a35d5905d45954f66a0e05d5fe8ab Mon Sep 17 00:00:00 2001
> From: Stefan Assmann <sassmann@redhat.com>
> Date: Mon, 12 Oct 2009 09:11:47 +0200
> Subject: [PATCH] ftrace: add kernel command line graph function filtering
>
> Add a command line parameter to allow limiting the top level callers functions
> traced by the function graph tracer at boot up.
>
> This patch adds the following command line option:
> ftrace_graph_filter=function-list
>
> Where function-list is a comma separated list of functions to filter.
>
> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |    9 ++++++++-
>  kernel/trace/ftrace.c               |   35 +++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                |    2 +-
>  kernel/trace/trace.h                |    1 +
>  4 files changed, 45 insertions(+), 2 deletions(-)


Yup, looks good to me. I'm going to queue it.
Just some minor neats I'll change, see below:


> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9107b38..539a053 100644
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
> +                       [FTRACE] Limit the top level callers functions traced
> +                       by the function graph tracer at boot up.
> +                       function-list is a comma separated list of functions
> +                       that can be changed at run time by the
> +                       set_graph_function file in the debugfs tracing directory.
>
>        ftrace_notrace=[function-list]
>                        [FTRACE] Do not trace the functions specified in
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3724756..ee9c509 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -78,6 +78,10 @@ ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
>  ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
>  ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
>
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
> +#endif



I'll try to move most of this new code in the bottom of ftrace.c, where most of
the ftrace related function graph tracer features are implemented.

Hopefully that could avoid us this ifdef'd declaration and all of the new others
by putting them in the already ifdef'd section of function graph helpers.
And also it's better to group the function graph helpers together.


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
> @@ -2317,6 +2322,32 @@ static int __init set_ftrace_filter(char *str)
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
> +       set_ftrace("function_graph");
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
>
>  static void __init set_ftrace_early_filter(char *buf, int enable)
>  {
>        char *func;
> @@ -2333,6 +2364,10 @@ static void __init set_ftrace_early_filters(void)
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
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4506826..811c918 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -129,7 +129,7 @@ static int tracing_set_tracer(const char *buf);
>  static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
>  static char *default_bootup_tracer;
>
> -static int __init set_ftrace(char *str)
> +int __init set_ftrace(char *str)


I'm also going to rename this into set_early_ftrace() :-)

Thanks!
