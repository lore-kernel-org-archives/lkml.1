Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYAHWY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYAHWY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYAHWYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:24:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYAHWYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:24:17 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: The ext3 way of journalling
To: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>
Reply-To: 7eggert@gmx.de
Date: Tue, 08 Jan 2008 23:24:06 +0100
References: <9JpbI-5yi-9@gated-at.bofh.it> <9JpEP-6df-25@gated-at.bofh.it> <9JpYc-6Eb-13@gated-at.bofh.it> <9Jqhr-7l9-13@gated-at.bofh.it> <9JqKt-7Z5-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JCMre-0001B2-GY@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/9vK+7JmYiIPFC7KTWnTz2I8WHMEEhaLbfS5K
 GTIZBWIRuIBDcBQSZDtIc/u2YkO1qtbjYxCZNvhQ8ZPetHftP0
 pKphTeKZyt8/3E1PLrVsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuomo Valkonen <tuomov@iki.fi> wrote:
> On 2008-01-08, Jan Engelhardt <jengelh@computergmbh.de> wrote:

>> "Power users" may still
>> use the index= option of sound card modules and wire it up in
>> /etc/modprobe.d if they prefer.
> 
> Another very cryptic directory whose contents say nothing to me.
> Configuration files should be self-documenting and editable,
> instead having to be created based on long documentation.
> The simple /etc/modules -- which at least Debian's stock kernels
> do not use -- qualifies, but few other files these days do.
> 
>> You can guess my answer: udev will fix it.
> 
> And break everything else, such as my symlinks, permissions, etc.
> I'm not going to learn its cryptic special-case config files for
> such trivial tasks as creating a fucking symlink or change the
> permissions of a file, for which exist general purpose methods:
> chmod, chown, ln -s.

Edit the start script, append your commands to create the links.
Or edit the correct file in /etc/udev/rules.d to include the links.

>> Well what do you expect of it? The kernel does not keep USB port <->
>> SCSI device mappings. Neither USB device <-> SCSI device mapping,
>> because not all USB ports or USB devices are mass-storage devices.
>> It just is not the kernel's job.
> 
> Mapping everything to scsi nodes is brain damaged. The old hda, hdb,
> etc. mappings had somewhat clear correspondence between to physical
> evice addresses, and were easy to use without such complicated crap
> as udev. Of course, I'd prefer just device unique IDs being used,
> where possible... but I'm not going to suffer udev for that.

If you wire your devices to a named/numbered port, you can use one device
node for each port. Therefore it's sane to create hda to hdd, fd0 to fd3,
etc. But if you don't have a fixed mapping (USB), or if you'd have too
many possible (and mostly unused) ports for the available amount of devices
(SCSI), you can not create fixed numbers. Even for hde ..., you have no
native ordering, you can only tell the first controller from the rest.

When the SCSI naming was created, there were at most 256 SCSI devices of
each kind. Since each partition is a SCSI device, too, you had at most
16 disks of up to 15 partitions! This was later extended to 128 disks.
If you'd hardcode the controller, linux would have been unable to support
more than 8 SCSI controllers.

The result was the semi-random enumeration of the SCSI devices, and all
the hacks trying to work around that. (google for Joerg Schilling lkml)
Udev provides a clean way of naming the devices, using the static
information from the devices or the path.

I agree that the current udev documentation makes it hard to even find the
settings you'd like to change. That's because the documentation is meant
for developers, while the configuration is themed by the distribution.

The udev files itself are as simple as possible. Imagine them to be
<bloat>XML</bloat>, like the pile of HAL, DBUS and KDE automatically
mounting my disks using the wrong settings into the wrong directory
and forcing me to su in order to umount them! I temporarily beat that
beast, but the kill is still on the TODO list. Maybe as soon as I find
more^W usable^W documentation ...

>> May I remind you that the kernel also "loses" all your network interface
>> configuration, routes, firewalling rules and all sysctl settings at
>> boot (sic: reboot & powerdown).
> 
> But traditional /dev does not lose permissions and symlinks. udev
> tmpfs shadow brain damage does. You have to illogically and
> inconveniently edit udev's cryptic config files instead, and yet
> it in no way stops /dev from being modified.

You aren't stopped from directly poking the memory and crashing the systems
either - if you are root. Or from deleting all nodes on a classic /dev.
Don't do that then.

>> Nonsense. The kernel notices udev about all available hardware and udev
>> will load modules. It has nothing to do with initrd, in fact, this very
>> step of loading a gazillion of modules is done after initrd has passed
>> control on to /sbin/init. At least, in opensuse.
> 
> I've never seen a system that would do so. And I won't use udev.

No system can load modules that are not on initrd, and only needed-for-boot
modules are usually put on the initrd. The bulk of modules must be loaded
from the real root.  This seems to work quite well (except not here because
I prefer to include all necessary drivers in the kernel.)

I've debugged hotplug, too, and I found it was a wrapper around a wrapper
around ... a script that would be supposed to load the required firmware,
except it did neither load it nor provide a way to find out why it didn't.
Each HOWTO mentioned a different directory to use, and a different filename.
I'd have settled for manually loading the firmware, but hacking the scripts
to pieces was finally easier than finding out how I was supposed to do that.

I did not need to install a firmware after this, therefore I don't know if
udev is better, but it CAN'T be worse.

