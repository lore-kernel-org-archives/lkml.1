Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZGEXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZGEXtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZGEXtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 19:49:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45609 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZGEXtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 19:49:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Jul 2009 08:47:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: +
 memory-hotplug-alloc-page-from-other-node-in-memory-online.patch added to
 -mm tree
Message-Id: <20090706084719.4f93179b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090703091206.GA27930@sli10-desk.sh.intel.com>
References: <1246497073.18688.28.camel@localhost.localdomain>
	<20090702102208.ff480a2d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090702144415.8B21.E1E9C6FF@jp.fujitsu.com>
	<alpine.DEB.1.10.0907020929060.32407@gentwo.org>
	<20090703085556.fc711310.kamezawa.hiroyu@jp.fujitsu.com>
	<20090703091206.GA27930@sli10-desk.sh.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 17:12:06 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> On Fri, Jul 03, 2009 at 07:55:56AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Thu, 2 Jul 2009 09:31:04 -0400 (EDT)
> > Christoph Lameter <cl@linux-foundation.org> wrote:
> > 
> > > On Thu, 2 Jul 2009, Yasunori Goto wrote:
> > > 
> > > > However, I don't enough time for memory hotplug now,
> > > > and they are just redundant functions now.
> > > > If someone create new allocator (and unifying bootmem allocator),
> > > > I'm very glad. :-)
> > > 
> > > "Senior"ities all around.... A move like that would require serious
> > > commitment of time. None of us older developers can take that on it
> > > seems.
> > > 
> > > Do we need to accept that the zone and page metadata are living on another
> > > node?
> > > 
> > I don't think so. Someone should do. I just think I can't do it _now_.
> > (because I have more things to do for cgroup..)
> > 
> > And, if not node-hotplug, memmap is allocated from local memory if possible.
> > "We should _never_ allow fallback to other nodes or not" is problem ?
> > I think we should allow fallback.
> > About pgdat, zones, I hope they will be on-cache...
> > 
> > Maybe followings are necessary for allocating pgdat/zones from local node
> > at node-hotplug.
> > 
> >   a) Add new tiny functions to alloacate memory from not-initialized area.
> >      allocate pgdat/memmap from here if necessary.
> >   b) leave allocated memory from (a) as PG_reserved at onlining.
> >   c) There will be "not unpluggable" section after (b). We should show this to
> >      users.
> >   d) For removal, we have to keep precise trace of PG_reserved pages.
> >   e) vmemmap removal, which uses large page for vmemmap, is a problem.
> >      edges of section memmap is not aligned to large pages. Then we need
> >      some clever trick to handle this.
> > 
> > Allocationg memmap from its own section was an idea (I love this) but
> > IBM's 16MB memory section doesn't allow this.
> Adding code for allocation should not be hard, but hard to make the memory
> unpluggable. For example, the vmemmap page table pages can map several
> sections and even several nodes (a pgd page). This will make some sections
> completely not unpluggable if the sections have page table pages.
> Is it possible we can merge the workaround temporarily? Without it, the hotplug
> fails immediately in our side.
> 
ZONE_MOVABLE is for that. I wonder current ZONE_MOVABLE interface is not enough.
If section should be removable later, the section should be onlined as ZONE_MOVABLE
as following.

example)
  echo removable_online > /sys/devices/system/memory/memoryXXX/online


thx,
-Kame

> Thanks,
> Shaohua
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

