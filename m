Return-Path: <linux-kernel-owner+w=401wt.eu-S2993116AbXCIKjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993116AbXCIKjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993113AbXCIKjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:39:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37453 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993105AbXCIKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:39:15 -0500
Date: Fri, 9 Mar 2007 10:39:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070309103913.GA4503@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <npiggin@suse.de>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208105458.26443.41479.sendpatchset@linux.site>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

sorry for my later reply, this has been on my to answer list for the last
month and I only managed to get back to it now.

On Thu, Feb 08, 2007 at 02:07:36PM +0100, Nick Piggin wrote:
> Add a new "perform_write" aop, which replaces prepare_write and commit_write
> as a single call to copy a given amount of userdata at the given offset. This
> is more flexible, because the implementation can determine how to best handle
> errors, or multi-page ranges (eg. it may use a gang lookup), and only requires
> one call into the fs.

I really like this idea, especially for avoiding to call into the allocator
for every block.  Have you contacted the reiser4 folks whether this would
superceed their batch_write op completely?

> One problem with this interface is that it cannot be used to write into the
> filesystem by any means other than already-initialised buffers via iovecs. So
> prepare/commit have to stay around for non-user data... 

Actually I think that's a a good thing to a certain extent.  It reminds
us that all other users are horrible abuse of the interface.  I'd even
go so far as to make batch_write a callback that the filesystem passes
to generic_file_aio_write to make clear it's not a generic thing but
a helper.  (It's not a generic thing because it's the upper layer writing
into the pagecache, not a pagecache to fs below operation).

The still leaves open on how to get rid of ->prepare_write and ->commit_write
compltely, and for that we'll probably need ->kernel_read and ->kernel_write
file operations.  But that's a step you shouldn't consider yet when doing
this work.

> Another thing is that it seems to be less able to be implemented in generic,
> reusable code. It should be possible to introduce a new 2-op interface (or
> maybe just a new error handler op) which can be used correctly in generic code.

We should be able to find a nice abstraction for this, see my next mails.

> +	/*
> +	 * perform_write replaces prepare and commit_write callbacks.
> +	 */

This is a rather useless comment :)  Better remove it and add a proper
descriptions to Documentation/filesystems/vfs.txt and
Documentation/filesystems/Locking

