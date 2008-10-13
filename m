Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbYJMQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbYJMQee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYJMQe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:34:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56529 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbYJMQeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:34:25 -0400
Date: Mon, 13 Oct 2008 09:34:16 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, pbadari@us.ibm.com,
       mel@csn.ul.ie, lcm@us.ibm.com, mingo@elte.hu, greg@kroah.com,
       dave@linux.vnet.ibm.com, nish.aravamudan@gmail.com
Subject: Re: [PATCH 1/2] [REPOST] mm: show node to memory section
	relationship with symlinks in sysfs
Message-ID: <20081013163416.GA7340@us.ibm.com>
References: <20081009192115.GB8793@us.ibm.com> <20081010124239.f92b5568.akpm@linux-foundation.org> <20081010213357.GD7369@us.ibm.com> <20081010145950.f51def29.akpm@linux-foundation.org> <20081010231844.GA1718@us.ibm.com> <20081010163230.ae9d964d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010163230.ae9d964d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 04:32:30PM -0700, Andrew Morton wrote:
> On Fri, 10 Oct 2008 16:18:44 -0700
> Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > On Fri, Oct 10, 2008 at 02:59:50PM -0700, Andrew Morton wrote:
> > > On Fri, 10 Oct 2008 14:33:57 -0700
> > > Gary Hade <garyhade@us.ibm.com> wrote:
> > > 
> > > > On Fri, Oct 10, 2008 at 12:42:39PM -0700, Andrew Morton wrote:
> > > > > On Thu, 9 Oct 2008 12:21:15 -0700
> > > > > Gary Hade <garyhade@us.ibm.com> wrote:
> > > > > 
> > > > > > Show node to memory section relationship with symlinks in sysfs
> > > > > > 
> > > > > > Add /sys/devices/system/node/nodeX/memoryY symlinks for all
> > > > > > the memory sections located on nodeX.  For example:
> > > > > > /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> > > > > > indicates that memory section 135 resides on node1.
> > > > > 
> > > > > I'm not seeing here a description of why the kernel needs this feature.
> > > > > Why is it useful?  How will it be used?  What value does it have to
> > > > > our users?
> > > > 
> > > > Sorry, I should have included that.  In our case, it is another
> > > > small step towards eventual total node removal.  We will need to
> > > > know which memory sections to offline for whatever node is targeted
> > > > for removal.  However, I suspect that exposing the node to section
> > > > information to user-level could be useful for other purposes.
> > > > For example, I have been thinking that using memory hotremove
> > > > functionality to modify the amount of available memory on specific
> > > > nodes without having to physically add/remove DIMMs might be useful
> > > > to those that test application or benchmark performance on a
> > > > multi-node system in various memory configurations.
> > > > 
> > > 
> > > hm, OK, thanks.  It does sound a bit thin, and if we merge this then
> > > not only do we get a porkier kernel,
> > 
> > Would you feel the same about the size increase if patch 2/2 (include
> > memory section subtree in sysfs with only sparsemem enabled) was
> > withdrawn?
> > 
> > Without patch 2/2 the size increase for non-Sparsemem or Sparsemem
> > wo/memory hotplug kernels is extremely small.  Even for memory hotplug
> > enabled kernels there is only a little extra code in ./drivers/base/node.o
> > which only gets linked into NUMA enabled kernels.  I can gather some numbers
> > if necessary.
> 
> Size is probably a minor issue on memory-hotpluggable machines.
> 
> > > we also get a new userspace interface which we're then locked into.
> > 
> > True.
> 
> That's a bigger issue.  The later we leave this sort of thing, the more
> information we have.

I understand your concerns about adding possibly frivolous interfaces
but in this case we are simply eliminating a very obvious hole in the
existing set of memory hot-add/remove interfaces.  In general, it
makes absolutely no sense to provide a resource add/remove mechanism
without telling the user where the resource is physically located.
i.e. providing the _maximum_ possible amount of location information
available for the add/remove controllable resource.  This is especially
critical for large multi-node systems and for resources that can impact
application or overall system performance.

The kernel already exports node location information for CPUs
(e.g. /sys/devices/system/node/node0/cpu0 -> ../../cpu/cpu0) and
PCI devices (e.g. ./devices/pci0000:00/0000:00:00.0/numa_node).
Why should memory be treated any differently?

The memory hot-add/remove interfaces include physical device files
(e.g. /sys/devices/system/memory/memory0/phys_device) which are not
yet fully implemented.  When systems that support removable memory
modules force this interface to mature, node location information
will become even more critical.  This feature will not be very useful
on multi-node systems if the user does not know what node a specific
memory module is installed in.  It may be possible to encode the
node ID into the string provided by the phys_device file but a
more general node to memory section association as provided by this
patch is better since it can be used for other purposes.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

