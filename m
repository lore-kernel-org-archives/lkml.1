Return-Path: <linux-kernel-owner+w=401wt.eu-S935357AbZLGPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935357AbZLGPmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935342AbZLGPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:42:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35958 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935258AbZLGPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:42:20 -0500
Date: Mon, 7 Dec 2009 10:42:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912062110240.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912071029260.3064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Linus Torvalds wrote:

> I can imagine that doing USB resume specially is worth it, since USB is 
> fundamentally a pretty slow bus. But USB is also a fairly clear hierarchy, 
> so there is no point in PM groups or any other information outside of the 
> pure topology.
> 
> But there is absolutely zero point in doing that for devices in general. 
> PCI drivers simply do not want concurrent initialization. The upsides are 
> basically zero (win a few msecs?) and the downsides are the pointless 
> complexity. We don't do PCI discovery asyncronously either - for all the 
> same reasons.
> 
> Now, a PCI driver may then implement a bus that is slow (ie SCSI, ATA, 
> USB), and that bus may itself then want to do something else. If it really 
> is a good idea to add the whole hierarchical model to USB suspend/resume, 
> I can live with that, but that is absolutely no excuse for then doing it 
> for cases where the hierarchy is (a) known to be broken (ie the whole PCI 
> multifunction thing, but also things like motherboard power management 
> devices) and (b) don't have the same kind of slow bus issues.

Okay.  I can understand not wanting to burden everybody else with USB's 
weaknesses.

Simply doing an async suspend & resume of each USB root hub might be
enough to give a significant advantage.  For the most part these root
hubs tend to be registered sequentially with few or no other devices in
between.[*]  Hence the "stalls" that would occur when suspending a
parent or resuming a child wouldn't slow things down very much.  We
would not always reap the maximum advantage of a fully-asyncronous
approach but there would be some improvement.

This is sort of what Arjan suggested yesterday.  Its benefit is that 
nothing outside usbcore has to change.

Alan Stern

[*] In fact this is true only on systems where the USB host controller 
drivers are built as modules.  If everything is compiled into the 
kernel then the devices are registered in the worst possible order:
controller 1, root hub 1, controller 2, root hub 2, ...

I suppose the root hubs could be registered in a delayed work routine.  
It would be a little awkward but it would solve this issue.

