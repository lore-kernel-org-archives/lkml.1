Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZBWPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZBWPH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZBWPHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:07:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZBWPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:07:14 -0500
Date: Mon, 23 Feb 2009 16:06:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090223150647.GE3377@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <m1bpst77te.fsf@fess.ebiederm.org> <20090223110433.GA17312@elte.hu> <200902231545.26250.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231545.26250.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 23 February 2009, Ingo Molnar wrote:
> > 
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > 
> > > > What makes s2ram fragile is not human failure but the 
> > > > combination of a handful of physical property:
> > > >
> > > > 1) Psychology: shutting the lid or pushing the suspend button is 
> > > >    a deceivingly 'simple' action to the user. But under the 
> > > >    hood, a ton of stuff happens: we deinitialize a lot of 
> > > >    things, we go through _all hardware state_, and we do so in a 
> > > >    serial fashion. If just one piece fails to do the right 
> > > >    thing, the box might not resume. Still, the user expects this 
> > > >    'simple' thing to just work, all the time. No excuses 
> > > >    accepted.
> > > >
> > > > 2) Length of code: To get a successful s2ram sequence the kernel
> > > >    runs through tens of thousands of lines of code. Code which
> > > >    never gets executed on a normal box - only if we s2ram. If 
> > > >    just one step fails, we get a hung box.
> > > >
> > > > 3) Debuggability: a lot of s2ram code runs with the console off, 
> > > >    making any bugs hard to debug. Furthermore we have no 
> > > >    meaningful persistent storage either for kernel bug messages. 
> > > >    The RTC trick of PM_DEBUG works but is a very narrow channel 
> > > >    of information and it takes a lot of time to debug a bug via 
> > > >    that method.
> > > 
> > > Yep that is an issue.
> > 
> > I'd also like to add #4:
> > 
> >      4) One more thing that makes s2ram special is that when the 
> >         resume path finds hardware often in an even more 
> >         deinitialized form than during normal bootup. During
> >         normal bootup the BIOS/firmware has at least done some
> >         minimal bootstrap (to get the kernel loaded), which
> >         makes life easier for the kernel.
> > 
> >         At s2ram stage we've got a completely pure hardware
> >         init state, with very minimal firmware activation.
> 
> This is very true and at least in some cases done on purpose, 
> AFAICS, due to some timing constraints forced on HW vendors by 
> M$, for example.

IMHO i think it's the technically sane thing to do. Personally i 
trust the quirks of bare metal much more than the combined 
quirks of firmware _and_ bare metal.

> >         So many of the init and deinit problems and bugs we 
> >         only hit in the s2ram path - which dynamics is again 
> >         not helpful.
> 
> Plus ACPI requires us to do additional things during 
> suspend-resume that are not done on boot-shutdown and which 
> have their own ordering requirements (not necessarily stated 
> directly, but such that we have do discover experimentally).  
> That also change from one BIOS to another.

We could perhaps do a few things here to trigger bugs sooner.

For example at driver init, instead of executing just 
->driver_open(), we could execute:

   ->driver_open()
   ->driver_suspend()
   ->driver_resume()

I.e. we'd simulate a suspend+resume mini-step. This makes it 
sure that the basic driver callbacks are sane. It is also 
supposed to work because the driver is just being initialized. 

This way certain types of bugs would not show up as difficult to 
debug s2ram regressions - but would show up as 'boot hang' or 
'boot crash' bugs.

This does not simulate the "big picture" resume machinery (the 
dependencies, etc.), nor does it trigger any of the "hardware 
got really turned off" effects that true resume will trigger - 
but at least it offloads a portion of the testing space from 
's2ram' to 'bootup' testing.

What's your feeling - what percentage of all s2ram regressions 
in the last year or so could have been triggered this way? Lets 
assume we had 100 regressions in that timeframe - would it be in 
the 10 bugs range? Or much lower or much higher?

	Ingo
