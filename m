Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbXEXVfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbXEXVfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbXEXVfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:35:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbXEXVfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:35:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070524133821.3ee9c9f3.akpm@linux-foundation.org>
References: <20070524133821.3ee9c9f3.akpm@linux-foundation.org> <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com> <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from the pagecache
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 24 May 2007 22:35:22 +0100
Message-ID: <27608.1180042522@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Could you please flesh this out a bit, from a higher level?

See the description for patch 3/4.

> As in: what does it mean for a server to "reject" a write? What's actually
> going on here?

Simply, it means that the server refused to perform the write.  The example I'm
thinking of is that it refused to do so because the ACL governing that file
changed between the permission() check and the attempt to write the data back.

All it takes is a write-back cache and a tiny little delay between the copy to
page cache and the write back to the server and there's a window in which
another client can leap in and make it impossible for the client to write the
data.

There are other possibilities, for instance:

 (1) The key governing the writeback expires.

 (2) The user's account is deleted or disabled.

The file being deleted is handled elsewhere.  In such a case, everyone's
writes are just discarded.

> Why does the server do this?

Because it's told to by some other client.  Think chmod, or in AFS's case:

	fs setacl -dir . -acl system:administrators rlidka

This removes write access by not including a 'w' amongst 'rlidka'.

(Note in AFS, the ACLs attached to a directory control the files in that
directory).

> I assume that the application will see a short write or an EIO or something?

EACCES or similar most likely.  In AFS's case you should get an abort with some
appropriate error code.  This is then mapped to EACCES, EKEYREVOKED,
EKEYEXPIRED, etc.

> How does this interact with MAP_SHARED?

MAP_SHARED/PROT_WRITE is just another way of doing writes to the pagecache.  It
isn't really special.  The way I've done it is to use page_mkwrite() to track
the key with which a write through a mapping is written back.

> Do we expect that any other networked filesystem would want to do this? 
> (and if not, why not?) Or do they already attempt to do it in some other
> fashion?

_Any_ network filesystem that (a) has access controls, and (b) does writeback
caching (be the interval ever so brief) is liable to this issue.  It could
possible for a netfs to avoid with this by getting a guarantee that the write
will be accepted upfront (CIFS might do this), or by blocking attempts to
change the access controls through some sort of locking (again CIFS might do
this).

However, looking at NFS, it appears that NFS may be liable to this problem.  It
does appear to use writeback caching, though it flushes its writes back fairly
promptly making it quite difficult to test.  I talked to Steve Dickson about
this, and I get the impression that NFS will just sit their and keep retrying
the writeback.

So, yes, other netfs's may well want to do this, and perhaps *should* be doing
this.

> > Note that the locking is tricky as it's very easy to deadlock against
> > truncate() and other routines once the pages have been unlocked as part of
> > the writeback process.  To this end, the PG_error flag is set, then the
> > PG_writeback flag is cleared, and only *then* can lock_page() be called.
> 
> hm.

Yeah.  Hm.  I spent a lot of time trying to work around deadlocks and finding
new ones.

> Why can't we just run the end_page_writeback() unconditionally? 
> PG_writeback _must_ be set here, and it is the caller who set PG_writeback,
> so this thread of control "owns" that flag.

You may be right.  I'm trying to avoid a race with truncate and attempts to
rewrite the page both, but as I set PG_error, that might not be a problem.

> Also, are you really really sure that there is no way in which PG_writeback
> can get itself set again after the end_page_writeback()?

PG_error ought to take care of that.  To set PG_writeback again, we have to
wait for any outstanding PG_writeback to go away first - at which point
PG_error should come to light.

That's also the reason for the second part of the if-complex - the one that
BUGs if PG_error is set *and* the page is dirty or undergoing writeback.  I
want to make sure I catch such a situation.

> I'd have thought that we should be doing a wait_on_page_writeback() after the
> lock_page() there.

That would require us to begin writing back a page marked PG_error, which
probably ought to be considered "a bad thing".

> Remember, other filesystems might want to be calling this, so we shouldn't be
> designing around AFS implementation specifics.

I know.  Part of the reason that I put it here is so that we can have a common
policy.  However, without trying to get it called from those other filesystems,
it's hard to see where I've made AFS-specific assumptions.  I don't think that
there are actually any, but...

> hm, is the pte-unmapping here completely solid?

I'm not sure.  Certainly by doing it after the grunging of the affected pages,
we should evict all the PTEs and they shouldn't come back after that point.

I'm tempted to rearrange the algorithm to be this:

 (1) Mark all affected pages PG_error.

 (2) Ditch all PTEs mapping to those pages.

 (3) Truncate all affected pages.

Which has the downside of traversing the set of affected pages twice, but the
upside of only whacking the PTEs once.  The calling netfs would then have to
make sure that nopage() didn't resurrect a PG_error page, but that could
possibly be built into filemap_nopage() or do_no_page() as a convenience.

> Are there any race windows in which a faulter can end up owning, say, an
> anonymous page?  We've had heaps of problems with that sort of thing in
> generic_file_direct_IO() and I don't expect it's this easy.

At the moment, I do two passes of PTE erasure to make sure that all these pages
are properly expunged.  However, if I use the above set of steps, and provided
PG_error is properly honoured, I don't think this should be a problem.

David
