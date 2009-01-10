Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZAJC2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZAJC2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 21:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZAJC2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 21:28:30 -0500
Received: from usul.saidi.cx ([204.11.33.34]:46077 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751859AbZAJC23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 21:28:29 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] =?UTF-8?Q?ricoh=5Fmmc=3A=20Use=20suspend/resume=5Fnoirq=20=28?=
 =?UTF-8?Q?v=32=29=20=28resend=29?=
MIME-Version: 1.0
Date: Fri, 09 Jan 2009 21:31:25 -0500
From: Philip Langdale <philipl@overt.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       sfr@canb.auug.org.au, Pierre Ossman <drzeus@drzeus.cx>
In-Reply-To: <200901082314.52840.rjw@sisk.pl>
References: <40499.98.210.152.237.1231345314.squirrel@overt.org> <200901082314.52840.rjw@sisk.pl>
Message-ID: <94b68f283abf372eab895fd76b0feb34@localhost>
User-Agent: RoundCube Webmail/0.2-beta
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009 23:14:52 +0100, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Wednesday 07 January 2009, philipl@overt.org wrote:
>> If ricoh_mmc suspends before sdhci_pci, it will pull the card
>> out from under the controller, which could leave the system in
>> a very confused state.
> 
> Does it really happen?  That depends on which of them is registered
first.

Yes, it does. It seems that due to the typical ordering of the PCI devices,
ricoh_mmc loads first.

The larger context is how the hardware works and what ricoh_mmc does.

The hardware is a multiple function PCI device with a separate function for
each type of media card. SD and MMC are special because they use the same
physical format, and consequently the same physical contacts. Inside the
chip, a basic detection routine runs on insertion, and the card then
appears
to the appropriate controller function.

Now, the ricoh chip implements the standard SD host controller spec but
as no such thing exists for MMC, it implements its own custom one. Linux
only has an SDHCI driver, but due to how the hardware works, we can support
MMC cards through it - but only if the controller can see them!

For that to happen, we must disable the MMC function - when that happens,
the card is routed to the SD function and an insertion event is generated.
Similarly, if you reactive the MMC function, the card will be seen to
disapper on the SD side.

The ricoh_mmc driver automates this enable/disable process. It is bound to
the MMC function but actually acts on another function of the Ricoh chip
(typically the firewire controller) to do the actual disabling.

For consistency, the driver reactivates the mmc function at suspend time
and deactivates it again on resume.

Now, if the ricoh_mmc driver suspends before the SD driver, it will
reactive
the MMC function and trigger this removal event on the SD side. Then, when
the SD driver does its suspend/resume cycle, the card will be unexpectedly
absent, and confusion follows.

If ricoh_mmc uses suspend/resume_noirq, it both ensures that it runs at
the right time and that the insertion/removal events are not reported.

>> Using suspend/resume_noirq ensures that sdhci_pci suspends first
>> and resumes second.
> 
> Well, I'm not sure if this is the best approach, but I don't know what
the
> dependencies between the devices are, so can you please explain that
> to me?

I hope my write up answers this question.
 
> That said, if you want to suspend-resume ricoh_mmc with interrupts
> disabled,
> please use the legacy PCI .suspend_late() and .resume_early() callbacks
for
> that, since in the new framework the core will carry out some standard PM
> operations in addition to your .suspend_noirq() and .resume_noirq().  It
> may
> not be what you want in this case, though.

I'd need to know what those other operations are. I originally wrote this
patch with suspend_late and resume_early but the first pm_ops patch I saw
removed those. Are you now saying that both suspend_late/resume_early and
noirq callbacks are supported now.

It's all a bit confusing :-)

--phil
