Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab0BXUWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:22:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018Ab0BXUV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:21:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [RFC][PATCH] ACPI: Eliminate race conditions related to removing event handlers
Date: Wed, 24 Feb 2010 21:22:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>
References: <201002210151.01159.rjw@sisk.pl> <4911F71203A09E4D9981D27F9D83085859B327F4@orsmsx503.amr.corp.intel.com>
In-Reply-To: <4911F71203A09E4D9981D27F9D83085859B327F4@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002242122.20435.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010, Moore, Robert wrote:
> 
> Rafael,
> 
> I've got some issues with this design.
> 
> First of all, are the two interfaces, acpi_remove_notify_handler() and
> acpi_remove_gpe_handler(), really being used in such a way to require such
> synchronization?

I had a problem with that when I was trying to implement adding more than one
system notify handler per device at the PCI level.  Specifically, I was trying
to create an extra layer of notify objects to be used by the PCI layer for
installing ACPI system notify handlers such that every PCI device had one
handler that might handle wakeup notifications as well as hotplug
notifications.  That didn't work, because I needed to remove a notify object
from memory after calling acpi_remove_notify_handler() for the handler
associated with it and I was unable to tell whether that was safe.

The patch at http://patchwork.kernel.org/patch/80104/ solved this issue for me
(BTW, you told me you'd have a look at this one :-)), but I think it generally
is good to know a handler is not being executed after
acpi_remove_notify_handler() or acpi_remove_gpe_handler() has been called
for it.

> Is there any way to limit their use to times where it is known that no
> handlers will be executing?

I don't think this is generally possible.  Since the event handlers are called
from a workqueue, we can't really guarantee any synchronization between them
and the other threads unless we use a mechanism that will enforce it.
 
> In addition, I'm afraid that this whole "events" mechanism, with an interface
> to wait for event completion, and now the concept of adding "barriers" to the
> event queue, is much too OS-specific for the core ACPICA code.

OK, I'm not going to insist.  However, I think that
acpi_os_wait_events_complete() should be called before we try to acquire
ACPI_MTX_EVENTS for the first time, because dropping it "temporarily" just in
order to call acpi_os_wait_events_complete() really defeats the purpose of the
locking.

Rafael
