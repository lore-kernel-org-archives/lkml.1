Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYJaBNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYJaBNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYJaBNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:13:40 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:18954 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYJaBNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:13:39 -0400
Subject: Re: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST /
	unable to handle kernel NULL pointer dereference in sysfs_create_link
From: Kay Sievers <kay.sievers@vrfy.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510810301623n6a7256a1td59d3e38a01add4c@mail.gmail.com>
References: <20081028151157.GI11214@vanheusden.com>
	 <ac3eb2510810281607o19266977l4c77d3d3ab4bb849@mail.gmail.com>
	 <20081029094041.GO11214@vanheusden.com>
	 <ac3eb2510810290525h1579bad8i4836ce1291d9022@mail.gmail.com>
	 <20081029132704.GS11214@vanheusden.com>
	 <ac3eb2510810290749o2dd062b5m7b966d2d25b69714@mail.gmail.com>
	 <20081029152550.GT11214@vanheusden.com>
	 <ac3eb2510810291451u577aa825lc12a7e8fbc213020@mail.gmail.com>
	 <20081030105513.GY11214@vanheusden.com>
	 <ac3eb2510810301606q5ff8e001j239c5108c3db4b6f@mail.gmail.com>
	 <ac3eb2510810301623n6a7256a1td59d3e38a01add4c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 02:13:40 +0100
Message-Id: <1225415620.2667.27.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 00:23 +0100, Kay Sievers wrote:
> On Fri, Oct 31, 2008 at 00:06, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Thu, Oct 30, 2008 at 11:55, Folkert van Heusden
> > <folkert@vanheusden.com> wrote:
> >>> >> >> >> > While running my http://vanheusden.com/pyk/ script (which randomly
> >>> >> >> >> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
> >>> >> >> >> > kernel on an IBM xSeries 260. This oops (in fact no oops at all) did not
> >>> >> >> >> > get triggered in a 2.6.18 kernel on that system.
> >>> >> >> >> >
> >>> >> >> >> > [   42.507375] FDC 0 is a National Semiconductor PC87306
> >>> >> >> >> > [   42.509057] kobject_add_internal failed for 2:0 with -EEXIST, don't try to register things with the same name in the same directory.
> >>> >> >> >> > [   42.509291] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
> >>> >> >> >> > [   42.509431]
> >>> >> >> >> > [   42.509433] Call Trace:
> >>> >> >> >> > [   42.509685]  [<ffffffff8031b031>] kobject_add_internal+0x13f/0x17e
> >>> >> > ...
> >>> >> >> >> > [   42.511519]  [<ffffffff8027d23b>] bdi_register+0x57/0xb4
> >>> >> >> >>
> >>> >> >> >> Looks like bdi sees two devices with the same devnum, or didn't
> >>> >> >> >> cleanup an old entry. What does: ls -l "/sys/class/bdi/" print?
> >>> >> >> >
> >>> >> >> > The following:
> >>> >> >> > folkert@debiantesthw:~$ ls -l /sys/class/bdi/
> >>> >> >> > drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:0
> >>> >> >> > drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:1
> >>> >> >>
> >>> >> >> Oh, you are running the old sysfs layout without symlinks. Care to
> >>> >> >> tell where the "device" link in these directories points to?
> >>> >> >
> >>> >> > None exist:
> >>> >> > folkert@debiantesthw:~$ ls -la /sys/class/bdi/*/device
> >>> >> > ls: cannot access /sys/class/bdi/*/device: No such file or directory
> >>> >>
> >>> >> Ah, sorry. Seems the bdi stuff never got to pass the usual parent
> >>> >> device with the device registration, to let the bdi device show up at
> >>> >> the right place in the device tree.
> >>> >>
> >>> >> Let's see what current devices on your box have the major 2:
> >>> >>   find /sys -name dev | xargs grep '^2:'
> >>> >
> >>> > /sys/block/fd0/dev:2:0
> >>> > /sys/block/fd1/dev:2:1
> >>> >
> >>> > As my script does modprobe/rmmod in parallel (4 processes) maybe it is a
> >>> > conflict of one process doing an modprobe of floppy while the other does
> >>> > an rmmod? Or both a modprobe?
> >>>
> >>> Might be, yes. If you just bootup, and don't run your modprobe/rmmod
> >>> script, does the box have 2 floppy devices in /sys too?
> >>
> >> Yes it does. One physical drive.
> >
> > Seems that always happens with multiple floppies. I can reproduce it
> > here with qemu. It seems not related to modprobing. Also mtd devices
> > suffer from the same problem, as bug reports show.
> >
> > It might be a bug in bdi. Looks like floppies share a single queue,
> > the bdi structure lives in the queue. Now we register for every device
> > a bdi device, but the queue is shared and the former recorded dev_t in
> > the bdi structure is overwritten. At unregistering the bdi device, all
> > earlier devices using the same queue are not removed.
> >
> > Peter, please check, if something like this can happen?
> 
> Ok, I get annoyed by these sysfs bugs. :)
> 
> Peter, it looks like bdi does not work for devices which share a single queue.
> If I add:
>   --- a/mm/backing-dev.c
>  +++ b/mm/backing-dev.c
>   @@ -184,6 +184,8 @@ int bdi_register(struct backing_dev_info *bdi,
> struct device *parent,
>                   goto exit;
>           }
> 
>   +       printk("XXXXXXX old bdidev is %p\n", bdi->dev);
>   +       printk("XXXXXXX new bdidev is %p\n", dev);
>           bdi->dev = dev;
>           bdi_debug_register(bdi, dev_name(dev));
> 
> I get:
>   $ modprobe floppy
>   Floppy drive(s): fd0 is 1.44M, fd1 is 1.44M
>   FDC 0 is a S82078B
>   XXXXXXX old bdidev is 0000000000000000
>   XXXXXXX new bdidev is ffff88001f20cd10
>   XXXXXXX old bdidev is ffff88001f20cd10
>   XXXXXXX new bdidev is ffff88001f20de30
> 
> which very much looks like bdi will not remove any earlier registered
> device, only the last one, right?

This fixes it for me.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: bdi: register sysfs bdi device only once per queue

Devices which share the same queue, like floppies and mtd devices,
get registered multiple times in the bdi interface, but bdi accounts
only the last registered device of the devices sharing one queue.

On remove, all earlier registered devices leak, stay around in
sysfs, and cause "duplicate filename" errors if the devices are
recreated.

This prevents the creation of multiple bdi interfaces per queue,
and the bdi device will carry the dev_t name of the block device
which is the first one registered, of the pool of devices using
the same queue.

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f2e574d..e6676e5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	int ret = 0;
 	struct device *dev;
 
+	if (bdi->dev)
+		goto exit;
+
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);


