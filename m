Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbZAOIr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbZAOIr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbZAOIrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:47:13 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:38956 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757642AbZAOIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:47:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACuHbkl5LBUR/2dsb2JhbADPBYVu
X-IronPort-AV: E=Sophos;i="4.37,268,1231075800"; 
   d="scan'208";a="283387079"
Date: Thu, 15 Jan 2009 19:47:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090115084700.GD8071@disturbed>
Mail-Followup-To: Lachlan McIlroy <lachlan@sgi.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090112151133.GA24852@infradead.org> <496C2D69.2010301@sgi.com> <20090114221655.GX8071@disturbed> <496E89E4.9070004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E89E4.9070004@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:57:08AM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
> > On Tue, Jan 13, 2009 at 04:58:01PM +1100, Lachlan McIlroy wrote:
> >> Christoph Hellwig wrote:
> >>> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
> >>>> Hi
> >>>>
> >>>> I discovered a bug in XFS in delayed allocation.
> >>>>
> >>>> When you take a small partition (52MB in my case) and copy many small 
> >>>> files on it (source code) that barely fits there, you get -ENOSPC. 
> >>>> Then sync the partition, some free space pops up, click "retry" in MC 
> >>>> an the copy continues. They you get again -ENOSPC, you must sync, 
> >>>> click "retry" and go on. And so on few times until the source code 
> >>>> finally fits on the XFS partition.
> >>>>
> >>>> This misbehavior is apparently caused by delayed allocation, delayed  
> >>>> allocation does not exactly know how much space will be occupied by 
> >>>> data, so it makes some upper bound guess. Because free space count is 
> >>>> only a guess, not the actual data being consumed, XFS should not 
> >>>> return -ENOSPC on behalf of it. When the free space overflows, XFS 
> >>>> should sync itself, retry allocation and only return -ENOSPC if it 
> >>>> fails the second time, after the sync.
> >> This sounds like a problem with speculative allocation - delayed allocations
> >> beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
> >> allocation will be credited to the file. 
> > 
> > The second retry occurs without speculative EOF allocation. That's
> > what the BMAPI_SYNC flag does....
> By then it's too late.  There could already be many files with delayed
> allocations beyond eof that are unneccesarily consuming space.

Yes:

> > That being said, it can't truncate away pre-existing speculative
> > allocations on other files, which is why there is a global flush
> > and wait before the third retry.....

> I suspect
> that when those files are flushed some are not able to convert the full
> delayed allocation in one extent and only convert what is needed to write
> out data.  The remaining unused delayed allocation is released and that's
> why the freespace is going up and down.

It takes time to flush several thousand files. The 500ms
sleep hack is probably not a long enough delay when there are lots
of small files to flush that haven't had their speculative
allcoation truncations removed.

I suspect that xfs_release() might not be truncating the speculative
EOF allocation on file close when the inode has no extents yet:

1190         if (ip->i_d.di_nlink != 0) {
1191                 if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
1192                      ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
1193                        ip->i_delayed_blks > 0)) &&
1194   >>>>>>>>>          (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
1195                     (!(ip->i_d.di_flags &
1196                                 (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
1197                         error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
1198                         if (error)
1199                                 return error;
1200                 }
1201         }

I think that check will prevent truncation of the speculative
allocation on new files that haven't been flushed or had allocation
done on them yet. That'll be the cause of the buildup, I think...

It's interesting that the only consideration for EOF truncation on
file close is when there extents in the inode itself, not when in
btree format....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
