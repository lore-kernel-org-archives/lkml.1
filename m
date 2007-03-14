Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbXCNNan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbXCNNan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXCNNan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:30:43 -0400
Received: from mail.suse.de ([195.135.220.2]:59111 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933907AbXCNNal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:30:41 -0400
Date: Wed, 14 Mar 2007 14:30:24 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>,
       Mark Fasheh <mark.fasheh@oracle.com>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070314133023.GA5103@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site> <20070309103913.GA4503@infradead.org> <20070309233301.GC18555@ca-server1.us.oracle.com> <20070310092541.GA22182@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310092541.GA22182@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 09:25:41AM +0000, Christoph Hellwig wrote:
> On Fri, Mar 09, 2007 at 03:33:01PM -0800, Mark Fasheh wrote:
> > ->kernel_write() as opposed to genericizing ->perform_write() would be fine
> > with me. Just so long as we get rid of ->prepare_write and ->commit_write in
> > that other kernel code doesn't call them directly. That interface just
> > doesn't work for Ocfs2.
> 
> It doesn't work for any filesystem that needs slightly fancy locking.
> That and the reason that's an interface that doesn't fit into our
> layering is why I want to get rid of it.  Note that fops->kernel_write
> might in fact use ->perform_write with an actor as Nick suggested.
> I'm not quite sure how it'll look like - I'd rather take care of the
> buffered write path first and then handle this issue once the first
> changes have stabilized.

So I've tried a different approach - the 2-op API rather than an actor.

perform_write stays around as a higher performance API, but it isn't
required if the filesystem implements the 2-op API. I've called them
write_begin/write_end for now.

There are a few upshots to doing this rather than the actor approach.
First of all, this is what callers expect, they want to write into the
page directly rather than making an actor.

More importantly, it allows us to implement generic block versions of
the API which is much more reusable than block_perform_write (which was
basically useless for anything more than ext2).

The API calls for the filesystem to find and lock the page itself, and
pass that up to the caller, as well as handle short-writes properly, so
we can solve this deadlock properly.

The nice thing about this is that write_begin is basically a single
page case of the first half (before the iovec copy) of perform_write,
and write_end is the single page case of the second half (after the
copy). So any filesystem that implements perform_write should be able
to reuse write_begin/write_end components.

Anyway, I'm attaching the top patches of my stack (underneath are the
initial patches to solve prepare_write deadlock -- I'll repost the
complete set once I get some more feedback). Sorry it is a bit under
commented and not stress tested. However it does boot and run with
ext2/3/shmem and other simplefses.

Mark has been providing some helpful advice about the new 2-op interface,
but it is still pretty much up in the air.

Also note that a _lot_ of crud is there to support prepare_write (eg.
pagecache_write_begin/pagecache_write_end basically become single liners
once we get rid of the old API).

Anyway, I think I should throw this out for comments before investing too
much more time, in case everyone hates it ;)

Anyway, comments much appreciated...

