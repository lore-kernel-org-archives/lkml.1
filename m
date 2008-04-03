Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbYDCCM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbYDCCM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYDCCMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:12:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758112AbYDCCMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:12:49 -0400
Date: Wed, 2 Apr 2008 19:12:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
Message-Id: <20080402191207.73213e96.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804021645560.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
	<alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
	<20080402150158.f366370f.akpm@linux-foundation.org>
	<alpine.LFD.1.00.0804021645560.14670@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 16:52:14 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 2 Apr 2008, Andrew Morton wrote:
> > 
> > But then the test-and-set of an already-set flag would newly cause the
> > cacheline to be dirtied, requiring additional bus usage to write it back?
> 
> Looking around a bit, I don't see any realistic case where this could 
> possibly be the case and that is performance-sensitive.

You sure?  A pretty common case would be overwrite of an already-dirty page
and from a quick read the only place where we modify bh.b_state is the
set_buffer_uptodate() and clear_buffer_new() in __block_commit_write(),
both of which could/should be converted to use the same trick.  Like
__block_prepare_write(), which already does

	if (!buffer_uptodate(bh))
		set_buffer_uptodate(bh);


What happened here was back in about, umm, 2001 we discovered one or two
code paths which when optimised in this way led to overall-measurably (not
just oprofile-measurably) improvements.  I don't recall which ones they
were.

So we then said oh-goody and sprinkled the same pattern all over the place
on the off-chance.  But I'm sure that over the ages we've let that
optimisation rot (witness __block_commit_write() above).

These were simpler times, and we didn't worry our little heads overly much
about this ordering stuff.

> The VFS-level uses of mark_buffer_dirty() seem to all be coupled with 
> other uses that clear or set other bits in the buffer status word, so the 
> cacheline will always apparently be dirty. 

As I say, I expect we could fix this if we want to.  The key point here is
that a page overwrite does not do lock_buffer(), so it should be possible
to do the whole operation without modifying bh.b_state.  If we wish to do
that.

> The low-level filesystems sometimes do it for things like block bitmap 
> changes, and I could imagine that there it actually (a) is no longer in 
> the cache and (b) the buffer really was dirty to start with, but in ext3 
> for example, you'd end up in journal_dirty_metadata which spinlocks on the 
> BH_State bit first etc etc.

Yeah, ext3 is probably a lost cause.  Anyone who cares about performance is
using ext2 and a UPS ;)

> So the cacheline *will* be dirty, and this function doesn't seem like it 
> could possibly ever show up in a real profile for any real load anyway, so 
> it seems odd to try to optimize it this way.
> 

I don't think the world would end if we took it out.  Particularly as not
many people use ext2 and we already broke it.

The trick will be to hunt down all the other places where we did a similar
thing and check them.
