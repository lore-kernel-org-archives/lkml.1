Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZGYAJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZGYAJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 20:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGYAJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 20:09:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45496 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZGYAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 20:09:35 -0400
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090723125245.34e84cac@skybase>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192057.177653956@de.ibm.com>	<1248205851.14209.777.camel@desktop>
	 <1248213607.3298.107.camel@localhost>	<20090722092519.772b238b@skybase>
	 <1248284733.18789.32.camel@work-vm>
	 <1248308900.7592.36.camel@localhost.localdomain>
	 <20090723125245.34e84cac@skybase>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 17:08:47 -0700
Message-Id: <1248480527.12279.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 12:52 +0200, Martin Schwidefsky wrote:
> On Wed, 22 Jul 2009 17:28:20 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> > 2) Structure names aren't too great right now. Not sure timeclock is
> > what I want to use, probably system_time or something. Will find/replace
> > before the next revision is sent out.
> 
> I've picked the name struct timekeeper.

Nice. I like this name.


> > 5) The TSC clocksource uses cycles_last to avoid very slight skew issues
> > (that otherwise would not be noticed). Not sure how to fix that if we're
> > pulling cycles_last (which is purely timekeeping state) out of the
> > clocksource. Will have to think of something.
> 
> That is an ugly one. A similar thing exists in the s390 backend where I
> want to reset the timekeeping to precise values after the clocksource
> switch from jiffies. The proper solution probably is to allow
> architectures to override the default clocksource. The jiffies
> clocksource doesn't make any sense on s390.

Yea. Still not sure what a good fix is here. We need some way for the
TSC to check if its slightly behind another cpu. Alternatively we could
create a flag (SLIGHTLY_UNSYNCED or something) where we then do the
quick comparison in the timekeeping code instead of the clocksource read
implementation? It would really only be useful for the TSC and would
clutter the code up somewhat, so I'm not sure I really like it, but
maybe that would work. 

> > 3) Once all arches are converted to using read_persistent_clock(), then
> > the arch specific time initialization can be dropped. Removing the
> > majority of direct xtime structure accesses.
> 
> Only if the read_persistent_clock allows for a better resolution than
> seconds. With my cputime accounting hat on: seconds are not good
> enough..

cputime accounting? read_persistent_clock is only used for time
initialization. But yea, it could be extended to return a timespec.

> > 4) Then once the remaining direct wall_to_monotonic and xtime accessors
> > are moved to timekeeping.c we can make those both static and embed them
> > into the core timekeeping structure.
> 
> Both should not be accessed at a rate that makes it necessary to read
> from the values directly. An accessor should be fine I think.

Yea its just a matter of cleaning things up.

> > But let me know if this patch doesn't achieve most of the cleanup you
> > wanted to see.
> 
> We are getting there. I wonder if it is really necessary to pull
> xtime_cache, raw_time, total_sleep_time and timekeeping_suspended into
> the struct timeclock. I would prefer the semantics that the struct
> timekeeper / timeclock contains the internal values of the timekeeping
> code for the currently selected clock source. xtime is not clock
> specific.

Its not necessary. Although I do like the idea of pulling all the values
protected by the xtime_lock into one structure so its clear what we're
protecting. As it is now, jiffies, ntp state and a whole host of other
data is covered by it, so it would be a ways off until all that logic
could be dethreaded.

The other reason for putting those values into the timekeeping struct is
that they are actually fairly tightly connected with the clocksource
state. There is some redundancy: xtime_nsec stores the highres remainder
of xtime.tv_nsec, xtime_cache is also mostly duplicate, so hopefully we
can combine those once xtime is made static.

> For reference here is the current stack of patches I have on my disk.
> The stop_machine conversion to install a new clocksource is currently missing.
> 
> PRELIMINARY PATCHES, USE AT YOUR OWN RISK.
> -------------------------------------------------------------------
> 
> Subject: [PATCH] introduce timekeeping_leap_insert
> 
> From: john stultz <johnstul@us.ibm.com>
> 
> ---
>  include/linux/time.h      |    1 +
>  kernel/time/ntp.c         |    7 ++-----
>  kernel/time/timekeeping.c |    7 +++++++
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
[snip]

