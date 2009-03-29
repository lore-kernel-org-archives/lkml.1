Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbZC2Qnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbZC2Qnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758256AbZC2Qif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:38:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:14676 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238AbZC2Qie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:38:34 -0400
MIME-Version: 1.0
In-Reply-To: <20090329174836.6de797d6@hyperion.delvare>
References: <20090329174836.6de797d6@hyperion.delvare>
Date: Sun, 29 Mar 2009 18:36:46 +0200
Message-ID: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
Subject: Re: Class device namespaces
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael E Brown <Michael_E_Brown@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 17:48, Jean Delvare <khali@linux-fr.org> wrote:
> I am a little confused by the directories created when one registers a
> class device. When a class device is registered as the children of a
> real device, a subdirectory by the class name is created, and the class
> device is created there, effectively granting each class a separate
> namespace. Example:
>
> /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0
>
> where 0000:00:1f.3 is the physical device, i2c-adapter the class name
> and i2c-0 the class device.
>
> OTOH, if I create a class device as the children of another class
> device, the class device is created directly, without a directory
> between the parent and the child. Example:
>
> /sys/class/i2c-adapter/i2c-0/i2c-0
>
> where the first i2c-0 is an i2c-adapter class device, and the second
> i2c-0 is an i2c-dev class device. I would have expected:
>
> /sys/class/i2c-adapter/i2c-0/i2c-dev/i2c-0
>
> The current behavior seems inconsistent to me. Is it done so on purpose,
> or is this accidental? If on purpose, what's the reason?

It's on purpose. The "glue" directory exists only between class
devices and bus devices. There is no need for class devices to have
such a "glue". When we moved the class devs as childs of the bus devs,
people complained, that they could no longer rename their netif to
"irq", because the name was already taken by a pci dev atrribute. :)

> I am asking because this is causing trouble in practice. We have both
> i2c-dev and firmware_class which try to create class devices by the
> same name and this of course collides. While I would blame
> firmware_class for coming up with an horrible naming scheme (or
> actually, for not coming up with any naming scheme) it might still be a
> good idea to prevent such collisions at the driver core level.

You have multiple instances, which request a firmware file for the
same parent device at the same time? Can't they request the firmware
for the actual child instead of using the same parent?

If the same parent needs to work, the firmware class needs to be fixed
to allow that. Maybe it should use the requested firmware filename
with the '/' translated to '!' as the name in sysfs, instead of the
easy-to-have-a-clash device name of the parent?

Thanks,
Kay
