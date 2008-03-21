Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbYCUA4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbYCUA4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYCUA4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:56:38 -0400
Received: from tim.rpsys.net ([194.106.48.114]:34645 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbYCUA4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:56:37 -0400
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080320164741.734e838c.akpm@linux-foundation.org>
References: <20080316184349.GA28543@khazad-dum.debian.net>
	 <200803161246.23909.david-b@pacbell.net>
	 <20080318001429.896acf51.akpm@linux-foundation.org>
	 <20080320225612.GB20788@khazad-dum.debian.net>
	 <20080320164741.734e838c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 00:56:16 +0000
Message-Id: <1206060976.4549.121.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 16:47 -0700, Andrew Morton wrote:
> On Thu, 20 Mar 2008 19:56:12 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> 
> > Can we add "in_scheduleable()", or maybe "can_schedule()", that returns
> > in_atomic() if CONFIG_PREEMT, or 0 if there is no way to know?   To my
> > limited knowledge of how that part of the kernel works, it would do the
> > right thing.
> 
> If we did that, then people would use it.  And that would be bad.  It'll
> lead to code which behaves differently on non-preemptible kernels, to code
> which works less well on non-preemptible kernels and it will lead to less
> well-thought-out code in general.
> 
> Really, this all points at an ill-designed part of the leds interface.  The
> consistent pattern we use in the kernel is that callers keep track of
> whether they are running in a schedulable context and, if necessary, they
> will inform callees about that.  Callees don't work it out for themselves.

The LED interface said that the brightness_set implementation should not
sleep since it was intended to be a 'cheap' function and to allow LED
triggers changing the LED brightness to be simple. A lot of embedded LED
hardware doesn't need to sleep to toggle gpios.

Some drivers do have a problem with that however and its usually been
suggested they offload the brightness changes into a workqueue. The gpio
driver tries to be clever and only uses the workqueue if the gpio
backend can sleep *and* the calling context requires it, the latter part
being the problem.

So the options are:

* fix the gpio driver not to be so clever and clearly document
* move the workqueue into the LED class, use it for everyone and remove
the limitation of the function (punishes the hardware which doesn't need
to sleep)
* move the workqueue into the LED class and have LED drivers state
whether they can sleep or not
* start passing around GFP_* flags

Passing flags around and maintaining a track of schedulable state for
the LED class sounds like overkill. I also don't like the idea of
needlessly always using a workqueue. The reason the workqueue was never
implemented in the core was basically a question of timing. If you know
the LED is on a serial bus running at 9600 baud you might not schedule
work quite as often as something on a faster bus. Yes you could start
passing this info around but to me it makes sense to leave this kind of
policy to the drivers.

So I'm leaning towards 'fixing' the gpio driver as I think David has
already offered. I will also improve the documentation on this function
and its requirements as I agree the current isn't as clear as it should
be.

Cheers,

Richard

