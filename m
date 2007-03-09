Return-Path: <linux-kernel-owner+w=401wt.eu-S1767652AbXCIXdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767652AbXCIXdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767654AbXCIXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:33:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54080 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767652AbXCIXdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:33:22 -0500
Date: Fri, 9 Mar 2007 15:33:01 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070309233301.GC18555@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site> <20070309103913.GA4503@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309103913.GA4503@infradead.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:39:13AM +0000, Christoph Hellwig wrote:
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
> 
> The still leaves open on how to get rid of ->prepare_write and ->commit_write
> compltely, and for that we'll probably need ->kernel_read and ->kernel_write
> file operations.  But that's a step you shouldn't consider yet when doing
> this work.

->kernel_write() as opposed to genericizing ->perform_write() would be fine
with me. Just so long as we get rid of ->prepare_write and ->commit_write in
that other kernel code doesn't call them directly. That interface just
doesn't work for Ocfs2. There, we have the triple whammy of having to order
cluster locks with page locks, avoiding nesting cluster locks in the case
that the user data has to be paged in (causing a lock in ->readpage()) and
grabbing / zeroing adjacent pages to fill holes.

So, a combination of ->perform_write and ->kernel_write() could really help
me solve my write woes.

Right now I've got Ocfs2 implementing it's own lowest-level buffered write
code - think generic_file_buffered_write() replacement for Ocfs2. With some
duplicated code above that layer. What's nice is that I can abstract away
the "copy data into some target pages" bits such that the majority of that
code is re-usable for ocfs2's splice write operation. I'm not sure we could
have that low a level of abstraction for anyhing above individual the file
system though which also has to deal with non-kernel writes though. That's
where a ->kernel_write() might come in handy.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
