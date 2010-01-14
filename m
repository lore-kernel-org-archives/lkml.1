Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903Ab0ANUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0ANUq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032Ab0ANUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:46:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53278 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0ANUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:46:58 -0500
Date: Thu, 14 Jan 2010 20:46:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, linux-arm-kernel@lists.infradead.org
Subject: Re: Re: [PATCH 20/40] arm,kgdb: Add hook to catch an oops with
	debugger
Message-ID: <20100114204647.GE21385@n2100.arm.linux.org.uk>
References: <20100114174821.GB21385@n2100.arm.linux.org.uk> <4B4F7EC2.6030000@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4F7EC2.6030000@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 02:29:54PM -0600, Jason Wessel wrote:
> Russell King - ARM Linux wrote:
> > 
> > I have a similar patch which implements the hook properly - but
> > with one caveat.  It needs a review to ensure that its safe to return
> > from die().  Until that's established, this patch can not be merged.
> 
> I completed the analysis on your patch and yes, it is safe to return
> from __die() and die() the way you currently structured it, but it
> doesn't work quite the same as on some other architectures.
> 
> After changing kgdb.c to register with the die notifier, I stepped
> through your code with an ICE, as well as running my regression tests
> which panic, oops, bad access etc...
> 
> While kernel execution does happen to continue to work, I don't know
> that you really want to continue execution.
> 
> 1) The kernel is marked tainted
> 2) bust_spinlocks() was toggled for a while
> 
> On x86 for example, the notifier is invoked prior to the
> bust_spinlocks() etc... and then it can pass the exception along to
> the rest of the system (which can result in something bad, but
> remember the human behind the kernel debugger controls did it for some
> reason or another).

On x86, it's called in multiple places - both before die(), and also
inside __die().

In __die(), notify_die() gets called with DIE_OOPS.  There's also a
pile of notify_die() calls in arch/x86/kernel/traps.c, which we don't
implement on ARM yet - it's unclear what's required here, and until
we have a user of notify_die()...

> I made the following addition to your patch, and then it behaved as
> the other archs do with respect to passing along the result of the
> exception.  Given this information, would you be willing to merge your
> patch and possibly fold in the change below, or further comment?

This changes the behaviour away from x86, so I'm not sure it's the
right thing to do.  For instance, it means that kexec won't get to
know about the oops on ARM if NOTIFY_STOP is returned, whereas on
x86 it will.

Maybe this hook wasn't meant for kgdb - what does kgdb use on x86?
