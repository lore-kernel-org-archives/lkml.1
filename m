Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbZATPyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbZATPyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbZATPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:54:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45324 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756721AbZATPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:54:38 -0500
Date: Tue, 20 Jan 2009 10:54:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] USB: Fix suspend-resume of PCI USB controllers
In-Reply-To: <20090120013602.GA8377@suse.de>
Message-ID: <Pine.LNX.4.44L0.0901201031490.2612-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009, Greg KH wrote:

> On Tue, Jan 20, 2009 at 01:26:56AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
> > (USB: fix up suspend and resume for PCI host controllers) attempted
> > to fix the suspend-resume of PCI USB controllers, but unfortunately
> > it did that incorrectly and interrupts are left enabled by the USB
> > controllers' ->suspend_late() callback as a result.  This leads to
> > serious problems during suspend which are very difficult to debug.
> > 
> > Fix the issue by removing the ->suspend_late() callback of PCI
> > USB controllers and moving the code from there to the ->suspend()
> > callback executed with interrupts enabled.  Additionally, make
> > the ->resume() callback of PCI USB controllers execute
> > pci_enable_wake(dev, PCI_D0, false) to disable wake-up from the
> > full power state (PCI_D0).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
> > Tested-by: "Jeff Chua" <jeff.chua.linux@gmail.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> 
> 
> Alan, does this look ok for you?

There are a few things I don't like about it:

	In usb_hcd_pci_suspend, the failure path for 
	pci_set_power_state doesn't undo all the changes
	that have already been made.  In fact, the easiest
	way to do the rest of the recovery probably is to
	call usb_hcd_pci_resume directly.

	In the !has_pci_pm path we don't call pci_set_power_state.
	This means controllers with legacy power management won't
	get suspended.  Maybe pci_set_power_state should be
	called always, and has_pci_pm be used only for
	interpreting the return code and printing debug messages.

	In usb_hcd_pci_resume, the pci_wake_from_d3 call
	should be moved up right next to the pci_enable_wake
	call.  It makes no sense for them to be separated by
	pci_enable_device and pci_set_master.  After all,
	even if you can't re-enable the device you probably
	don't want it to continue being a wakeup source.

	It's a little annoying that several debug messages
	in usb_hcd_pci_resume have been removed.  Can't we
	display the power state upon entry, before trying to
	change it?

	It stands out that the resume method contains no call
	to match pci_set_power_state() in the suspend method.
	There should at least be a comment about it.

Some of these problems predate Rafael's patch.  Given that it has 
already helped a number of people, we might want to merge the patch 
and then make additional changes to address these issues.

Alan Stern

