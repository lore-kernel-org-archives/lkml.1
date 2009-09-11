Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZIKPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZIKPRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZIKPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:17:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:20743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbZIKPRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,370,1249282800"; 
   d="scan'208";a="726079886"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "gregory.haskins@gmail.com" <gregory.haskins@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "s.hetze@linux-ag.com" <s.hetze@linux-ag.com>
Date: Fri, 11 Sep 2009 23:17:33 +0800
Subject: RE: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Thread-Topic: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Thread-Index: AcowwWX/F+DiTtfHR6uaB3YEadPi2wCLS5tg
Message-ID: <C85CEDA13AB1CF4D9D597824A86D2B9006AECB9C1D@PDSMSX501.ccr.corp.intel.com>
References: <cover.1251388414.git.mst@redhat.com>
 <20090827160750.GD23722@redhat.com>
 <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com>
 <20090908172035.GB319@ovro.caltech.edu> <20090908201428.GA12420@redhat.com>
In-Reply-To: <20090908201428.GA12420@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,
We are very interested in your patch and want to have a try with it.
I have collected your 3 patches in kernel side and 4 patches in queue side.
The patches are listed here:

PATCHv5-1-3-mm-export-use_mm-unuse_mm-to-modules.patch
PATCHv5-2-3-mm-reduce-atomic-use-on-use_mm-fast-path.patch
PATCHv5-3-3-vhost_net-a-kernel-level-virtio-server.patch

PATCHv3-1-4-qemu-kvm-move-virtio-pci[1].o-to-near-pci.o.patch
PATCHv3-2-4-virtio-move-features-to-an-inline-function.patch
PATCHv3-3-4-qemu-kvm-vhost-net-implementation.patch
PATCHv3-4-4-qemu-kvm-add-compat-eventfd.patch

I applied the kernel patches on v2.6.31-rc4 and the qemu patches on latest kvm qemu.
But seems there are some patches are needed at least irqfd and ioeventfd patches on
current qemu. I cannot create a kvm guest with "-net nic,model=virtio,vhost=vethX".

May you kindly advice us the patch lists all exactly to make it work?
Thanks a lot. :-)

Thanks
Xiaohui
-----Original Message-----
From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Michael S. Tsirkin
Sent: Wednesday, September 09, 2009 4:14 AM
To: Ira W. Snyder
Cc: netdev@vger.kernel.org; virtualization@lists.linux-foundation.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; mingo@elte.hu; linux-mm@kvack.org; akpm@linux-foundation.org; hpa@zytor.com; gregory.haskins@gmail.com; Rusty Russell; s.hetze@linux-ag.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server

