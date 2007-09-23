Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXIWKQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXIWKQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 06:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXIWKQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 06:16:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128AbXIWKQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 06:16:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Date: Sun, 23 Sep 2007 12:29:34 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <20070922220347.586903979@linutronix.de> <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231229.35747.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 September 2007 00:59, Linus Torvalds wrote:
> 
> On Sat, 22 Sep 2007, Thomas Gleixner wrote:
> > 
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
> 
> I realize that the answer is easily "because ACPI screwed up", but I'm 
> wondering if there's something we do to trigger that screw-up.
> 
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

I think that this is the case.

> Now, if this is the cause, then I think your patch should indeed fix it, 
> since you get called by the early-suspend code (which happens *before* the 
> "->prepare()" call), but at the same time, I wonder if maybe it would be 
> slightly "more correct" to instead of using the suspend/resume callbacks, 
> simply do this in the "acpi_pm_prepare()" stage, since that is likely the 
> thing that triggers it?
> 
> But hey, I think I'll apply the patches as-is. I'd just feel even better 
> if we actually understood *why* doing the CPU Cx states is not something 
> we can do around the suspend code!

Greetings,
Rafael
