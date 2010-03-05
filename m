Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0CEOLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:11:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41660 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752456Ab0CEOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:11:48 -0500
Date: Fri, 5 Mar 2010 08:11:43 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] improve stop_machine performance
Message-ID: <20100305141143.GA17417@sgi.com>
References: <20100304212034.GA3171@sgi.com> <4B904EA8.3050709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B904EA8.3050709@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 09:22:00AM +0900, Tejun Heo wrote:
> Hello,
> 
> On 03/05/2010 06:20 AM, Dimitri Sivanich wrote:
> > On systems with large cpu counts, we've been seeing long bootup times
> > associated with stop_machine operations.  I've noticed that by simply
> > removing the creation of the workqueue and associated percpu variables
> > in subsequent stop_machine calls, we can reduce boot times on a
> > 1024 processor SGI UV system from 25-30 (or more) minutes down to 12
> > minutes.
> > 
> > The attached patch does this in a simple way by removing the
> > stop_machine_destroy interface, thereby by leaving the workqueues and
> > percpu variables for later use once they are created.
> > 
> > If people are against having these areas around after boot, maybe there
> > are some alternatives that will still allow for this optimization:
> > 
> >  - Set a timer to go off after a configurable number of minutes, at
> >    which point the workqueue areas will be deleted.
> > 
> >  - Keep the stop_machine_destroy function, but somehow run it at the tail
> >    end of boot (after modules have loaded), rather than running it at
> >    every stop_machine call.
> 
> Yeah, I can indeed imagine that creating and destroying all those
> workers on every module load during boot would be very costly if there
> are lots of CPUs.  How about sharing the migration thread so that it
> serves as one-per-cpu uninterruptible RT simple thread pool?  It's not
> like these things can run taking their turns anyway.  I'll go ahead
> and make something up.
>

It seems reasonable as long as setup is fast enough.  Will that thread indeed become fully uninterruptible (not affected by anything including scheduler decisions like sched_rt_period_us/sched_rt_runtime_us, etc..)?
