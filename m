Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXEXVrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXEXVrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXEXVrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:47:45 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbXEXVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:47:44 -0400
Date: Thu, 24 May 2007 14:47:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from
 the pagecache
Message-Id: <20070524144732.d9b2650b.akpm@linux-foundation.org>
In-Reply-To: <27608.1180042522@redhat.com>
References: <20070524133821.3ee9c9f3.akpm@linux-foundation.org>
	<20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	<20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
	<27608.1180042522@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 22:35:22 +0100
David Howells <dhowells@redhat.com> wrote:

> 
> > Why can't we just run the end_page_writeback() unconditionally? 
> > PG_writeback _must_ be set here, and it is the caller who set PG_writeback,
> > so this thread of control "owns" that flag.
> 
> You may be right.  I'm trying to avoid a race with truncate and attempts to
> rewrite the page both, but as I set PG_error, that might not be a problem.

Thing is, this new interpretation and usage of PG_error is worrisome.  For
example, I don't think we've previously made any effort to avoid starting
writeback against PageError() pages.  We may be avoiding it in certain
places, but it wasn't a design rule of any sort.  And any such code hasn't
had any useful testing: PageError() is a damn rare thing.

So my reason for asking the above is to try to find a way to make all these
new PG-error games just go away.

> > Also, are you really really sure that there is no way in which PG_writeback
> > can get itself set again after the end_page_writeback()?
> 
> PG_error ought to take care of that.  To set PG_writeback again, we have to
> wait for any outstanding PG_writeback to go away first - at which point
> PG_error should come to light.
> 
> That's also the reason for the second part of the if-complex - the one that
> BUGs if PG_error is set *and* the page is dirty or undergoing writeback.  I
> want to make sure I catch such a situation.
> 
> > I'd have thought that we should be doing a wait_on_page_writeback() after the
> > lock_page() there.
> 
> That would require us to begin writing back a page marked PG_error, which
> probably ought to be considered "a bad thing".

As I say, no effort has been made to enforce anything like that.

> > Remember, other filesystems might want to be calling this, so we shouldn't be
> > designing around AFS implementation specifics.
> 
> I know.  Part of the reason that I put it here is so that we can have a common
> policy.  However, without trying to get it called from those other filesystems,
> it's hard to see where I've made AFS-specific assumptions.  I don't think that
> there are actually any, but...
> 
> > hm, is the pte-unmapping here completely solid?
> 
> I'm not sure.  Certainly by doing it after the grunging of the affected pages,
> we should evict all the PTEs and they shouldn't come back after that point.
> 
> I'm tempted to rearrange the algorithm to be this:
> 
>  (1) Mark all affected pages PG_error.
> 
>  (2) Ditch all PTEs mapping to those pages.
> 
>  (3) Truncate all affected pages.
> 
> Which has the downside of traversing the set of affected pages twice, but the
> upside of only whacking the PTEs once.  The calling netfs would then have to
> make sure that nopage() didn't resurrect a PG_error page, but that could
> possibly be built into filemap_nopage() or do_no_page() as a convenience.
> 
> > Are there any race windows in which a faulter can end up owning, say, an
> > anonymous page?  We've had heaps of problems with that sort of thing in
> > generic_file_direct_IO() and I don't expect it's this easy.
> 
> At the moment, I do two passes of PTE erasure to make sure that all these pages
> are properly expunged.  However, if I use the above set of steps, and provided
> PG_error is properly honoured, I don't think this should be a problem.
> 

Would be better, I think, to be able to remove all this new PG_error stuff.


