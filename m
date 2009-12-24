Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZLXEwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZLXEwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZLXEwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:52:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55260 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZLXEwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:52:49 -0500
MIME-Version: 1.0
In-Reply-To: <4B32A09D.30400@codemonkey.ws>
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> 
	<4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> 
	<4B3103B4.4070708@gmail.com> <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com> 
	<4B3232A1.8050505@codemonkey.ws> <20091223195413.GB30700@ovro.caltech.edu> 
	<4B32A09D.30400@codemonkey.ws>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 23 Dec 2009 23:52:28 -0500
Message-ID: <f73f7ab80912232052u5248c652h8e6d0637897cd5af@mail.gmail.com>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 17:58, Anthony Liguori <anthony@codemonkey.ws> wrote:
> On 12/23/2009 01:54 PM, Ira W. Snyder wrote:
>> On Wed, Dec 23, 2009 at 09:09:21AM -0600, Anthony Liguori wrote:
>>> But both virtio-lguest and virtio-s390 use in-band enumeration and
>>> discovery since they do not have support for PCI on either platform.
>>
>> I'm interested in the same thing, just over PCI. The only PCI agent
>> systems I've used are not capable of manipulating the PCI configuration
>> space in such a way that virtio-pci is usable on them.
>
> virtio-pci is the wrong place to start if you want to use a PCI *device* as
> the virtio bus. virtio-pci is meant to use the PCI bus as the virtio bus.
>  That's a very important requirement for us because it maintains the
> relationship of each device looking like a normal PCI device.
>
>> This means
>> creating your own enumeration mechanism. Which sucks.
>
> I don't think it sucks.  The idea is that we don't want to unnecessarily
> reinvent things.
>
> Of course, the key feature of virtio is that it makes it possible for you to
> create your own enumeration mechanism if you're so inclined.

See... the thing is... a lot of us random embedded board developers
don't *want* to create our own enumeration mechanisms.  I see a huge
amount of value in vbus as a common zero-copy DMA-capable
virtual-device interface, especially over miscellaneous non-PCI-bus
interconnects.  I mentioned my PCI-E boards earlier, but I would also
personally be interested in using infiniband with RDMA as a virtual
device bus.

Basically, what it comes down to is vbus is practically useful as a
generic way to provide a large number of hotpluggable virtual devices
across an arbitrary interconnect.  I agree that virtio works fine if
you have some out-of-band enumeration and hotplug transport (like
emulated PCI), but if you *don't* have that, it's pretty much faster
to write your own set of paired network drivers than it is to write a
whole enumeration and transport stack for virtio.

On top of *that*, with the virtio approach I would need to write a
whole bunch of tools to manage the set of virtual devices on my custom
hardware.  With vbus that management interface would be entirely
common code across a potentially large number of virtualized physical
transports.

If vbus actually gets merged I will most likely be able to spend the
time to get the PCI-E crosslinks on my boards talking vbus, otherwise
it's liable to get completely shelved as "not worth the effort" to
write all the glue to make virtio work.

>> See my virtio-phys
>> code (http://www.mmarray.org/~iws/virtio-phys/) for an example of how I
>> did it. It was modeled on lguest. Help is appreciated.
>
> If it were me, I'd take a much different approach.  I would use a very
> simple device with a single transmit and receive queue.  I'd create a
> standard header, and the implement a command protocol on top of it. You'll
> be able to support zero copy I/O (although you'll have a fixed number of
> outstanding requests).  You would need a single large ring.

That's basically about as much work as writing entirely new network
and serial drivers over PCI.  Not only that, but I   The beauty of
vbus for me is that I could write a fairly simple logical-to-physical
glue driver which lets vbus talk over my PCI-E or infiniband link and
then I'm basically done.

Not only that, but the tools for adding new virtual devices (ethernet,
serial, block, etc) over vbus would be the same no matter what the
underlying transport.

> But then again, I have no idea what your requirements are.  You could
> probably get far treating the thing as a network device and just doing ATAoE
> or something like that.

<sarcasm>Oh... yes... clearly the right solution is to forgo the whole
zero-copy direct DMA of block writes and instead shuffle the whole
thing into 16kB ATAoE packets.  That would obviously be much faster on
my little 1GHz PowerPC boards </sarcasm>

Sorry for the rant, but I really do think vbus is a valuable
technology and it's a damn shame to see Gregory Haskins being put
through this whole hassle.  While most everybody else was griping
about problems he sat down and wrote some very nice clean maintainable
code to do what he needed.  Not only that, but he designed a good
enough model that it could be ported to run over almost everything
from a single PCI-E link to an infiniband network.

I personally would love to see vbus merged, into staging at the very
least.  I would definitely spend some time trying to make it work
across PCI-E on my *very* *real* embedded boards.  Look at vbus not as
another virtualization ABI, but as a multiprotocol high-level device
abstraction API that already has one well-implemented and
high-performance user.

Cheers,
Kyle Moffett
