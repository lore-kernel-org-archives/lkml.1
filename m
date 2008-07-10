Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbYGJQwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbYGJQwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYGJQwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:52:31 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:34081 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750881AbYGJQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:52:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FKOqXPYd/SyKJAoPmIVQjUlhTH3gmOkwDrcPnAsgo3n1qXnbZuDAk7mCXBmkfJEMQUpw1ayIq2Z+NQxnuU8yGMzvdIr2ECw1emTe0My2x5NR4Ql7hNjgvWEeqUYuwwr3zaRK1CNOntZOCGZyECC0WCscJ6yFd2Otj9lb7eDzVrc=  ;
X-YMail-OSG: BY0EkngVM1ne89LaFBDkrSlpmg2FK5u4.x9GXWNCuHBGJ1IHZkjJRTfEE_d1bhk_XmQ8VJZptHX6PpAWUfsnzFN94ipOCl5ZqGWA7QhnlREOMD0xbyyLMrBFWtql1F77aX8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Date: Fri, 11 Jul 2008 02:52:00 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       cl@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
References: <20080703213348.489120321@attica.americas.sgi.com> <200807110021.29392.nickpiggin@yahoo.com.au> <20080710163329.GB1860@sgi.com>
In-Reply-To: <20080710163329.GB1860@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807110252.00887.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 02:33, Jack Steiner wrote:
> On Fri, Jul 11, 2008 at 12:21:28AM +1000, Nick Piggin wrote:
> > On Thursday 10 July 2008 23:29, Jack Steiner wrote:
> > > On Thu, Jul 10, 2008 at 05:31:54PM +1000, Nick Piggin wrote:
> > > > On Thursday 10 July 2008 05:11, Jack Steiner wrote:
> > > > > I'll post the new GRU patch in a few minutes.
> > > >
> > > > It looks broken to me. How does it determine whether it has a
> > > > normal page or not?
> > >
> > > Right. Hugepages are not currently supported by the GRU. There is code
> > > that I know is missing/broken in this path. I'm trying to get the core
> > > driver accepted, then I'll get the portion dealing with hugepages
> > > working.
> >
> > Oh, I meant "normal" pages as in vm_normal_page(), or is there some
> > other reason this codepath is exempt from them?
>
> Maybe...
>
> The GRU deals with cacheable memory only (the check is currently missing).
> What is the proper way to catch a reference to a PTE that maps something
> other than normal cacheable memory. Note that we support XPMEM. Some
> cacheable memory that is valid for GRU references will be memory located on
> other partitions. No page struct entries will exist nor will the physical
> address ranges be known to the kernel. (Not in efi/e820 tables).
>
> One idea that I had was to use the attributes of the PTE. Is there
> better way. vm_flags? ???
>
> Ideas???

lockless gup checks for struct page by checking a bit in the pte.
This should be enough to guarantee  it is cacheable memory (unless
another driver has done something tricky like set the the page's
cache attributes to UC or WC -- I don't know if there is a way to
completely avoid all corner cases).


> > Using gup.c code I don't think will prevent your driver from getting
> > accepted. Conversely, I would not like the open coded page table walk
> > to go upstream...
>
> If that is the concensus, that is ok. How certain are we that gup.c will
> go into 2.6.27.

Linus sounded pretty happy to merge gup as soon as 2.6.27 opens
when I asked.


> Initially, I though it was cleaner to decouple the GRU 
> from gup.c & to wait until I had all the hugepage & ia64 issues resolved
> before trying to push the walker into the kernel.

If you're just getting things working in -mm I don't mind one way
or the other I guess. But it should not get merged like that.


> (The driver runs ok as 
> long as huge pages are not referenced. It detects attempts to reference
> hugepages and gives the user an error).
>
> We would also need a gup.c for ia64.

That may not be such a bad idea. Don't know if they have a spare pte bit.
