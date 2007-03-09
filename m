Return-Path: <linux-kernel-owner+w=401wt.eu-S1767237AbXCIMw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767237AbXCIMw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767236AbXCIMw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:52:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:47998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767237AbXCIMw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:52:56 -0500
Date: Fri, 9 Mar 2007 13:52:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070309125242.GB15325@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site> <20070309103913.GA4503@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309103913.GA4503@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Mar 09, 2007 at 10:39:13AM +0000, Christoph Hellwig wrote:
> Hi Nick,
> 
> sorry for my later reply, this has been on my to answer list for the last
> month and I only managed to get back to it now.

No worries, I haven't had much time to work on it since then anyway.
Thanks for taking a look.

> On Thu, Feb 08, 2007 at 02:07:36PM +0100, Nick Piggin wrote:
> > as a single call to copy a given amount of userdata at the given offset. This
> > is more flexible, because the implementation can determine how to best handle
> > errors, or multi-page ranges (eg. it may use a gang lookup), and only requires
> > one call into the fs.
> 
> I really like this idea, especially for avoiding to call into the allocator
> for every block.  Have you contacted the reiser4 folks whether this would
> superceed their batch_write op completely?

I haven't yet, although that's been on my todo list when I get the API
into a more final state.

batch_write seems quite similar, however theirs is still page based, and
a bit crufty, IMO. I found it to be really clean to just pass down offsets,
but that may be a matter for debate.

What they _do_ have is a write actor function that will do the data copy.
This could be one possible way to get rid of ->prepare_write and
->commit_write, but I haven't tried that yet, because I don't like adding
more redirection and complexity if possible...

> > One problem with this interface is that it cannot be used to write into the
> > filesystem by any means other than already-initialised buffers via iovecs. So
> > prepare/commit have to stay around for non-user data... 
> 
> Actually I think that's a a good thing to a certain extent.  It reminds
> us that all other users are horrible abuse of the interface.  I'd even
> go so far as to make batch_write a callback that the filesystem passes
> to generic_file_aio_write to make clear it's not a generic thing but
> a helper.  (It's not a generic thing because it's the upper layer writing
> into the pagecache, not a pagecache to fs below operation).

OK, if you think that's reasonable, then that is one hurdle out of the way ;)

> The still leaves open on how to get rid of ->prepare_write and ->commit_write
> compltely, and for that we'll probably need ->kernel_read and ->kernel_write
> file operations.  But that's a step you shouldn't consider yet when doing
> this work.

I had a couple of possibilities for that. First is passing in a write actor
(eg. defaulting to the normal iovec usercopy), but as I said I consider this
more like fixing the problem with brute force (ie. just making the interface
more complex). Maybe as a last resort, though.

Another thing that would be much nicer from _my_ point of view would be to
just make all kernel users set up their data in an iovec, and use the normal
call with KERNEL_DS. Unfortunately, this is not the expected way for a lot
of code to work, and it might require extra copying of the data.


> > Another thing is that it seems to be less able to be implemented in generic,
> > reusable code. It should be possible to introduce a new 2-op interface (or
> > maybe just a new error handler op) which can be used correctly in generic code.
> 
> We should be able to find a nice abstraction for this, see my next mails.
> 
> > +	/*
> > +	 * perform_write replaces prepare and commit_write callbacks.
> > +	 */
> 
> This is a rather useless comment :)  Better remove it and add a proper
> descriptions to Documentation/filesystems/vfs.txt and
> Documentation/filesystems/Locking

Will do. Thanks!

