Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbXEJTrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbXEJTrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbXEJTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:47:36 -0400
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:44983 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXEJTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:47:36 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Tomas Janousek <tjanouse@redhat.com>
Subject: Re: [PATCH] Introduce boot based time
Date: Thu, 10 May 2007 21:48:59 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
References: <1178302732.5929.23.camel@localhost.localdomain> <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
In-Reply-To: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705102149.01714.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

On Thursday 10 May 2007, Tomas Janousek wrote:
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 8997b61..06f3eaf 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -116,6 +116,8 @@ extern int do_setitimer(int which, struct itimerval *value,
>  extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
>  extern void getnstimeofday(struct timespec *tv);
> +extern void getboottime(struct timespec *ts);
> +extern void monotonic_to_bootbased(struct timespec *ts);
>  
>  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>  extern int timekeeping_is_continuous(void);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f9217bf..dd9647a 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -36,9 +36,17 @@ EXPORT_SYMBOL(xtime_lock);
>   * at zero at system boot time, so wall_to_monotonic will be negative,
>   * however, we will ALWAYS keep the tv_nsec part positive so we can use
>   * the usual normalization.
> + *
> + * wall_to_monotonic is moved after resume from suspend for the monotonic
> + * time not to jump. We need to add total_sleep_time to wall_to_monotonic
> + * to get the real boot based time offset.
> + *
> + * - wall_to_monotonic is no longer the boot time, getboottime must be
> + * used instead.
>   */
>  struct timespec xtime __attribute__ ((aligned (16)));
>  struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
> +static unsigned long total_sleep_time;

Could you make that a ktime_t (or struct ktime)?
There are machines, which sleep more than they are awake. 
Just imagine a surveillance camera triggered by door entrance.

Yes, these things might run Linux (e.g. on "cris" architecture).

Or your VCR.
Yes, these devices might sleep more than they are awake, 
if you are not a TV junkie :-)


Best regards

Ingo Oeser
