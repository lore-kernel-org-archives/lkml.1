Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZIIXI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZIIXI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZIIXI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:08:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44660 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZIIXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:08:25 -0400
Subject: Re: [PATCH] update clocksource raw_time in timekeeping_suspend
From: john stultz <johnstul@us.ibm.com>
To: ye janboe <janboe.ye@gmail.com>
Cc: zippel@linux-m68k.org, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
References: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 16:07:02 -0700
Message-Id: <1252537622.9883.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 15:35 +0800, ye janboe wrote:
> after resume from suspend, raw_time is not updated in
> timekeeping_suspend. CLOCK_MONOTONIC_RAW could not get the real hw
> time.
> This patch fix this issue.

Hmm.. I'll admit suspend probably was less considered with
CLOCK_MONOTONIC_RAW, so the semantics aren't well established.

However, I do think we want CLOCK_MONOTONIC_RAW to at-least closely map
to CLOCK_MONOTONIC (but *not* be NTP adjusted). I think that is what
folks would most likely expect.

However, that isn't what this patch seems to do.

Over suspend, I believe all hardware counters reset, so this patch would
seem to try to subtract the value back. 

This sort of makes sense for something like the TSC, which never wraps,
so the raw_time would be set back to a tranlation of the actual TSC
counter,  but for other clocksources like the ACPI PM, it would only
subtract at most 5 seconds. So this leaks hardware specific detail in an
ugly way.

Instead I suspect the most intuitive change would be to add in the
sleep_length to the raw time. This keeps CLOCK_MONOTONIC_RAW behaving
similarly to CLOCK_MONOTONIC, which I believe makes it more useful for
folks using CLOCK_MONOTONIC_RAW for things like tuning time
synchronization.

But let me know more why you chose this implementation and maybe that
will show some better insight in to how you expect it to behave.

thanks
-john



> Signed-off-by: janboe <janboe.ye@gmail.com>
> ---
>  kernel/time/timekeeping.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index e8c77d9..8420b85 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -331,6 +331,8 @@ static unsigned long timekeeping_suspend_time;
>  static int timekeeping_resume(struct sys_device *dev)
>  {
>         unsigned long flags;
> +       s64 nsec;
> +       cycle_t last_cycle, cycle_delta;
>         unsigned long now = read_persistent_clock();
> 
>         clocksource_resume();
> @@ -346,8 +348,12 @@ static int timekeeping_resume(struct sys_device *dev)
>         }
>         update_xtime_cache(0);
>         /* re-base the last cycle value */
> +       last_cycle = clock->cycle_last;
>         clock->cycle_last = 0;
>         clock->cycle_last = clocksource_read(clock);
> +       cycle_delta = clock->cycle_last - last_cycle;
> +       nsec = cyc2ns(clock, cycle_delta);
> +       timespec_add_ns(&clock->raw_time, nsec);
>         clock->error = 0;
>         timekeeping_suspended = 0;
>         write_sequnlock_irqrestore(&xtime_lock, flags);

