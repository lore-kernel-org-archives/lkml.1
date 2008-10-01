Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYJAQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYJAQwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYJAQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:52:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54230 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYJAQwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:52:04 -0400
Date: Wed, 1 Oct 2008 09:51:05 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH] mm: show node to memory section relationship with
	symlinks in sysfs
Message-ID: <20081001165105.GA7098@us.ibm.com>
References: <1222789837.17630.41.camel@nimitz> <20080930194122.GA7123@us.ibm.com> <20081001103221.306C.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001103221.306C.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:48:29AM +0900, Yasunori Goto wrote:
> > On Tue, Sep 30, 2008 at 08:50:37AM -0700, Dave Hansen wrote:
> > > On Tue, 2008-09-30 at 17:06 +0900, Yasunori Goto wrote:
> > > > > +#define section_nr_to_nid(section_nr) pfn_to_nid(section_nr_to_pfn(section_nr))
> > > > >  #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
> > > > 
> > > > If the first page of the section is not valid, then this section_nr_to_nid()
> > > > doesn't return correct value.
> > > > 
> > > > I tested this patch. In my box, the start_pfn of node 1 is 1200400, but 
> > > > section_nr_to_pfn(mem_blk->phys_index) returns 1200000. As a result,
> > > > the section is linked to node 0.
> > > 
> > > Crap, I was worried about that.
> > > 
> > > Gary, this means that we have a N:1 relationship between NUMA nodes and
> > > sections.  This normally isn't a problem because sections don't really
> > > care about nodes and they layer underneath them.
> > 
> > So, using Yasunori-san's example the memory section starting at
> > pfn 1200000 actually resides on both node 0 and node 1.
> 
> 
> It may be possible that one section is divided to different node in theory.
> (I don't know really there is...)
> 
> But, the cause of my trouble differs from it.
> There is a memory hole which is occupied by firmware.
> So, the memory map of my box is here.
> 
> ----
> early_node_map[3] active PFN ranges
>     0: 0x00000100 -> 0x00006d00
>     0: 0x00408000 -> 0x00410000
>     1: 0x01200400 -> 0x01210000
> ----
> 
> memmap_init() initializes from start_pfn (to end_pfn).
> So, the memmaps for this first hole (0x1200000 - 0x12003ff) are not initialized,
> and node id is not set for them. This is true cause.

Thanks for the clarification.  I think we need to cover both the
theoretical single memory section spanning multiple nodes case
and your memory hole/memory section intersection case.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
