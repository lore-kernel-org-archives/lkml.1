Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbYIATIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbYIATIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYIATI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 15:08:28 -0400
Received: from www.tglx.de ([62.245.132.106]:33567 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYIATI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 15:08:27 -0400
Date: Mon, 1 Sep 2008 21:08:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809011136340.12958@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809012052420.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809011136340.12958@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Linus Torvalds wrote:
> On Mon, 1 Sep 2008, Larry Finger wrote:
> >
> > TSC calibrated against PIT
> > Detected 428.823 MHz processor.
> 
> Ok, Thomas, that means that the PIT is reliable (not surprising), and the 
> PM_TIMER isn't (again, I'm not horribly surprised). And HPET isn't 
> available, of course.
> 
> The old x86-32 code never even bothered with the PM_TIMER for calibration. 
> I don't understand why the x86-64 code bothers with it either. Why not 
> just drop that whole broken thing, and just depend on the PIT if there is 
> no HPET?

We had horrible results on some machines with the PIT especially in
the local APIC timer calibration code. One of my own laptops behaved
stupid until I verified the APIC timer versus the PM timer. Until
recently it also had occasional stupid TSC calibration values.

This was reported by others as well and is definitely caused by SMM
taking the CPU away and blocking the PIT interrupt.
 
> I would also like to point out that the 32-bit code actually had a much 
> nicer PIT setup, using the much better documented mach_prepare_counter() 
> and mach_countup() helper functions. I'm unhappy to note that the new 
> "common" code uses what appears to be the inferior code.
> 
> Also, note that this is _not_ a new issue. See "verify_pmtmr_rate()" in 
> drivers/clocksource/acpi_pm.c, along with all the code to check that the 
> reads are stable in "init_acpi_pm_clocksource()".

Yeah, I really forgot about this one.

> IOW, the PM_TIMER has been found to be broken before. Depending on it for 
> calibration is broken.

While on older machines, which might have pmtimer wreckage (I just
googled that some AMD K6 are known to have such issues), the SMM/SMI
wreckage is likely to be a non issue, while on modern systems the
SMM/SMI wreckage will bite us. So we have the choice between evil and
evil.

One way out would be to check on which CPU type we run and ignore the
pmtimer for older systems.

Thanks,

	tglx
