Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZBWOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZBWOpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZBWOpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:45:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39894 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbZBWOpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:45:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 15:45:25 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <m1bpst77te.fsf@fess.ebiederm.org> <20090223110433.GA17312@elte.hu>
In-Reply-To: <20090223110433.GA17312@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231545.26250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Ingo Molnar wrote:
> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > > What makes s2ram fragile is not human failure but the 
> > > combination of a handful of physical property:
> > >
> > > 1) Psychology: shutting the lid or pushing the suspend button is 
> > >    a deceivingly 'simple' action to the user. But under the 
> > >    hood, a ton of stuff happens: we deinitialize a lot of 
> > >    things, we go through _all hardware state_, and we do so in a 
> > >    serial fashion. If just one piece fails to do the right 
> > >    thing, the box might not resume. Still, the user expects this 
> > >    'simple' thing to just work, all the time. No excuses 
> > >    accepted.
> > >
> > > 2) Length of code: To get a successful s2ram sequence the kernel
> > >    runs through tens of thousands of lines of code. Code which
> > >    never gets executed on a normal box - only if we s2ram. If 
> > >    just one step fails, we get a hung box.
> > >
> > > 3) Debuggability: a lot of s2ram code runs with the console off, 
> > >    making any bugs hard to debug. Furthermore we have no 
> > >    meaningful persistent storage either for kernel bug messages. 
> > >    The RTC trick of PM_DEBUG works but is a very narrow channel 
> > >    of information and it takes a lot of time to debug a bug via 
> > >    that method.
> > 
> > Yep that is an issue.
> 
> I'd also like to add #4:
> 
>      4) One more thing that makes s2ram special is that when the 
>         resume path finds hardware often in an even more 
>         deinitialized form than during normal bootup. During
>         normal bootup the BIOS/firmware has at least done some
>         minimal bootstrap (to get the kernel loaded), which
>         makes life easier for the kernel.
> 
>         At s2ram stage we've got a completely pure hardware
>         init state, with very minimal firmware activation.

This is very true and at least in some cases done on purpose, AFAICS, due to
some timing constraints forced on HW vendors by M$, for example.

>         So many of the init and deinit problems and bugs we only 
>         hit in the s2ram path - which dynamics is again not 
>         helpful.

Plus ACPI requires us to do additional things during suspend-resume that
are not done on boot-shutdown and which have their own ordering requirements
(not necessarily stated directly, but such that we have do discover
experimentally).  That also change from one BIOS to another.

> > > The combination of these factors really makes up for a 
> > > perfect storm in terms of kernel technology: we have this 
> > > very-deceivingly-simple-looking but 
> > > complex-and-rarely-executed piece of code, which is very 
> > > hard to debug.
> > 
> > And much of this as you are finding with this piece of code is 
> > how the software was designed rather then how the software 
> > needed to be.
> 
> Well most of the 4 problems above are externalities and cannot 
> go away just by fixing the kernel.
> 
>  #1 will always be with us.
>  #3 needs the hardware to change. It's happening, but slowly.
>  #4 will be with us as long as there's non-Linux BIOSes
> 
> #2 is the only thing where we can make a realistic difference,
> but there's just so much we can do there.
> 
> And that still leaves the other three items: each of which is 
> powerful enough of a force to give a bad name to any normal 
> subsystem.

Agreed.

Thanks,
Rafael
