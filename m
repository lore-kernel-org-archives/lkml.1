Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYL3WvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYL3WvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYL3WuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:50:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYL3WuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:50:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC][PATCH 0/10] PCI PM: Make new suspend-resume callbacks carry out core operations
Date: Tue, 30 Dec 2008 23:33:44 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl>
In-Reply-To: <200812281607.28007.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812302333.45560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2008, Rafael J. Wysocki wrote:
> On Friday 19 December 2008, Rafael J. Wysocki wrote:
> > Hi Len,
> > 
> > The patch below adds the callbacks that save/restore the standard PCI config
> > registers, change the power state of the device etc. to the new suspend-resume
> > callbacks (which are not yet used by device drivers), so that the drivers don't
> > have to worry about these operations.
> > 
> > The saving and restoring of the standard PCI config registers is done with
> > interrupts off, the other things are done with interrupts enabled.
> > 
> > The patch should apply to the current linux-next tree.
> 
> Below is a new version of the patch.
> 
> Now, the standard config spaces of devices are restored with interrupts
> disabled, but only if the bridges the devices are behind are in D0.  Otherwise,
> the operation is attempted again with interrupts enabled (presumably the
> bridge would be put into D0 before that happens).
> 
> Also, pci_disable_device() is not called during resume and
> pci_reenable_device() is used to enable the devices that were enabled during
> suspend.  This allows us to automatically call pci_set_master() for devices
> that were bus masters before suspend.  Additionally, the pci_reenable_device()
> may be overriden by the driver, by disabling the device during suspend.
> 
> Finally, bridges are handled a bit differently from the regular devices (they
> are not put into low power states during suspend and pci_enable_wake() is
> not called for them.
> 
> The patch should apply on top of linux-next with the patch fixing
> pci_update_current_state() I sent yesterday
> (http://marc.info/?l=linux-kernel&m=123039199607159&w=4).

In the meantime I realized that the pcibios_enable_device() called from
pci_reenable_device() in the resume code path should be balanced by a "suspend"
call of the same kind.

Also, I decided to split the patch into a series of smaller patches with their
own changelogs to make it easier to follow the changes.  Perhaps this way
it will be more clear what I'm after.

The patches should apply to linux-next with the patch from
http://marc.info/?l=linux-kernel&m=123039199607159&w=4 on top.

Comments welcome.

Happy New Year to everyone,
Rafael

