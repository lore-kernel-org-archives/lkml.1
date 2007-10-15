Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbXJOH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbXJOH3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXJOH3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:29:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXJOH3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:29:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Rework hrtimer_nanosleep to make sys_compat_nanosleep easier
Date: Mon, 15 Oct 2007 09:28:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20071014215437.GF26693@kryten> <alpine.LFD.0.9999.0710150804290.22612@localhost.localdomain> <20071015063833.GA15396@kryten>
In-Reply-To: <20071015063833.GA15396@kryten>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710150928.56916.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19P9iqLUjUAE+IYIvtqMe2ZjDOi6vI9vbhT/qI
 ekEf2ljw9y83tg1gIVrWPmo+46OHRlI4LsezxvrlkA8btxw92y
 lEZ+NZb8FY91n2zRX2Nww==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007, Anton Blanchard wrote:
> Pull the copy_to_user out of hrtimer_nanosleep and into the callers
> (common_nsleep, sys_nanosleep) in preparation for converting
> compat_sys_nanosleep to use hrtimers.

Looks good, except for two micro-optimization:

> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> @@ -1361,7 +1356,14 @@ sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
>         if (!timespec_valid(&tu))
>                 return -EINVAL;
>  
> -       return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
> +       ret = hrtimer_nanosleep(&tu, &rmt, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
> +
> +       if (ret && rmtp) {
> +               if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
> +                       return -EFAULT;
> +       }
> +
> +       return ret;
>  }
>  

If it's common to call sys_nanosleep with a NULL rmtp argument, we could save a
few cycles using 

	return hrtimer_nanosleep(&tu, rmtp ? &rmp : NULL, HRTIMER_MODE_REL,
								 CLOCK_MONOTONIC);

> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 57efe04..cce8c75 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -980,9 +980,19 @@ sys_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
>  static int common_nsleep(const clockid_t which_clock, int flags,
>                          struct timespec *tsave, struct timespec __user *rmtp)
>  {
> -       return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
> +       struct timespec rmt;
> +       int ret;
> +
> +       ret = hrtimer_nanosleep(tsave, &rmt, flags & TIMER_ABSTIME ?
>                                  HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
>                                  which_clock);
> +
> +       if (ret && rmtp) {
> +               if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
> +                       return -EFAULT;
> +       }
> +
> +       return ret;
>  }

I think it would be better here to propagate the move to a kernel *rmtp
down to sys_clock_nanosleep so we get the same optimization in
compat_sys_clock_nanosleep. That should probably also be a separate
patch. I can do one if you don't do it first.

	Arnd <><
