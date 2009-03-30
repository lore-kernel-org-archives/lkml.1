Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZC3QeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZC3QeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZC3QeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:34:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36313 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZC3QeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:34:12 -0400
Date: Mon, 30 Mar 2009 18:34:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com, riel@redhat.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
Message-ID: <20090330183405.750440da@skybase>
In-Reply-To: <1238428495.8286.638.camel@nimitz>
References: <20090327150905.819861420@de.ibm.com>
	<1238195024.8286.562.camel@nimitz>
	<20090329161253.3faffdeb@skybase>
	<1238428495.8286.638.camel@nimitz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 08:54:55 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Sun, 2009-03-29 at 16:12 +0200, Martin Schwidefsky wrote:
> > > Can we persuade the hypervisor to tell us which pages it decided to page
> > > out and just skip those when we're scanning the LRU?
> > 
> > One principle of the whole approach is that the hypervisor does not
> > call into an otherwise idle guest. The cost of schedulung the virtual
> > cpu is just too high. So we would a means to store the information where
> > the guest can pick it up when it happens to do LRU. I don't think that
> > this will work out.
> 
> I didn't mean for it to actively notify the guest.  Perhaps, as Rik
> said, have a bitmap where the host can set or clear bit for the guest to
> see.

Yes, agreed.

> As the guest is scanning the LRU, it checks the structure (or makes an
> hcall or whatever) and sees that the hypervisor has already taken care
> of the page.  It skips these pages in the first round of scanning.

As long as we make this optional I'm fine with it. On s390 with the
current implementation that translates to an ESSA call. Which is not
exactly inexpensive, we are talking about > 100 cycles. The better
solution for us is to age the page with the standard active/inactive
processing.

> I do see what you're saying about this saving the page-*out* operation
> on the hypervisor side.  It can simply toss out pages instead of paging
> them itself.  That's a pretty advanced optimization, though.  What would
> this code look like if we didn't optimize to that level?

Why? It is just a simple test in the hosts LRU scan. If the page is at
the end of the inactive list AND has the volatile state then don't
bother with writeback, just throw it away. This is the only place where
the host has to check for the page state. 

> It also occurs to me that the hypervisor could be doing a lot of this
> internally.  This whole scheme is about telling the hypervisor about
> pages that we (the kernel) know we can regenerate.  The hypervisor
> should know a lot of that information, too.  We ask it to populate a
> page with stuff from virtual I/O devices or write a page out to those
> devices.  The page remains volatile until something from the guest
> writes to it.  The hypervisor could keep a record of how to recreate the
> page as long as it remains volatile and clean.

Unfortunately it is not that simple. There are quite a few reasons why
a page has to be made stable. You'd have to pass that information back
and forth between the guest and the host otherwise the host will throw
away e.g. an mlocked page because it is still marked as volatile in the
virtual block device.

> That wouldn't cover things like page cache from network filesystems,
> though.  

Yes, there are pages with a backing the host knows nothing about.

> This patch does look like the full monty but I have to wonder what other
> partial approaches are out there.  

I am open for suggestions. The simples partial approach is already
implemented for s390: unused/stable transitions in the buddy allocator.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

