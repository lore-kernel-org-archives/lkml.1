Return-Path: <linux-kernel-owner+w=401wt.eu-S932747AbZLOVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbZLOVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761107AbZLOVZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:25:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760882AbZLOVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:25:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Tue, 15 Dec 2009 22:26:22 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912151444010.2643-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912151444010.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912152226.22578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009, Alan Stern wrote:
> On Tue, 15 Dec 2009, Linus Torvalds wrote:
> 
> > It's a very subtle theory, and it's not necessarily always 100% true. For 
> > example, a cardbus bridge is strictly speaking very much a PCI bridge, but 
> > for cardbus bridges we _do_ have a suspend/resume function.
> > 
> > And perhaps worse than that, cardbus bridges are one of the canonical 
> > examples where two different PCI devices actually share registers. It's 
> > quite common that some of the control registers are shared across the two 
> > subfunctions of a two-slot cardbus controller (and we generally don't even 
> > have full docs for them!)
> 
> Okay.  This obviously implies that if/when cardbus bridges are
> converted to async suspend/resume, the driver should make sure that the
> lower-numbered devices wait for their sibling higher-numbered devices
> to suspend (and vice versa for resume).  Awkward though it may be.
> 
> > > The same goes for devices that don't have suspend or resume methods.
> > 
> > Yes and no. 
> > 
> > Again, the "async_suspend" flag is done at the generic device layer, but 
> > 99% of all suspend/resume methods are _not_ done at that level: they are 
> > bus-specific functions, where the bus has a generic suspend-resume 
> > function that it exposes to the generic device layer, and that knows about 
> > the bus-specific rules.
> > 
> > So if you are a PCI device (to take just that example - but it's true of 
> > just about all other buses too), and you don't have any suspend or resume 
> > methods, it's actually impossible to see that fact from the generic device 
> > layer.
> 
> Sure.  That's why the async_suspend flag is set at the bus/driver 
> level.
> 
> > And even when you know it's PCI, our rules are actually not simple at all. 
> > Our rules for PCI devices (and this strictly speaking is true for bridges 
> > too) are rather complex:
> > 
> >  - do we have _any_ legacy PM support (ie the "direct" driver 
> >    suspend/resume functions in the driver ops, rather than having a 
> >    "struct dev_pm_ops" pointer)? If so, call "->suspend()"
> > 
> >  - If not - do we have that "dev_pm_ops" thing? If so, call it.
> > 
> >  - If not - just disable the device entirely _UNLESS_ you're a PCI bridge.
> > 
> > Notice? The way things are set up, if you have no suspend routine, you'll 
> > not get suspended, but you will get disabled. 
> > 
> > So it's _not_ actually safe to asynchronously suspend a PCI device if that 
> > device has no driver or no suspend routines - because even in the absense 
> > of a driver and suspend routines, we'll still least disable it. And if 
> > there is some subtle dependency on that device that isn't obvious (say, it 
> > might be used indirectly for some ACPI thing), then that async suspend is 
> > the wrong thing to do.
> > 
> > Subtle? Hell yes.
> 
> I don't disagree.  However the subtlety lies mainly in the matter of
> non-obvious dependencies.  (The other stuff is all known to the PCI
> core.)  AFAICS there's otherwise little difference between an async
> routine that does nothing and one that disables the device -- both
> operations are very fast.
> 
> The ACPI relations are definitely something to worry about.  It would
> be a good idea, at an early stage, to add those dependencies
> explicitly.  I don't know enough about them to say more; perhaps Rafael 
> does.

It boils down to the fact that for each PCI device known to the ACPI BIOS
there is a "shadow" ACPI device that generally has its own suspend/resume
callbacks and these "shadow" devices are members of the ACPI subtree
of the device tree (ie. they have parents and so on).

Now, when I worked on the first version of async suspend/resume, I noticed
that if those "shadow" ACPI devices did not wait for their PCI counterparts to
suspend, things broke badly.  The reason probably wasn't related to what they
did in their suspend/resume callbacks, because they are usually empty, but it
was rather related to the dependencies between devices in the ACPI subtree
(so, generally speaking, it seems the entire ACPI subtree of the device tree
should be suspended after the entire PCI subtree).

That obviously requires more investigation, though.

> As for other non-obvious dependencies...  Who knows?  Probably the only
> way to find them is by experimentation.  My guess is that they will
> turn out to be connected mostly with "high-level" devices: system
> devices, things on the motherboard -- generally speaking, stuff close
> to the CPU.  Relatively few will be associated with devices below the 
> level of a PCI device or equivalent.
> 
> Ideally we would figure out how to do the slow devices in parallel
> without interference from fast devices having unknown dependencies.  
> Unfortunately this may not be possible.