I think this one is pretty easy and should be able to be submitted on
the sooner side. 




> -------------------------------------------------------------------
> 
> Subject: [PATCH] remove clocksource inline functions
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Remove clocksource_read, clocksource_enable and clocksource_disable
> inline functions. No functional change.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  include/linux/clocksource.h |   46 --------------------------------------------
>  kernel/time/timekeeping.c   |   32 +++++++++++++++++-------------
>  2 files changed, 18 insertions(+), 60 deletions(-)

[snip]

Again, the outstanding mult_orig fix (I need to pester Thomas or Andrew
to push that before 2.6.31 comes out) will collide with this, but
overall it looks ok.


> -------------------------------------------------------------------
> 
> Subject: [PATCH] cleanup clocksource selection
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Introduce clocksource_dequeue & clocksource_update and move spinlock
> calls. clocksource_update does nothing for GENERIC_TIME=n since
> change_clocksource does nothing as well.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

[snip]

Haven't had enough time to closely review or test this, but it looks
like an agreeable change. 




> -------------------------------------------------------------------
> 
> Subject: [PATCH] introduce struct timekeeper
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Add struct timekeeper to keep all the internal values timekeeping.c
> needs in regard to the currently selected clock source. This moves
> all timekeeping related values out of the struct clocksource.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  arch/ia64/kernel/time.c       |    5 
>  arch/powerpc/kernel/time.c    |    5 
>  arch/s390/kernel/time.c       |    9 -
>  arch/x86/kernel/vsyscall_64.c |    5 
>  include/linux/clocksource.h   |   51 ---------
>  kernel/time/timekeeping.c     |  224 +++++++++++++++++++++++++++---------------
>  6 files changed, 161 insertions(+), 138 deletions(-)
> 

[snip]

> +/* Structure holding internal timekeeping values. */
> +struct timekeeper {
> +	struct clocksource *clock;
> +	cycle_t cycle_interval;
> +	u64	xtime_interval;
> +	u32	raw_interval;
> +	u64	xtime_nsec;
> +	s64	ntp_error;
> +	int	xtime_shift;
> +	int	ntp_shift;
> +
> +	/*
> +	 * The following is written at each timer interrupt
> +	 * Keep it in a different cache line to dirty no
> +	 * more than one cache line.
> +	 */
> +	cycle_t cycle_last ____cacheline_aligned_in_smp;
> +};


The cacheline aligned bit probably needs to cover almost everything here
(not clock, not the shift values), as it will all be updated each tick.


