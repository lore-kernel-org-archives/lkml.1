Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYDCOfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYDCOfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbYDCOfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:35:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577AbYDCOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:35:23 -0400
Date: Thu, 3 Apr 2008 07:34:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <20080402191207.73213e96.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0804030724210.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org> <20080402150158.f366370f.akpm@linux-foundation.org> <alpine.LFD.1.00.0804021645560.14670@woody.linux-foundation.org>
 <20080402191207.73213e96.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Andrew Morton wrote:
> 
> You sure?  A pretty common case would be overwrite of an already-dirty page
> and from a quick read the only place where we modify bh.b_state is the
> set_buffer_uptodate() and clear_buffer_new() in __block_commit_write(),
> both of which could/should be converted to use the same trick.  Like
> __block_prepare_write(), which already does
> 
> 	if (!buffer_uptodate(bh))
> 		set_buffer_uptodate(bh);

Well, that particular optimization is safe, but it's safe because 
"uptodate" is sticky. Once it gets set, it is never reset.

But in general, it's simply a bad idea to do

	if (read)
		atomic-read-modify-write;

because it so often has races. This is pretty much exactly the same bug as 
we had not long ago with

	if (!waitqueue_empty(..))
		wake_up(..);

and for very similar reasons - the "read" part is very fast, yes, but it's 
also by definition not actually doing all the careful things that the 
atomic operation (whether a CPU-atomic one, or a software-written atomic 
with a spinlock one) does.

> What happened here was back in about, umm, 2001 we discovered one or two
> code paths which when optimised in this way led to overall-measurably (not
> just oprofile-measurably) improvements.  I don't recall which ones they
> were.
> 
> So we then said oh-goody and sprinkled the same pattern all over the place
> on the off-chance.  But I'm sure that over the ages we've let that
> optimisation rot (witness __block_commit_write() above).

And the problem is that 

	if (!buffer_uptodate(bh))
		set_buffer_uptodate(bh);

really isn't "the same" optimization at all as

	if (!buffer_dirty(bh) && test_and_set_buffer_dirty(bh)) {
			..

and the latter is simply fundamentally different.

> As I say, I expect we could fix this if we want to.  The key point here is
> that a page overwrite does not do lock_buffer(), so it should be possible
> to do the whole operation without modifying bh.b_state.  If we wish to do
> that.

Well, if we really want to do this op, then I'd rather make the code be 
really obvious what the smp_mb is about, but also make sure that we don't 
unnecessarily do *both* the smp_mb and the actual already-serialized bit 
operation.

But I'd be even happier if we only did these kinds of things when we have 
real performance-data that they help.

		Linus
---
 fs/buffer.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9819632..39ff144 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1181,7 +1181,20 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
 void mark_buffer_dirty(struct buffer_head *bh)
 {
 	WARN_ON_ONCE(!buffer_uptodate(bh));
-	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
+
+	/*
+	 * Very *carefully* optimize the it-is-already-dirty case.
+	 *
+	 * Don't let the final "is it dirty" escape to before we
+	 * perhaps modified the buffer.
+	 */
+	if (buffer_dirty(bh)) {
+		smp_mb();
+		if (buffer_dirty(bh))
+			return;
+	}
+
+	if (!test_set_buffer_dirty(bh))
 		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
 }
 
