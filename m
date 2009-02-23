Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZBWLFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZBWLFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZBWLFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:05:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZBWLFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:05:10 -0500
Date: Mon, 23 Feb 2009 12:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090223110433.GA17312@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain> <200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl> <m1ab8ddfbr.fsf@fess.ebiederm.org> <20090223084400.GB9582@elte.hu> <m17i3ha4nk.fsf@fess.ebiederm.org> <20090223094441.GM9582@elte.hu> <m1bpst77te.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpst77te.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > What makes s2ram fragile is not human failure but the 
> > combination of a handful of physical property:
> >
> > 1) Psychology: shutting the lid or pushing the suspend button is 
> >    a deceivingly 'simple' action to the user. But under the 
> >    hood, a ton of stuff happens: we deinitialize a lot of 
> >    things, we go through _all hardware state_, and we do so in a 
> >    serial fashion. If just one piece fails to do the right 
> >    thing, the box might not resume. Still, the user expects this 
> >    'simple' thing to just work, all the time. No excuses 
> >    accepted.
> >
> > 2) Length of code: To get a successful s2ram sequence the kernel
> >    runs through tens of thousands of lines of code. Code which
> >    never gets executed on a normal box - only if we s2ram. If 
> >    just one step fails, we get a hung box.
> >
> > 3) Debuggability: a lot of s2ram code runs with the console off, 
> >    making any bugs hard to debug. Furthermore we have no 
> >    meaningful persistent storage either for kernel bug messages. 
> >    The RTC trick of PM_DEBUG works but is a very narrow channel 
> >    of information and it takes a lot of time to debug a bug via 
> >    that method.
> 
> Yep that is an issue.

I'd also like to add #4:

     4) One more thing that makes s2ram special is that when the 
        resume path finds hardware often in an even more 
        deinitialized form than during normal bootup. During
        normal bootup the BIOS/firmware has at least done some
        minimal bootstrap (to get the kernel loaded), which
        makes life easier for the kernel.

        At s2ram stage we've got a completely pure hardware
        init state, with very minimal firmware activation. So 
        many of the init and deinit problems and bugs we only 
        hit in the s2ram path - which dynamics is again not 
        helpful.

> > The combination of these factors really makes up for a 
> > perfect storm in terms of kernel technology: we have this 
> > very-deceivingly-simple-looking but 
> > complex-and-rarely-executed piece of code, which is very 
> > hard to debug.
> 
> And much of this as you are finding with this piece of code is 
> how the software was designed rather then how the software 
> needed to be.

Well most of the 4 problems above are externalities and cannot 
go away just by fixing the kernel.

 #1 will always be with us.
 #3 needs the hardware to change. It's happening, but slowly.
 #4 will be with us as long as there's non-Linux BIOSes

#2 is the only thing where we can make a realistic difference,
but there's just so much we can do there.

And that still leaves the other three items: each of which is 
powerful enough of a force to give a bad name to any normal 
subsystem.

	Ingo
