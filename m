Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYJNLyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYJNLyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbYJNLyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:54:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41653 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbYJNLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:54:23 -0400
Date: Tue, 14 Oct 2008 20:54:21 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 1/2] [REPOST] mm: show node to memory section relationship with symlinks in sysfs
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, pbadari@us.ibm.com, mel@csn.ul.ie,
       lcm@us.ibm.com, mingo@elte.hu, greg@kroah.com, dave@linux.vnet.ibm.com,
       nish.aravamudan@gmail.com
In-Reply-To: <20081013163416.GA7340@us.ibm.com>
References: <20081010163230.ae9d964d.akpm@linux-foundation.org> <20081013163416.GA7340@us.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081014201346.AD7D.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Oct 10, 2008 at 04:32:30PM -0700, Andrew Morton wrote:
> > On Fri, 10 Oct 2008 16:18:44 -0700
> > Gary Hade <garyhade@us.ibm.com> wrote:
> > 
> > > On Fri, Oct 10, 2008 at 02:59:50PM -0700, Andrew Morton wrote:
> > > > On Fri, 10 Oct 2008 14:33:57 -0700
> > > > Gary Hade <garyhade@us.ibm.com> wrote:
> > > > 
> > > > > On Fri, Oct 10, 2008 at 12:42:39PM -0700, Andrew Morton wrote:
> > > > > > On Thu, 9 Oct 2008 12:21:15 -0700
> > > > > > Gary Hade <garyhade@us.ibm.com> wrote:
> > > > > > 
> > > > > > > Show node to memory section relationship with symlinks in sysfs
> > > > > > > 
> > > > > > > Add /sys/devices/system/node/nodeX/memoryY symlinks for all
> > > > > > > the memory sections located on nodeX.  For example:
> > > > > > > /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> > > > > > > indicates that memory section 135 resides on node1.
> > > > > > 
> > > > > > I'm not seeing here a description of why the kernel needs this feature.
> > > > > > Why is it useful?  How will it be used?  What value does it have to
> > > > > > our users?
> > > > > 
> > > > > Sorry, I should have included that.  In our case, it is another
> > > > > small step towards eventual total node removal.  We will need to
> > > > > know which memory sections to offline for whatever node is targeted
> > > > > for removal.  However, I suspect that exposing the node to section
> > > > > information to user-level could be useful for other purposes.
> > > > > For example, I have been thinking that using memory hotremove
> > > > > functionality to modify the amount of available memory on specific
> > > > > nodes without having to physically add/remove DIMMs might be useful
> > > > > to those that test application or benchmark performance on a
> > > > > multi-node system in various memory configurations.
> > > > > 
> > > > 
> > > > hm, OK, thanks.  It does sound a bit thin, and if we merge this then
> > > > not only do we get a porkier kernel,
> > > 
> > > Would you feel the same about the size increase if patch 2/2 (include
> > > memory section subtree in sysfs with only sparsemem enabled) was
> > > withdrawn?
> > > 
> > > Without patch 2/2 the size increase for non-Sparsemem or Sparsemem
> > > wo/memory hotplug kernels is extremely small.  Even for memory hotplug
> > > enabled kernels there is only a little extra code in ./drivers/base/node.o
> > > which only gets linked into NUMA enabled kernels.  I can gather some numbers
> > > if necessary.
> > 
> > Size is probably a minor issue on memory-hotpluggable machines.
> > 
> > > > we also get a new userspace interface which we're then locked into.
> > > 
> > > True.
> > 
> > That's a bigger issue.  The later we leave this sort of thing, the more
> > information we have.
> 
> I understand your concerns about adding possibly frivolous interfaces
> but in this case we are simply eliminating a very obvious hole in the
> existing set of memory hot-add/remove interfaces.  In general, it
> makes absolutely no sense to provide a resource add/remove mechanism
> without telling the user where the resource is physically located.
> i.e. providing the _maximum_ possible amount of location information
> available for the add/remove controllable resource.  This is especially
> critical for large multi-node systems and for resources that can impact
> application or overall system performance.
> 
> The kernel already exports node location information for CPUs
> (e.g. /sys/devices/system/node/node0/cpu0 -> ../../cpu/cpu0) and
> PCI devices (e.g. ./devices/pci0000:00/0000:00:00.0/numa_node).
> Why should memory be treated any differently?
> 
> The memory hot-add/remove interfaces include physical device files
> (e.g. /sys/devices/system/memory/memory0/phys_device) which are not
> yet fully implemented.  When systems that support removable memory
> modules force this interface to mature, node location information
> will become even more critical.  This feature will not be very useful
> on multi-node systems if the user does not know what node a specific
> memory module is installed in.  It may be possible to encode the
> node ID into the string provided by the phys_device file but a
> more general node to memory section association as provided by this
> patch is better since it can be used for other purposes.

Sorry for late responce.

Our fujitsu box can hot-add a node. This means a user/script has to
find which memory sections and cpus belong to added node when node hot-add
is executed. 

Current my hotplug script is very poor. It onlines all offlined cpus and memories. 
However if user offlined one memory section intentionally due to
memory error message, the script can't understand it is intended, and hot-add
the error section. I think this is one of reason why this link is necessary.



I think not only node id, but I would like to show _PXM value of ACPI to specify
physical position of the node. Because node id is decided by OS at boot time
(and hot-add time) to make it consecutive.
(This is historical inheritance when there is no macro like
 for_each_online_cpus().)

If a system has 2 nodes whose _PXM values are 0 and 3, and boot up,
then kernel make node id 0 and 1 for them, and when hot-add a node
whose _PXM value is 1, then new node id will be 2.

  _PXM      0      1      3
  node id   0      2      1

When user reboot the system, then node id will be followings.
User will be confused by this.
  _PXM      0      1      3
  node id   0      1      2

Current kernel may allow "node id = _PXM", because for_each_xxx_node() works
well now. But I'm not sure....

Bye.

-- 
Yasunori Goto 


