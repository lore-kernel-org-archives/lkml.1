Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbZLGFUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbZLGFUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZLGFUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:20:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbZLGFUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:20:53 -0500
Date: Sun, 6 Dec 2009 21:20:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.0912062110240.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Dec 2009, Alan Stern wrote:
> 
> That's ridiculous.  Having gone to all the trouble of building a device
> tree, one which is presumably still almost entirely correct, why go to
> all the trouble of tearing it down only to rebuild it again?  (Note:
> I'm talking about resume-from-RAM here, not resume-from-hibernation.)

Hey, I can believe that it's worth keeping the USB device tree, and just 
validating it instead. However:

> If I understand correctly, what you're suggesting is impractical.  You
> would have each driver responsible for resuming the devices it
> registers.

The thing is, for 99% of all devices, we really _really_ don't care. 
Especially PCI devices. 

Your average laptop will have something like ten PCI devices on it, and 
99% of those have no delays at all outside of the millisecond-level ones 
that it takes for power management register writes etc to take place.

So what I'm suggesting is to NOT DO ANY ASYNC RESUME AT ALL by default. 
Because async device management is _hard_, and results in various nasty 
ordering problems that are timing-dependent etc. And it's totally 
pointless for almost all cases.

This is why I think it is so crazy to try to create those idiotic "this 
device depends on that other" lists etc - it's adding serious conceptual 
complexity for something that nobody cares about, and that just allows for 
non-deterministic behavior that we don't even want.

> So consider this suggestion: Let's define PM groups.

Let's not.

I can imagine that doing USB resume specially is worth it, since USB is 
fundamentally a pretty slow bus. But USB is also a fairly clear hierarchy, 
so there is no point in PM groups or any other information outside of the 
pure topology.

But there is absolutely zero point in doing that for devices in general. 
PCI drivers simply do not want concurrent initialization. The upsides are 
basically zero (win a few msecs?) and the downsides are the pointless 
complexity. We don't do PCI discovery asyncronously either - for all the 
same reasons.

Now, a PCI driver may then implement a bus that is slow (ie SCSI, ATA, 
USB), and that bus may itself then want to do something else. If it really 
is a good idea to add the whole hierarchical model to USB suspend/resume, 
I can live with that, but that is absolutely no excuse for then doing it 
for cases where the hierarchy is (a) known to be broken (ie the whole PCI 
multifunction thing, but also things like motherboard power management 
devices) and (b) don't have the same kind of slow bus issues.

				Linus
