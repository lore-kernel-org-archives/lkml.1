Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXIVXBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXIVXBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXIVXBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:01:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbXIVXBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:01:22 -0400
Date: Sat, 22 Sep 2007 15:59:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
In-Reply-To: <20070922220347.586903979@linutronix.de>
Message-ID: <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
References: <20070922220347.586903979@linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Sep 2007, Thomas Gleixner wrote:
> 
> My final enlightment was, when I removed the ACPI processor module,
> which controls the lower idle C-states, right before resume; this
> worked fine all the time even without all the workaround hacks.
> 
> I really hope that this two patches finally set an end to the "jinxed
> VAIO heisenbug series", which started when we removed the periodic
> tick with the clockevents/dyntick patches.

Ok, so the patches look fine, but I somehow have this slight feeling that 
you gave up a bit too soon on the "*why* does this happen?" question.

I realize that the answer is easily "because ACPI screwed up", but I'm 
wondering if there's something we do to trigger that screw-up.

In particular, I also suspect that this may not really fix the problem - 
maybe it just makes the window sufficiently small that it no longer 
triggers. Because we don't necessarily understand what the real background 
for the problem is, I'm not sure we can say that it is solved.

The reason I say this is that I have a suspicion on what triggers it.

I suspect that the problem is that we do

	pm_ops->prepare();
	disable_nonboot_cpus()
	suspend_enter();
	enable_nonboot_cpus()
	pm_finish()

and here the big thing to notice is that "pm_ops->prepare()" call, which 
sets the wakup vector etc etc.

So maybe the real problem here is that once we've done the "->prepare()" 
call and ACPI has set up various stuff, we MUST NOT do any calls to any 
ACPI routines to set low-power states, because the stupid firmware isn't 
expecting it.

Now, if this is the cause, then I think your patch should indeed fix it, 
since you get called by the early-suspend code (which happens *before* the 
"->prepare()" call), but at the same time, I wonder if maybe it would be 
slightly "more correct" to instead of using the suspend/resume callbacks, 
simply do this in the "acpi_pm_prepare()" stage, since that is likely the 
thing that triggers it?

But hey, I think I'll apply the patches as-is. I'd just feel even better 
if we actually understood *why* doing the CPU Cx states is not something 
we can do around the suspend code!

		Linus
