Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZH1TiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZH1TiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZH1Th7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:37:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZH1Th6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:37:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
Date: Fri, 28 Aug 2009 21:38:14 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908281137110.4116-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908281137110.4116-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908282138.14602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 August 2009, Alan Stern wrote:
> On Wed, 26 Aug 2009, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Theoretically, the total time of system sleep transitions (suspend
> > to RAM, hibernation) can be reduced by running suspend and resume
> > callbacks of device drivers in parallel with each other.  However,
> > there are dependencies between devices such that, for example, we may
> > not be allowed to put one device into a low power state before
> > anohter one has been suspended (e.g. we cannot suspend a bridge
> > before suspending all devices behind it).  In particular, we're not
> > allowed to suspend the parent of a device before suspending the
> > device itself.  Analogously, we're not allowed to resume a device
> > before resuming its parent.
> 
> > In this version of the patch the async threads started to execute
> > the resume callbacks of specific device don't exit immediately having
> > done that, but search dpm_list for devices whose PM dependencies have
> > already been satisfied and execute their callbacks without waiting.
> 
> Given this design, why bother to invoke device_resume() for the async 
> devices?  Why not just start up a bunch of async threads, each of which 
> calls async_resume() repeatedly until everything is finished?  (And 
> rearrange async_resume() to scan the list first and do the actual 
> resume second.)
> 
> The same goes for the noirq versions.

I thought about that, but there are a few things to figure out:
- how many threads to start
- when to start them
- stop condition
I had a few ideas, but then I thought it would be simpler to start an async
thread when we know there's some async work to do (ie. there's an async
device to handle) and make each async thread browse the list just once (the
rationale is that we've just handled a device, so there's a chance there are
some devices with satisfied dependencies down the list).

Thanks,
Rafael