On Tue, Sep 08, 2009 at 10:20:35AM -0700, Ira W. Snyder wrote:
> On Mon, Sep 07, 2009 at 01:15:37PM +0300, Michael S. Tsirkin wrote:
> > On Thu, Sep 03, 2009 at 11:39:45AM -0700, Ira W. Snyder wrote:
> > > On Thu, Aug 27, 2009 at 07:07:50PM +0300, Michael S. Tsirkin wrote:
> > > > What it is: vhost net is a character device that can be used to reduce
> > > > the number of system calls involved in virtio networking.
> > > > Existing virtio net code is used in the guest without modification.
> > > > 
> > > > There's similarity with vringfd, with some differences and reduced scope
> > > > - uses eventfd for signalling
> > > > - structures can be moved around in memory at any time (good for migration)
> > > > - support memory table and not just an offset (needed for kvm)
> > > > 
> > > > common virtio related code has been put in a separate file vhost.c and
> > > > can be made into a separate module if/when more backends appear.  I used
> > > > Rusty's lguest.c as the source for developing this part : this supplied
> > > > me with witty comments I wouldn't be able to write myself.
> > > > 
> > > > What it is not: vhost net is not a bus, and not a generic new system
> > > > call. No assumptions are made on how guest performs hypercalls.
> > > > Userspace hypervisors are supported as well as kvm.
> > > > 
> > > > How it works: Basically, we connect virtio frontend (configured by
> > > > userspace) to a backend. The backend could be a network device, or a
> > > > tun-like device. In this version I only support raw socket as a backend,
> > > > which can be bound to e.g. SR IOV, or to macvlan device.  Backend is
> > > > also configured by userspace, including vlan/mac etc.
> > > > 
> > > > Status:
> > > > This works for me, and I haven't see any crashes.
> > > > I have done some light benchmarking (with v4), compared to userspace, I
> > > > see improved latency (as I save up to 4 system calls per packet) but not
> > > > bandwidth/CPU (as TSO and interrupt mitigation are not supported).  For
> > > > ping benchmark (where there's no TSO) troughput is also improved.
> > > > 
> > > > Features that I plan to look at in the future:
> > > > - tap support
> > > > - TSO
> > > > - interrupt mitigation
> > > > - zero copy
> > > > 
> > > 
> > > Hello Michael,
> > > 
> > > I've started looking at vhost with the intention of using it over PCI to
> > > connect physical machines together.
> > > 
> > > The part that I am struggling with the most is figuring out which parts
> > > of the rings are in the host's memory, and which parts are in the
> > > guest's memory.
> > 
> > All rings are in guest's memory, to match existing virtio code.
> 
> Ok, this makes sense.
> 
> > vhost
> > assumes that the memory space of the hypervisor userspace process covers
> > the whole of guest memory.
> 
> Is this necessary? Why?

Because with virtio ring can give us arbitrary guest addresses.  If
guest was limited to using a subset of addresses, hypervisor would only
have to map these.

> The assumption seems very wrong when you're
> doing data transport between two physical systems via PCI.
> I know vhost has not been designed for this specific situation, but it
> is good to be looking toward other possible uses.
> 
> > And there's a translation table.
> > Ring addresses are userspace addresses, they do not undergo translation.
> > 
> > > If I understand everything correctly, the rings are all userspace
> > > addresses, which means that they can be moved around in physical memory,
> > > and get pushed out to swap.
> > 
> > Unless they are locked, yes.
> > 
> > > AFAIK, this is impossible to handle when
> > > connecting two physical systems, you'd need the rings available in IO
> > > memory (PCI memory), so you can ioreadXX() them instead. To the best of
> > > my knowledge, I shouldn't be using copy_to_user() on an __iomem address.
> > > Also, having them migrate around in memory would be a bad thing.
> > > 
> > > Also, I'm having trouble figuring out how the packet contents are
> > > actually copied from one system to the other. Could you point this out
> > > for me?
> > 
> > The code in net/packet/af_packet.c does it when vhost calls sendmsg.
> > 
> 
> Ok. The sendmsg() implementation uses memcpy_fromiovec(). Is it possible
> to make this use a DMA engine instead?

Maybe.

> I know this was suggested in an earlier thread.

Yes, it might even give some performance benefit with e.g. I/O AT.

> > > Is there somewhere I can find the userspace code (kvm, qemu, lguest,
> > > etc.) code needed for interacting with the vhost misc device so I can
> > > get a better idea of how userspace is supposed to work?
> > 
> > Look in archives for kvm@vger.kernel.org. the subject is qemu-kvm: vhost net.
> > 
> > > (Features
> > > negotiation, etc.)
> > > 
> > 
> > That's not yet implemented as there are no features yet.  I'm working on
> > tap support, which will add a feature bit.  Overall, qemu does an ioctl
> > to query supported features, and then acks them with another ioctl.  I'm
> > also trying to avoid duplicating functionality available elsewhere.  So
> > that to check e.g. TSO support, you'd just look at the underlying
> > hardware device you are binding to.
> > 
> 
> Ok. Do you have plans to support the VIRTIO_NET_F_MRG_RXBUF feature in
> the future? I found that this made an enormous improvement in throughput
> on my virtio-net <-> virtio-net system. Perhaps it isn't needed with
> vhost-net.

Yes, I'm working on it.

> Thanks for replying,
> Ira
--
To unsubscribe from this list: send the line "unsubscribe kvm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
