Return-Path: <linux-kernel-owner+w=401wt.eu-S965884AbXCLOcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965884AbXCLOcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965881AbXCLOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:32:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:51418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965884AbXCLOcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:32:12 -0400
Date: Mon, 12 Mar 2007 15:32:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org
Cc: Michael Kerrisk <michael.kerrisk@gmx.net>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312143202.GA6016@wotan.suse.de>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org> <20070312141214.GG4372@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312141214.GG4372@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:12:14AM -0400, Theodore Tso wrote:
> On Mon, Mar 12, 2007 at 11:58:26AM +0100, Andi Kleen wrote:
> > On Mon, Mar 12, 2007 at 12:00:20PM +0100, Thomas Gleixner wrote:
> > > On Mon, 2007-03-12 at 12:27 +0100, Andi Kleen wrote:
> > > > Ingo Molnar <mingo@elte.hu> writes:
> > > > > 
> > > > > the only correct approach is the use of hrtimers, and a patch exists for 
> > > > > that - see below. This has been included in -rt for quite some time.
> > > > 
> > > > But isn't that bad for power management? You'll likely get more
> > > > idle wakeups, won't you?
> > > 
> > > Why so ? It comes more precise, but only once.
> > 
> > When it's clustered around the jiffies interval then wakeups from
> > multiple processes will be somewhat batched. With a precise wakeup you'll
> > get wakeups all over the jiffies period, won't you?
> 
> What we probably need in the long-term, and not just for high
> precision wakeups, is we need a way for waiters (either in the kernel
> or in userspace) to specify a desired precision in their timers.  Is
> it, "wake me up in a second, exactly", or "wake me up in a second,
> plus or minus 10ms"?   (or 50ms?  or 100ms?).

Would this work, or will it just create more confusion for the API user?
I mean, all sleeps can only guarantee "no less than".

Would it be enough for a binary (exact as possible / relaxed if needed)
flag? Or perhaps ternary (exact/relaxed/batched), where relaxed could
add an extra jiffy or so, and batched is really relaxed that may delay
up to double the value of the timeout.

> This becomes especially important if we want the tickless code to
> really shine as far as power management is concerned.  Unfortunately,
> the POSIX timer abstraction doesn't give this kind of flexibility
> easily, so it's going to be a while before we see significant
> userspace adoption of such a kernel feature, but I think it's
> something that would be still worthwhile to add.

But given that we know most userspace API timeouts are broadly just an
"equal to or greater", then we could add another timeout flag to specify
it is a userspace timeout, and make that controllable by sysctl.

Sure it isn't ideal, but for those who really want power / hypervisor
savings, it could be useful.

BTW. my futex man page says timeout's contents "describe the maximum duration
of the wait". Surely that should be *minimum*? Michael cc'ed.
