Return-Path: <linux-kernel-owner+w=401wt.eu-S939054AbXHIJvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939054AbXHIJvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXHIJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:50:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:56189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764009AbXHIJu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:50:57 -0400
Subject: Re: [PATCH/RFC] allow mapping from block-device-file to sysfs
	entry.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Neil Brown <neilb@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <18106.47442.440816.650446@notabene.brown>
References: <18104.3098.696484.970773@notabene.brown>
	 <1186468623.2700.4.camel@laptopd505.fenrus.org>
	 <18104.7056.369176.547630@notabene.brown>
	 <3ae72650708070041s52861b7dr484cacf98353a3c6@mail.gmail.com>
	 <18106.47442.440816.650446@notabene.brown>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 11:54:10 +0200
Message-Id: <1186653250.21247.37.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19W2ZKDW34aeOD2COoHhWYlv5Flf8jNT13VGDk
 wojO0DJSem+E+Ye4xce1m/m9sKP237vb0pifgv+6uOQaLCO9O6
 XmuNtSUdABk4pEPFyC4KOptapIFIEXC
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 16:50 +1000, Neil Brown wrote:
> On Tuesday August 7, kay.sievers@vrfy.org wrote:
> > On 8/7/07, Neil Brown <neilb@suse.de> wrote:
> > > On Monday August 6, arjan@infradead.org wrote:
> > > > On Tue, 2007-08-07 at 16:07 +1000, Neil Brown wrote:
> > > > > Suppose that in a program I have an open file descriptor for a device,
> > > > > and I want to find the /sys/block information for this device.
> > > > > There is currently no direct way to do this.  I need to read
> > > > >    /sys/block/*/dev, /sys/block/*/*/dev
> > > > > and match major/minor numbers with the result from fstat.
> > > > >
> > > > > I would like a more direct mechanism.
> > 
> >   $ udevinfo --query=path --name=sda
> >   /block/sda
> 
> If I interpret the result of 'strace' properly, this looks at
>    /dev/.udev/names/sda
> and prints the result after decoding '\x2f' as '/'.
> I want to go from an open file descriptor, or at least an entry in
> /dev.

Right, it maintains two indices, one from the devpath to the /dev-name,
and one from the /dev-name to the devpath.

> And I don't think I want to depend on udev if I can avoid it....
> 
> > >
> > > That makes a lot of sense.
> > > So it would return "block/sda/sda1" now,
> > 
> > Every devpath always starts with a '/' in the kernel, its kind of
> > weird, but we should not introduce a new variation of it. :)
> 
> Fair comment.  So
>        /block/sda/sda1
> now, and whatever later.

Right.

> > They can be definitely longer than than 256, probably not longer than
> > 512 today, but you can't be sure about that.
> 
> I guess we go for PATH_MAX then?

Maybe, yes.

> Any idea how to get a sysfs path in a generic way?

No, no idea.

> I tried:
> 		struct inode *inode = filp->f_path.dentry->d_inode;
> 		struct kobject *ko = NULL;
> 		char *path = NULL;
> 		if (S_ISBLK(inode->i_mode) &&
> 		    inode->i_bdev &&
> 			inode->i_bdev->bd_disk)
> 			ko = &inode->i_bdev->bd_disk->kobj;
> 		if (S_ISCHR(inode->i_mode) &&
> 		    inode->i_cdev)
> 			ko = &inode->i_cdev->kobj;
> 		if (ko)
> 			path = kobject_get_path(ko, GFP_KERNEL);
> 
> 
> For /dev/sda, it returns /block/sda which is good.
> For /dev/sda1 it still returns /block/sda which is not good.

You have to explicitely handle partitions by looking at the minor
number. They are not registered in the kobj_map.

> For /dev/null it returns /mem which doesn't even exist in sysfs

In the kobj_map is only the minor _range_ of the subsystem, which is
able to resolve the minor to the object.

> For /dev/tty it doesn't return anything.

Same here.

> I'm tempted to just implement it for block devices and let someone
> else worry about char devices.

We probably want to extend kobj_map with something where _every_ device
is registered, not only the "handler" for a region of devices.

Today, when you open a device, the "driver" gets called and it looks up
the device by traversing over a list of known devices, or some using idr
internally for this. In /proc/devices are the registered "handlers", you
can't get more than this. The "mem" entry there, is what you are looking
up, but which device (devpath) it is, is hidden inside the mem class.

Seems block devices are special here, and register every genhd directly
and make them accessible the way you try to do it. Not sure if that will
work for all block devices in all cases though.

Would be nice if generic kernel code (the kobj_map) could just return a
pointer back to the kobject for _every_ major/minor combination, instead
of only the pointer into the subsystem (which registered a range). Today
every subsystem implements its own way of doing the lookup for the
object the minor number belongs to. That would be the right place to
solve this problem. :)

Kay

