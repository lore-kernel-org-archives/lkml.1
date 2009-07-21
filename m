Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZGUHkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZGUHkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZGUHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:40:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZGUHkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:40:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jul 2009 16:38:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org
Subject: Re: [PATCH] hibernate / memory hotplug: always use
 for_each_populated_zone()
Message-Id: <20090721163846.2a8001c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090721071508.GB12734@osiris.boeblingen.de.ibm.com>
References: <1248103551.23961.0.camel@localhost.localdomain>
	<4A64E1D6.8090102@crca.org.au>
	<20090721071508.GB12734@osiris.boeblingen.de.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 09:15:08 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Tue, Jul 21, 2009 at 07:29:58AM +1000, Nigel Cunningham wrote:
> > Hi.
> > 
> > Gerald Schaefer wrote:
> > > From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > > 
> > > Use for_each_populated_zone() instead of for_each_zone() in hibernation
> > > code. This fixes a bug on s390, where we allow both config options
> > > HIBERNATION and MEMORY_HOTPLUG, so that we also have a ZONE_MOVABLE
> > > here. We only allow hibernation if no memory hotplug operation was
> > > performed, so in fact both features can only be used exclusively, but
> > > this way we don't need 2 differently configured (distribution) kernels.
> > > 
> > > If we have an unpopulated ZONE_MOVABLE, we allow hibernation but run
> > > into a BUG_ON() in memory_bm_test/set/clear_bit() because hibernation
> > > code iterates through all zones, not only the populated zones, in
> > > several places. For example, swsusp_free() does for_each_zone() and
> > > then checks for pfn_valid(), which is true even if the zone is not
> > > populated, resulting in a BUG_ON() later because the pfn cannot be
> > > found in the memory bitmap.
> > 
> > I agree with your logic and patch, but doesn't this also imply that the
> > s390 implementation pfn_valid should be changed to return false for
> > those pages?
> 
> For CONFIG_SPARSEMEM, which s390 uses, there is no architecture specific
> pfn_valid() implementation.
> Also it looks like the semantics of pfn_valid() aren't clear.
> At least for sparsemem it means nothing but "the memmap for the section
> this page belongs to exists". So it just means the struct page for the
> pfn exists.

Historically, pfn_valid() just means "there is a memmap." no other meanings
in any configs/archs.


> We still have pfn_present() for CONFIG_SPARSEMEM. But that just means
> "some pages in the section this pfn belongs to are present."

It just exists for sparsemem internal purpose IIUC.


> So it looks like checking for pfn_valid() and afterwards checking
> for PG_Reserved (?) might give what one would expect.
I think so, too. If memory is offline, PG_reserved is always set.

In general, it's expected that "page is contiguous in MAX_ORDER range"
and no memory holes in MAX_ORDER. In most case, PG_reserved is checked
for skipping not-existing memory.


> Looks all a bit confusing to me.
> Or maybe it's just me who is confused? :)
> 
IIRC, there are no generic interface to know whether there is a physical page.

pfn_valid() is only for memmap and people have used
	if (pfn_valid(pfn) && !PageReserved(page))
check.
But, hmm, If hibernation have to save PG_reserved memory, general solution is
use copy_user_page() and handle fault.

Alternative is making use of walk_memory_resource() as memory hotplug does.
It checks resource information registered.

Thanks,
-Kame





