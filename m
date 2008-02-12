Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYBLWGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYBLWGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYBLWGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:06:23 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50273 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbYBLWGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:06:22 -0500
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
From: Dave Hansen <haveblue@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <1202853415.25604.59.camel@dyn9047017100.beaverton.ibm.com>
References: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
	 <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
	 <20080212154309.F9DA.Y-GOTO@jp.fujitsu.com>
	 <1202836953.25604.42.camel@dyn9047017100.beaverton.ibm.com>
	 <1202849972.11188.71.camel@nimitz.home.sr71.net>
	 <1202853415.25604.59.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 14:06:16 -0800
Message-Id: <1202853976.11188.86.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 13:56 -0800, Badari Pulavarty wrote:
> > > +   /*
> > > +    * Its ugly, but this is the best I can do - HELP !!
> > > +    * We don't know where the allocations for section memmap and usemap
> > > +    * came from. If they are allocated at the boot time, they would come
> > > +    * from bootmem. If they are added through hot-memory-add they could be
> > > +    * from sla or vmalloc. If they are allocated as part of hot-mem-add
> > > +    * free them up properly. If they are allocated at boot, no easy way
> > > +    * to correctly free them :(
> > > +    */
> > > +   if (usemap) {
> > > +           if (PageSlab(virt_to_page(usemap))) {
> > > +                   kfree(usemap);
> > > +                   if (memmap)
> > > +                           __kfree_section_memmap(memmap, nr_pages);
> > > +           }
> > > +   }
> > > +}
> > 
> > Do what we did with the memmap and store some of its origination
> > information in the low bits.
> 
> Hmm. my understand of memmap is limited. Can you help me out here ?

Never mind.  That was a bad suggestion.  I do think it would be a good
idea to mark the 'struct page' of ever page we use as bootmem in some
way.  Perhaps page->private?  Otherwise, you can simply try all of the
possibilities and consider the remainder bootmem.  Did you ever find out
if we properly initialize the bootmem 'struct page's?

Please have mercy and put this in a helper, first of all.

static void free_usemap(unsigned long *usemap)
{
	if (!usemap_
		return;

	if (PageSlab(virt_to_page(usemap))) {
		kfree(usemap)
	} else if (is_vmalloc_addr(usemap)) {
		vfree(usemap);
	} else {
		int nid = page_to_nid(virt_to_page(usemap));
		bootmem_fun_here(NODE_DATA(nid), usemap);
	}
}

right?

> I was trying to use free_bootmem_node() to free up the allocations,
> but I need nodeid from which allocation came from :(

How is this any different from pfn_to_nid() on the thing?  Or, can you
not use that because we never init'd the bootmem 'struct page's?

If so, I think the *CORRECT* fix is to give the bootmem areas real
struct pages, probably at boot-time.

-- Dave

