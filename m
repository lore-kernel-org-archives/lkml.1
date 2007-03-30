Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXC3WCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXC3WCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXC3WCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:02:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53349 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbXC3WCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:02:40 -0400
X-AuditID: d80ac287-92925bb000000c42-7a-460d89000be7 
Date: Fri, 30 Mar 2007 23:01:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Brian Pomerantz <bapper@piratehaven.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fix page leak during core dump
In-Reply-To: <20070330134359.ec6d95bc.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703302250050.28059@blonde.wat.veritas.com>
References: <20070329203913.GA5190@skull.piratehaven.org>
 <20070330134359.ec6d95bc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 30 Mar 2007 22:01:50.0827 (UTC) FILETIME=[04F9CBB0:01C77317]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:
> On Thu, 29 Mar 2007 13:39:13 -0700
> Brian Pomerantz <bapper@piratehaven.org> wrote:
> 
> > When the dump cannot occur most likely because of a full file system
> > and the page to be written is the zero page, the call to
> > page_cache_release() is missed.
> > 
> > Signed-off-by: Brian Pomerantz <bapper@mvista.com>
> > 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index a2fceba..9cc4f0a 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
> >  				DUMP_SEEK(PAGE_SIZE);
> >  			} else {
> >  				if (page == ZERO_PAGE(addr)) {
> > -					DUMP_SEEK(PAGE_SIZE);
> > +					if (!dump_seek(file, PAGE_SIZE)) {
> > +						page_cache_release(page);
> > +						goto end_coredump;
> > +					}
> 
> Oh for gawds sake I wish we could be rid of those idiotic macros :(
> 
> This patch looks OK to me, although a refcount leak on the ZERO_PAGE is
> special, because that page is PageReserved().
> 
> It used to be the case that we'd ignore attempts to change the refcount on
> reserved pages (or at least on the ZERO_PAGE), but we changed that, so we
> now actually refcount the ZERO_PAGE.  (I think, from a quick read of the
> code.  This contradicts my memory of how it works).
> 
> So I expect the net effect here is that a sufficiently determined attacker
> can overflow the ZERO_PAGE's refcount, thus causing it to be "freed".  The
> page allocator won't actually free the page due to PG_Reserved, but it'll
> all become very noisy.
> 
> Nick, Hugh: agree?

I think so - lots of "Bad page state" messages as the count bounces
around the 0 mark, but not actually freed.  But when CONFIG_DEBUG_VM
you'll get BUG_ONs.  And I can't swear bad things won't happen some-
where once the count wraps to negative.  Easier to fix than work out
the consequences.

(Of course, Nick is right now proposing a patch to take us back the
other way, back to not accounting the ZERO_PAGE: so the fix needs
to go in, then he'll need to reverse that again in his patch.)

Doesn't fs/binfmt_elf_fdpic.c need the same fix?  It looks slightly
different there, but I think when you look closer there's exactly
the same issue?

Hugh
