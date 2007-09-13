Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbXIMUBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbXIMUBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbXIMUBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:01:41 -0400
Received: from www.osadl.org ([213.239.205.134]:51815 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758801AbXIMUBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:01:40 -0400
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl>
	 <1188822917.3406.0.camel@chaos>
	 <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 22:01:35 +0200
Message-Id: <1189713695.3974.23.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-09-04 at 09:27 +0200, Pavel Machek wrote:
> > On Mon, 2007-09-03 at 12:19 +0200, Rafael J. Wysocki wrote:
> > > > Ok, so it gets weirder. I have now machine in "hung" state; other
> > > > consoles still work, but there are no timers -  sleep 1 hangs forever.
> > > > 
> > > > sysrq-t shows kstopmachine hung in hrtimer_try_to_cancel.
> > > > 
> > > > So I indeed suspect difference-in-kconfig to trigger this, and will
> > > > try disabling noidlehz.
> > > 
> > > I would unset CONFIG_HIGH_RES_TIMERS for starters.
> > > 
> > > Well, I guess Thomas should know about that. ;-)
> > 
> > What was the last known to work version ?
> 
> I'm afraid I only turned on HIGH_RES_TIMERS in 2.6.23-rc1
> timeframe... so I'm not sure if it ever worked for me.
> 
> I can confirm it is working in 2.6.23-rc5 with highres disabled, and
> broken with highres enabled. NOHZ turns "waits for keypress during
> unplug/replug" into "just plain hangs".

Ok, I can reproduce it and I tracked down what happens:

When the CPU goes offline, the clock event source for this CPU (lapic)
is removed from the clock events framework. This also clears the
information that the CPU is using C-States which stop the local APIC
timer.

Now you put the CPU online again and the local APIC timer is used, but
the C-State information is not evaluated again in ACPI. This means that
the clock events code does not know that the APIC might stop. In the
worst case this will happen and make the CPU wait for timer interrupts
forever.

The problem only appears when you are on battery (c3/c4 available) or on
those broken machines, where C2 is in reality C3 (e.g. akpm's VAIO)

I have an yet untested fix, which preserves the broadcast state across
the offline state, but Len is looking into it as well, whether we can
just reevaluate the power states (and the broadcast flags) when a cpu
becomes online again. If Len can do that easily for 2.6.23, I'd prefer
that.

	tglx


