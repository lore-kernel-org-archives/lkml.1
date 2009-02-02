Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZBBXXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZBBXXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZBBXXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:23:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZBBXXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:23:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Tue, 3 Feb 2009 00:22:38 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain> <1233615423.18767.129.camel@pasglop>
In-Reply-To: <1233615423.18767.129.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030022.39396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 14:15 -0800, Linus Torvalds wrote:
> > 
> > On Mon, 2 Feb 2009, Rafael J. Wysocki wrote:
> > > 
> > > I think it would be easier to make ACPI allow us to run AML with interrupts
> > > off.
> > 
> > Well, I'd agree, except I have this strong memory of us having known bugs 
> > with ACPI turning hard-interrupts on again. Similarly, it uses mutexes etc 
> > that simply don't work with interrupts off and/or may turn them on again 
> > thanks to scheduling.
> > 
> > "Fixing" that seems not very easy. ACPI has a bad habit of being _really_ 
> > hard to fix in this area.
> > 
> > I do agree that _if_ we can just fix ACPI, we wouldn't have these issues, 
> > and we should  just call it with interrupts disabled with our existing 
> > code. But my previous email was a "maybe we can do it like this" kind of 
> > thing, which might allow us to use ACPI with none of the irq-off issues.
> 
> Len, what's your take here ? How much of that stuff is burried deep and
> how much is nicely split in a "helper" layer we could more easily fix ?
> 
> I'm adding Ingo to the CC as he might have more ideas on how best to
> just make the mutexes work & not complain rather than touching ACPI
> itself... again, just like boot, might just be a matter of instructing
> the mutexes/lockdep to shut up and ignore in_atomic() in those "special"
> phases such as late suspend and early resume().
> 
> That would help me for something else that broke recently too ... I have
> a special "hook" in radeonfb that my arch calls to resume it -very-
> early (interrupts off, I haven't even re-enabled the L2 cache). This is
> very useful to help debugging problems at resume since without that you
> basically don't see a thing and we have no serial port on most of these
> machines.
> 
> However, that started breaking recently due to fb_set_suspend() calling
> into various bits of infrastructure that is no longer safe to call in
> atomic context.
> 
> Here too, in fact, those -would- be safe since it's mostly a matter of
> teaching things like mutex of kmalloc that we are not in standard
> SYSTEM_RUNNING state, and thus mutex can just pretty much ignore the
> problem of being in atomic state and kmalloc/gfp could automatically
> degrade to GFP_ATOMIC (*)
> 
> So it might just all be a matter of making might_sleep() shut up in
> late suspend/early resume, and possibly msleep() silently turn into
> mdelay or something like that. Just make sure we don't actually try to
> schedule (and possibly BUG_ON if we actually end up blocking on a mutex,
> we should not).
> 
> Len, do you think that would work with ACPI or it's more convoluted than
> that ?
> 
> (*) There are reasons to think that kmalloc/gfp should both silently
> turn into GFP_NOIO always while the suspend process is started, but
> that's somewhat a different subject. Rafael, did we ever act on that ?
> It's an old discussion we had but I don't know if we actually
> implemented anything.

We have the ->prepare(), ->complete() callbacks that, among other things,
can be used for allocating and freeing memory with GFP_KERNEL safely.

> IE. Without that, afaik, a driver that hasn't suspend yet might end up
> being blocked in some allocation somewhere due to an attempt to page
> things out on to an already sleeping device. That driver might be in
> such blockage while holding one of its internal mutexes or other thing
> that will cause it's own suspend routine later on to screw up. etc etc
> etc...

Yes, that's possible in theory, never observed in practice from what I can
tell.

> In general, best to avoid having to teach drivers that in suspend-land,
> non-atomic, allocations may block for ever. Better to make them all atomic
> magically.

Hm, atomic allocations may cause other problems to happen (ie. fail easily).

Thanks,
Rafael
