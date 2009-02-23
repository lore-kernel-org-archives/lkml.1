Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZBWWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZBWWAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZBWWA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:00:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZBWWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:00:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 22:59:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902231545.26250.rjw@sisk.pl> <20090223150647.GE3377@elte.hu>
In-Reply-To: <20090223150647.GE3377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232259.56391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Monday 23 February 2009, Ingo Molnar wrote:
> > > 
> > > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > 
> > > > > What makes s2ram fragile is not human failure but the 
> > > > > combination of a handful of physical property:
> > > > >
> > > > > 1) Psychology: shutting the lid or pushing the suspend button is 
> > > > >    a deceivingly 'simple' action to the user. But under the 
> > > > >    hood, a ton of stuff happens: we deinitialize a lot of 
> > > > >    things, we go through _all hardware state_, and we do so in a 
> > > > >    serial fashion. If just one piece fails to do the right 
> > > > >    thing, the box might not resume. Still, the user expects this 
> > > > >    'simple' thing to just work, all the time. No excuses 
> > > > >    accepted.
> > > > >
> > > > > 2) Length of code: To get a successful s2ram sequence the kernel
> > > > >    runs through tens of thousands of lines of code. Code which
> > > > >    never gets executed on a normal box - only if we s2ram. If 
> > > > >    just one step fails, we get a hung box.
> > > > >
> > > > > 3) Debuggability: a lot of s2ram code runs with the console off, 
> > > > >    making any bugs hard to debug. Furthermore we have no 
> > > > >    meaningful persistent storage either for kernel bug messages. 
> > > > >    The RTC trick of PM_DEBUG works but is a very narrow channel 
> > > > >    of information and it takes a lot of time to debug a bug via 
> > > > >    that method.
> > > > 
> > > > Yep that is an issue.
> > > 
> > > I'd also like to add #4:
> > > 
> > >      4) One more thing that makes s2ram special is that when the 
> > >         resume path finds hardware often in an even more 
> > >         deinitialized form than during normal bootup. During
> > >         normal bootup the BIOS/firmware has at least done some
> > >         minimal bootstrap (to get the kernel loaded), which
> > >         makes life easier for the kernel.
> > > 
> > >         At s2ram stage we've got a completely pure hardware
> > >         init state, with very minimal firmware activation.
> > 
> > This is very true and at least in some cases done on purpose, 
> > AFAICS, due to some timing constraints forced on HW vendors by 
> > M$, for example.
> 
> IMHO i think it's the technically sane thing to do. Personally i 
> trust the quirks of bare metal much more than the combined 
> quirks of firmware _and_ bare metal.
> 
> > >         So many of the init and deinit problems and bugs we 
> > >         only hit in the s2ram path - which dynamics is again 
> > >         not helpful.
> > 
> > Plus ACPI requires us to do additional things during 
> > suspend-resume that are not done on boot-shutdown and which 
> > have their own ordering requirements (not necessarily stated 
> > directly, but such that we have do discover experimentally).  
> > That also change from one BIOS to another.
> 
> We could perhaps do a few things here to trigger bugs sooner.
> 
> For example at driver init, instead of executing just 
> ->driver_open(), we could execute:
> 
>    ->driver_open()
>    ->driver_suspend()
>    ->driver_resume()

I'm not sure.  On PCI we run some code apart from the driver's suspend and
resume callbacks, especially in the new framework, and the bus type executes
the driver callbacks.

> I.e. we'd simulate a suspend+resume mini-step. This makes it 
> sure that the basic driver callbacks are sane. It is also 
> supposed to work because the driver is just being initialized. 
>
> This way certain types of bugs would not show up as difficult to 
> debug s2ram regressions - but would show up as 'boot hang' or 
> 'boot crash' bugs.

There is a testing facility exactly for this (/sys/power/pm_test) that allows
you to simulate the entire suspend sequence without suspending as well as some
separate pieces of it.  Still, it doesn't work very well, because the
conditions in which the resume callbacks are being run differ substantially
from the conditions right after we get control from the BIOS.

For one example, if ->suspend() puts the device into D3, then your simulated
->resume() will get the device in D3, while the BIOS would probably put it into
D0 (at least as far as PCI devices are concerned).

> This does not simulate the "big picture" resume machinery (the 
> dependencies, etc.), nor does it trigger any of the "hardware 
> got really turned off" effects that true resume will trigger - 
> but at least it offloads a portion of the testing space from 
> 's2ram' to 'bootup' testing.
> 
> What's your feeling - what percentage of all s2ram regressions 
> in the last year or so could have been triggered this way? Lets 
> assume we had 100 regressions in that timeframe - would it be in 
> the 10 bugs range? Or much lower or much higher?

Very small number of actual bugs with rather a lot of false positives.

IMO there are three basic sources of recent suspend regressions:
1) Arch-dependent changes (x86 mostly) and low-level changes affecting suspend
   (like PCI bus enumeration, IOMMU etc.), where people didn't realize their
   modifications would have a broader effect.
2) PM core changes where we weren't sure what was the best way to go (probably
   I'm to blame for the majority of these).
3) Changes related to graphics (this has always been difficult, but is getting
   much better now).

Driver regressions, other than the graphics-related, are really a very small
fraction.

Well, there still are some known problems unsolved, but that's a different
matter.

Thanks,
Rafael
