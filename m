Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYCCU4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYCCU4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYCCU4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:56:33 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:23191 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYCCU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:56:32 -0500
Date: Mon, 3 Mar 2008 13:56:21 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, Matthew Wilcox <matthew@wil.cx>,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/4] Introduce pci_slot
Message-ID: <20080303205621.GD17814@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
	Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002855.GD21420@ldl.fc.hp.com> <20080301052433.GC19353@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301052433.GC19353@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

* Greg KH <gregkh@suse.de>:
> On Thu, Feb 28, 2008 at 05:28:55PM -0700, Alex Chiang wrote:
> >   - Make pci_slot the primary sysfs entity. hotplug_slot becomes a
> >     subsidiary structure.
> >     o pci_create_slot() creates and registers a slot with the PCI core
> >     o pci_slot_add_hotplug() gives it hotplug capability
> > 
> >   - Change the prototype of pci_hp_register() to take the bus and
> >     slot number (on parent bus) as parameters.
> > 
> >   - Remove all the ->get_address methods since this functionality is
> >     now handled by pci_slot directly.
> 
> This describes what you did, but not why you are doing this, making it a
> pretty bad changelog comment.
> 
> Can you refresh my memory as to the "why" for all of this 

How about this:

Currently, /sys/bus/pci/slots/ only exposes hotplug attributes
when a hotplug driver is loaded, but PCI slots have attributes
such as address, speed, width, etc. that are not related to
hotplug at all.

Introduce pci_slot as the primary data structure and kobject
model. Hotplug attributes described in hotplug_slot become a
secondary structure associated with the pci_slot.

This patch only creates the infrastructure that allows the
separation of PCI slot attributes and hotplug attributes.
In this patch, the PCI hotplug core remains the only user of this
infrastructure, and thus, /sys/bus/pci/slots/ will still only
become populated when a hotplug driver is loaded.

A later patch in this series will add a second user of this new
infrastructure and demonstrate splitting the task of exposing
pci_slot attributes from hotplug_slot attributes.

  - Make pci_slot the primary sysfs entity. hotplug_slot becomes a
    subsidiary structure.
    o pci_create_slot() creates and registers a slot with the PCI core
    o pci_slot_add_hotplug() gives it hotplug capability

  - Change the prototype of pci_hp_register() to take the bus and
    slot number (on parent bus) as parameters.

  - Remove all the ->get_address methods since this functionality is
    now handled by pci_slot directly.

> and how you are handling machines that do not export this
> information at all?

With this patch, there is no change from existing behavior that
users see; only infrastructure is changed. The existing hotplug
drivers will continue to expose whatever they were exposing
before (when they are loaded).

> oh, and don't put "extern" in a .c file, 

Fixed in next version.

> and call kobject_uevent in the same function that you added the
> kobject in, unless there is a very good reason to do so,
> otherwise you just missed all of those events...

I *think* I might actually have a "good" reason, but welcome your
feedback.

In this patch, pci_create_slot() is responsible for
kobject_init_and_add, and it adds the 'address' attribute in
sysfs.

The caller of pci_create_slot() is pci_hp_register, and it is
calling kobject_uevent after pci_create_slot, because it still
has to expose the hotplug attributes in sysfs, which can only
happen *after* the pci_slot is created.

I don't think I want to emit the uevent until those hotplug
attributes are exposed, right?

This kinda seems like a stupid design, but the next patch in the
series adds another callsite for pci_create_slot. The next patch
is detecting physical slots described by ACPI, but doesn't know
(or care) about their hotplug capabilities.

I don't think it makes sense to be emitting uevents simply upon
detecting a physical slot.

[over time, I hope to add more functionality to pci_slot, such as
displaying speed, width, etc., but right now, we only get the
address]

One alternative I can think of -- which would further complicate
this model that I'm introducing -- would be to make hotplug_slot
a kobject too, and then let pci_slot emit a uevent upon physical
slot detection, and then let pci_hp_register emit another uevent
when the hotplug_slot is created / added to sysfs. But I must
admit, I don't really like that alternative.

Your thoughts?

Thanks.

/ac

