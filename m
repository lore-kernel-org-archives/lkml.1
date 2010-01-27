Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370Ab0A0NGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0A0NGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731Ab0A0NGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:06:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38788 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0A0NGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nrOutu0EHkcU508Ypo1aqX24B9aYQuU3w5PSad5C/Rl70/Yf1OLFwPty4u4I9B68/0
         N3DE2iAcQ0pvxrbDaZ1wZWRz+6iLddeYVvJDd2taR/9D0k4qunssCHnbNMgclpeZvI/a
         TX7ftje/vt2K//tOPPDWsmYYh0M2v6rcjCMfQ=
MIME-Version: 1.0
In-Reply-To: <a0e7fce51001270318q6f16aea1j765849bb09df8640@mail.gmail.com>
References: <a0e7fce51001270318q6f16aea1j765849bb09df8640@mail.gmail.com>
Date: Wed, 27 Jan 2010 14:06:51 +0100
X-Google-Sender-Auth: f63de91db96c05c3
Message-ID: <520f0cf11001270506ge76cca1ha259539a101522c2@mail.gmail.com>
Subject: Re: [PATCH] cyclictest: Set tracing_thresh optionally
From: John Kacur <jkacur@redhat.com>
To: yi li <liyi.dev@gmail.com>
Cc: williams@redhat.com, tglx@linutronix.de,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 12:18 PM, yi li <liyi.dev@gmail.com> wrote:
> Hi,
>
> In cyclictest, by default "tracing_thresh" will be set to "tracelimit"
> (given to cyclictest with option "-b tracelimit").
> If the maximum latency of the tracer currently used is less than
> "tracelimit", no trace will be recorded.

So, can't you just set the tracing_thresh to your desired value with the
-b tracelimit option?

Explain to me how cyclictest will behave if tracelimit and tracing_thresh
are set to different values.

If you showed us two sets of outputs (with and without your option)
to show what setting tracing_thresh separately would achieve that
would be helpful.

>
> e.g:
> ./cyclictest -p 80 -t 1 -n -l 10000 -i 10000 -b 8000 -I -f
> If the "irqsoff" maximum latency is less than 8000,
> "/sys/kernel/debug/tracing/trace" will no contain valid "irqsoff"
> trace.
>
> This is not expected sometimes if e.g, the maximum latency of
> cyclictest is caused by wakeup, but I want to see the irqsoff latency.
> So I think it may be better to allow user set "tracing_thresh"
> optionally, by adding a "--tracing_thresh=THRESH" option.
>
> Here is a simple patch to show the idea:
>
> Signed-off-by: yi.li@analog.com
>
> diff --git a/src/cyclictest/cyclictest.c b/src/cyclictest/cyclictest.c
> index ce4d911..c2f1c07 100644
> --- a/src/cyclictest/cyclictest.c
> +++ b/src/cyclictest/cyclictest.c
> @@ -144,6 +144,7 @@ struct thread_stat {
>
>  static int shutdown;
>  static int tracelimit = 0;
> +static int tracing_thresh = 0;
>  static int ftrace = 0;
>  static int kernelversion;
>  static int verbose = 0;
> @@ -384,9 +385,11 @@ static void setup_tracer(void)
>        if (kernelversion == KV_26_CURR) {
>                char buffer[32];
>                int ret;
> -
> -               sprintf(buffer, "%d", tracelimit);
> -               setkernvar("tracing_thresh", buffer);
> +
> +               if (tracing_thresh > 0 && tracing_thresh <= tracelimit) {
> +                       sprintf(buffer, "%d", tracing_thresh);
> +                       setkernvar("tracing_thresh", buffer);
> +               }

Do you need an else part that sets tracing_thresh to tracelimit?


>
>                /* ftrace_enabled is a sysctl variable */
>                fileprefix = procfileprefix;
> @@ -766,6 +769,7 @@ static void display_help(int error)
>               "                           without -t default = 1\n"
>               "-T TRACE --tracer=TRACER   set tracing function\n"
>               "    configured tracers: %s\n"
> +              "--tracing_thresh=THRESH    set tracing_thresh of current
> tracer to THRESH\n"

If you run your patch through checkpatch you'll get

ERROR: patch seems to be corrupt (line wrapped?)
#64: FILE: src/cyclictest/cyclictest.c:772:
tracer to THRESH\n"

And because of the above, I am unable to apply your patch
with git am

We don't follow all the kernel style recommendations in cyclictest
but we try to follow most of them. So please run your patch
through checkpatch and fix-up the warnings.

>               "-u       --unbuffered      force unbuffered output for live
> processing\n"
>               "-v       --verbose         output values on stdout for statistics\n"
>               "                           format: n:c:v n=tasknum c=count
> v=value in us\n"
> @@ -896,6 +900,7 @@ static void process_options (int argc, char *argv[])
>                        {"help", no_argument, NULL, '?'},
>                        {"tracer", required_argument, NULL, 'T'},
>                        {"traceopt", required_argument, NULL, 'O'},
> +                       {"tracing_thresh", required_argument, NULL, 1},
>                        {"smp", no_argument, NULL, 'S'},
>                        {NULL, 0, NULL, 0}
>                };
> @@ -972,6 +977,7 @@ static void process_options (int argc, char *argv[])
>                        use_nanosleep = MODE_CLOCK_NANOSLEEP;
>                        break;
>                case '?': display_help(0); break;
> +               case 1 : tracing_thresh = atoi(optarg); break;
>                }
>        }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
