Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589Ab0A1UQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0A1UQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276Ab0A1UQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:16:26 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60506 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0A1UQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:16:25 -0500
Subject: Re: [PATCH] kernel/timekeeping:  move xtime_cache to be in the
 same cache line as the lock
From: john stultz <johnstul@us.ibm.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264594226.2059.47.camel@localhost>
References: <1264088361.2082.45.camel@localhost>
	 <20100126152822.d05b5487.akpm@linux-foundation.org>
	 <1264594226.2059.47.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 12:16:14 -0800
Message-ID: <1264709774.3437.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 12:10 +0000, Richard Kennedy wrote:
> On Tue, 2010-01-26 at 15:28 -0800, Andrew Morton wrote:
> > On Thu, 21 Jan 2010 15:39:21 +0000
> > Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> > 
> > > move xtime_cache to be in the same cache line as the lock
> > >     
> > > allowing current_kernel_time() to access only one cache line
> > 
> > Sentences start with capital letters, please.
> 
> Sorry about that, I will try harder in future ;)
> 
> 
> > 
> > I don't know how reliable this is.  I _think_ the compiler and linker
> > are free to place variables of this nature in any old place.  Whether
> > any of the current tools actually do that I don't know.  Note that one
> > of these variables has file-static scope and the other does not, which
> > perhaps increases the risk that the compiler or linker will go and
> > fiddle with them.
> > 
> > To do this reliably one would need to put them in a struct:
> > 
> > time.h:
> > 
> > extern struct xtime_stuff {
> > 	seqlock_t _xtime_lock,
> > 	struct timespec _xtime_cache,
> > } xtime_stuff;
> > 
> > #define xtime_lock xtime_stuff._xtime_lock
> > 
> > 
> > timekeeping.c:
> > 
> > struct xtime_stuff {
> > 	._xtime_lock = __SEQLOCK_UNLOCKED(xtime_stuff._xtime_lock),
> > };
> Thank you, yes that looks like a much better approach.
> I can do this if it's needed, but John Stultz said he's going to kill
> the xtime_cache anyway, so it may not be worth it?
> 
> However I do wonder if we should move all, or at least some, of the
> variables protected by that xtime_lock into that structure? Then we can
> manage their placement and they would be easier to find. After only a
> brief look I see variables in ntp, tick &  timekeeping that seem to be
> protected by that seqlock.

The xtime lock has been used to protect quite a bit, but that has been
slowly cleaned up. Luckily process accounting is no longer done under it
(although load time accounting still is - not that its used on the
read-side if I recall), but jiffies, tick_next_period, almost all of the
values in ntp.c, and the timekeeper structure and friends are all
covered by it.

Personally I'd love to see the timekeeper structure gain a lock that
protects its elements, further removing the need for the external
xtime_lock. The timekeeper structure should also pull in xtime and
wall_to_monotonic, but there's still quite a bit of arch specific code
that needs to be fixed first (see my arch_gettimeoffset patches and
read/update_persistent_clock patches from end of December).

Trying to resolve the ntp.c and timekeeping.c xtime_lock usage is a
little harder. Keeping those files and structures separate makes the
time code slightly less confusing (though maybe not as much as I'd
hope), but the functionality is so tightly coupled that splitting the
xtime lock into two separate locks seems like a little too much. But
maybe you have some interesting ideas there?

So by all means, please take a shot at it. I'm probably prone to being
too conservative with making changes in the hopes that we don't cause
too many regressions and if we do they're easy to find. But folks like
Martin have been able to make some great cleanups without the world
falling apart, so maybe my turtle's pace is unwarranted.

thanks
-john

