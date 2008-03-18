Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbYCSUmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbYCSUmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYCSTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:43:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758055AbYCSTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:08 -0400
Date: Tue, 18 Mar 2008 13:07:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: hmh@hmh.eng.br, rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-Id: <20080318130701.63e354a9.akpm@linux-foundation.org>
In-Reply-To: <200803181206.14162.david-b@pacbell.net>
References: <20080316184349.GA28543@khazad-dum.debian.net>
	<200803161246.23909.david-b@pacbell.net>
	<20080318001429.896acf51.akpm@linux-foundation.org>
	<200803181206.14162.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 11:06:13 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Tuesday 18 March 2008, Andrew Morton wrote:
> > On Sun, 16 Mar 2008 11:46:23 -0800 David Brownell <david-b@pacbell.net> wrote:
> > 
> > > On Sunday 16 March 2008, Henrique de Moraes Holschuh wrote:
> > > > Is the use of "if (preempt_count())" to know when to defer led gpio work to
> > > > a workqueue needed? __Shouldn't "if (in_atomic())" be enough?
> > > 
> > > At this point, I don't know of any such reason.
> > > 
> > > I remember hunting for the right heuristic, and settling on
> > > that one for reasons that I can't recall now.  They may even
> > > be no longer applicable.
> > 
> > Both are incorrect. 
> 
> So something like the appended patch would seem "better"?
> 
> 
> > <greps for in_atomic>
> > 
> > omigawd, what have we done, and how can we fix it? :(
> 
>  
> ==============
> It appears that we can't just check to see if we're in a task
> context ... so instead of trying that, just make the relevant
> leds always schedule a little worklet.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/leds/leds-gpio.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- g26.orig/drivers/leds/leds-gpio.c	2008-03-18 01:32:08.000000000 -0700
> +++ g26/drivers/leds/leds-gpio.c	2008-03-18 02:01:23.000000000 -0700
> @@ -49,13 +49,13 @@ static void gpio_led_set(struct led_clas
>  	if (led_dat->active_low)
>  		level = !level;
>  
> -	/* setting GPIOs with I2C/etc requires a preemptible task context */
> +	/* Setting GPIOs with I2C/etc requires a task context, and we don't
> +	 * seem to have a reliable way to know if we're already in one; so
> +	 * let's just assume the worst.
> +	 */
>  	if (led_dat->can_sleep) {
> -		if (preempt_count()) {
> -			led_dat->new_level = level;
> -			schedule_work(&led_dat->work);
> -		} else
> -			gpio_set_value_cansleep(led_dat->gpio, level);
> +		led_dat->new_level = level;
> +		schedule_work(&led_dat->work);
>  	} else
>  		gpio_set_value(led_dat->gpio, level);
>  }
> 

Better, I guess.

There's a design problem in the LED interface, though.  If callers really
do want to be able to call led_classdev.brightness_set() from atomic
contexts then we should either

a) make that function atomic (as you've done).  But that's inefficient.

b) pass in a mode flag to tell the callee whether it is allowed to
   sleep.  Ugly, but there's lots of precedent: GFP_ATOMIC-vs-GFP_KERNEL.

c) create a separate led_classdev.brightness_set_atomic() which callers
   should use when they're in atomic contexts.


Option c) would be best from a cleanness and efficiency POV.
