Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZIQMDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZIQMDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZIQMDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:03:21 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:37559 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZIQMDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:03:20 -0400
MIME-Version: 1.0
In-Reply-To: <m1y6oef08k.fsf@fess.ebiederm.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 17 Sep 2009 14:03:09 +0200
Message-ID: <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:23, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> devtmpfs has numerous problems.  The once I see from a quick review.
> - devtmpfs steals i_private from tmpfs (a layering/maintenance horror)

I can't see the horror.

> - devtmpfs is missing calls to mnt_want_write.

If you think we miss something, we are glad to add it, if you point it out.

> - device_add does not clean up it's devtmpfs node on error

That's fixable, if the remove event is not already taking care of it.

> - The filesystem does not live under fs/ where it can be found.
> - The Kconfig entry is not under Filesystems.

It's a special-purpose superblock, not a filesystem. The filesystem is
still 100% tmpfs. Devtmpfs is just a companion to the driver core's
sysfs, hence the code is in the driver core. The code does not
implement any kind of filesystem, it just populates a tmpfs
superblock.

> - The fundamental justification for devtmpfs is bogus.
>  devtmpfs is not faster nor does it solve the hotplug problem.

It's not about speed, as stated many many times. Please read the archives.

>  * A static dev is faster.

A static /dev is unreliable and unpredictable, and can not be used in
any not very limited and controlled environment. It's pure theory for
the systems out there, it just does not work with todays dynamic
major/minors. You will never know which actual kernel device you open
from your static /dev entries. Unless someone converts the many
subsytems across the entire kernel, this is just not an option to even
think about.

Eric, ever wondered why all the people working in hotplug area,
maintaining todays systems, and even the ones who wrote udev, want
this? And only people who have never written any code in hotplug land
like to object to it? There seems a big disconnect here.

>  * Dynamically creating dev entries (in userspace) is not slow.

Again, it's not about speed, it's about simplicity, reliability and
synchronous vs. asynchronous behavior.

>    Fundamentally it should be the same amount of time as it is the
>    same amount of work.

It's the synchronous context of sysfs. It's not interesting to compare
the overall work. We create the device in /sys, there is no reason not
to provide the device node at the same time.

>  * People actively write/depend on udev rules to the file names in /dev.

No, the sysfs names give the the device names. And udev can overwrite
the kernel supplied names, which it doesn't. That all still works the
same way with devtmpfs. Udev runs just fine on top of it. It even
removes the kernel created device node if asked for.

>    Perhaps they are just for the creation of symlink to the filenames
>    specified in Documentation/devices.txt but regardless device names
>    not documented in Documentation/devices.txt are used in the real
>    world. (i.e. udev still handles naming).

No, udev does not name devices, it's the kernel. There have been a few
trivial exceptions, but they are all in the kernel today. Please make
yourself familiar how things work.

>  * If you are truly dealing with hotplug events in userspace
>    it is necessary to listen to uevents and react which
>    last I checked is role of udev.

I don't understand. Udev applies the final policy including
permissions/ownership, just as before. There is no differrence. It's
just that you can bring up a box without complex userspace to
bootstrap /dev. And that's a big win on its own. And things like
"modprobe loop; losetup /dev/loop0" will just work, which it doesn't
with todays async udev. Again, please make yourself familiar how
things work, and what the problems are.

> - Once everyone starts using devtmpfs it will be a serious technical
>  problem for containers.

This is not different from todays udev or sysfs. Also udev runs fine
with plain tmpfs.

> - Reportedly devtmpfs is mandatory in the latest version of Suse
>  so claiming it is experimental and if unsure say N seems like
>  the wrong advice, and a serious misnomer.

openSUSE uses it, but it runs fine without devtmpfs.

> Who places a filesystem in drivers/core/ and not even
> in the filesystem Kconfig menu?

As stated, it's a special-purpose superblock, and not a filesystem at all.

> Additionally Greg KH and Kay Sievers have a bad track record of fixing
> filesystem bugs in sysfs, which I see no reason will not continue with
> devtmpfs.

Oh, interesting. Any points to working fixes we missed?

Your last series was way over the top, you did not even boot a box
with it and it broke things in obvious ways when I ran it. I thought
we applied all your working fixes, and asked you to rebase the rest,
and skip the stuff that caused the breakage. I think you never did.
Some of the things showed problems in other subsystem which needed to
be fixed, and some of these things got fixed. So please send out a
rebased _and_ tested series again.

Thanks,
Kay
