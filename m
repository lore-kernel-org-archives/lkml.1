Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZESOzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZESOzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZESOy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:54:56 -0400
Received: from www.tglx.de ([62.245.132.106]:50531 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbZESOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:54:54 -0400
Date: Tue, 19 May 2009 16:53:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend3 2/2] itimers: fix periodic tics precision
In-Reply-To: <20090518135028.3ce0f44e@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905191552170.5983@localhost.localdomain>
References: <20090518135028.3ce0f44e@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Stanislaw Gruszka wrote:
>  int do_getitimer(int which, struct itimerval *value)
> @@ -133,18 +134,20 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
>  }
>  
>  static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
> -			   struct itimerval *value, struct itimerval *ovalue)
> +			   const struct itimerval *const value,
> +			   struct itimerval *const ovalue)
>  {
> -	cputime_t cval, cinterval, nval, ninterval;
> +	cputime_t cval, nval;
> +	ktime_t kt_cinterval, kt_ninterval;

  Just nitpicking. That kt_ prefix is not really helpful, but that's
  my personal taste :)

> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index b6accca..905734b 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -1080,9 +1080,27 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
>  		return;
>  
>  	if (cputime_ge(cur_time, it->expires)) {
> -		it->expires = it->incr;
> -		if (!cputime_eq(it->expires, cputime_zero)) {
> -			it->expires = cputime_add(it->expires, cur_time);
> +		if (it->incr.tv64 != 0) {
> +			ktime_t incr, real_incr, diff;
> +			cputime_t cpu_incr;
> +			struct timespec ts_incr, ts_real_incr;
> +
> +			incr = ktime_sub_ns(it->incr, it->err_ns);
> +			if (unlikely(incr.tv64 <= 0))
> +				incr = ktime_set(0, 1);
> +
> +			ts_incr = ktime_to_timespec(incr);
> +			cpu_incr = timespec_to_cputime(&ts_incr);
> +
> +			cputime_to_timespec(cpu_incr, &ts_real_incr);
> +			real_incr = timespec_to_ktime(ts_real_incr);

  Yuck, we convert back and forth here. That's lots of really
  expensive math operations.

  ktime -> timespec -> cputime -> timespec -> ktime

  Isn't there a more intelligent way to get the delta ?

  We can precompute the real (cputime) increment of the given
  increment value, which should be always >= the precise increment
  value. We also can precompute the ktime_t value of one cputime
  increment.

  So now we can do:

  it->expires = cputime_add(it->expires, it->cpu_incr);
  it->error = ktime_add(it->error, it->incr_error);
  if (it->error.tv64 >= onecputimetick.tv64) {
  	it->expires--;
	it->error = ktime_sub(it->error, onecputimetick);
  }

  And the whole function boils down to simple add/sub/compare math.

Thanks,

	tglx
