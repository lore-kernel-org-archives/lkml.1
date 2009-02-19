Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZBSXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZBSXIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZBSXIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:08:47 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:38000 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbZBSXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <fa686aa40902182250g1c4e7cb6o4d0102da35ab838b@mail.gmail.com>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <ac3eb2510902180745v2886ae31s2d7faeb2faedab6e@mail.gmail.com>
	 <fa686aa40902180748i2d621de1j1da7600e8cc3165f@mail.gmail.com>
	 <ac3eb2510902180753l5dc94e5dje9154eaea9d2db29@mail.gmail.com>
	 <fa686aa40902180834r2b9b8de0tcdc31c850f6323a6@mail.gmail.com>
	 <ac3eb2510902180849o6d86bbfev337e1bc203d6543e@mail.gmail.com>
	 <fa686aa40902180951q64c71581y3811062256685df7@mail.gmail.com>
	 <ac3eb2510902181032h3f9ed994s212dd8b42ddca82@mail.gmail.com>
	 <20090218183945.GA31797@suse.de>
	 <fa686aa40902182250g1c4e7cb6o4d0102da35ab838b@mail.gmail.com>
Date: Fri, 20 Feb 2009 00:08:44 +0100
Message-ID: <ac3eb2510902191508w71cf7d76x4a8957ecee9c4e6@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 07:50, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Feb 18, 2009 at 11:39 AM, Greg KH <gregkh@suse.de> wrote:
>> On Wed, Feb 18, 2009 at 07:32:19PM +0100, Kay Sievers wrote:
>>> On Wed, Feb 18, 2009 at 18:51, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> > Mostly because I have no need another full struct device, and none of
>>> > the files that I'm adding have any bearing on udev.  They are debug
>>> > and statistical files for an embedded system that are used by the
>>> > developer.  I don't want application code depending on them and I'm
>>> > not interested in having them advertised.
>>>
>>> That's what debugfs is for.
>>
>> Kay is right, use debugfs for stuff like this.  Not sysfs.
>>
>> So sorry, I'm not going to apply the patch, and you should change your
>> code to not open-code this as well.
>
> Forgive my frustration, but I've been happily using sysfs for simple
> exports of driver data (not just debug either; for tuning also) for a
> while now with no indication that I've doing the wrong thing.  I
> haven't found anything in Documentation or in LDDv3 that says files
> should not be created at probe time.  The sysfs API is beautiful to
> work with and requires less code than the equivalent debugfs
> interface.  Often using it exactly matches the use case that I need;
> small values, simple settings and safe, concise code.
>
> So, I re-ask my questions:
> When is it legal and when is it not legal to call
> device_create_file()?  If debug only stuff belongs in debugfs, then
> fair enough.  But what about when tuning controls are needed?  If I
> have to create a child 'struct device', then I will do so, but I'm
> still not convinced on the benefit.
>
> Even then, I'm confused.  The KOBJ_ADD uevent is raised at
> device_register() time.  However, it appear that device_create_file()
> often gets called after device_register() (pci_bus_add_child() for
> example).  What is the cutoff point for calling device_create_file()
> so that attributes exist before the uevent (as Kay stated earlier in
> this thread)?

People expect to be able to hook into device events and *match*
against certain device properties when the device shows up. Like you
can say: If a "usb_interface" with the "subclass" "video" shows up,
run this program, or do whatever else.

People expect to be able to hook into device events to *configure*
devices. They want to write to the tunables as soon as the device has
shown up, or the driver gets loaded. Like they want to enable timeouts
or power-management for specific devices.

Both *matching* and *configuring* devices at creation time are the key
to auto-setup and "just works" configurations.

If an attribute is not available at event time, nothing of this can
ever work. If you look a the device a second later, you will see the
proper looking files and values, and all the test programs will work,
but it will always fail at device creation.

You can hook into all that with a few simple instructions from udev,
and people can expect that device attributes they see at runtime can
be used in udev, means at creation time.

The same timing problem arises if a driver creates stuff at an already
existing device, userspace has no chance to ever get notified about
this. That's why the driver should usually create his own instance in
sysfs, that represents functionality, and will be a child device of
the hardware device it has bound to.
The child device that would be created, gets its "default attributes"
and they are always guaranteed to exist before the event is sent out.

That all might not be needed for your specific setup/driver/device and
may work fine for your need. But we don't want to encourage anybody
with another new API which creates the usual trouble we need to fix
later. And we need to fix things like this all the time.

Also the existing sysfs attribute groups API has the same problem if
the group is created later, but as far as I can see it should work
fine for your purpose. So it's better using that, instead of exporting
another different API.

Thanks,
Kay
