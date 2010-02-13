Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0BMATv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 19:19:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab0BMATu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 19:19:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Sat, 13 Feb 2010 01:20:29 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <20100212015508.GD10298@us.ibm.com> <201002121219.36350.rjw@sisk.pl>
In-Reply-To: <201002121219.36350.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002130120.29385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 February 2010, Rafael J. Wysocki wrote:
> On Friday 12 February 2010, Gary Hade wrote:
... 
> > There seems to be a problem.
> > 
> > The first time I booted I was able to successfully hot-remove
> > a PCIe card and then successfully hot-add it to a different slot.
> > When I tried to hot-remove a PCI-X card that was also present
> > during boot I saw that lingering blinking amber LED issue.
> > 
> > After rebooting I tried the same thing but this time I did
> > not see the lingering blinking amber LED after removing the
> > PCI-X card but I did see it when removing the PCIe card.
> > I then tried to hot-add the PCIe card to a different slot
> > and noticed the below messages.
> > 
> > I don't think I will be able to try to characterize this
> > better or test any more patches until Monday.  
> 
> OK, thanks for testing.
> 
> It seems we have a deadlock on pci_acpi_notify_mtx, but I'm yet to understand
> the exact mechanism of it.

In fact there are two problems in there.  First, the bridge event notification
calls handle_bridge_insertion() which attempts to install a PM notifier for
the bridge and that deadlocks, because it tries to acquire the mutex
recursively.  Second, apparently, init_bridge_misc() may be called in the
notification code path and it attempts to unregister the notifier and register
it again, which can't be done with pci_acpi_notify_mtx held.

I guess there are similar problems on the hot remove notification path.

Anyway, I have a new version of the patch and I'm going to test it a bit
over the weekend.  Unfortunately, I don't have hardware with PCI hotplug
capability, so I'll send you the new patch for testing on Monday, if you don't
mind.

Rafael
