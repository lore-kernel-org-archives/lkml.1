Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYJaVyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYJaVyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYJaVyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:54:37 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:14134 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbYJaVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:54:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM8S9kh5LIXk/2dsb2JhbADCJoFr
X-IronPort-AV: E=Sophos;i="4.33,524,1220193000"; 
   d="scan'208";a="222553264"
Date: Sat, 1 Nov 2008 08:54:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031215430.GB19509@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed> <20081031203123.GA11514@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031203123.GA11514@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 04:31:23PM -0400, Christoph Hellwig wrote:
> On Fri, Oct 31, 2008 at 11:12:49AM +1100, Dave Chinner wrote:
> > Right - that's exactly where we should be going with this, I think.
> > I'd suggest two callouts, perhaps: ->sync_data and ->sync_metadata.
> > The freeze code can then still operate in two stages, and we can
> > also use then for separating data and inode writeback in pdflush....
> > 
> > FWIW, I mentioned doing this sort of thing here:
> > 
> > http://xfs.org/index.php/Improving_inode_Caching#Avoiding_the_Generic_pdflush_Code
> > 
> > I think I'll look at redoing do_sync() to provide a custom sync
> > method before trying to fix XFS....
> 
> And you weren't the first to thing of this.  Reiser4 for example
> has bad a patch forever to turn sync_sb_inodes into a filesystem method,
> and I think something similar is what we want.  When talking about
> syncing we basically want a few things:
> 
>  - sync out data, either async (from pdflush) or sync
>    (from sync, freeze, remount ro or unmount)
>  - sync out metadata (from pdflush), either async or sync
>    (from sync, freeze, remount ro or unmount)

Effectively, yes. 

Currently we iterate inodes for data and "metadata" sync, and the
only other concept is writing superblocks. I think most filesystems
have more types of metadata than this, so it makes sense for sync to
work on abstracts sync as data and metadata rather than data, inodes
and superblocks...

> and then we want pdflush / sync / etc call into it.  If we are doing
> this correctly this would also avoid having our own xfssyncd.

Yes, though we'd need to change a couple of the functions that
xfssynd does to pdflush operations...

> And as we found out it's not just sync that gets it wrong, it's also
> fsync (which isn't part of the above picture as it's per-inode) that
> gets this utterly wrong, as well as all kinds of syncs, not just the
> unmount one.

Async writeback (write_inode()) has the same problem as fsync -
writing the inode before waiting for data I/O to complete - which
means we've got to jump through hoops in the filesystem to avoid
blocking on inodes that can't be immediately flushed, and often we
end up writing the inode multiple times and having to issue log
forces whenw e shouldn't need to. Effectively we have to tell the
VFS to "try again later" the entire time data is being flushed
before we can write the inode and it's exceedingly inefficient.....

> Combine this with the other data integrity issues Nick
> found in write_cache_pages I come to the conclusion that this whole area
> needs some profound audit and re-architecture urgently.

It's looking more and more that way, isn't it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
