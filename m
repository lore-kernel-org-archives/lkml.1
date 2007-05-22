Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbXEVKpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbXEVKpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933590AbXEVKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:44:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52581 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933351AbXEVKoq (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:44:46 -0400
Date: Tue, 22 May 2007 20:44:30 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Hellwig <hch@lst.de>
Cc: David Chinner <dgc@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       xfs-masters@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
Message-ID: <20070522104429.GN86004887@sgi.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org> <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de> <464CB577.5080106@googlemail.com> <20070518021114.GV86004887@sgi.com> <20070521101141.GX86004887@sgi.com> <20070521102321.GA2632@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521102321.GA2632@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 12:23:21PM +0200, Christoph Hellwig wrote:
> On Mon, May 21, 2007 at 08:11:42PM +1000, David Chinner wrote:
> > Christoph - this is an interaction with xfs_buf_associate_memory();
> > I'm not sure what it is doing is at all safe now that it never gets
> > passed kmem_alloc()d memory - it works for the log recovery case
> > because we use it in pairs - once to shorten the buffer and then once
> > to put it back the way it was.
> > 
> > But that doesn't work for the log buffers (we never return them to their
> > original state) and the log wrap case looks to work mostly by accident
> > now (and could posibly lead to double freeing pages)....
> > 
> > It seems that what we really need with the new code is a xfs_buf_clone()
> > operation followed by trimming the range to what the secondary I/O needs
> > to span. This would work for the log buffer case as well. Your thoughts?
> 
> xfs_buf_associate_memory is a mess.  My original plan was to get rid of
> it, but I kept that out to keep that patchset small and easily reviable,
> but it seems like that was a mistake.  My plan is the following:
> 
>  - xlog_bread and thus the whole buffer I/O path grows an iooffset
>    paramater that specifies at which offset into the buffer we start
>    the actual I/O.  That gets rid of all the xfs_buf_associate_memory
>    memory uses in the log recovery code

Perhaps a new field in the xfs_buf structure - that way call paths
don't need to grow extra parameters and potentially increase
stack usage. The read path tends to be at the top of the stack
when it gets blown in the writeback path....

>  - add a buffer clone operation as suggested by you above, and use
>    the offset in xlog_sync aswell.

I don't want to have to introduce a mempool just for one xfs_buf per
filesystem, so this would need to be able to take a xfs_buf (log->l_xbuf)
that it clones to.... 

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
