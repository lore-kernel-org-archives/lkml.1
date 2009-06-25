Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZFYEGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZFYEGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZFYEFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:05:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:44095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZFYEFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:05:55 -0400
Date: Thu, 25 Jun 2009 06:05:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625040556.GA15782@wotan.suse.de>
References: <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624150714.c7264768.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 03:07:14PM -0700, Andrew Morton wrote:
> On Wed, 24 Jun 2009 13:40:11 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Wed, 24 Jun 2009, Linus Torvalds wrote:
> > > On Wed, 24 Jun 2009, Andrew Morton wrote:
> > actually makes tons of sense. 
> 
> I suspect that warning will trigger.
> 
> alloc_pages
> -> ...
>   -> pageout
>     -> ...
>       -> get_request
>         -> blk_alloc_request
>           -> elv_set_request
>             -> cfq_set_request
>               -> cfq_get_queue
>                 -> cfq_find_alloc_queue
>                   -> kmem_cache_alloc_node(__GFP_NOFAIL)
>                     -> Jens
> 
> How much this can happen in practice I don't know, but it looks bad.
> 
> > There are other cases where __GFP_NOFAIL doesn't make sense too, and that 
> > could be warned about. The __GFP_NORETRY thing was already mentioned. 
> > Similarly, !__GFP_WAIT doesn't work with __GFP_NOFAIL - because the nofail 
> > obviously relies on being able to do something about the failure case.
> > 
> > We might want to also have rules like "in order to have NOFAIL, you need 
> > to allow IO and FS accesses". 
> 
> Sure, that's sane.
> 
> fs/jbd/journal.c:       new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> 
> But that isn't :(

Unfortunately there's a lot of "hidden" ones in fs/buffer.c.
alloc_page_buffers with arg3=1, which is used quite a lot in
create_empty_buffers.

Also getblk. Sad.

fsblock FTW :)

