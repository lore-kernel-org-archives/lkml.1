Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbZCPKVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbZCPKVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZCPKVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:21:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47770 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbZCPKVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:21:34 -0400
Date: Mon, 16 Mar 2009 11:21:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, npiggin@suse.de
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090316102131.GO27476@kernel.dk>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-3-git-send-email-jens.axboe@oracle.com> <20090312223321.ccfe51b2.akpm@linux-foundation.org> <20090313105446.GO27476@kernel.dk> <20090315225215.GA26138@disturbed> <20090316073321.GJ27476@kernel.dk> <20090316101720.GC21118@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316101720.GC21118@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16 2009, Christoph Hellwig wrote:
> On Mon, Mar 16, 2009 at 08:33:21AM +0100, Jens Axboe wrote:
> > This is very useful feedback, thanks Dave. So on the filesystem vs bdi
> > side, XFS could register a bdi per allocation group. Then set the proper
> > inode->mapping->backing_dev_info from sb->s_op->alloc_inode and
> > __mark_inode_dirty() should get the placement right. For private
> > traverse and flush, provide some address_space op to override
> > generic_sync_bdi_inodes().
> > 
> > It sounds like I should move the bdi flushing bits separate from the bdi
> > itself. Embed one in the bdi, but allow outside registration of others.
> > Will fit better with the need for more than one flusher per backing
> > device.
> 
> Yes, having a separate flushing container is a good idea.  Either way
> I'm not sure how much use all this is for XFS.  We're working on using
> our own flushing code as we want to iterate the inodes using the
> knowledge about their placement on disk.  Due to that we don't use
> the dirty inode list anymore (already in mainline since 2.6.29-rc) but
> the per-ag radix-tree.  The finer granularity pdflush management might
> come in handy, but we'll hand off to some XFS-specific code at a pretty
> high level in there.

Nobody says that you have to use the inode lists for iteration. Or
perhaps it would be possible to plug __mark_inode_dirty() and allow for
alternate placement of the inode upfront.

I'll definitely proceed with the flushing container approach. And I'd
very much like to work with XFS to ensure that it caters to that end as
well, makes it a lot more applicable imho.

-- 
Jens Axboe

