Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbXEXXyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbXEXXyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXEXXy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:54:29 -0400
Received: from pat.uio.no ([129.240.10.15]:51546 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXEXXy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:54:28 -0400
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write
	from the pagecache
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <29320.1180048725@redhat.com>
References: <1180046115.8872.27.camel@heimdal.trondhjem.org>
	 <20070524133821.3ee9c9f3.akpm@linux-foundation.org>
	 <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	 <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
	 <27608.1180042522@redhat.com>  <29320.1180048725@redhat.com>
Content-Type: text/plain
Date: Thu, 24 May 2007 19:54:20 -0400
Message-Id: <1180050860.8872.42.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.097)
X-UiO-Scanned: E61E10F1B40464BC680BEA3CB67653DD6E9DB147
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 253 total 1943834 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 00:18 +0100, David Howells wrote:
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > No. If the write fails, then NFS will mark the mapping as invalid and
> > attempt to call invalidate_inode_pages2() at the earliest possible
> > moment.
> 
> Will it erase *all* unwritten writes?  Or is that what launder_page() is for?

Yes. launder_page() will flush out any writes that may have raced with
the call to invalidate_inode_pages2() (you're supposed to attempt to
flush them out before you call the latter).

> How do you deal with pages that were in the process of being written out when
> that particular write was rejected?  Do you just summarily clear PG_writeback
> and hope no-one else looks at the page until invalidate_inode_pages2() gets
> around to excising it?  Or do you have a better way?

All I do is to protect new calls to read() and write() with a call to
check if the page cache needs invalidating. As I said earlier, you
cannot avoid the race. At best you can reduce the window of opportunity,
and so I'd argue that if you can't do that cheaply, then it isn't worth
it.

> > I'm adding in a patch to defer marking the page as uptodate until the
> > write is successful in cases where NFS is writing a pristine page.
> 
> That sounds reasonable, though it doesn't help in the case I'm looking at.  Do
> you also munge i_size if the write fails?

I just mark the inode as needing revalidation so that we update the size
on the next read()/write()/getattr(). That won't stop any existing
append writes from punching ugly holes into the file, but trying to
recover from that sort of thing would be _really_ painful!

> > As for pages that are already marked as uptodate, well you already have
> > a race: you have deferred the page write, and so other processes may
> > already have read the rejected data before you tried to write it out.
> 
> Yeah, I know, and that's very difficult to deal with without some formal
> transaction rollback mechanism.  I think that the best I can do is to discard
> the dodgy data that I've got lurking in the pagecache, but I still have to
> deal with writes made by other users to that file after the rejected write.
> 
> There isn't a perfect way of dealing with it, given the circumstances.

Agreed.

Trond