I really expect to see those "unknown dependencies" in the _noirq
suspend/resume phases and above.  [The very fact they exist is worrisome,
because that's why we don't know why things work on one system and don't
work on another, although they appear to be very similar.]

> > So the whole thing about "we can do PCI bridges asynchronously because 
> > they are obviously no-op" is kind of true - except for the "obviously" 
> > part. It's not obvious at all. It's rather subtle.
> > 
> > As an example of this kind of subtlety - iirc PCIE bridges used to have 
> > suspend and resume bugs when we initially switched over to the "new world" 
> > suspend/resume exactly because they actually did things at "suspend" time 
> > (rather than suspend_late), and that broke devices behind them (this was 
> > not related to async, of course, but the point is that even when you look 
> > like a PCI bridge, you might be doing odd things).

Well, those "pcieport devices" still are the children of PCIe ports, although
physically they just correspond to different sets of registers within the
ports' config spaces (_that_ is overdesigned IMnsHO) and they are "suspended"
during the regular suspend of their PCIe port "parents".

> > So just saying "let's do it asynchronously" is _not_ always guaranteed to 
> > be the right thing at all. It's _probably_ safe for at least regular PCI 
> > bridges. Cardbus bridges? Probably not, but since most modern laptop have 
> > just a single slot - and people who have multiple slots seldom use them 
> > all - most people will probably never see the problems that it _could_ 
> > introduce.
> > 
> > And PCIE bridges? Should be safe these days, but it wasn't quite as 
> > obvious, because a PCIE bridge actually has a driver unlike a regular 
> > plain PCI-PCI bridge.
> > 
> > Subtle, subtle.
> 
> Indeed.  Perhaps you were too hasty in suggesting that PCI bridges 
> should be async.
> 
> It would help a lot to see some device lists for typical machines.  (If 
> there are such things.)  Otherwise we are just blowing gas.
> 
> > > There remains a separate question: Should async devices also be forced
> > > to wait for their children?  I don't see why not.  For PCI bridges it
> > > won't make any significant difference.  As long as the async code
> > > doesn't have to do anything, who cares when it runs?
> > 
> > That's why I just set the "async_resume = 1" thing.
> > 
> > But there might actually be reasons why we care. Like the fact that we 
> > actually throttle the amount of parallel work we do in async_schedule(). 
> > So doing even a "no-op" asynchronously isn't actually a no-op: while it is 
> > pending (and those things can be pending for a long time, since they have 
> > to wait for those slow devices underneath them), it can cause _other_ 
> > async work - that isn't necessarily a no-op at all - to be then done 
> > synchronously.
> > 
> > Now, admittedly our async throttling limits are high enough that the above 
> > kind of detail will probably never ever realy matter (default 256 worker 
> > threads etc). But it's an example of how practice is different from theory 
> > - in _theory_ it doesn't make any difference if you wait for something 
> > asynchronously, but in practice it could make a difference under some 
> > circumstances.
> 
> We certainly shouldn't be worried about side effects of async 
> throttling as this stage.  KISS works both ways: Don't overdesign, and 
> don't worry about things that might crop up when you expand the design.
> 
> We have strayed off the point of your original objection: not providing
> a way for devices to skip waiting for their children.  This really is a
> separate issue from deciding whether or not to go async.  For example,
> your proposed patch makes PCI bridges async but doesn't allow them to
> avoid waiting for children.  IMO that's a good thing.
> 
> The real issue is "blockage": synchronous devices preventing 
> possible concurrency among async devices.  That's what you thought 
> making PCI bridges async would help.
> 
> In general, blockage arises in suspend when you have an async child
> with a synchronous parent.  The parent has to wait for the child, which
> might take a long time, thereby delaying other unrelated devices.

Exactly, but the Linus' point seems to be that's going to be rare and we
should be able to special case all of the interesting cases.

> (This explains why you wanted to make PCI bridges async -- they are the
> parents of USB controllers.)  For resume it's the opposite: an async
> parent with synchronous children.

Is that really going to happen in practice?  I mean, what would be the point?

> Thus, while making PCI bridges async might make suspend faster, it probably
> won't help much with resume speed.  You'd have to make the children of USB
> devices (SCSI hosts, TTYs, and so on) async.  Depending on the order of
> device registration, of course.
> 
> Apart from all this, there's a glaring hole in the discussion so far.  
> You and Arjan may not have noticed it, but those of us still using
> rotating media have to put up with disk resume times that are a factor
> of 100 (!) larger than USB resume times.  That's where the greatest
> gains are to be found.

I guess so.

Rafael
