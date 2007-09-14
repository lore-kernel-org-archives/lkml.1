Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXINMh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXINMh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXINMhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:37:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59768 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXINMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:37:20 -0400
Date: Fri, 14 Sep 2007 14:38:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070914123816.GE1671@elf.ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com> <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl> <1188822917.3406.0.camel@chaos> <20070904072744.GA30474@atrey.karlin.mff.cuni.cz> <1189713695.3974.23.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189713695.3974.23.camel@chaos>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > What was the last known to work version ?
> > 
> > I'm afraid I only turned on HIGH_RES_TIMERS in 2.6.23-rc1
> > timeframe... so I'm not sure if it ever worked for me.
> > 
> > I can confirm it is working in 2.6.23-rc5 with highres disabled, and
> > broken with highres enabled. NOHZ turns "waits for keypress during
> > unplug/replug" into "just plain hangs".
> 
> Ok, I can reproduce it and I tracked down what happens:
> 
> When the CPU goes offline, the clock event source for this CPU (lapic)
> is removed from the clock events framework. This also clears the
> information that the CPU is using C-States which stop the local APIC
> timer.
> 
> Now you put the CPU online again and the local APIC timer is used, but
> the C-State information is not evaluated again in ACPI. This means that
> the clock events code does not know that the APIC might stop. In the
> worst case this will happen and make the CPU wait for timer interrupts
> forever.
> 
> The problem only appears when you are on battery (c3/c4 available) or on
> those broken machines, where C2 is in reality C3 (e.g. akpm's VAIO)
> 
> I have an yet untested fix, which preserves the broadcast state across
> the offline state, but Len is looking into it as well, whether we can
> just reevaluate the power states (and the broadcast flags) when a cpu
> becomes online again. If Len can do that easily for 2.6.23, I'd prefer
> that.

Is there a patch you want me to test? Or does Len have anything to
play with?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
