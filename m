Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZC3IuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZC3IuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZC3IuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:50:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38316 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZC3IuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:50:04 -0400
Date: Mon, 30 Mar 2009 10:49:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael E Brown <Michael_E_Brown@dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090330104952.26f03c13@hyperion.delvare>
In-Reply-To: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Sun, 29 Mar 2009 18:36:46 +0200, Kay Sievers wrote:
> On Sun, Mar 29, 2009 at 17:48, Jean Delvare <khali@linux-fr.org> wrote:
> > I am a little confused by the directories created when one registers a
> > class device. When a class device is registered as the children of a
> > real device, a subdirectory by the class name is created, and the class
> > device is created there, effectively granting each class a separate
> > namespace. Example:
> >
> > /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0
> >
> > where 0000:00:1f.3 is the physical device, i2c-adapter the class name
> > and i2c-0 the class device.
> >
> > OTOH, if I create a class device as the children of another class
> > device, the class device is created directly, without a directory
> > between the parent and the child. Example:
> >
> > /sys/class/i2c-adapter/i2c-0/i2c-0
> >
> > where the first i2c-0 is an i2c-adapter class device, and the second
> > i2c-0 is an i2c-dev class device. I would have expected:
> >
> > /sys/class/i2c-adapter/i2c-0/i2c-dev/i2c-0
> >
> > The current behavior seems inconsistent to me. Is it done so on purpose,
> > or is this accidental? If on purpose, what's the reason?
> 
> It's on purpose. The "glue" directory exists only between class
> devices and bus devices. There is no need for class devices to have
> such a "glue".

The example I have is one where the need exists.

>                When we moved the class devs as childs of the bus devs,
> people complained, that they could no longer rename their netif to
> "irq", because the name was already taken by a pci dev atrribute. :)

That's what I had guessed, although this only moves the problem: if a
class has the same name as an attribute, a collision will happen.
Probably that's just less likely to happen than collisions between
class device names and device attributes.

> > I am asking because this is causing trouble in practice. We have both
> > i2c-dev and firmware_class which try to create class devices by the
> > same name and this of course collides. While I would blame
> > firmware_class for coming up with an horrible naming scheme (or
> > actually, for not coming up with any naming scheme) it might still be a
> > good idea to prevent such collisions at the driver core level.
> 
> You have multiple instances, which request a firmware file for the
> same parent device at the same time? Can't they request the firmware
> for the actual child instead of using the same parent?

No, there's a single firmware request which collides with an i2c-dev
class device name. The firmware request happens to use the parent
device's name as its class device name, and it happens that both the
i2c-adapter class and the i2c-dev class name their class devices the
same way (which makes sense as they refer to the same thing,
i2c-adapter for the kernel-space access and i2c-dev for the user-space
access), and the latter is a child of the former. So when an
i2c-adapter class device is used as the parent for a firmware request,
and the i2c-dev driver is loaded, you get a collision.

It could be argued that i2c-adapter and i2c-dev should be the same
class, but changing this now would break several user-space tools so I
doubt it's going to happen. The fact that i2c-dev is optional can also
be seen as a desirable feature.

> If the same parent needs to work, the firmware class needs to be fixed
> to allow that. Maybe it should use the requested firmware filename
> with the '/' translated to '!' as the name in sysfs, instead of the
> easy-to-have-a-clash device name of the parent?

Changing the name of the firmware class devices was already attempted
once, but was quickly reverted because it broke some user-space tools:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=109f0e93b6b728f03c1eb4af02bc25d71b646c59
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7d640c4a5b36c4733460065db1554da924044511

Unless the user-space tool in question (Dell BIOS updater) has been
modified to no longer depend on this since then, changing the firmware
class device names isn't possible.

Now that we have a use case which would justify that a class device
child of another class device gets its own namespace, is there a chance
to see it happen?

Thanks,
-- 
Jean Delvare
