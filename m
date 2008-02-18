Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYBROhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYBROhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYBROhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:37:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54162 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbYBROhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:37:36 -0500
Date: Mon, 18 Feb 2008 15:37:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
Message-ID: <20080218143757.GB1960@elf.ucw.cz>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm trying to use the "sleepy test" here, unfortunately it locks for
> > 10-or-so seconds.
> > 
> > Problem is in wait_event_timeout: timeouts take about 100x as long as
> > they should. Code in drivers/input/serio/libps2.c:
> > 
> > +       printk("ps2_command waiting event: %d\n", timeout);
> >         timeout = wait_event_timeout(ps2dev->wait,
> >                                      !(ps2dev->flags & PS2_FLAG_CMD1),timeout);
> > 
> >         if (ps2dev->cmdcnt && timeout > 0) {
> > +               printk("wait_event returned: %d\n", timeout);
> > 
> >                 timeout = ps2_adjust_timeout(ps2dev, command, timeout);
> > +
> > +               printk("ps2_command adjust timeout: %d\n", timeout);
> >                 wait_event_timeout(ps2dev->wait,
> >                                    !(ps2dev->flags & PS2_FLAG_CMD), timeout);
> >         }
> > 
> > +       printk("ps2_command receiving\n");
> > 
> > 
> > ...and I get hang after "ps2_command adjust timeout" for 10 seconds,
> > while it should  wait 10msec or so.
> 
> When is this code called ?

from serio_suspend. It is normal device, not a sysdev, AFAICT. 

> > nohz=off fixes that.
> > 
> > notsc fixes that, too... On my system (thinkpad x60 in UP mode) tsc is
> > normally marked unstable very shortly after boot, so only sleepy test
> > can trigger this.
> 
> I do not understand, what you mean. When exactly is "sleeppy test"
> running ?

from late_initcall().

> Also the TSC unstable detection is in a 500ms timeframe, so you should
> never get a 10s delay.

I'd not expect TSC instability detection to be ran while system is
suspending, plus "wrong for 500msec" is still wrong.

Plus TSC unstable detection is heuristic that can easily go wrong, right?

> > I believe fix is very simple:
> 
> NAK. 
> 
> This kills TSC on machines which have a working TSC and never go into
> suspend.

Apart from OLPC, which machines have working TSC?

Anything that has cpufreq does not.

Anything that enters C2 does not.

Anything that is SMP does not.

So, how many machines do you have with working TSC?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
