Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZHRTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZHRTzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHRTzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:55:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZHRTzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:55:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Tue, 18 Aug 2009 21:56:30 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0908180954210.2995-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908180954210.2995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908182156.30320.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Alan Stern wrote:
> On Mon, 17 Aug 2009, Rafael J. Wysocki wrote:
> 
> > On Wednesday 12 August 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > The following patches introduce a mechanism allowing us to execute device
> > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > message.
> > 
> > Changes:
> > 
> > * Added [1/7] that fixes kerneldoc comments in drivers/base/power/main.c
> >   (this is a 2.6.32 candidate).
> > 
> > * Added [2/7] adding a framework for representing PM link (idea described
> >   in the patch message).
> > 
> > * [3/7] is the async resume patch (idea described in the patch message).
> > 
> > * [4/7] is the async suspend patch.
> > 
> > * [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.
> > 
> > The patches have been tested on HP nx6325.
> > 
> > Comments welcome.
> 
> I'm not sure about the design of these things.  How much do we care 
> about wasting memory?

Not much.

> Your scheme allocates six pointers for every dependency, plus four pointers
> for every device.

Yes, it does.

> It's possible to reduce this considerably, especially if the parent-child
> dependencies aren't stored explicitly.

Yes, at the expense of increased complexity and reduced performance.

> If you decide to keep this scheme, you should make pm_link_add() check 
> for duplicate dependencies before adding them.

That's correct.

> Also, I think a better approach to the async execution would not
> require adding a struct completion to each device and making each async
> thread wait for the completion to be signalled.  Instead, have a single
> master thread (i.e., the thread doing the suspend) monitor the
> dependencies and have it farm the devices out to async threads as they
> become ready to be suspended or resumed.

Do you mean that the master thread should check the dependencies
_before_ executing, for example, __device_resume() and execute it
asynchronously only if they are already satisfied?  In that case we might lose
the opportunity to save some time.

For example, assume devices A and B depend on C. Say that normally, A would be
handled before B, so if C hasn't finished yet, the A's callback will be
executed synchronously.  Now, if both A and B take time T to complete the
callback and C finishes dT after we've called A synchronously, we'll lose the
chance to save T - dT by handling A and B in parallel.

The master thread might chose another device for asynchronous execution, but
then it should revisit A and B and that still is going to be suboptimal
time-wise in some specific situations (eg. A and B are the last two devices to
handle).

> Finally, devices that don't have async_suspend set should implicitly 
> depend on everything that comes after them (for suspend) or before them 
> (for resume) in the device list.

They do, through dpm_list.

Thanks,
Rafael
