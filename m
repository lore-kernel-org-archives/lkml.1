Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYBRPNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYBRPNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYBRPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:13:06 -0500
Received: from www.tglx.de ([62.245.132.106]:57535 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYBRPND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:13:03 -0500
Date: Mon, 18 Feb 2008 16:12:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
In-Reply-To: <20080218143757.GB1960@elf.ucw.cz>
Message-ID: <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Pavel Machek wrote:
> > > ...and I get hang after "ps2_command adjust timeout" for 10 seconds,
> > > while it should  wait 10msec or so.
> > 
> > When is this code called ?
> 
> from serio_suspend. It is normal device, not a sysdev, AFAICT. 
> 
> > > nohz=off fixes that.
> > > 
> > > notsc fixes that, too... On my system (thinkpad x60 in UP mode) tsc is
> > > normally marked unstable very shortly after boot, so only sleepy test
> > > can trigger this.
> > 
> > I do not understand, what you mean. When exactly is "sleeppy test"
> > running ?
> 
> from late_initcall().

Has the system already switched to highres/nohz mode at this point ?

> > Also the TSC unstable detection is in a 500ms timeframe, so you should
> > never get a 10s delay.
> 
> I'd not expect TSC instability detection to be ran while system is
> suspending

There is nothing which switches it off, except right at the point
where the machine is shutdown. It's definitely active during the
freeze period.

> , plus "wrong for 500msec" is still wrong.

To be wrong for 500ms, the TSC must freeze completely.

> Plus TSC unstable detection is heuristic that can easily go wrong, right?

It should detect it, but I have to check, why it does not work in that
particular case.

> > > I believe fix is very simple:
> > 
> > NAK. 
> > 
> > This kills TSC on machines which have a working TSC and never go into
> > suspend.
> 
> Apart from OLPC, which machines have working TSC?
> 
> Anything that has cpufreq does not.

Wrong. Newer CPUs have TSCs which are not affected by cpu frequency.
 
> Anything that enters C2 does not.

Wrong. C3 stops the TSC everywhere. C2 should not, but it does
unfortunately due to stupid BIOS implementations and on a lot of AMD
CPUs.

> Anything that is SMP does not.

Wrong. I'm writing this mail from a SMP machine with perfectly
sychronized TSCs.

> So, how many machines do you have with working TSC?

At least 5.

One sensible solution would be to force TSC unstable before we
suspend, but I'd like to know why that 10sec delay happens at all.

Can you please provide a dmesg log ?

Thanks,

	tglx
