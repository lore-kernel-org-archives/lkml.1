Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbXGYJSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbXGYJSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbXGYJSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:18:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755609AbXGYJSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:18:23 -0400
Date: Wed, 25 Jul 2007 02:17:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-Id: <20070725021730.a9a624b3.akpm@linux-foundation.org>
In-Reply-To: <20070725090439.GA26286@elte.hu>
References: <20070717114453.GA8212@elte.hu>
	<469CCF8F.4010107@goop.org>
	<20070717154934.GA24231@elte.hu>
	<20070725014912.35c7e325.akpm@linux-foundation.org>
	<20070725085204.GA22067@elte.hu>
	<20070725020003.63144fd6.akpm@linux-foundation.org>
	<20070725090439.GA26286@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 11:04:39 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> > fix-the-softlockup-watchdog-to-actually-work.patch
> > softlockup-make-asm-irq_regsh-available-on-every-platform.patch
> > softlockup-improve-debug-output.patch
> > softlockup-watchdog-style-cleanups.patch
> > softlockup-add-a-proc-tuning-parameter.patch
> > softlockup-add-a-proc-tuning-parameter-fix.patch
> 
> you have the key one missing i think - attached below.
> 
> 	Ingo
> 
> ------------------------------------>
> Subject: softlockup: use cpu_clock() instead of sched_clock()
> From: Ingo Molnar <mingo@elte.hu>
> 
> sched_clock() is not a reliable time-source, use cpu_clock() instead.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softlockup.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -42,14 +42,16 @@ static struct notifier_block panic_block
>   * resolution, and we don't need to waste time with a big divide when
>   * 2^30ns == 1.074s.
>   */
> -static unsigned long get_timestamp(void)
> +static unsigned long get_timestamp(int this_cpu)
>  {
> -	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
> +	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
>  }
>  
>  void touch_softlockup_watchdog(void)
>  {
> -	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
> +	int this_cpu = raw_smp_processor_id();
> +
> +	per_cpu(touch_timestamp, this_cpu) = get_timestamp(this_cpu);
>  }
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> @@ -95,7 +97,7 @@ void softlockup_tick(void)
>  		return;

argh.  afacit this was never sent, except as part of some jumbopatch called
"sched: implement cpu_clock(cpu) high-speed time source".

That patch helped.

It's all a plot.

