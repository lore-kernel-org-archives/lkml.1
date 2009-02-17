Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZBQCyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZBQCyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZBQCx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:53:57 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:9352 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZBQCxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:53:55 -0500
MIME-Version: 1.0
In-Reply-To: <20090216202215.GA6543@kroah.com>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
	 <200902160931.34771.oliver@neukum.org>
	 <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com>
	 <20090216161331.GB5008@kroah.com>
	 <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com>
	 <20090216185914.GA6239@kroah.com>
	 <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com>
	 <20090216202215.GA6543@kroah.com>
Date: Mon, 16 Feb 2009 21:53:54 -0500
X-Google-Sender-Auth: b272a20534ddfa89
Message-ID: <5aa163d00902161853x27d98a83l3c2c02abe651fe1e@mail.gmail.com>
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 3:22 PM, Greg KH <greg@kroah.com> wrote:
>> >
>> > Put it on the input device, which is what is the per-device thing.  It's
>> > much simpler than creating a new struct kobject.  You can even create a
>> > subdirectory for your attributes if you use an attribute group (which
>> > you should be doing anyway, it's much simpler that way.)
>> >
>>
>> OK, one thing I'm not clear on: is there a clean API for adding
>> attributes to an existing struct device, or do I need to "subclass" it
>> (the C containment and delegation approach)?
>
> device_create_file()
>

In the process of trying to re-factor the code for the above changes,
I ran into the problem that the show and store functions for sysfs
expect to be passed a struct device *. I can get to struct input_dev *
without problems (since struct input_dev contains the struct device,
and I can simply use container_of indirectly via to_input_dev).
However, I can't seem to get back to struct usb_xpad, because that
structure defines 2 pointers to devices, rather than simply embedding
the devices:

struct usb_xpad {
	struct input_dev *dev;		/* input device interface */
	struct usb_device *udev;	/* usb device */
...
};

This is not my code... it was set up this way in the stable xpad driver.

So it looks like I'm stuck with a struct input_dev * pointer to the
input device, a struct device * pointer in the show/store handlers,
and no way to get back to struct usb_xpad * with the container_of
macro. Unless, of course, there is something I don't know about
container_of (or another macro I can use in this instance).

Worse, I can't simply change the struct input_dev *dev to struct
input_dev dev, because the input subsystem's input_register_device
expects to have a struct input_dev * pointer allocated with
input_allocate_device, which does both a kzalloc AND initialization.
Trying to hack my driver by incorporating the initialization logic in
input_allocate_device would be stupid, since the result would be
unmaintainable. So the route out of this mess, going in the direction
of device attributes, would be to modify drivers/input/input.c to
factor the initialization away from the allocation.

So which is the lesser of two evils? Allocating a new kobject, or
mucking around with more of the input subsystem? Or am I missing
something?

Thanks,
Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
