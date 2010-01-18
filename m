Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938Ab0AROYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0AROYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505Ab0AROYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:24:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0AROYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:24:05 -0500
Date: Tue, 19 Jan 2010 01:23:59 +1100
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 5/8] vmalloc: simplify vread()/vwrite()
Message-ID: <20100118142359.GA14472@laptop>
References: <20100113135305.013124116@intel.com>
 <20100113135957.833222772@intel.com>
 <20100114124526.GB7518@laptop>
 <20100118133512.GC721@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118133512.GC721@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 09:35:12PM +0800, Wu Fengguang wrote:
> On Thu, Jan 14, 2010 at 05:45:26AM -0700, Nick Piggin wrote:
> > On Wed, Jan 13, 2010 at 09:53:10PM +0800, Wu Fengguang wrote:
> > > vread()/vwrite() is only called from kcore/kmem to access one page at a time.
> > > So the logic can be vastly simplified.
> > > 
> > > The changes are:
> > > - remove the vmlist walk and rely solely on vmalloc_to_page()
> > > - replace the VM_IOREMAP check with (page && page_is_ram(pfn))
> > > - rename to vread_page()/vwrite_page()
> > > 
> > > The page_is_ram() check is necessary because kmap_atomic() is not
> > > designed to work with non-RAM pages.
> > 
> > I don't know if you can really do this. Previously vmlist_lock would be
> > taken, which will prevent these vm areas from being freed.
> >  
> > > Note that even for a RAM page, we don't own the page, and cannot assume
> > > it's a _PAGE_CACHE_WB page.
> > 
> > So why is this not a problem for your patch? I don't see how you handle
> > it.
> 
> Sorry I didn't handle it. Just hope to catch attentions from someone
> (ie. you :).
> 
> It's not a problem for x86_64 at all. For others I wonder if any
> driver will vmalloc HIGHMEM pages with !_PAGE_CACHE_WB attribute..
> 
> So I noted the possible problem and leave it alone.

Well it doesn't need to be vmalloc. Any kind of vmap like ioremap. And
these can be accompanied by changing the caching attribute. Like agp
code, for an example. But I don't know if that ever becomes a problem
in practice.


> > What's the problem with the current code, exactly? I would prefer that
> 
> - unnecessary complexity to handle multi-page case, since it's always
>   called to access one single page;

Fair point there. It just wasn't clear what exactly is your rationale
because this was in a set of other patches.
 
> - the kmap_atomic() cache consistency problem, which I expressed some
>   concern (without further action)

Which kmap_atomic problem? Can you explain again? Virtual cache aliasing
problem you mean? Or caching attribute conflicts?

The whole thing looks stupid though, apparently kmap is used to avoid "the
lock". But the lock is already held. We should just use the vmap
address.


> > you continue using the same vmlist locking and checking for validating
> > addresses.
> 
> It's a reasonable suggestion. Kame, would you agree on killing the
> kmap_atomic() and revert to the vmlist walk?

Yes, vmlist locking is always required to have a pin on the pages, and
IMO it should be quite easy to check for IOREMAP, so we should leave
that check there to avoid the possibility of regressions.

Thanks,
Nick

