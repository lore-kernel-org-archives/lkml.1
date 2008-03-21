Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYCUCKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYCUCKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 22:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYCUCK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 22:10:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50746 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYCUCK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 22:10:26 -0400
X-Sasl-enc: /iPRI3ZC94isJeYRuaAZiLfZWCOYuvjRmIuh1X/Se/OR 1206065425
Date: Thu, 20 Mar 2008 23:10:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080321021020.GA28989@khazad-dum.debian.net>
References: <20080316184349.GA28543@khazad-dum.debian.net> <200803161246.23909.david-b@pacbell.net> <20080318001429.896acf51.akpm@linux-foundation.org> <20080320225612.GB20788@khazad-dum.debian.net> <20080320164741.734e838c.akpm@linux-foundation.org> <1206060976.4549.121.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206060976.4549.121.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Richard Purdie wrote:
> The LED interface said that the brightness_set implementation should not
> sleep since it was intended to be a 'cheap' function and to allow LED
> triggers changing the LED brightness to be simple. A lot of embedded LED
> hardware doesn't need to sleep to toggle gpios.

So far so good.

> Some drivers do have a problem with that however and its usually been
> suggested they offload the brightness changes into a workqueue. The gpio

Also good.  But the fact is, the LED core *does* know when it is calling
from a scheduleable context (e.g. from sysfs handlers), and that's not an
uncommon path either.

The trigger code is more complicated, I don't know if most of its calls to
brightness_set are in safe or unsafe contexts for sleep.  But the people
calling the trigger code certainly would.

> * fix the gpio driver not to be so clever and clearly document
> * move the workqueue into the LED class, use it for everyone and remove
> the limitation of the function (punishes the hardware which doesn't need
> to sleep)
> * move the workqueue into the LED class and have LED drivers state
> whether they can sleep or not
> * start passing around GFP_* flags
> 
> Passing flags around and maintaining a track of schedulable state for
> the LED class sounds like overkill. I also don't like the idea of

It is the preferred way to do these things.  If you don't do it like that,
both gpio and *all* ACPI-based LED devices will have to always defer to
workqueues.

> So I'm leaning towards 'fixing' the gpio driver as I think David has
> already offered. I will also improve the documentation on this function
> and its requirements as I agree the current isn't as clear as it should
> be.

And we will have to always defer to workqueues on drivers that can't operate
from an atomic/interrupt context?  Even when there would be no need for it
because brightness_set is not being called from an non-scheduleable context
at all?

I hope I can live with that for LEDs (I have to think about LED
brightness_get first before I am sure about that), but I don't like it at
all for the long term.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
