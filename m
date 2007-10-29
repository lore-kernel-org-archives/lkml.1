Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXJ2WRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXJ2WRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJ2WRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:17:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXJ2WRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:17:37 -0400
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stefani@seibold.net,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1193681839.27652.60.camel@twins>
References: <1193064057.16541.1.camel@matrix>
	 <20071029004002.60c7182a.akpm@linux-foundation.org>
	 <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
	 <1193677302.27652.56.camel@twins>
	 <45a44e480710291051s7ffbb582x64ea9524c197b48a@mail.gmail.com>
	 <1193681839.27652.60.camel@twins>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 23:16:50 +0100
Message-Id: <1193696211.5644.100.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-29 at 19:17 +0100, Peter Zijlstra wrote:
> On Mon, 2007-10-29 at 13:51 -0400, Jaya Kumar wrote:
> > On 10/29/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Mon, 2007-10-29 at 01:17 -0700, Jaya Kumar wrote:
> > > > An aside, I just tested that deferred IO works fine on 2.6.22.10/pxa255.
> > > >
> > > > I understood from the thread that PeterZ is looking into page_mkclean
> > > > changes which I guess went into 2.6.23. I'm also happy to help in any
> > > > way if the way we're doing fb_defio needs to change.
> > >
> > > OK, seems I can't read. Or at least, I missed a large part of the
> > > problem.
> > >
> > > page_mkclean() hasn't changed, it was ->page_mkwrite() that changed. And
> > > looking at the fb_defio code, I'm not sure I understand how its
> > > page_mkclean() use could ever have worked.
> > >
> > > The proposed patch [1] only fixes the issue of ->page_mkwrite() on
> > > vmalloc()'ed memory. Not page_mkclean(), and that has never worked from
> > > what I can make of it.
> > >
> > > Jaya, could you shed some light on this? I presume you had your display
> > > working.
> > >
> > 
> > I thought I had it working. I saw the display update after each
> > mmap/write sequence to the framebuffer. I need to check if there's an
> > munmap or anything else going on in between write sequences that would
> > cause it to behave like page_mkclean was working.
> > 
> > Is it correct to assume that page_mkclean should mark the pages
> > read-only so that the next write would again trigger mkwrite?
> 
> Well, yes, that is the intended behaviour.
> 
> >  Even if the page was from a vmalloc_to_page()?
> 
> That is the crux, I only ever implemented it for file pages.

Hmm, so these vmalloc pages are mapped into user-space with
remap_pfn_range(), which doesn't have any form of rmap. That is, given a
pfn there is no way to obtain all ptes for it. So the interface to
page_mkclean() could never work for these (as it only provides a struct
page *).

[ also, remap_vmalloc_range() suffers similar issues, only file and anon
  have proper rmap ]

I'm not sure we want full rmap for remap_pfn/vmalloc_range, but perhaps
we could assist drivers in maintaining and using vma lists.

I think page_mkclean_one() would work if you'd manually set page->index
and iterate the vmas yourself. Although atm I'm not sure of anything so
don't pin me on it.

