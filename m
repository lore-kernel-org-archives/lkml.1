Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbZLOQ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbZLOQ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760553AbZLOQ3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:29:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496AbZLOQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:29:15 -0500
Date: Tue, 15 Dec 2009 08:28:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <Pine.LNX.4.44L0.0912151047410.3566-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912150803250.14385@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912151047410.3566-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Dec 2009, Alan Stern wrote:
> 
> It doesn't feel like an ugly hack to me.  It seems like exactly the 
> Right Thing To Do: Make as many devices as possible use async 
> suspend/resume.

The reason it's a ugly hack is that it's actually not a simple decision to 
make. The devil is in the details:

> The only reason we don't make every device async is because we don't
> know whether it's safe.  In the case of PCI bridges we _do_ know --
> because they don't have any work to do outside of
> late_suspend/early_resume -- and so they _should_ be async.

That's the theory, yes. And it was worth the comment to spell out that 
theory. But..

It's a very subtle theory, and it's not necessarily always 100% true. For 
example, a cardbus bridge is strictly speaking very much a PCI bridge, but 
for cardbus bridges we _do_ have a suspend/resume function.

And perhaps worse than that, cardbus bridges are one of the canonical 
examples where two different PCI devices actually share registers. It's 
quite common that some of the control registers are shared across the two 
subfunctions of a two-slot cardbus controller (and we generally don't even 
have full docs for them!)

> The same goes for devices that don't have suspend or resume methods.

Yes and no. 

Again, the "async_suspend" flag is done at the generic device layer, but 
99% of all suspend/resume methods are _not_ done at that level: they are 
bus-specific functions, where the bus has a generic suspend-resume 
function that it exposes to the generic device layer, and that knows about 
the bus-specific rules.

So if you are a PCI device (to take just that example - but it's true of 
just about all other buses too), and you don't have any suspend or resume 
methods, it's actually impossible to see that fact from the generic device 
layer.

And even when you know it's PCI, our rules are actually not simple at all. 
Our rules for PCI devices (and this strictly speaking is true for bridges 
too) are rather complex:

 - do we have _any_ legacy PM support (ie the "direct" driver 
   suspend/resume functions in the driver ops, rather than having a 
   "struct dev_pm_ops" pointer)? If so, call "->suspend()"

 - If not - do we have that "dev_pm_ops" thing? If so, call it.

 - If not - just disable the device entirely _UNLESS_ you're a PCI bridge.

Notice? The way things are set up, if you have no suspend routine, you'll 
not get suspended, but you will get disabled. 

So it's _not_ actually safe to asynchronously suspend a PCI device if that 
device has no driver or no suspend routines - because even in the absense 
of a driver and suspend routines, we'll still least disable it. And if 
there is some subtle dependency on that device that isn't obvious (say, it 
might be used indirectly for some ACPI thing), then that async suspend is 
the wrong thing to do.

Subtle? Hell yes.

So the whole thing about "we can do PCI bridges asynchronously because 
they are obviously no-op" is kind of true - except for the "obviously" 
part. It's not obvious at all. It's rather subtle.

As an example of this kind of subtlety - iirc PCIE bridges used to have 
suspend and resume bugs when we initially switched over to the "new world" 
suspend/resume exactly because they actually did things at "suspend" time 
(rather than suspend_late), and that broke devices behind them (this was 
not related to async, of course, but the point is that even when you look 
like a PCI bridge, you might be doing odd things).

So just saying "let's do it asynchronously" is _not_ always guaranteed to 
be the right thing at all. It's _probably_ safe for at least regular PCI 
bridges. Cardbus bridges? Probably not, but since most modern laptop have 
just a single slot - and people who have multiple slots seldom use them 
all - most people will probably never see the problems that it _could_ 
introduce.

And PCIE bridges? Should be safe these days, but it wasn't quite as 
obvious, because a PCIE bridge actually has a driver unlike a regular 
plain PCI-PCI bridge.

Subtle, subtle.

> There remains a separate question: Should async devices also be forced
> to wait for their children?  I don't see why not.  For PCI bridges it
> won't make any significant difference.  As long as the async code
> doesn't have to do anything, who cares when it runs?

That's why I just set the "async_resume = 1" thing.

But there might actually be reasons why we care. Like the fact that we 
actually throttle the amount of parallel work we do in async_schedule(). 
So doing even a "no-op" asynchronously isn't actually a no-op: while it is 
pending (and those things can be pending for a long time, since they have 
to wait for those slow devices underneath them), it can cause _other_ 
async work - that isn't necessarily a no-op at all - to be then done 
synchronously.

Now, admittedly our async throttling limits are high enough that the above 
kind of detail will probably never ever realy matter (default 256 worker 
threads etc). But it's an example of how practice is different from theory 
- in _theory_ it doesn't make any difference if you wait for something 
asynchronously, but in practice it could make a difference under some 
circumstances.

			Linus
