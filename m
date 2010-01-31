Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930Ab0AaAq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0AaAq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406Ab0AaAqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:46:25 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:46205 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0AaAqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:46:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hAdtIctqiSFTcNoJ5nHs8UxXGJw7HJSPSf5qjavO3Lvz0p24EAWX1/9BIoj/gz3Isf
         x1t2rVLIDKeA4es2SfuV/YD7eigikbvsvrNCfY55FxsoZXIAFZ34wloFzwdiwyLkdtxo
         cUJHWP8SLwTsRTO7oeLuxsFrrmj0ayJ0hluFs=
Date: Sat, 30 Jan 2010 18:46:00 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100131004600.GD27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net> <20100130161114.07278221@infradead.org> <20100131003549.GC27390@mediacenter.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131003549.GC27390@mediacenter.gateway.2wire.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 06:35:49PM -0600, Shawn Bohrer wrote:
> On Sat, Jan 30, 2010 at 04:11:14PM -0800, Arjan van de Ven wrote:
> > On Sat, 30 Jan 2010 17:45:51 -0600
> > Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> > 
> > > Hello,
> > > 
> > > Currently we have a workload that depends on around 50 processes that
> > > wake up 1000 times a second do a small amount of work and go back to
> > > sleep.  This works great on RHEL 5 (2.6.18-164.6.1.el5), but on recent
> > > kernels we are unable to achieve 1000 iterations per second.  Using
> > > the simple test application below on RHEL 5 2.6.18-164.6.1.el5 I can
> > > run 500 of these processes on and still achieve 999.99 iterations per
> > > second.  Running just 10 of these processes on the same machine with
> > > 2.6.32.6 produces results like:
> > > ]
> > 
> > there's an issue with your expectation btw.
> > what your application does, in practice is
> > 
> > <wait 1 millisecond>
> > <do a bunch of work>
> > <wait 1 millisecond>
> > <do a bunch of work>
> > etc
> > 
> > you would only be able to get close to 1000 per second if "bunch of
> > work" is nothing.....but it isn't.
> > so lets assume "bunch of work" is 100 microseconds.. the basic period
> > of your program (ignoring any costs/overhead in the implementation) 
> > is 1.1 milliseconds, which is approximately 909 per second, not 1000!
> > 
> > I suspect that the 1000 you get on RHEL5 is a bug in the RHEL5 kernel
> > where it gives you a shorter delay than what you asked for; since it's
> > clearly not a correct number to get.
> > 
> > (and yes, older kernels had such rounding bugs, current kernels go
> > through great length to give applications *exactly* the delay they are
> > asking for....)
> 
> I agree that we are currently depending on a bug in epoll.  The epoll
> implementation currently rounds up to the next jiffie, so specifying a
> timeout of 1 ms really just wakes the process up at the next timer tick.
> I have a patch to fix epoll by converting it to use
> schedule_hrtimeout_range() that I'll gladly send, but I still need a way
> to achieve the same thing.

I guess I should add that I think we could achieve the same effect by
adding a 1 ms (or less) periodic timerfd to our epoll set.  However, it
still appears that newer kernels have a much larger scheduler delay and
I still need a way to fix that in order for us to move to a newer
kernel.

--
Shawn
