Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYGDOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYGDOgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYGDOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:36:29 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50042 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbYGDOg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:36:28 -0400
X-BigFish: VPS-34(z297cpz1432R98dR7efV1805M1442J3117Kzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3HKJE-01-0FC-01
Date: Fri, 4 Jul 2008 16:35:36 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Len Brown <lenb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Message-ID: <20080704143536.GA21102@alberich.amd.com>
References: <20080610171639.551369443@linutronix.de> <alpine.LFD.1.10.0806181834110.3074@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806181834110.3074@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Jul 2008 14:35:38.0647 (UTC) FILETIME=[3A5BD270:01C8DDE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 06:47:49PM -0400, Len Brown wrote:
> On Thu, 12 Jun 2008, Thomas Gleixner wrote:
> 
> > AMD CPUs with C1E support are currently excluded from high resolution
> > timers and NOHZ support. The reason is that C1E is a BIOS controlled
> > C3 power state which switches off TSC and the local APIC timer. The
> > ACPI C-State control manages the TSC/local APIC timer wreckage, but
> > this does not include the C1 based ("halt" instruction) C1E mode. The
> > BIOS/SMM controlled C1E state works on most systems even without
> > enabling ACPI C-State control.
> 
> What a mess.
> 
> What is the measured power savings that justifies this effort?

IMHO the power savings are not that important when such a kernel runs
on bare metal:

(In the following C1E denotes "AMD-C1E" of course ;-)

- From what I've seen in some basic tests, power usage was not that
  different between C1E+NOHZ and C1E+250Hz. (I've done tests on a
  Turion X2 (RevF) Laptop, a desktop with Phenom (RevB3), and some
  Turion X2 Ultra (family 0x11) prototype.)

- Just the desktop showed 2-4 Watt larger power usage with C1E+250Hz
  in comparison to C1E+NOHZ.

- The Turion X2 (Ultra) systems showed almost no differences. Just
  when running with C1E+1000Hz the ACPI power usage estimate reported
  by powertop was slightly increased (by <1 Watt). (No differences
  shown on external power meter and removed battery.)

In conclusion, I think the big benefit from that code is not improved
power savings for laptop users but that it allows highres timers and
dynticks for CPUs with C1E.

E.g. this helps a lot with virtualization -- where dynticks is
preferred for the host system.
And if you have lots of guests the number of timer interrupts can
significantly be reduced for the entire system when all guests and the
host use dynticks.

Some further (random) observations/notes from my tests:

- Using C1E (NOHZ or with periodic timer) was usually better than
  running w/o C1E on those machines. (Ok, I didn't expect anything
  else.)

- It did not matter which timer interrupt source was used (PIT or
  HPET) in NOHZ/one-shot mode.

  + One-shot programming of HPET in comparison to PIT was faster (on
    average) by a factor of 2.7 with the chipsets that I've used.

  + Of course using PIT in NOHZ mode resulted in sligtly more
    interrupts as the 16-bit counter overflows at least every 0.055
    seconds - and Linux even uses a maximum delta of about 27ms.

  But overall no measurable difference in power usage was seen.

- "wakeups from idle" as reported by powertop are somehow inaccurate
  (from my point of view). They are calculated as "number of
  interrupts"/"number of online CPUs". Thus powertop shows about 125
  wakeups with 250 HZ on any dual core system or about 250 wakeups
  with 1000Hz on a quad-core system.  But I had no time to look
  further into this.

- Doing battery tests where you fully charge the battery and then
  deeply discharge it are harmful, it will/might decrease full
  capacity of your lithium battery and most probably decrease its
  lifetime. ;-(

> While I'm okay with platform specific idle states,
> I'm not okay with the use of therm C1E here.

Valid point.
I try to address this with some patch.


Regards,

Andreas


