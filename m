Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZCPXja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZCPXja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZCPXjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:39:17 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:12468 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbZCPXjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:39:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPN/vkl5LAJ7/2dsb2JhbADUeoN/Bg
X-IronPort-AV: E=Sophos;i="4.38,375,1233495000"; 
   d="scan'208";a="340048590"
Date: Tue, 17 Mar 2009 10:38:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, npiggin@suse.de
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090316233835.GM26138@disturbed>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, npiggin@suse.de
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-3-git-send-email-jens.axboe@oracle.com> <20090312223321.ccfe51b2.akpm@linux-foundation.org> <20090313105446.GO27476@kernel.dk> <20090315225215.GA26138@disturbed> <20090316073321.GJ27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316073321.GJ27476@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 08:33:21AM +0100, Jens Axboe wrote:
> On Mon, Mar 16 2009, Dave Chinner wrote:
> > On Fri, Mar 13, 2009 at 11:54:46AM +0100, Jens Axboe wrote:
> > > On Thu, Mar 12 2009, Andrew Morton wrote:
> > > > On Thu, 12 Mar 2009 15:33:43 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > Bear in mind that the XFS guys found that one thread per fs had
> > > > insufficient CPU power to keep up with fast devices.
> > > 
> > > Yes, I definitely want to experiment with > 1 thread per device in the
> > > near future.
> > 
> > The question here is how to do this efficiently. Even if XFS is
> > operating on a single device, it is not optimal just to throw
> > multiple threads at the bdi. Ideally we want a thread per region
> > (allocation group) of the filesystem as each allocation group has
> > it's own inode cache (radix tree) to traverse. These traversals can
> > be done completely in parallel and won't contend either at the
> > traversal level or in the IO hardware....
> > 
> > i.e. what I'd like to see is the ability so any new flushing
> > mechanism to be able to offload responsibility of tracking,
> > traversing and flushing of dirty inodes to the filesystem.
> > Filesystems that don't do such things could use a generic
> > bdi-based implementation.
> > 
> > FWIW, we also want to avoid the current pattern of flushing
> > data, then the inode, then data, then the inode, ....
> > By offloading into the filesystem, this writeback ordering can
> > be done as efficiently as possible for each given filesystem.
> > XFs already has all the hooks to be able to do this
> > effectively....
> > 
> > I know that Christoph was doing some work towards this end;
> > perhaps he can throw his 2c worth in here...
> 
> This is very useful feedback, thanks Dave. So on the filesystem vs bdi
> side, XFS could register a bdi per allocation group.

How do multiple bdis on a single block device interact?

> Then set the proper
> inode->mapping->backing_dev_info from sb->s_op->alloc_inode and
> __mark_inode_dirty() should get the placement right. For private
> traverse and flush, provide some address_space op to override
> generic_sync_bdi_inodes().

Yes, that seems like it would support the sort of internal XFS
structure I've been thinking of.

> It sounds like I should move the bdi flushing bits separate from the bdi
> itself. Embed one in the bdi, but allow outside registration of others.
> Will fit better with the need for more than one flusher per backing
> device.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
