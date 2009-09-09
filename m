Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZIIOZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZIIOZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZIIOZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:25:50 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:57987 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZIIOZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TB8U+M8/Nn+3XT3B620jm9sO6MslZrikVYUasX2qOoLNodTiBk212jzzgjsztUdypT
         sdY8/8VN7Pju3F6SUtNr19Ji2tHlh4XqiXl7wYI567k4KDKn8+MKZNtAKjZ6N6iEuvQx
         lN6VrsleHOyx6bYGFL5tpThqh3e4NyoFF2eHU=
MIME-Version: 1.0
In-Reply-To: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
References: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
Date: Wed, 9 Sep 2009 22:25:52 +0800
Message-ID: <2674af740909090725l5862dc95o7cc7236ebc66ad83@mail.gmail.com>
Subject: Re: [PATCH] update clocksource raw_time in timekeeping_suspend
From: Yong Zhang <yong.zhang0@gmail.com>
To: ye janboe <janboe.ye@gmail.com>
Cc: johnstul@us.ibm.com, zippel@linux-m68k.org, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 3:35 PM, ye janboe<janboe.ye@gmail.com> wrote:
> after resume from suspend, raw_time is not updated in
> timekeeping_suspend. CLOCK_MONOTONIC_RAW could not get the real hw
> time.

It seems that this is not a bug. The design of CLOCK_MONOTONIC_RAW doesn't
say it will reflect the real hw time. It's just monotonic time which
is unpoisoned by
ntp.

Cheers,
Yong

> This patch fix this issue.
>
> Signed-off-by: janboe <janboe.ye@gmail.com>
> ---
>  kernel/time/timekeeping.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index e8c77d9..8420b85 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -331,6 +331,8 @@ static unsigned long timekeeping_suspend_time;
>  static int timekeeping_resume(struct sys_device *dev)
>  {
>        unsigned long flags;
> +       s64 nsec;
> +       cycle_t last_cycle, cycle_delta;
>        unsigned long now = read_persistent_clock();
>
>        clocksource_resume();
> @@ -346,8 +348,12 @@ static int timekeeping_resume(struct sys_device *dev)
>        }
>        update_xtime_cache(0);
>        /* re-base the last cycle value */
> +       last_cycle = clock->cycle_last;
>        clock->cycle_last = 0;
>        clock->cycle_last = clocksource_read(clock);
> +       cycle_delta = clock->cycle_last - last_cycle;
> +       nsec = cyc2ns(clock, cycle_delta);
> +       timespec_add_ns(&clock->raw_time, nsec);
>        clock->error = 0;
>        timekeeping_suspended = 0;
>        write_sequnlock_irqrestore(&xtime_lock, flags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
