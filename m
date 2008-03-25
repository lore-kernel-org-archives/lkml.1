Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYCYOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYCYOT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYCYOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:19:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44472 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752375AbYCYOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:19:46 -0400
Date: Tue, 25 Mar 2008 10:19:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] =?utf-8?q?=5BRFC=5D=5BPATCH=5D_PM=3A_Introduce_new_top?=
 =?utf-8?q?_level_suspend=09and_hibernation_callbacks_=28rev=2E_2?=
 =?utf-8?q?=29?=
In-Reply-To: <200803251415.09088.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0803251011110.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Oliver Neukum wrote:

> Am Dienstag, 25. März 2008 14:06:15 schrieb Rafael J. Wysocki:
> > On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> 
> > > A device that cannot wake up is unusable. Shouldn't the pm core disconnect()
> > > such a device?

It's not safe for the PM core to do such things unilaterally.  The 
decision to unregister a device should be made by the driver or the 
subsystem.

(The only problem is that it's impossible to unregister a device from 
within its suspend or resume methods.  Perhaps there should be a way 
for the driver to tell the PM core that the core should unregister the 
device as soon as the method returns.  I don't know if such a facility 
would get used...)

> > Well, if ->resume() returns an error, the driver already knows there's a
> > problem and it can act upon that, at least in principle.
> 
> Then why return an error? If a driver returns an error I would assume that
> to indicate an irrecoverable error.

The PM core prints a warning in the system log whenever an error is 
returned.  There isn't much more it can do.

> > However, the PM core probably shouldn't try to resume the children of a failing
> > device.  Also, if ->resume_noirq() fails, it probably is not a good idea to
> > call ->resume() and ->complete() for the same device and for it's children.
> 
> Exactly. But we need to define what happens in these cases. If we simply
> ignore the errors, the drivers must be able to deal with IO to half suspended
> devices.

Just so -- it's up to the drivers to deal with this sort of thing.  The 
PM core can't know the details of what should be done in each case.

For example, if a USB hub can't be resumed then usbcore marks all of
its descendants with USB_STATE_NOTATTACHED.  When the children's resume
methods are called, they return without trying to do anything.  Later
on khubd takes care of unregistering everything.

Alan Stern

