Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZETMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZETMYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZETMYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:24:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbZETMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:24:04 -0400
Date: Wed, 20 May 2009 08:24:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090520122402.GA19832@infradead.org>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com> <20090520111850.GB3760@duck.suse.cz> <20090520113234.GT11363@kernel.dk> <20090520121111.GF3760@duck.suse.cz> <20090520121629.GW11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520121629.GW11363@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 02:16:30PM +0200, Jens Axboe wrote:
> It's a fine rule, I agree ;-)
> 
> I'll take another look at this when splitting the sync paths.

Btw, there has been quite a bit of work on the higher level sync code in
the VFS tree, and I have some TODO list items for the lower level sync
code.  The most important one would be splitting data and metadata
writeback.

Currently __sync_single_inode first calls do_writepages to write back
the data, then write_inode to potentially write the metadata and then
finally filemap_fdatawait to wait for the inode to be completed.

Now for one thing doing the data wait after the metadata writeout is
wrong for all those filesystems performing some kind of metadata updates
in the I/O completion handler, and e.g. XFS has to work around this
by doing a wait by itself in it's write_inode handler.

Second inodes are usually clustered together, so if a filesystem can
issue multiple dirty inodes at the same time performance will be much
better.

So an optimal sync could would first issue data I/O for all inodes it
wants to write back, then wait for the data I/O to finish and finally
write out the inodes in big clusters.

I'm not quite sure when we'll get to that, just making sure we don't
work against this direction anywhere.

And yeah, I really need to take a detailed look at the current
incarnation of your patchset :)

