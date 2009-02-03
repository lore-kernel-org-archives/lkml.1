Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZBCVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZBCVyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZBCVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:54:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41474 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZBCVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:54:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Date: Tue, 3 Feb 2009 22:53:42 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902031114321.3247@localhost.localdomain> <1233695486.16867.95.camel@pasglop>
In-Reply-To: <1233695486.16867.95.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032253.42709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-02-03 at 11:19 -0800, Linus Torvalds wrote:
> > 
> > On Tue, 3 Feb 2009, Linus Torvalds wrote:
> > > 
> > > Hmm. The _normal_ simple irq handler does this the way I described, but 
> > > for some reason the "handle_edge_irq()" does not. And the reason is 
> > > actually a buglet: it needs to mask things for the "recursive interrupt" 
> > > case.
> > 
> > Btw, just to clarify: none of this happens at the actual "irq_disable()" 
> > time: it only happens if you get an interrupt _while_ it's disabled. Which 
> > obviously shouldn't happen in the shutdown/wakeup path anyway for MSI, 
> > since the interrupts aren't shared, but it would be good to just be extra 
> > safe.
> > 
> > I do suspect we could/should just get rid of the msi masking entirely, but 
> > that may be too scary a step.
> 
> I agree :-) It's been a source of problem anyway, I remember hearing
> some device reacting strangely (aka, losing MSIs) when masked, and it's
> not even implemented by all devices (somebody had the "smart" idea of
> making an optional feature). So it ends up being a lot of not very
> useful code...
> 
> > For the current suspend/resume situation, maybe it's enough to know that 
> > it shouldn't be happening anyway, and even if it _does_ happen on a device 
> > that has been shut down, it's just not going to do anything. Sure, it's 
> > doing that "writel/readl", but if it gets lost, who really cares? Nobody.
> 
> Note that I still believe that life would be simpler to just keep the
> current local_irq_save() and just tweak might_sleep() etc... so that
> ACPI is safe to call. At least it can be done orthogonally to this
> interrupt change.

That would change the ordering of ACPI method calls, which also is important
and prone to breaking, as I wrote in the original message.

> IE. As I said earlier, that interrupt masking -will- change the exposed
> semantics of suspend_late() to drivers. In fact, iirc, it's you who
> advertised initially suspend_late() as being the 'easy' way to write a
> PCI driver suspend routine specifically because you don't have to bother
> about being re-entered from anywhere for things like request processing
> etc... With the change, the kernel is essentially still operating,
> timers are ticking, we may even be scheduling, so this important
> assumption is gone. That means a lot more chances for driver to screw
> up.

Whatever we do, it will have drawbacks and the approach with moving
local_irq_disable() seems to be more straightforward to me.

Thanks,
Rafael
