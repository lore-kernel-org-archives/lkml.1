Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZGCJMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZGCJMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZGCJMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:12:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:44068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZGCJMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,340,1243839600"; 
   d="scan'208";a="704757780"
Date: Fri, 3 Jul 2009 17:12:06 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: +
	memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
	added to -mm tree
Message-ID: <20090703091206.GA27930@sli10-desk.sh.intel.com>
References: <1246497073.18688.28.camel@localhost.localdomain> <20090702102208.ff480a2d.kamezawa.hiroyu@jp.fujitsu.com> <20090702144415.8B21.E1E9C6FF@jp.fujitsu.com> <alpine.DEB.1.10.0907020929060.32407@gentwo.org> <20090703085556.fc711310.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703085556.fc711310.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 07:55:56AM +0800, KAMEZAWA Hiroyuki wrote:
> On Thu, 2 Jul 2009 09:31:04 -0400 (EDT)
> Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > On Thu, 2 Jul 2009, Yasunori Goto wrote:
> > 
> > > However, I don't enough time for memory hotplug now,
> > > and they are just redundant functions now.
> > > If someone create new allocator (and unifying bootmem allocator),
> > > I'm very glad. :-)
> > 
> > "Senior"ities all around.... A move like that would require serious
> > commitment of time. None of us older developers can take that on it
> > seems.
> > 
> > Do we need to accept that the zone and page metadata are living on another
> > node?
> > 
> I don't think so. Someone should do. I just think I can't do it _now_.
> (because I have more things to do for cgroup..)
> 
> And, if not node-hotplug, memmap is allocated from local memory if possible.
> "We should _never_ allow fallback to other nodes or not" is problem ?
> I think we should allow fallback.
> About pgdat, zones, I hope they will be on-cache...
> 
> Maybe followings are necessary for allocating pgdat/zones from local node
> at node-hotplug.
> 
>   a) Add new tiny functions to alloacate memory from not-initialized area.
>      allocate pgdat/memmap from here if necessary.
>   b) leave allocated memory from (a) as PG_reserved at onlining.
>   c) There will be "not unpluggable" section after (b). We should show this to
>      users.
>   d) For removal, we have to keep precise trace of PG_reserved pages.
>   e) vmemmap removal, which uses large page for vmemmap, is a problem.
>      edges of section memmap is not aligned to large pages. Then we need
>      some clever trick to handle this.
> 
> Allocationg memmap from its own section was an idea (I love this) but
> IBM's 16MB memory section doesn't allow this.
Adding code for allocation should not be hard, but hard to make the memory
unpluggable. For example, the vmemmap page table pages can map several
sections and even several nodes (a pgd page). This will make some sections
completely not unpluggable if the sections have page table pages.
Is it possible we can merge the workaround temporarily? Without it, the hotplug
fails immediately in our side.

Thanks,
Shaohua
