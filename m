Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZDZNmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZDZNmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZDZNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:42:42 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60193 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDZNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <20090426085401.3788fc9c@hyperion.delvare>
References: <20090329174836.6de797d6@hyperion.delvare> <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<20090330104952.26f03c13@hyperion.delvare> <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com> 
	<20090426085401.3788fc9c@hyperion.delvare>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 26 Apr 2009 15:42:25 +0200
Message-ID: <ac3eb2510904260642s66a15a8eg5811fdc6b339d493@mail.gmail.com>
Subject: Re: Class device namespaces
To: Jean Delvare <khali@linux-fr.org>
Cc: Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 08:54, Jean Delvare <khali@linux-fr.org> wrote:
> But anyway, this isn't going to happen quickly, and I still believe we
> should solve the namespace problem I reported.

I think the real namespace problem lives well inside the i2c devices,
not in the core. :) Sure, the firmware class is pretty dumb with its
naming, but the root case is the way i2c devices are created.

First, i2c stacks class devices, which it should not do, it should use
a bus not a class, if it has device <-> children relations between
different types.

Second, it names all the devices from different classes with the
_same_ name, then puts them in a hierarchy, and the tries to mix-in a
third class, the firmware class, which also uses the _same_ name. That
just asks for trouble. :)

> For firmware, it doesn't seem as legitimate, I can't really think of a
> good reason to use the i2c-adapter as the parent for the firmware
> device.

Oh, I may miss something, I thought that is what you already do and
causes the problem? I though you use the "adapter" to request the
firmware? Otherwise I don't see how this can conflict.

You have the "adapter" and the "device" stacked, right?
  /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/i2c-0/

Then you use the adapter:
   /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0
to request the firmware, which will try to create:
  /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/i2c-0/

I thought you could use the "device" and not the "adapter" to request
the firmware? Then you would get a "nice" chain of devices with all
the same names, like :)
   /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/i2c-0/i2c-0/

I see the following options:
  - the i2c "device", not the "adapter" would request the firmware

  - the i2c-adapter converts to a bus, and is no longer a class

  - i2c "adapters" and "devices" don't get the same duplicated name

  - if "adapters" can only ever have a single "device", the
    both could just be merged to a single instance, and maybe compat
    symlinks created

  - the firmware class adds a firmware-% prefix in the case the
    requesting device is a class device, and not the common case
    which is a bus device

  - change the "glue dir" rules, which I would try to avoid, because
    we don't know who else might stack class devices of different
    classes, and might get surprised by this

What do you think?

Thanks,
Kay
