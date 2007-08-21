Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXHUPSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXHUPSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761457AbXHUPS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:18:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761063AbXHUPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:18:26 -0400
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel
	events? [u]
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <200708211421.16800.aj@ciphirelabs.com>
References: <200708171622.05115.aj@ciphirelabs.com>
	 <20070821073656.GA6691@kroah.com>
	 <1187696468.2489.10.camel@lov.localdomain>
	 <200708211421.16800.aj@ciphirelabs.com>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 17:22:20 +0200
Message-Id: <1187709740.2489.62.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Ok5CqOW7lKgvbsnmhuxGXNLuSxowLfahxxjt
 5w2FdrXjeVmE2WKjvyIFQQgOTxX7BiC7ahDGkcQC3SFRwt8NSu
 1AFj/BZtXYIoklLEQDFQex2S3yzGcum
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 14:21 +0200, Andreas Jellinghaus [c] wrote:
> Am Dienstag, 21. August 2007 schrieb Kay Sievers:
> > The subject says MODALIAS was removed, but I don't think that it ever
> > was there for a usb-device event. And sure, it's still there for a
> > usb-interface event.
> >
> > Andreas, do I read this right, you miss:
> >   DEVICE, PRODUCT, TYPE
> > in the usb-interface event, and they only exist in the usb-device event?
> >
> > And MODALIAS is not what you miss, and the subject of the mail is
> > misleading?
> 
> I'm coming from a different side, as I know not much about the kernel 
> internals. but if I run "udevmonitor --kernel --environment" and then
> plug in some usb device (e.g. my smart card reader):
>  - on 2.6.21 there are two events with DEVICE and the second has DEVICE
>    and MODALIAS set. thats what I need.
>  - on 2.6.22 there are two events: one has DEVICE and one has MODALIAS,
>    but neither has both. this breaks openct. 

Ok, the patch fixes this.

> PRODUCT and TYPE are also missing from the event that has MODALIAS in 2.6.22.
> 
> > Note:
> > DEVICE only exists when USB_DEVICE_CLASS=y,

Oops, I meant USB_DEVICEFS.

> yes, I tested with 2.6.22 with that turned on. if setting this to no breaks
> openct, then we should not easily deprecate it. instead we first need a 
> migration plan, than we need enough time to get a new version of openct to 
> every user that works with the new and the old kernel, and only after that is 
> done we can deprecate it, suggest to turn it of, and even later remove it.
> please keep such a timing, many other parts of the kernel follow these rules
> too. Documentation/feature-removal-schedule.txt should be updated to contain
> exact information how long we can count on USB_DEVICE_CLASS=y etc.

You don't use USB_DEVICE_CLASS devices at all, I guess. Sorry, for the
confusion about the option name.

> > because it unfortunately is 
> > prefixed with the /proc mount path, which doesn't exist when the /proc
> > device node support is not compiled in
> 
> I'm fine with that. people have used that one for years, and they still should 
> have it. if you suggest people should use /dev/bus/usb instead, we need the 
> same plan: migration plan first, enough time to adjust the software and get 
> it to the users, then deprecation plan and later a removeal. maybe add an 
> entry to feature-removal-schedule.txt too? even if only to let everyone
> incl. distribution makers know, that /dev/bus/usb is not an instant 
> replacement for /proc/bus/usb, even if it seems so for some software.

Oh, it's not our call what distros do. There is nothing deprecated and
distros don't need to change anything, if they don't want. It's just
that distros who need to support fast-user-switching and support for
ownership of device nodes for multiple people at the same time, depend
on ACL support and switched to udev managed device nodes for usb
devices.
There is no plan, or removal schedule on the kernel side, it's all up to
the distros to fit their needs.

As an example, openSUSE disabled usbfs and switched entirely
to /dev/bus/usb/ nodes, openct is integrated into HAL instead of udev.
But that does not mean anything for other distros, or the kernel itself.

> > so nothing should depend on the existence of DEVICE. 
> well, first I need the migration plan: so far I could depend on it,
> please give me the new thing that I can depend on. it needs to work
> with old kernels too (something like a 6month to 2year window of kernel,
> we shouldn't force people to upgrade and downgrade kernel and other
> apps unless it is absolutely necessary).

Again, its up to the distro, nothing in the kernel has changed. It's
just that some distros stopped to provide an option the kernel provides,
which doesn't mean that the kernel will remove that feature anytime
soon.

> all discussions I remember ended nowhere: there is no alternative
> for the combination of DEVICE and MODALIAS. I tried /dev/bus/usb
> and sysfs, but it didn't work out because of timing and race conditions
> and other problems you summed up as "there is no sane way" ...

Yes, that was true, there was no sane way, now there is. With the device
nodes exported directly from the usb-device instead of an additional
artificial class device with the timing problems.

> but maybe I got this wrong, so I'm asking once more: DEVICE plus MODALIAS
> is working fine for me, but I'm happy to migrate. what is the plan,
> what shall I do instead? and what is the minimum kernel and udev etc.
> required for this alternative to work? and how long can I count on the
> old style still to work?

It all depends on the distro, DEVICE will not go away from the kernel,
but from some distros.

> > Most of the recent distros don't mount or configure 
> > usbfs anymore, but use /dev/bus/usb/ device nodes, which can handle
> > access control lists for local users.
> 
> that would be a huge problem, as I know no alternative to DEVICE with
> /proc/bus/usb.

The udev event contains DEVNAME, which points you to the device node
in /dev. With the recent kernel, it's just the parent device of the
interface-device you match on. 

Your script could ask from the interface event, which is a child of the
usb-device, the parent device has the node you want to access. Something
like the following should work to get the name of the device node:
  /dev/$(udevinfo --query=name --path=$(dirname /sys/$DEVPATH))

> the kernel tells me about new /proc/bus/usb devices,
> but who tells me about any /dev/bus/usb device?
> as far as I know: no one.
> please correct me if I'm wrong,

Udev, with DEVNAME is doing this, like for all other devices with device
nodes too. But it just does this for the device that created the device
node. You hook into the interface which is a child of the device,
therefore you need to ask with udevinfo.

> I would be real happy to migrate to a working 
> new solution, if it fixes the problem and gives me time for new adventures.

Good luck with the new adventures! :)

If you have further questions about integration into udev, you may start
a new thread at the hotplug list, that is where all the distro
maintainers coordinate their work for things like this.

Thanks,
Kay

