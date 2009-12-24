Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZLXRJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZLXRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 12:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZLXRJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 12:09:46 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:48742 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZLXRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 12:09:45 -0500
Message-ID: <4B33A053.9090009@codemonkey.ws>
Date: Thu, 24 Dec 2009 11:09:39 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: Kyle Moffett <kyle@moffetthome.net>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com> <4B3232A1.8050505@codemonkey.ws> <20091223195413.GB30700@ovro.caltech.edu> <4B32A09D.30400@codemonkey.ws> <20091223234256.GC30700@ovro.caltech.edu>
In-Reply-To: <20091223234256.GC30700@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 05:42 PM, Ira W. Snyder wrote:
>
> I've got a single PCI Host (master) with ~20 PCI slots. Physically, it
> is a backplane in a cPCI chassis, but the form factor is irrelevant. It
> is regular PCI from a software perspective.
>
> Into this backplane, I plug up to 20 PCI Agents (slaves). They are
> powerpc computers, almost identical to the Freescale MPC8349EMDS board.
> They're full-featured powerpc computers, with CPU, RAM, etc. They can
> run standalone.
>
> I want to use the PCI backplane as a data transport. Specifically, I
> want to transport ethernet over the backplane, so I can have the powerpc
> boards mount their rootfs via NFS, etc. Everyone knows how to write
> network daemons. It is a good and very well known way to transport data
> between systems.
>
> On the PCI bus, the powerpc systems expose 3 PCI BAR's. The size is
> configureable, as is the memory location at which they point. What I
> cannot do is get notified when a read/write hits the BAR. There is a
> feature on the board which allows me to generate interrupts in either
> direction: agent->master (PCI INTX) and master->agent (via an MMIO
> register). The PCI vendor ID and device ID are not configureable.
>
> One thing I cannot assume is that the PCI master system is capable of
> performing DMA. In my system, it is a Pentium3 class x86 machine, which
> has no DMA engine. However, the PowerPC systems do have DMA engines. In
> virtio terms, it was suggested to make the powerpc systems the "virtio
> hosts" (running the backends) and make the x86 (PCI master) the "virtio
> guest" (running virtio-net, etc.).

IMHO, virtio and vbus are both the wrong model for what you're doing. 
The key reason why is that virtio and vbus are generally designed around 
the concept that there is shared cache coherent memory from which you 
can use lock-less ring queues to implement efficient I/O.

In your architecture, you do not have cache coherent shared memory. 
Instead, you have two systems connected via a PCI backplace with 
non-coherent shared memory.

You probably need to use the shared memory as a bounce buffer and 
implement a driver on top of that.

> I'm not sure what you're suggesting in the paragraph above. I want to
> use virtio-net as the transport, I do not want to write my own
> virtual-network driver. Can you please clarify?

virtio-net and vbus are going to be overly painful for you to use 
because no one end can access arbitrary memory in the other end.

> Hopefully that explains what I'm trying to do. I'd love someone to help
> guide me in the right direction here. I want something to fill this need
> in mainline.

If I were you, I would write a custom network driver.  virtio-net is 
awfully small (just a few hundred lines).  I'd use that as a basis but I 
would not tie into virtio or vbus.  The paradigms don't match.

> I've been contacted seperately by 10+ people also looking
> for a similar solution. I hunch most of them end up doing what I did:
> write a quick-and-dirty network driver. I've been working on this for a
> year, just to give an idea.

The whole architecture of having multiple heterogenous systems on a 
common high speed backplane is what IBM refers to as "hybrid computing". 
  It's a model that I think will be come a lot more common in the 
future.  I think there are typically two types of hybrid models 
depending on whether the memory sharing is cache coherent or not.  If 
you have coherent shared memory, the problem looks an awfully lot like 
virtualization.  If you don't have coherent shared memory, then the 
shared memory basically becomes a pool to bounce into and out-of.

> PS - should I create a new thread on the two mailing lists mentioned
> above? I don't want to go too far off-topic in an alacrityvm thread. :)

Couldn't hurt.

Regards,

Anthony Liguori
