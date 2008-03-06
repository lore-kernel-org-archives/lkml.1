Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbYCFKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbYCFKkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYCFKkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:40:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54360 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbYCFKkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:40:43 -0500
Date: Thu, 6 Mar 2008 10:40:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Message-ID: <20080306104034.GB27894@ZenIV.linux.org.uk>
References: <200802042311.18762.rusty@rustcorp.com.au> <20080204145736.GX27894@ZenIV.linux.org.uk> <200802051441.53844.rusty@rustcorp.com.au> <200803051355.36502.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803051355.36502.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 01:55:36PM +1100, Rusty Russell wrote:

> AFAICT you posted an untested code fragment which won't actually compile 
> because the callback in this case returns void.

Callbacks for timers *do* return void.  FWIW,

extern void decay_to_pointer(void const volatile *);
#define check_callback_type(f,x) (sizeof((0 ? decay_to_pointer(x),(f)(x) : (void)0), 0))
#define __setup_timer(timer, func, arg) \
do {    \
	struct timer_list *__timer = (timer);   \
	__timer->function = (void (*)(unsigned long))(func); \
	__timer->data = (unsigned long)(arg);   \
	(void)check_callback_type(func, arg); \
} while(0)

#define setup_timer(timer, func, arg) \
do {    \
	struct timer_list *__timer = (timer);   \
	__timer->function = (void (*)(unsigned long))(func); \
	__timer->data = (unsigned long)(arg);   \
	init_timer(__timer);    \
	(void)check_callback_type(func, arg); \
} while(0)

#define DECLARE_TIMER(_name, _function, _data) \
        struct timer_list _name = { \
                .base = &boot_tvec_bases, \
                .function = (void (*)(unsigned long))(_function), \
                .data = (unsigned long)(_data) + \
                        0 * check_callback_type(_function, _data) \
        }

is what the timer series ended up using.  Note that this is _after_
conversion of setup_timer() users to natural argument types.  And yes,
it went timer-by-timer.
 
> > > ; normal C constructs are quite sufficient, TYVM.
> 
> Your code didn't check the return type, except that it's a pointer or 
> int-compatible.

Huh?  It certainly does _not_ accept return of int or pointer - ? : with
(void) 0 in the other branch is there to give a warning on those.  Note
that any timer callback that does anything of that kind is simply bogus -
there is nothing the caller could do about whatever return values we might
have, anyway.

> We can do better, as this patch showed.

> If you have a "saner way" of doing this in general which is just as effective, 
> I look forward to it.  Otherwise you're just managed to delay these 
> improvements for another release.

See above.  The point is, we don't bloody need to convert them all at once
and we can eliminate void (unsigned long) ones as we go.

Let me put it that way: if you actually look at these suckers, you'll see
that there's less than a dozen instances that actually want an integer.
Out of several hundreds.  And out of those only two, IIRC, were not trivially
converted by "pass pointer to array element instead of index in array".
Something in arch/sparc and arch/sparc64 - I can dig the details out if
you wish, but (a) it'll obviously need search from scratch to verify that
new pathology didn't show up and (b) it's extremely unlikely that the total
amount had become considerable.

So for timer callbacks the right answer is "just convert them to pointers,
these two cases are not worth the trouble".  And we _can_ do that in bisectable
way, TYVM - it's not that we can't do conversion stepwise.

A _very_ long series (we've a lot of these suckers) and I had two of its
incarnations bitrot on me by now, but it's not particulary tricky.

FWIW, I've finally rescued another bitrot victim (bdev API conversion and
related cleanups and fixes; sent to Jens for review last week, might be
actually mergable next cycle), so the timer one is near the top of the pile
right now; I can certainly bump it up and post the infrastructure + several
hundred instances converted by the next week.  Finishing vfs-2.6 tree should
take a couple of days (there are several _old_ pending mini-series that might
go there; currently the tree on kernel.org still has only immediate fixes +
ro-bind, all under vfs-fixes.b1 / ro-bind.b1), then I'm free for that...

PS: apologies for missing your previous mail; ETOOBIGMBOX ;-/
