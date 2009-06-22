Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZFVPj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZFVPj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZFVPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:39:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36408 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752783AbZFVPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:39:50 -0400
Date: Mon, 22 Jun 2009 11:39:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework
 for run-time PM of I/O devices
In-Reply-To: <200906221727.29295.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906221135360.14561-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Rafael J. Wysocki wrote:

> On Monday 22 June 2009, Alan Stern wrote:
> > On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:
> > 
> > > > Seriously, there _are_ places where drivers get bound to device before
> > > > those devices are registered.  This happens for example in USB when a
> > > > bunch of related interfaces are present in the same physical device.  
> > > > When the first interface is registered, its driver binds itself to all
> > > > the others even though they haven't been registered yet.
> > > 
> > > Well, the suspend functions could be protected against that under the
> > > assumption that no suspend is possible for resume_counter = 0 (then, the "good
> > > to go" value would be -1).
> > > 
> > > Still, the resume functions start from acquring a spinlock, which is not going
> > > to work if that spinlock is uninitialized.
> > 
> > The initialization needs to be improved.  Most of the code in
> > pm_runtime_init() should be called from device_pm_init(), and the rest
> > should be moved into a separate pm_runtime_add() routine to be called
> > from device_pm_add().
> 
> OK
> 
> In that case, I think, the initialization of the spinlock and resume_counter
> can be put into the thing called by device_pm_init().

Right.

> > One of the things pm_runtime_add() could do is change the status from 
> > RPM_UNREGISTERED to RPM_ACTIVE.
> 
> If the status is initially (ie. at the device_pm_init() point) RPM_ACTIVE and
> resume_couter is initially 1, what are we going to need RPM_UNREGISTERED for?

Okay, we don't need it then.  I forgot to mention in the previous
message that there also has to be a pm_runtime_del() routine, which
should cancel pending workqueue items and set the counter to some high
value so that no new items are added.

Alan Stern

