Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYGYJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYGYJEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbYGYJD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:03:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54820 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbYGYJD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:03:58 -0400
Date: Fri, 25 Jul 2008 11:04:38 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080725110438.463d0f04@halley.suse.de>
In-Reply-To: <20080725085206.GA6669@boogie.lpds.sztaki.hu>
References: <20080428092513.495378af.akpm@linux-foundation.org>
	<20080429175419.6c8a0ebf@strauss.suse.de>
	<20080430133824.GC18711@boogie.lpds.sztaki.hu>
	<20080430165131.7426d5d3@strauss.suse.de>
	<20080507114343.GB5583@boogie.lpds.sztaki.hu>
	<20080507144520.17e9902a@strauss.suse.de>
	<20080507134223.GB4278@boogie.lpds.sztaki.hu>
	<20080512142146.2a32793c@kopernikus.site>
	<20080513143917.GC17309@boogie.lpds.sztaki.hu>
	<20080615171140.GG22313@boogie.lpds.sztaki.hu>
	<20080725085206.GA6669@boogie.lpds.sztaki.hu>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gabor Gombas [2008-07-25 10:52]:
>
> On Sun, Jun 15, 2008 at 07:11:41PM +0200, Gabor Gombas wrote:
> > On Tue, May 13, 2008 at 04:39:29PM +0200, Gabor Gombas wrote:
> > > On Mon, May 12, 2008 at 02:21:46PM +0200, Bernhard Walle wrote:
> > > 
> > > > Well, can you try if that really not happens without
> > > > CONFIG_HPET_EMULATE_RTC? The question is if that 64 interrupts per second really
> > > > cause a machine hang ...
> > > 
> > > I'll try when I have a little time...
> > 
> > Ok, it took much more time than I'd have liked, but now I'm having:
> > 
> > $ uname -a
> > Linux boogie 2.6.25 #3 SMP Thu Jun 12 13:32:35 CEST 2008 x86_64 GNU/Linux
> > $ grep EMULATE_RTC /boot/config-2.6.25
> > # CONFIG_HPET_EMULATE_RTC is not set
> > $ uptime
> >  19:07:17 up 3 days,  4:07, 12 users,  load average: 0.14, 0.31, 0.20
> > 
> > So I'd say it works.
> 
> FYI, the bug is still present in 2.6.26. I also got the same hang on a
> Dell PowerEdge 850 using a Debian-provided kernel (based on 2.6.25.6);
> that is the 3rd distinct HW configuration that hangs.

Did you try that patch?

-------------- 8< ---------------------------------------------------
From: David Brownell <dbrownell@users.sourceforge.net>

Resolve http://bugzilla.kernel.org/show_bug.cgi?id=11051 and other bugs
related to the way the HPET glue code in rtc-cmos was incomplete and
inconsistent:

 * Switch the approach so that the basic driver code flow isn't
   changed by having HPET ... instead, just have HPET shadow the
   RTC_CONTROL irq enables and RTC_FREQ_SELECT data.  It's only
   coping with IRQ thievery, after all.

 * Do that consistently (!!) to avoid problems when the HPET code
   is out of sync with the real RTC intent.  Examples include:

   - cmos_procfs(), which now reports correct data

   - cmos_irq_set_state() ... also removing the previous PIE_{ON,OFF}
     ioctl support so only one code path manages "periodic" IRQs

   - cmos_do_shutdown() ... currently a "just in case" change.

   - cmos_suspend() and cmos_resume() ... also handling a bug that
     was specific to HPET's IRQ thievery, where the alarm wasn't
     disabled after waking the system

 * Always call that HPET code under the RTC spinlock (it doesn't do
   its own locking)
-------------- >8 ---------------------------------------------------


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
