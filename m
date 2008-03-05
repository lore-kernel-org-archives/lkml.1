Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCEQEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCEQEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYCEQDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:03:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40535 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751380AbYCEQDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:03:53 -0500
Date: Wed, 5 Mar 2008 11:03:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
In-Reply-To: <200803042252.51440.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803051050310.4621-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Rafael J. Wysocki wrote:

> > It's not clear that we want to have this check.  It would cause
> > problems if the device ordering got mixed up by device_move(), which is
> > pretty much the only way it could be triggered.
> 
> Well, isn't it actually dangerous to suspend parents before their children?
> What happens, for example, if putting the parent into D3 causes power to be
> cut from the children and then we attempt to suspend them?

It depends on the devices involved.  For PCI devices, obviously there 
will be problems of the sort you described.  But for other devices 
there might not be.

For example, the USB Bluetooth driver will sometimes create a new TTY
device and then move the existing Bluetooth device underneath it (this
description is oversimplified and probably wrong in some important
respects, but you get the idea).  Suspending the Bluetooth device
before suspending the TTY won't cause any power-related problems,
because a TTY is a purely logical device with no power implications at
all.

There might still be logical problems, of course...  We need to add a
mechanism for reordering the dpm_active list when device_move() is
called.  But first we need to get in touch with the people using
device_move() -- basically just Marcel and Cornelia -- and see what
sort of mechanism they will need.

Alan Stern

