Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZLVTJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZLVTJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZLVTJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:09:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47104 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbZLVTJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:09:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFD] Asynchronous suspend/resume of PCI devices
Date: Tue, 22 Dec 2009 20:10:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>
References: <200912200031.38775.rjw@sisk.pl> <20091222083001.10ce3948@jbarnes-x200>
In-Reply-To: <20091222083001.10ce3948@jbarnes-x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912222010.28046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 December 2009, Jesse Barnes wrote:
> On Sun, 20 Dec 2009 00:31:38 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > I'd like to know your opinions about the viability of suspending and
> > resuming PCI devices asynchronously during system-wide PM transitions
> > (suspend to RAM and hibernation).
> > 
> > Linus says it's generally dangerous, because some PCI devices may
> > indirectly depend on the others, but if that's the case, I wonder if
> > we really can power manage PCI devices at run time.
> > 
> > It follows from my experiments that suspending and resuming PCI
> > devices asynchronously doesn't lead to problems as long as we make
> > sure that every PCI device is suspended before and resumed after its
> > ACPI "shadow" partner. However, I'm not sure if this is generally
> > correct.
> > 
> > What are possible problems we can run into while doing asynchronous
> > suspend and resume of PCI devices?  What do we need to do in general
> > to avoid that problems?
> > 
> > Please tell me what you think.
> 
> AFAIK it should be *mostly* safe.  Individual drivers are generally
> independent of one another.  However, there are quite a few
> multifunction devices (some exposed as such, some exposed as multiple
> busses and devices on the same device) where interdependencies are
> possible.  In some cases, we just won't see power savings until the
> whole chip is powered down (which may require extra code in the form of
> a "bus" driver of some sort), in other cases a driver may inadvertently
> power down a piece of a device needed by another driver.
> 
> That said, the best practice for those sorts of devices is to create a
> bus driver anyway, that binds to the master device and has a few
> child drivers, so maybe even that case won't be much trouble...

My current idea is to mark all PCI devices as async and introduce mutexes
for the devices that shouldn't be suspended/resumed at the same time.
Perhaps we can start with just one mutex to be acquired in ->suspend() and
->resume() by the drivers that have to be serialized with respect to one
another.

What do you think?

Rafael
