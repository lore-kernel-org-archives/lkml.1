Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXEIK02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXEIK02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbXEIKZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:25:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681AbXEIKZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:25:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070508170051.eb4751ce.akpm@linux-foundation.org> 
References: <20070508170051.eb4751ce.akpm@linux-foundation.org>  <20070508194358.27477.74888.stgit@warthog.cambridge.redhat.com> <20070508194411.27477.7552.stgit@warthog.cambridge.redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] AFS: Implement basic file write support 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 09 May 2007 11:25:47 +0100
Message-ID: <997.1178706347@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	BUG_ON(i_size > 0xffffffff); // TODO: use 64-bit store
> 
> You're sure this isn't user-triggerable?

Hmmm...  I'm not.  I'll whip up a patch for this.

> kmap_atomic() could be used here and is better.

Yeah.  It used to have something that slept in the middle of it, but that's no
longer there.  I'll add to the patch.

> We have this zero_user_page() thing heading in which could perhaps be used
> here also.

Okay.  I'll have a look at it once it's there.

> > +	ASSERTRANGE(wb->first, <=, index, <=, wb->last);
> 
> wow.

:-)

The assertions I've put in have been very useful.

> > +	set_page_dirty(page);
> > +
> > +	if (PageDirty(page))
> > +		_debug("dirtied");
> > +
> > +	return 0;
> > +}
> 
> One would normally run mark_inode_dirty() after any i_size_write()?

Not in this case, I assume, because set_page_dirty() ultimately calls
__mark_inode_dirty(), but I could be wrong.

> We can invalidate pages and we can truncate them and we can clean them. 
> But here we have a new operation, "killing".  I wonder what that is.

I can call it invalidation if you like, though that name is already reserved
as it were:-/  I suppose it might actually make sense for me to call
invalidatepage() myself.

> > +	if (wbc->sync_mode != WB_SYNC_NONE)
> > +		wait_on_page_writeback(page);
> 
> Didn't the VFS already do that?

I'm not entirely sure.  Looking at generic_writepages(), I guess so.  I'll
patch it out.

> > +	if (PageWriteback(page) || !PageDirty(page)) {
> > +		unlock_page(page);
> > +		return 0;
> > +	}
> 
> And some of that?

Yeah.  Seems so.  I'll patch that out too.

What I'd like to do is ditch writepage() entirely - I'm not sure it's entirely
necessary with the availability of writepages() - but I'll look at that
another time.

> I have this vague prehistoric memory that something can go wrong at the VFS
> level if the address_space writes back more pages than it was asked to. 
> But I forget what the issue was and it would be silly to have an issue
> with that anyway.  Something to keep an eye out for.

Okay.

Thanks for the 'cherry-pick'.  I'll hopefully have a revision patch for you
soon.

David
