Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXEGKBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXEGKBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXEGKBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:01:12 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33712 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbXEGKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:01:11 -0400
Subject: Re: LED stuff - why bother with error handling
From: Richard Purdie <rpurdie@rpsys.net>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070506142329.GA21158@flint.arm.linux.org.uk>
References: <20070506142329.GA21158@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Mon, 07 May 2007 11:00:45 +0100
Message-Id: <1178532046.5864.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-06 at 15:23 +0100, Russell King wrote:
> While reviewing 4359/2, I found the following issue.  Let's remove all
> the irrelevant lines of code to illustrate the problem.
> 
> void led_trigger_register_simple(const char *name, struct led_trigger **tp)
> {
>         struct led_trigger *trigger;
> 
>         trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
> ...
>         *tp = trigger;
> }
> 
> void led_trigger_unregister(struct led_trigger *trigger)
> {
>         list_del(&trigger->next_trig);
> }
> 
> The thing to note is that led_trigger_register_simple() can fail but it's
> a void function.  There's a very good school of thought which says that
> functions which can fail should never have a return type of void.

The simple triggers are often tagged onto other subsystems and were
designed to be minimally invasive. Since they were ancillary, it was
left that they didn't return error codes. Taking the IDE trigger as an
example, the failure of the trigger should not cause the IDE subsystem
to fail, if should just skip over the LED registration. The alternative
is every simple trigger site has an error check and a printk which
seemed a bit pointless.

Note that you can still check whether it succeeded by looking at the
trigger pointer if you really need to - I've never seen a use case that
did though.

Moving to the problem you raised, I thought all the code paths a simple
trigger could end up on checked for NULL and/or were NULL safe. The
led_trigger_unregister_simple function has a missing NULL check which
I'll fix.

> If we want people to detect errors then we must *not* return values by
> reference.  It stops people thinking about "what if this returns a non-
> zero error value" or "what if it returns NULL?".  Adding __must_check
> gives extra persuasion to check the return value.
> 
> Can the LED trigger API be fixed please?

I agree the failure shouldn't be silent as it currently is and therefore
led_trigger_register_simple() should have some warning printks added so
the user can tell if it failed to register. I think they belong in the
core rather than at every call site though for the reasons I mention
above.

Regards,

Richard


