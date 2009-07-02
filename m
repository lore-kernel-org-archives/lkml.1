Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZGBBYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZGBBYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZGBBXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:23:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40688 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZGBBXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:23:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 10:22:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yakui <yakui.zhao@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: +
 memory-hotplug-alloc-page-from-other-node-in-memory-online.patch added to
 -mm tree
Message-Id: <20090702102208.ff480a2d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1246497073.18688.28.camel@localhost.localdomain>
References: <200906291949.n5TJnuov028806@imap1.linux-foundation.org>
	<alpine.DEB.1.10.0906291804340.21956@gentwo.org>
	<20090630004735.GA21254@sli10-desk.sh.intel.com>
	<20090701025558.GA28524@sli10-desk.sh.intel.com>
	<1246419543.18688.14.camel@localhost.localdomain>
	<alpine.DEB.1.10.0907011317030.9522@gentwo.org>
	<1246497073.18688.28.camel@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jul 2009 09:11:13 +0800
yakui <yakui.zhao@intel.com> wrote:

> On Thu, 2009-07-02 at 01:22 +0800, Christoph Lameter wrote:
> > On Wed, 1 Jul 2009, yakui wrote:
> > 
> > > If we can't allocate memory from other node when there is no memory on
> > > this node, we will have to do something like the bootmem allocator.
> > > After the memory page is added to the system memory, we will have to
> > > free the memory space used by the memory allocator. At the same time we
> > > will have to assure that the hot-plugged memory exists physically.
> > 
> > The bootmem allocator must stick around it seems. Its more like a node
> > bootstrap allocator then.
> > 
> > Maybe we can generalize that. The bootstrap allocator may only need to be
> > able boot one node (which simplifies design). During system bringup only
> > the boot node is brought up.
> > 
> > Then the other nodes are hotplugged later all in turn using the bootstrap
> > allocator for their node setup?
> Your idea looks fragrant. But it seems that it is difficult to realize.
> In the boot phase the bootmem allocator is initialized. And after the
> page buddy mechanism is enabled, the memory space used by bootmem
> allocator will be freed.
> 
> If we also do the similar thing for the hotplugged node, how and when to
> free the memory space used by the bootstrap allocator? It seems that we
> will have to wait before all the memory sections are onlined for this
> hotplugged node. And before all the memory sections are onlined, the
> bootstrap allocator and buddy page allocator will co-exist.
> 

When I was an eager developper of memory hotplug, I planned that.
A special page allocater which works from allocating pgdat until memmap setup.
But there were problems.
example)
  1. We wanted to reuse bootmem.c but it was difficult.
  2. IBM guys uses 16MB section. Then, they cannot allocate local pgdat/memmap
    as other platform which have larger section size.
  3. At memory hotplug, "memory section which includes pgdat for a node should be
     removed after all other sections on the node are removed"
     There is the same problem to memmap.

Because current memory hotplug works sane and above problem was too complicated for
me, I stopped. But there are more NUMAs than we implemented memory hotplug initially.
I hope someone fixes this mis-allocation problem.

IIUC, "3" is the worst problem. It creates dependency among memory.

Thanks,
-Kame







> thanks.
> > 
> > There are a couple of things where one would want to spread out memory
> > across the nodes at boot time. How would node hotplugging handle that
> > situation?
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

