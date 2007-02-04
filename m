Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXBDLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXBDLWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 06:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXBDLWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 06:22:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:46132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXBDLWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 06:22:47 -0500
Date: Sun, 4 Feb 2007 12:22:46 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070204112246.GA12771@wotan.suse.de>
References: <20070204063707.23659.20741.sendpatchset@linux.site> <20070204063833.23659.55105.sendpatchset@linux.site> <20070204014445.88e6c8c7.akpm@linux-foundation.org> <Pine.LNX.4.64.0702041036420.24838@hermes-1.csi.cam.ac.uk> <20070204031039.46b56dbb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070204031039.46b56dbb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 03:10:39AM -0800, Andrew Morton wrote:
> On Sun, 4 Feb 2007 10:59:58 +0000 (GMT) Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> > 
> > How about leaving the existing code with the following minor 
> > modifications:
> > 
> > Instead of calling filemap_copy_from_user{,_iovec}() do only the atomic 
> > bit with pagefaults disabled, i.e. instead of filemap_copy_from_user() we 
> > would do (could of course move into a helper function of course):
> > 
> > pagefault_disable()
> > kaddr = kmap_atomic(page, KM_USER0);
> > left = __copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
> > kunmap_atomic(kaddr, KM_USER0);
> > pagefault_enable()
> > 
> > if (unlikely(left)) {
> > 	/* The user space page got unmapped before we got to copy it. */
> > 	...
> > }
> > 
> > Thus the 99.999% (or more!) of the time the code would just work as it 
> > always has and there is no bug and no speed impact.  Only in the very rare 
> > and hard to trigger race condition that the user space page after being 
> > faulted in got thrown out again before we did the atomic memory copy do we 
> > run into the above "..." code path.
> 
> Right.  And what I wanted to do here is to zero out the uncopied part of
> the page (if it wasn't uptodate), then run commit_write(), then retry the
> whole thing.
> 
> iirc, we ruled that out because those temporary zeroes are exposed to
> userspace.  But the kernel used to do that anyway for a long time (years)
> until someone noticed, and we'll only do it in your 0.0001% case anyway.

Serious? I'd rather leave the deadlock in there than introduce a
very hard to reproduce data corruption bug to fix it. At least the
deadlock is fail-stop and you can tell exactly what happened when
you hit it (assuming you can get a trace).

Then again, we've got lots more similar little correctness corner
cases like this that most people don't notice most of the time. Am
I aiming too high?

> (Actually, perhaps we can prevent it by not marking the page uptodate in
> this case.  But that'll cause a read()er to try to bring it uptodate...)

We have to write something back to the filesystem because it may have
allocated blocks at this point.

> > I would propose to call out a different function altogether which could do 
> > a multitude of things including drop the lock on the destination page 
> > (maintaining a reference on the page!), allocate a temporary page, copy 
> > from the user space page into the temporary page, then lock the 
> > destination page again, and copy from the temporary page into the 
> > destination page.
> 
> The problem with all these things is that as soon as we unlock the page,
> it's visible to read().  And in fact, as soon as we mark it uptodate it's
> visible to mmap, even if it's still locked.
> 
> > This would be slow but who cares given it would only happen incredibly 
> > rarely and on majority of machines it would never happen at all.
> > 
> > The only potential problem I can see is that the destination page could be 
> > truncated whilst it is unlocked.  I can see two possible solutions to 
> > this:
> 
> truncate's OK: we're holding i_mutex.

Not all truncates hold i_mutex. Neither do all invalidates, for that
matter.
