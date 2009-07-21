Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZGUOKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZGUOKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZGUOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:10:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59854 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZGUOKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:10:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] hibernate / memory hotplug: always use for_each_populated_zone()
Date: Tue, 21 Jul 2009 16:11:08 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org
References: <1248103551.23961.0.camel@localhost.localdomain> <20090721071508.GB12734@osiris.boeblingen.de.ibm.com> <20090721163846.2a8001c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090721163846.2a8001c1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211611.09525.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, KAMEZAWA Hiroyuki wrote:
> On Tue, 21 Jul 2009 09:15:08 +0200
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Tue, Jul 21, 2009 at 07:29:58AM +1000, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > Gerald Schaefer wrote:
> > > > From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > > > 
> > > > Use for_each_populated_zone() instead of for_each_zone() in hibernation
> > > > code. This fixes a bug on s390, where we allow both config options
> > > > HIBERNATION and MEMORY_HOTPLUG, so that we also have a ZONE_MOVABLE
> > > > here. We only allow hibernation if no memory hotplug operation was
> > > > performed, so in fact both features can only be used exclusively, but
> > > > this way we don't need 2 differently configured (distribution) kernels.
> > > > 
> > > > If we have an unpopulated ZONE_MOVABLE, we allow hibernation but run
> > > > into a BUG_ON() in memory_bm_test/set/clear_bit() because hibernation
> > > > code iterates through all zones, not only the populated zones, in
> > > > several places. For example, swsusp_free() does for_each_zone() and
> > > > then checks for pfn_valid(), which is true even if the zone is not
> > > > populated, resulting in a BUG_ON() later because the pfn cannot be
> > > > found in the memory bitmap.
> > > 
> > > I agree with your logic and patch, but doesn't this also imply that the
> > > s390 implementation pfn_valid should be changed to return false for
> > > those pages?
> > 
> > For CONFIG_SPARSEMEM, which s390 uses, there is no architecture specific
> > pfn_valid() implementation.
> > Also it looks like the semantics of pfn_valid() aren't clear.
> > At least for sparsemem it means nothing but "the memmap for the section
> > this page belongs to exists". So it just means the struct page for the
> > pfn exists.
> 
> Historically, pfn_valid() just means "there is a memmap." no other meanings
> in any configs/archs.

Is this documented anywhere actually?

> > We still have pfn_present() for CONFIG_SPARSEMEM. But that just means
> > "some pages in the section this pfn belongs to are present."
> 
> It just exists for sparsemem internal purpose IIUC.
> 
> 
> > So it looks like checking for pfn_valid() and afterwards checking
> > for PG_Reserved (?) might give what one would expect.
> I think so, too. If memory is offline, PG_reserved is always set.
> 
> In general, it's expected that "page is contiguous in MAX_ORDER range"
> and no memory holes in MAX_ORDER. In most case, PG_reserved is checked
> for skipping not-existing memory.

PG_reserved is also set for kernel text, at least on some architectures, and
for some other areas that we want to save.

> > Looks all a bit confusing to me.
> > Or maybe it's just me who is confused? :)
> > 
> IIRC, there are no generic interface to know whether there is a physical page.

We need to know that for hibernation, though.

Well, there is a mechanism for marking making address ranges that are never
to be saved, but they need to be known during initialisation already.

> pfn_valid() is only for memmap and people have used
> 	if (pfn_valid(pfn) && !PageReserved(page))
> check.
> But, hmm, If hibernation have to save PG_reserved memory, general solution is
> use copy_user_page() and handle fault.

That's not exactly straightforward IMHO.

> Alternative is making use of walk_memory_resource() as memory hotplug does.
> It checks resource information registered.

I'd be fine with any _simple_ mechanism allowing us to check whether there's
a physical page frame for given page (or given PFN).

Best,
Rafael
