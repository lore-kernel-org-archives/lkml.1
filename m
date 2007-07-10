Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbXGJLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbXGJLRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXGJLRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:17:11 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:43208 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXGJLRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:17:10 -0400
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 07:17:09 EDT
From: Gabriel Paubert <paubert@iram.es>
Date: Tue, 10 Jul 2007 12:52:12 +0200
To: Matt Sealey <matt@genesi-usa.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       mingo@elte.hu
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Message-ID: <20070710105212.GA14682@iram.es>
References: <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org> <464C9E67.2020909@ru.mvista.com> <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org> <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com> <464DADFC.3080802@ru.mvista.com> <464DB800.40702@genesi-usa.com> <1179499713.12981.75.camel@chaos> <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org> <464DD9DD.8030603@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464DD9DD.8030603@genesi-usa.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 05:52:45PM +0100, Matt Sealey wrote:
> Kumar Gala wrote:
> > 
> > On May 18, 2007, at 9:48 AM, Thomas Gleixner wrote:
> > 
> >> On Fri, 2007-05-18 at 15:28 +0100, Matt Sealey wrote:
> >>>
> >>> I think both the MPC52xx GPT0-7 and the SLT0-1 fulfil this fairly
> >>> easily.
> >>
> >> There is some basic work for MPC5200 available:
> >>
> >> http://www.pengutronix.de/oselas/bsp/phytec/index_en.html#phyCORE-MPC5200B-tiny
> >>
> > 
> > I asked this earlier, but figured you might have a better insight.  Is
> > their value in having 'drivers' for more than one clock source?  I'd say
> > most (of not all) the PPC SoCs have timers on the system side that we
> > could provide drivers for, I'm just not sure if that does anything for
> > anyone.
> 
> As I asked after, I'm also very intrigued as to what is going to end
> up using these timers, but likewise, not much use writing a driver if
> everyone can use the extremely high resolution decrementer all at
> once..
> 
> As I said before too, at least Intel has decided there is a great need
> for up to 256 high resolution timer sources on a system, but since this
> is a fairly new concept to Linux (and hrtimers and dynticks too) it
> only seems to be used in the case of i8254/RTC emulation, mostly on
> x86-64.
> 
> I'm looking at it now and finding "users" of hrtimers is looking very
> thin on the ground. Maybe it's justified on the basis that more is
> better, and having support is preferable to not having it (even if
> nobody really uses it) but it seems the entire gamut of timing
> possibility in Linux can be handled through a simple, and single,
> high resolution timer and a queue of events..
> 
> So do we need some more? :D
> 

I don't think so. I really wonder what other capabilities the
other clock sources bring, except more convoluted and complex
code in the end.

There may be one exception to it: scheduled wakeup with 
very deep sleep in which you can't even afford the power
dissipated by the processor in the modes in with the
timebase/decrementer keeps running (which is fairly low
to start with). But this would be a special wakeup path 
where timebase and decrementer are reinitialized and 
become again the main timer source.

Otherwise the decrementer can provide essentially arbitrary 
high resolution (i.e., comparable to the time of an external 
bus access) on a fairly large number of independent timers. 
This scales with the number of processors since there is one 
decrementer per core (is it per thread on SMT chips? 
I don't know).

<side note>
A few months ago, I implemented here for out internal needs
the equivalent of HRT (I called them FGT for fine-grained timers)
for our VME machines still running a 2.2 kernel. We have boards
who should have generated regular interrupts at programmable
rate interpreting GPS timestamp signals (IRIG B). Unfortunately
the signals were sometimes corrupt and the interrupts were no
more regularly spaced. Now the IRIGB signal is only used to feed
NTP which acts as a low pass filter with an extremely small
cut-off frequency (1mHz or less) and the regular interrupts
are generated from the decrementer in parallel with the standard
ticks. The code is not really polished and would not scale to
a large number of timers but it took me about one day and a half 
to write and debug it. I can even monitor it from a /proc file:

[root@vac1 /root]# cat /proc/fgtimer
     Calls       Lost Name
  60865181        158 System timer tick
  77889762          0 itFast (128Hz)

There are a few lost ticks for the main system timer because 
some operations mask interrupts for too long during early
boot, especially with root on NFS which is the case here,
they never happen after the root file system is mounted.

This is also a somewhat special 2.2 kernel, it essentially has
the timekeeping code I submitted for 2.4 and which is
still the core of PPC timekeeping.
</side note>

	Regards,
	Gabriel
