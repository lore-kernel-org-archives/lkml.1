Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbZJLKLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbZJLKLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbZJLKLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:11:33 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:38855 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbZJLKLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IpXrMVjEFG+nYU67vel1QoTQ7A8g5Q4NwP3c2WmkJv8VOOYwpZT5uDKwv/zzWuID0R
         XHxTWbQY4vNekrVXOcmUtJS8wzGNR0dnSJQJDHVLYZzJ3S7Eh9K0zfUjKixlUX468Gt4
         kNE7O990tPlBEagH+PNPFR2oucVtw1uz4VlmY=
MIME-Version: 1.0
In-Reply-To: <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
Date: Mon, 12 Oct 2009 12:10:51 +0200
Message-ID: <c62985530910120310m386e9289v29e71fee1992476b@mail.gmail.com>
Subject: Re: [PATCH tracing/kprobes v3 4/7] tracing/kprobes: Avoid field name 
	confliction
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/8 Masami Hiramatsu <mhiramat@redhat.com>:
> Check whether the argument name is conflict with other field names.
>
> Changes in v3:
>  - Check strcmp() == 0 instead of !strcmp().
>
> Changes in v2:
>  - Add common_lock_depth to reserved name list.
>
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> ---
>
>  kernel/trace/trace_kprobe.c |   65 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 53 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 030f28c..e3b824a 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -38,6 +38,25 @@
>  #define MAX_EVENT_NAME_LEN 64
>  #define KPROBE_EVENT_SYSTEM "kprobes"
>
> +/* Reserved field names */
> +#define FIELD_STRING_IP "ip"
> +#define FIELD_STRING_NARGS "nargs"
> +#define FIELD_STRING_RETIP "ret_ip"
> +#define FIELD_STRING_FUNC "func"


If it might conflict, then we should minimize the possibilities for
that to happen.

What if we prefix these fields with kprobed_ ?

kprobed_ip
kprobed_nargs
kprobed_ret_ip
kprobed_func

We are lucky there in that kprobe functions in the kernel can't be kprobed
so it's safe wrt the conflict in the same namespace.

And we can further schrink the kprobed prefixes in userspace post processing.

(If you agree with the above, that can be done incrementally).

Thanks.


> +
> +const char *reserved_field_names[] = {
> +       "common_type",
> +       "common_flags",
> +       "common_preempt_count",
> +       "common_pid",
> +       "common_tgid",
> +       "common_lock_depth",
> +       FIELD_STRING_IP,
> +       FIELD_STRING_NARGS,
> +       FIELD_STRING_RETIP,
> +       FIELD_STRING_FUNC,
> +};
> +
>  /* currently, trace_kprobe only supports X86. */
>
>  struct fetch_func {
> @@ -537,6 +556,20 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
>        return ret;
>  }
>
> +/* Return 1 if name is reserved or already used by another argument */
> +static int conflict_field_name(const char *name,
> +                              struct probe_arg *args, int narg)
> +{
> +       int i;
> +       for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
> +               if (strcmp(reserved_field_names[i], name) == 0)
> +                       return 1;
> +       for (i = 0; i < narg; i++)
> +               if (strcmp(args[i].name, name) == 0)
> +                       return 1;
> +       return 0;
> +}
> +
>  static int create_trace_probe(int argc, char **argv)
>  {
>        /*
> @@ -637,6 +670,12 @@ static int create_trace_probe(int argc, char **argv)
>                        *arg++ = '\0';
>                else
>                        arg = argv[i];
> +
> +               if (conflict_field_name(argv[i], tp->args, i)) {
> +                       ret = -EINVAL;
> +                       goto error;
> +               }
> +
>                tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
>
>                /* Parse fetch argument */
> @@ -1039,8 +1078,8 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
>        if (!ret)
>                return ret;
>
> -       DEFINE_FIELD(unsigned long, ip, "ip", 0);
> -       DEFINE_FIELD(int, nargs, "nargs", 1);
> +       DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
> +       DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
>        /* Set argument names as fields */
>        for (i = 0; i < tp->nr_args; i++)
>                DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
> @@ -1057,9 +1096,9 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
>        if (!ret)
>                return ret;
>
> -       DEFINE_FIELD(unsigned long, func, "func", 0);
> -       DEFINE_FIELD(unsigned long, ret_ip, "ret_ip", 0);
> -       DEFINE_FIELD(int, nargs, "nargs", 1);
> +       DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
> +       DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
> +       DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
>        /* Set argument names as fields */
>        for (i = 0; i < tp->nr_args; i++)
>                DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
> @@ -1108,15 +1147,16 @@ static int kprobe_event_show_format(struct ftrace_event_call *call,
>        int ret, i;
>        struct trace_probe *tp = (struct trace_probe *)call->data;
>
> -       SHOW_FIELD(unsigned long, ip, "ip");
> -       SHOW_FIELD(int, nargs, "nargs");
> +       SHOW_FIELD(unsigned long, ip, FIELD_STRING_IP);
> +       SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
>
>        /* Show fields */
>        for (i = 0; i < tp->nr_args; i++)
>                SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
>        trace_seq_puts(s, "\n");
>
> -       return __probe_event_show_format(s, tp, "(%lx)", "REC->ip");
> +       return __probe_event_show_format(s, tp, "(%lx)",
> +                                        "REC->" FIELD_STRING_IP);
>  }
>
>  static int kretprobe_event_show_format(struct ftrace_event_call *call,
> @@ -1126,9 +1166,9 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
>        int ret, i;
>        struct trace_probe *tp = (struct trace_probe *)call->data;
>
> -       SHOW_FIELD(unsigned long, func, "func");
> -       SHOW_FIELD(unsigned long, ret_ip, "ret_ip");
> -       SHOW_FIELD(int, nargs, "nargs");
> +       SHOW_FIELD(unsigned long, func, FIELD_STRING_FUNC);
> +       SHOW_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP);
> +       SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
>
>        /* Show fields */
>        for (i = 0; i < tp->nr_args; i++)
> @@ -1136,7 +1176,8 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
>        trace_seq_puts(s, "\n");
>
>        return __probe_event_show_format(s, tp, "(%lx <- %lx)",
> -                                         "REC->func, REC->ret_ip");
> +                                        "REC->" FIELD_STRING_FUNC
> +                                        ", REC->" FIELD_STRING_RETIP);
>  }
>
>  #ifdef CONFIG_EVENT_PROFILE
>
>
> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>
