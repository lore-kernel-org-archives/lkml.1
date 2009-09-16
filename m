Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZIPUXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZIPUXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZIPUXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:23:33 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:40386 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZIPUXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bKXlnxY4BleC+hWdRJjA5CJzZBNvSKlFZuhlvok8LD4jUIqvuW/sQaCoG1eXf8qnOW
         HRXe7a9hSc+WXMvWPOxtphYOeoGf72jxOeqDQTtDj+dYshpqcjQvARew6VPZvQIpdYas
         cfgbDuieR9dyNfh4X4HQJexxKzBpPrCGSfXbQ=
MIME-Version: 1.0
In-Reply-To: <4A939D4A.1020706@cn.fujitsu.com>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>
	 <4A89213C.5090109@cn.fujitsu.com>
	 <20090818215620.A63C.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
	 <4A939CDF.2000407@cn.fujitsu.com> <4A939D4A.1020706@cn.fujitsu.com>
Date: Wed, 16 Sep 2009 12:56:14 -0700
X-Google-Sender-Auth: 645dc91524deb88d
Message-ID: <1f1b08da0909161256m376b1292ia4b2f3b2b4e82c34@mail.gmail.com>
Subject: Re: [PATCH 2/3] ftrace: add tracepoint for xtime
From: john stultz <johnstul@us.ibm.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 1:14 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>
> This patch can trace current xtime and wall_to_monotonic. Then user can
> use ctime() to convert them to wall time which is easier to be understood,
> especially for flight-recorder which need to get trace event from a kernel
> dump file.
>
> Example of ftrace output:
>          <idle>-0     [000] 20118.489849: gtod_update_xtime: xtime=1243265589.999999824 wall_to_monotonic=3051713268.744158739
>           <...>-4020  [001] 20118.489855: sys_open(filename: bf9e66e0, flags: 98800, mode: bf9e66e0)
>           <...>-4020  [001] 20118.489873: sys_open -> 0xffffffec
>
> ctime(1243265590) = date:Mon May 25 11:33:10 2009
> So we can realize the task with pid 4020 open a file at
> Mon May 25 11:33:10 2009
>
> Changelog:
> v1->v2: Rebased by Zhao Lei <zhaolei@cn.fujitsu.com>
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/trace/events/xtime.h |   38 ++++++++++++++++++++++++++++++++++++++
>  kernel/time/ntp.c            |    4 ++++
>  kernel/time/timekeeping.c    |    6 ++++++
>  3 files changed, 48 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/xtime.h
>
> diff --git a/include/trace/events/xtime.h b/include/trace/events/xtime.h
> new file mode 100644
> index 0000000..398e679
> --- /dev/null
> +++ b/include/trace/events/xtime.h
> @@ -0,0 +1,38 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM xtime
> +
> +#if !defined(_TRACE_XTIME_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_XTIME_H
> +
> +#include <linux/time.h>
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(gtod_update_xtime,
> +
> +       TP_PROTO(struct timespec *xtime, struct timespec *wall_to_monotonic),
> +
> +       TP_ARGS(xtime, wall_to_monotonic),
> +
> +       TP_STRUCT__entry(
> +               __field(        long,   xtime_sec               )
> +               __field(        long,   xtime_nsec              )
> +               __field(        long,   wall_to_monotonic_sec   )
> +               __field(        long,   wall_to_monotonic_nsec  )
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->xtime_sec              = xtime->tv_sec;
> +               __entry->xtime_nsec             = xtime->tv_nsec;
> +               __entry->wall_to_monotonic_sec  = wall_to_monotonic->tv_sec;
> +               __entry->wall_to_monotonic_nsec = wall_to_monotonic->tv_nsec;
> +       ),
> +
> +       TP_printk("xtime=%ld.%09ld wall_to_monotonic=%ld.%09ld",
> +                 __entry->xtime_sec, __entry->xtime_nsec,
> +                 __entry->wall_to_monotonic_sec, __entry->wall_to_monotonic_nsec)
> +);
> +
> +#endif /* _TRACE_XTIME_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 4800f93..fc2f13a 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -15,6 +15,8 @@
>  #include <linux/time.h>
>  #include <linux/mm.h>
>
> +#include <trace/events/xtime.h>
> +
>  /*
>  * NTP timekeeping variables:
>  */
> @@ -218,6 +220,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
>                break;
>        }
>
> +       trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
> +
>        write_sequnlock(&xtime_lock);
>
>        return res;
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 03cbeb3..2e57a87 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -20,6 +20,9 @@
>  #include <linux/tick.h>
>  #include <linux/stop_machine.h>
>
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/xtime.h>
> +
>  /* Structure holding internal timekeeping values. */
>  struct timekeeper {
>        /* Current clocksource used for timekeeping. */
> @@ -338,6 +341,8 @@ int do_settimeofday(struct timespec *tv)
>
>        update_vsyscall(&xtime, timekeeper.clock);
>
> +       trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
> +

So the only thing to watch out on here is that xtime doesn't hold the
current time, but the accumulated time. There is some unaccumulated
time still kept in the clocksource structure.

You probably want (assuming you only need tick granularity time) to
use current_kernel_time().

As an aside, is there a reason you have to have update callbacks and
duplicate the time storage instead of using the existing interfaces?
(ie: Is this due to locking or something else?)

thanks
-john
