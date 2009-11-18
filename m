Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZKRQvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZKRQvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbZKRQvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:51:46 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:43548 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749AbZKRQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mwL2FJXMiLkdPg4S8RF+h97y9h03ohNVzbxlwqTs0j0cVsAdQaaDBrm4SvM2knWm+T
         YtsVnQCAD4BSR3HXqYUiUGyAKkGOVWp5H/fIz888yBvkm32Z0LNVHXMiCAZp5t7JjanB
         xkAZRyC3X01wuAy9ee8hqj4/S+C0Q1rmEsDM0=
MIME-Version: 1.0
In-Reply-To: <200911181527.18791.oliver@neukum.org>
References: <f9d2a5e10911171306r416eaf2k45c3256370e82eda@mail.gmail.com>
	 <alpine.LRH.2.00.0911181141030.31913@twin.jikos.cz>
	 <200911181527.18791.oliver@neukum.org>
Date: Wed, 18 Nov 2009 09:51:49 -0700
Message-ID: <f9d2a5e10911180851g5d21eeb6g3d9eeccff2c2d371@mail.gmail.com>
Subject: Re: Use of usb_find_interface in open is racy
From: Russ Dill <russ.dill@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 7:27 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch, 18. November 2009 11:41:25 schrieb Jiri Kosina:
>> > User space receives the hotplug event for the class device, makes the
>> > device node and notifies another program that opens the device node.
>> > The program opens the device node which calls into usb_open and then
>> > skel_open. skel_open calls usb_find_interface. usb_find_interfaces
>> > searches the klist_devices of skel_driver, finds no device associated
>> > with the minor number and returns NULL. skel_open returns -ENODEV.
>> >
>> > Control returns to really_probe and really_probe calls driver_bound
>> > which adds the device to the list of devices associated with
>> > skel_driver (klist_devices).
>> >
>> > I'm not sure what the right way to solve this is. A call to
>> > wait_for_device_probe() in the skel_open call before calling
>> > usb_find_interface fixes the problem, but it is a rather large hammer.
>>
>
> Device core code is hard to follow, but I tried.
> How about simply covering all of usb_register_dev() with minor_rwsem?
>

The race is open from the point that usb_register_dev calls
device_create (at the end of usb_register_dev) till the point that
skel_probe returns up to the point of really_probe, really_probe calls
driver_bound, and driver_bound adds the device to the driver's
klist_devices.

call stack:

device_create
usb_register_dev
skel_probe
usb_probe_device (via drv->probe())
really_probe

really_probe:

dev->driver = drv;
if (driver_sysfs_add(dev)) {
[...]
}

if (dev->bus->probe) {
[...]
} else if (drv->probe) {
