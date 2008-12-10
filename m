Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYLJSHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYLJSHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYLJSHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:07:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:10480 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYLJSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:07:30 -0500
Message-ID: <ac3eb2510812101007h4e244bf3p44e6eee47193e556@mail.gmail.com>
Date: Wed, 10 Dec 2008 19:07:28 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Mark McLoughlin" <markmc@redhat.com>
Subject: Re: [PATCH 0/6] Clean up virtio device object handling [was Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref]
Cc: "Anthony Liguori" <aliguori@us.ibm.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <1228931096.5384.63.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228394671.3732.77.camel@blaa> <1228489626.3858.37.camel@blaa>
	 <200812071852.08962.rusty@rustcorp.com.au>
	 <1228741409.3609.32.camel@blaa> <493D334D.6050004@us.ibm.com>
	 <1228840890.26198.25.camel@blaa>
	 <ac3eb2510812091016u944d6c9je6ac8470127e5115@mail.gmail.com>
	 <1228902558.5384.19.camel@blaa>
	 <ac3eb2510812100402v58f792e3k6ebd6607495a13bf@mail.gmail.com>
	 <1228931096.5384.63.camel@blaa>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 18:44, Mark McLoughlin <markmc@redhat.com> wrote:
> (Moved from kvm@vger to virtualization@linux-foundation, changed
> subject, cleaned up cc list)
> On Wed, 2008-12-10 at 13:02 +0100, Kay Sievers wrote:
>> On Wed, Dec 10, 2008 at 10:49, Mark McLoughlin <markmc@redhat.com> wrote:
>> > On Tue, 2008-12-09 at 19:16 +0100, Kay Sievers wrote:
>> >> On Tue, Dec 9, 2008 at 17:41, Mark McLoughlin <markmc@redhat.com> wrote:
>> >> > On Mon, 2008-12-08 at 08:46 -0600, Anthony Liguori wrote:
>> >> >> Mark McLoughlin wrote:
>> >> >> > On Sun, 2008-12-07 at 18:52 +1030, Rusty Russell wrote:
>> >> >> >> On Saturday 06 December 2008 01:37:06 Mark McLoughlin wrote:
>> >> >> >>
>> >> >> >>> Another example of a lack of an explicit dependency causing problems is
>> >> >> >>> Fedora's mkinitrd having this hack:
>> >> >> >>>
>> >> >> >>>     if echo $PWD | grep -q /virtio-pci/ ; then
>> >> >> >>>         findmodule virtio_pci
>> >> >> >>>     fi
>> >> >> >>>
>> >> >> >>> which basically says "if this is a virtio device, don't forget to
>> >> >> >>> include virtio_pci in the initrd too!". Now, mkinitrd is full of hacks,
>> >> >> >>> but this is a particularly unusual one.
>> >> >> >>>
>> >> >> >> Um, I don't know what this does, sorry.
>> >> >> >>
>> >> >> >> I have no idea how Fedora chooses what to put in an initrd; I can't think
>> >> >> >> of a sensible way of deciding what goes in and what doesn't other than
>> >> >> >> lists and heuristics.
>> >> >> >>
>> >> >> >
>> >> >> > Fedora's mkinitrd creates an initrd suitable to boot the machine you run
>> >> >> > mkinitrd on, rather than creating an initrd suitable to boot any
>> >> >> > machine.
>> >> >> >
>> >> >> > So, it goes "ah, / is mounted from /dev/vda, we need to include
>> >> >> > virtio_blk and it's dependencies". It does that in a generic way that
>> >> >> > works well for most setups:
>> >> >> >
>> >> >> >   1) Find the device name (e.g. vda) below /sys/block
>> >> >> >
>> >> >> >   2) Follow the 'device' link to e.g. /sys/devices/virtio-pci/virtio1
>> >> >> >
>> >> >> >   3) Find the module need for this through either 'modalias' or the
>> >> >> >      'driver/module' symlink
>> >> >> >
>> >> >> >   4) Use modprobe to list any dependencies of that module
>> >> >> >
>> >> >> > Clearly, virtio-pci won't be pulled in by any of this so we've added a
>> >> >> > hack to say "oh, it's a virtio device, let's include virtio_pci just in
>> >> >> > case".
>> >> >> >
>> >> >> > It's not even the case that mkinitrd needs to know how to include the
>> >> >> > the module for the bus, because in our case that's virtio.ko ... we've
>> >> >> > pretty effectively hidden the the bus *implementation* from userspace.
>> >> >> >
>> >> >> > I don't think this is worth wasting too much time fixing, that's why I'm
>> >> >> > thinking we should just make virtio_pci built-in by default with
>> >> >> > CONFIG_KVM_GUEST.
>> >> >> >
>> >> >>
>> >> >> What if we have multiple virtio transports?
>> >> >
>> >> > I don't think that's so much an an issue (just build in any transport
>> >> > supported by KVM), but rather that you might build a non-pv_ops kernel
>> >> > to run on QEMU which would benefit from using virtio drivers ...
>> >> >
>> >> >>   Is there a way that we can
>> >> >> expose the relationship with virtio-blk and virtio-pci in sysfs?  We
>> >> >> have a struct device for the PCI device, it's just a matter of making
>> >> >> the link visible.
>> >> >
>> >> > It feels a bit like busy work to generalise this since only virtio_pci
>> >> > can be built as a module, but here's a patch.
>> >> >
>> >> > The mkinitrd hack turns into:
>> >> >
>> >> >        # Handle finding virtio bus implementations
>> >> >        if [ -L ./virtio_module ] ; then
>> >> >            findmodule $(basename $(readlink ./virtio_module))
>> >> >        else if echo $PWD | grep -q /virtio-pci/ ; then
>> >> >            findmodule virtio_pci
>> >> >        fi; fi
>> >> >
>> >> > [PATCH] virtio: add a 'virtio_module' sysfs symlink
>> >>
>> >> Doesn't the device have a "driver" link already? If yes, the driver it
>> >> points to should have a "module" link.
>> >
>> > The virtio bus is an abstraction that has several different backend
>> > implementations - currently virtio-pci, lguest and kvm-s390.
>> >
>> > So yes, the driver/module link gives us the device driver, but the
>> > virtio_module link is to the virtio bus driver (aka implementation,
>> > transport, backend, ...):
>> >
>> >  $> basename $(readlink virtio_module)
>> >  virtio_pci
>> >  $> basename $(readlink driver/module)
>> >  virtio_net
>>
>> I see. But why not just call it "module", like we do in all other
>> places, when it points to /sys/module/.
>>
>> To find dependent modules, you would walk up the chain of parents, and
>> include everything that is found by looking for "driver/module" and
>> "module" links?
>>
>> Wouldn't that make it completely generic, without any virtio specific hacks?
>
> Yeah, that sounds much better - a minor detail is that it'd be better to
> hang the symlink off each virtio implementation's root object rather
> than off each device.

Sounds good, if the devices below can never be from different modules
at the same time.

> To that end, I've hacked up register_virtio_root_device() which fixes
> the fact that we statically allocate root objects and gives us a sane
> place to add this generic symlink.

Fine.

> It might make sense to add this to the core, though - e.g.
> device_register_root() - and that would also allow us use the same
> approach as module_add_driver() to add the module symlink for built-in
> modules.

Sure, I see no problem moving that over when things work out as expected.

Looks all fine from a short look over it. Also thanks for converting
to allocated struct device, and the bus_id conversion.

Kay
