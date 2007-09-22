Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbXIVXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbXIVXaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXIVXar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:30:47 -0400
Received: from www.osadl.org ([213.239.205.134]:52083 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbXIVXar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:30:47 -0400
Subject: Re: [patch 0/2] suspend/resume regression fixes
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
References: <20070922220347.586903979@linutronix.de>
	 <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 01:30:44 +0200
Message-Id: <1190503844.4035.136.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Sat, 2007-09-22 at 15:59 -0700, Linus Torvalds wrote:
> > My final enlightment was, when I removed the ACPI processor module,
> > which controls the lower idle C-states, right before resume; this
> > worked fine all the time even without all the workaround hacks.
> > 
> > I really hope that this two patches finally set an end to the "jinxed
> > VAIO heisenbug series", which started when we removed the periodic
> > tick with the clockevents/dyntick patches.
> 
> Ok, so the patches look fine, but I somehow have this slight feeling that 
> you gave up a bit too soon on the "*why* does this happen?" question.

Yeah, I gave up at the point where I was not longer able to dig
deeper :)

> I realize that the answer is easily "because ACPI screwed up", but I'm 
> wondering if there's something we do to trigger that screw-up.

Fair enough.

> In particular, I also suspect that this may not really fix the problem - 
> maybe it just makes the window sufficiently small that it no longer 
> triggers. Because we don't necessarily understand what the real background 
> for the problem is, I'm not sure we can say that it is solved.
> 
> The reason I say this is that I have a suspicion on what triggers it.
> 
> I suspect that the problem is that we do
> 
> 	pm_ops->prepare();
> 	disable_nonboot_cpus()
> 	suspend_enter();
> 	enable_nonboot_cpus()
> 	pm_finish()
> 
> and here the big thing to notice is that "pm_ops->prepare()" call, which 
> sets the wakup vector etc etc.
> 
> So maybe the real problem here is that once we've done the "->prepare()" 
> call and ACPI has set up various stuff, we MUST NOT do any calls to any 
> ACPI routines to set low-power states, because the stupid firmware isn't 
> expecting it.

That's what I suspect and deduced from the various experiments including
a force the cpu into a lower c-state one, which triggered the problem
fully reproducible. Note that in case of the "force a lower c-state" I
verified, that the PIT was activated to avoid the local apic stops in c3
issue. But I never got an PIT interrupt. Either the box was completely
stuck or I was able to recover by hitting a key, which is as well one of
the unexplained phenomenons.

> Now, if this is the cause, then I think your patch should indeed fix it, 
> since you get called by the early-suspend code (which happens *before* the 
> "->prepare()" call), but at the same time, I wonder if maybe it would be 
> slightly "more correct" to instead of using the suspend/resume callbacks, 
> simply do this in the "acpi_pm_prepare()" stage, since that is likely the 
> thing that triggers it?

Yeah, probably that's the correct point, but I leave this to the ACPI
wizards.

> But hey, I think I'll apply the patches as-is. I'd just feel even better 
> if we actually understood *why* doing the CPU Cx states is not something 
> we can do around the suspend code!

That needs some explanation of the folks who can actually look beyond
the ACPI/BIOS internals.

	tglx


