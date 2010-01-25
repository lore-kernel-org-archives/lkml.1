Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334Ab0AYRhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0AYRhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084Ab0AYRhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:37:07 -0500
Received: from smtp106.rog.mail.re2.yahoo.com ([68.142.225.204]:47813 "HELO
	smtp106.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753504Ab0AYRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:37:06 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 12:37:05 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=glu1A8vooavgWSS4K7HmKCZRSW3DO+vwVlr+pp5mMnnB4nQl2aqiFkwR4DgmbLsIxgIeSDsCfF3Bz/JIN38nG7AwvDDVtSGkaVmoGs/ax2IVLgu8bslmoeMQ1qgnbvClSA5fv3z5hiDqz5Le0CPRlm5B6lzB8eFN26WdXVHm/Os=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: ifCDsIoVM1lcRBYyAyThUnTesU4nfdxLrquRSu2_MIxIG5HwnuBUKpC6TRmwFusOaw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #14859] System timer firing too much without cause
Date: Mon, 25 Jan 2010 12:30:22 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc5-custom-radeon; KDE/4.4.60; x86_64; svn-1073382; 2010-01-11)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jerome Glisse" <jglisse@redhat.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001251153.59084.shawn.starr@rogers.com> <alpine.LFD.2.00.1001251808480.5926@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001251808480.5926@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001251230.23109.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010 12:20:38 Thomas Gleixner wrote:
> On Mon, 25 Jan 2010, Shawn Starr wrote:
> > On Monday 25 January 2010 05:35:50 Thomas Gleixner wrote:
> > > Shawn, why can't you use dynamic ticks ? In the bugzilla I just see
> > > that you worry about the IRQ0 interrupts (which are correct and
> > > necessary when the system is in nohz mode) and the extra rescheduling
> > > interrupts. How is the system misbehaving ?
> > 
> > Well, this all stems from trying to use Radeon KMS with IRQs
> > on. Doing so I see system stalls and this is quite noticeable
> > however, I am able to show this same stall on the quad core with the
> 
> x> same GPU.  Right now, it is unclear to me if there is a underlying
> 
> > irq issue or a bug in the radeon driver code that is showing these
> > stalls. Since the radeon folks - at the moment - do not think it is
> > a coding problem in their driver
> 
> Does the stall go away, when you disable dynticks ?
> 

It does not, no. 

> > My impression was using dynamic ticks meant ticks were on demand and
> 
> Dynamic ticks are providing a continuous tick long as the machine is
> busy. When a core becomes idle, we programm the timer to go off at the
> next scheduled timer event, if the event is longer away than the next
> tick. When the core goes out of idle (due to the timer or some other
> event) we restart the tick.
> 
> So you see less timer interrupts (IRQ0 + Local timer interrupts)

With dynamic ticks on or off, LOC increments rapidly, but I assume that is 
normal behavour.

So if none of this really is a kernel issue, I defer it to the radeon folks to 
comment further.

Please remove from regression list, I'll close the original bug.

> 
> > not continuous. On the quad core box, with dynamic ticks on, the
> > broadcasts are not increasing IRQ 0 events this only happens on the
> > laptop.
> 
> Right, that is expected as I explained already. Your desktop does not
> use deeper power states. Check /proc/acpi/processor/CPU0/power on both
> machines to see the difference. You _cannot_ compare a desktop and a
> laptop machine and deduce a regression.
> 
> The broadcast mechanism is necessary because the local APIC timer
> stops in deeper power states. That's a hardware problem. So if the
> core goes into a deeper power state then we arm the broadcast timer
> which fires on IRQ0 to wake us up. It is a single timer which is used
> by all cores in a system to work around this hardware stupidity. It's
> named broadcast because it broadcasts the event to the other cores
> when necessary. Your desktop does not use deeper power states,
> therefor it does not use the broadcast timer either.
> 
> So the timer IRQ0 increasing is neither a Linux BUG nor a regression.
> 
> Thanks,
> 
> 	tglx