[snip]
> @@ -564,8 +628,8 @@ static __always_inline int clocksource_b
>  	 * Now calculate the error in (1 << look_ahead) ticks, but first
>  	 * remove the single look ahead already included in the error.
>  	 */
> -	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
> -	tick_error -= clock->xtime_interval >> 1;
> +	tick_error = tick_length >> (timekeeper.ntp_shift + 1);
> +	tick_error -= timekeeper.xtime_interval >> 1;
>  	error = ((error - tick_error) >> look_ahead) + tick_error;
> 
>  	/* Finally calculate the adjustment shift value.  */
> @@ -590,18 +654,18 @@ static __always_inline int clocksource_b
>   * this is optimized for the most common adjustments of -1,0,1,
>   * for other values we can do a bit more work.
>   */
> -static void clocksource_adjust(s64 offset)
> +static void timekeeping_adjust(s64 offset)
>  {
> -	s64 error, interval = clock->cycle_interval;
> +	s64 error, interval = timekeeper.cycle_interval;
>  	int adj;
> 
> -	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
> +	error = timekeeper.ntp_error >> (timekeeper.ntp_shift - 1);
>  	if (error > interval) {
>  		error >>= 2;
>  		if (likely(error <= interval))
>  			adj = 1;
>  		else
> -			adj = clocksource_bigadjust(error, &interval, &offset);
> +			adj = timekeeping_bigadjust(error, &interval, &offset);
>  	} else if (error < -interval) {
>  		error >>= 2;
>  		if (likely(error >= -interval)) {
> @@ -609,15 +673,14 @@ static void clocksource_adjust(s64 offse
>  			interval = -interval;
>  			offset = -offset;
>  		} else
> -			adj = clocksource_bigadjust(error, &interval, &offset);
> +			adj = timekeeping_bigadjust(error, &interval, &offset);
>  	} else
>  		return;
> 
> -	clock->mult += adj;
> -	clock->xtime_interval += interval;
> -	clock->xtime_nsec -= offset;
> -	clock->error -= (interval - offset) <<
> -			(NTP_SCALE_SHIFT - clock->shift);
> +	timekeeper.clock->mult += adj;
> +	timekeeper.xtime_interval += interval;
> +	timekeeper.xtime_nsec -= offset;
> +	timekeeper.ntp_error -= (interval - offset) << timekeeper.ntp_shift;
>  }
> 
>  /**
> @@ -627,53 +690,56 @@ static void clocksource_adjust(s64 offse
>   */
>  void update_wall_time(void)
>  {
> +	struct clocksource *clock;
>  	cycle_t offset;
> 
>  	/* Make sure we're fully resumed: */
>  	if (unlikely(timekeeping_suspended))
>  		return;
> 
> +	clock = timekeeper.clock;
>  #ifdef CONFIG_GENERIC_TIME
> -	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
> +	offset = (clock->read(clock) - timekeeper.cycle_last) & clock->mask;
>  #else
> -	offset = clock->cycle_interval;
> +	offset = timekeeper.cycle_interval;
>  #endif
> -	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
> +	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.xtime_shift;
> 
>  	/* normally this loop will run just once, however in the
>  	 * case of lost or late ticks, it will accumulate correctly.
>  	 */
> -	while (offset >= clock->cycle_interval) {
> +	while (offset >= timekeeper.cycle_interval) {
>  		/* accumulate one interval */
> -		offset -= clock->cycle_interval;
> -		clock->cycle_last += clock->cycle_interval;
> +		offset -= timekeeper.cycle_interval;
> +		timekeeper.cycle_last += timekeeper.cycle_interval;
> 
> -		clock->xtime_nsec += clock->xtime_interval;
> -		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
> -			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
> +		timekeeper.xtime_nsec += timekeeper.xtime_interval;
> +		if (timekeeper.xtime_nsec >= (u64)NSEC_PER_SEC << timekeeper.xtime_shift) {
> +			timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << timekeeper.xtime_shift;
>  			xtime.tv_sec++;
>  			second_overflow();
>  		}
> 
> -		clock->raw_time.tv_nsec += clock->raw_interval;
> -		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
> -			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
> -			clock->raw_time.tv_sec++;
> +		raw_time.tv_nsec += timekeeper.raw_interval;
> +		if (raw_time.tv_nsec >= NSEC_PER_SEC) {
> +			raw_time.tv_nsec -= NSEC_PER_SEC;
> +			raw_time.tv_sec++;
>  		}
> 
>  		/* accumulate error between NTP and clock interval */
> -		clock->error += tick_length;
> -		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
> +		timekeeper.ntp_error += tick_length;
> +		timekeeper.ntp_error -= timekeeper.xtime_interval <<
> +					timekeeper.ntp_shift;
>  	}


Just to be super careful, I'd probably separate the introduction of the
timekeeper code and the ntp_shift changes into separate patches. Just to
keep the amount of change to very complex code down to a more easily
review-able amount.


So yea, so I think we're pretty much seeing the same vision here!
There's still the outstanding cycles_last access by the TSC clocksource,
so let me know what you think about my idea for that I mentioned
earlier.

Looks good. If I can get some more time soon I'll try to put all of
these patches together for some testing and see what else I can add.

thanks again!
-john


