Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbZCXRyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbZCXRyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZCXRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:54:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbZCXRyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:54:40 -0400
Date: Tue, 24 Mar 2009 18:35:11 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jan Kara <jack@suse.cz>, "Martin J. Bligh" <mbligh@mbligh.org>,
       linux-ext4@vger.kernel.org, Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090324173511.GJ23439@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200903250130.02485.nickpiggin@yahoo.com.au> <20090324144709.GF23439@duck.suse.cz> <200903250203.55520.nickpiggin@yahoo.com.au> <20090324154813.GH23439@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324154813.GH23439@duck.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-03-09 16:48:14, Jan Kara wrote:
> On Wed 25-03-09 02:03:54, Nick Piggin wrote:
> > On Wednesday 25 March 2009 01:47:09 Jan Kara wrote:
> > > On Wed 25-03-09 01:30:00, Nick Piggin wrote:
> > 
> > > > I don't think it is a very good idea for block_write_full_page recovery
> > > > to do clear_buffer_dirty for !mapped buffers. I think that should rather
> > > > be a redirty_page_for_writepage in the case that the buffer is dirty.
> > > >
> > > > Perhaps not the cleanest way to solve the problem if it is just due to
> > > > transient shortage of space in ext3, but generic code shouldn't be
> > > > allowed to throw away dirty data even if it can't be written back due
> > > > to some software or hardware error.
> > >
> > >   Well, that would be one possibility. But then we'd be left with dirty
> > > pages we cannot ever release since they are constantly dirty (when the
> > > filesystem really becomes out of space). So what I
> > 
> > If the filesystem becomes out of space and we have over-committed these
> > dirty mmapped blocks, then we most definitely want to keep them around.
> > An error of the system losing a few pages (or if it happens an insanely
> > large number of times, then slowly dying due to memory leak) is better
> > than an app suddenly seeing the contents of the page change to nulls
> > under it when the kernel decides to do some page reclaim.
>   Hmm, probably you're right. Definitely it would be much easier to track
> the problem down than it is now... Thinking a bit more... But couldn't a
> malicious user bring the machine easily to OOM this way? That would be
> unfortunate.
  OK, below is the patch which makes things work for me (i.e. no data
lost). What do you think?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

>From f423c2964dd5afbcc40c47731724d48675dd2822 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 24 Mar 2009 16:38:22 +0100
Subject: [PATCH] fs: Don't clear dirty bits in block_write_full_page()

If getblock() fails in block_write_full_page(), we don't want to clear
dirty bits on buffers. Actually, we even want to redirty the page. This
way we just won't silently discard users data (written e.g. through mmap)
in case of ENOSPC, EDQUOT, EIO or other write error. The downside of this
approach is that if the error is persistent we have this page pinned in
memory forever and if there are lots of such pages, we can bring the
machine OOM.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 891e1c7..ae779a0 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1833,9 +1833,11 @@ recover:
 	/*
 	 * ENOSPC, or some other error.  We may already have added some
 	 * blocks to the file, so we need to write these out to avoid
-	 * exposing stale data.
+	 * exposing stale data. We redirty the page so that we don't
+	 * loose data we are unable to write.
 	 * The page is currently locked and not marked for writeback
 	 */
+	redirty_page_for_writepage(wbc, page);
 	bh = head;
 	/* Recovery: lock and submit the mapped buffers */
 	do {
@@ -1843,12 +1845,6 @@ recover:
 		    !buffer_delay(bh)) {
 			lock_buffer(bh);
 			mark_buffer_async_write(bh);
-		} else {
-			/*
-			 * The buffer may have been set dirty during
-			 * attachment to a dirty page.
-			 */
-			clear_buffer_dirty(bh);
 		}
 	} while ((bh = bh->b_this_page) != head);
 	SetPageError(page);
-- 
1.6.0.2

