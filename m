Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbZGVA1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbZGVA1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 20:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZGVA1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 20:27:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47097 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZGVA1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 20:27:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jul 2009 09:25:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org
Subject: Re: [PATCH] hibernate / memory hotplug: always use
 for_each_populated_zone()
Message-Id: <20090722092535.5eac1ff6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200907211611.09525.rjw@sisk.pl>
References: <1248103551.23961.0.camel@localhost.localdomain>
	<20090721071508.GB12734@osiris.boeblingen.de.ibm.com>
	<20090721163846.2a8001c1.kamezawa.hiroyu@jp.fujitsu.com>
	<200907211611.09525.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 16:11:08 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 21 July 2009, KAMEZAWA Hiroyuki wrote:
> > On Tue, 21 Jul 2009 09:15:08 +0200
> > Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > > On Tue, Jul 21, 2009 at 07:29:58AM +1000, Nigel Cunningham wrote:
> > > > Hi.
> > > > 
> > > > Gerald Schaefer wrote:
> > > > > From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > > > > 
> > > > > Use for_each_populated_zone() instead of for_each_zone() in hibernation
> > > > > code. This fixes a bug on s390, where we allow both config options
> > > > > HIBERNATION and MEMORY_HOTPLUG, so that we also have a ZONE_MOVABLE
> > > > > here. We only allow hibernation if no memory hotplug operation was
> > > > > performed, so in fact both features can only be used exclusively, but
> > > > > this way we don't need 2 differently configured (distribution) kernels.
> > > > > 
> > > > > If we have an unpopulated ZONE_MOVABLE, we allow hibernation but run
> > > > > into a BUG_ON() in memory_bm_test/set/clear_bit() because hibernation
> > > > > code iterates through all zones, not only the populated zones, in
> > > > > several places. For example, swsusp_free() does for_each_zone() and
> > > > > then checks for pfn_valid(), which is true even if the zone is not
> > > > > populated, resulting in a BUG_ON() later because the pfn cannot be
> > > > > found in the memory bitmap.
> > > > 
> > > > I agree with your logic and patch, but doesn't this also imply that the
> > > > s390 implementation pfn_valid should be changed to return false for
> > > > those pages?
> > > 
> > > For CONFIG_SPARSEMEM, which s390 uses, there is no architecture specific
> > > pfn_valid() implementation.
> > > Also it looks like the semantics of pfn_valid() aren't clear.
> > > At least for sparsemem it means nothing but "the memmap for the section
> > > this page belongs to exists". So it just means the struct page for the
> > > pfn exists.
> > 
> > Historically, pfn_valid() just means "there is a memmap." no other meanings
> > in any configs/archs.
> 
> Is this documented anywhere actually?
> 
When I helped developping SPARSEMEM, I goodled, I found Linus said that ;)
But, from implementaion, it's a very clear fact. See CONFIG_FLATMEM, the simplest
implemenation of memmap. It use a coutinous mem_map regardless of memory holes
and pfn_valid() returns true if pfn < max_mapnr.
#define pfn_valid(pfn)          ((pfn) < max_mapnr)



> > > We still have pfn_present() for CONFIG_SPARSEMEM. But that just means
> > > "some pages in the section this pfn belongs to are present."
> > 
> > It just exists for sparsemem internal purpose IIUC.
> > 
> > 
> > > So it looks like checking for pfn_valid() and afterwards checking
> > > for PG_Reserved (?) might give what one would expect.
> > I think so, too. If memory is offline, PG_reserved is always set.
> > 
> > In general, it's expected that "page is contiguous in MAX_ORDER range"
> > and no memory holes in MAX_ORDER. In most case, PG_reserved is checked
> > for skipping not-existing memory.
> 
> PG_reserved is also set for kernel text, at least on some architectures, and
> for some other areas that we want to save.
> 
yes.

> > > Looks all a bit confusing to me.
> > > Or maybe it's just me who is confused? :)
> > > 
> > IIRC, there are no generic interface to know whether there is a physical page.
> 
> We need to know that for hibernation, though.
> 
> Well, there is a mechanism for marking making address ranges that are never
> to be saved, but they need to be known during initialisation already.
> 
> > pfn_valid() is only for memmap and people have used
> > 	if (pfn_valid(pfn) && !PageReserved(page))
> > check.
> > But, hmm, If hibernation have to save PG_reserved memory, general solution is
> > use copy_user_page() and handle fault.
> 
> That's not exactly straightforward IMHO.
> 
See ia64's ia64_pfn_valid(). It uses get_user() very effectively.
(I think this cost cost is small in any arch...)

 523 ia64_pfn_valid (unsigned long pfn)
 524 {
 525         char byte;
 526         struct page *pg = pfn_to_page(pfn);
 527 
 528         return     (__get_user(byte, (char __user *) pg) == 0)
 529                 && ((((u64)pg & PAGE_MASK) == (((u64)(pg + 1) - 1) & PAGE_MASK))
 530                         || (__get_user(byte, (char __user *) (pg + 1) - 1) == 0));
 531 }

Adding function like this is not very hard.

bool can_access_physmem(unsigned long pfn)
{
	 char byte;
	 char *pg = __va(pfn << PAGE_SHIFT);
	 return (__get_user(byte, pg) == 0)
}

and enough simple. But this may allow you to access remapped device's memory...
Then, some range check will be required anyway.
Can we detect io-remapped range from memmap or any ?
(I think we'll have to skip PG_reserved page...)

> > Alternative is making use of walk_memory_resource() as memory hotplug does.
> > It checks resource information registered.
> 
> I'd be fine with any _simple_ mechanism allowing us to check whether there's
> a physical page frame for given page (or given PFN).
> 

walk_memory_resource() is enough _simple_,  IMHO.
Now, I'm removing #ifdef CONFIG_MEMORY_HOTPLUG for walk_memory_resource() to
rewrite /proc/kcore. 

Thanks,
-Kame

