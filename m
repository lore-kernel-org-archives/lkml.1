Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYLDRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYLDRnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758961AbYLDRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:37:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35357 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYLDRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:37:33 -0500
Date: Thu, 4 Dec 2008 18:48:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081204174838.GS6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com> <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com> <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 11:45:44AM -0500, Mikulas Patocka wrote:
> > No there is nothing unordered. The file system path typically looks like
> > 
> > commit of a transaction
> > 	if (i have never seen a barrier failing) 
> > 		write block with barrier
> > 		if (EOPNOTSUPP) {
> > 			record failure
> > 			submit synchronously
> > 		}
> > 	} else
> > 		submit synchronously
> > 
> 
> If you view this as a "right" way of using barriers, then you can drop 

It's the way the file systems do it. If you don't believe me feel
free to read the code for yourself.

> barrier support at all and replace this code sequence with:
> 
>  flush disk cache
>  submit write synchronously
>  flush disk cache
> 
> --- because synchronous barriers bring you no performance advantage over 
> the above sequence.

Remember this is done by a commit thread in a journaling file system. 
Commits are ordered so the thread cannot really order out of order 
anyways. And yes the barriers are essentially a way to flush the cache
regularly for selected commits. The alternative (if you
want to guarantee transaction order) would be to disable
the write cache completely and do it synchronous on each IO.

> 
> > So if a pvmove barrier fails it will just submit synchronously.
> > 
> > The write block with barrier bit varies, jbd/gfs2 do it synchronously
> > too and xfs does it asynchronously (with io done callbacks), but
> 
> And how does xfs preserve write ordering, if the barrier asynchronously 
> fails with -EOPNOTSUPP and there are other writes submitted after the 
> barrier?

>From the high level journaling perspective they are not asynchronous
I think. Just the low level xfs_buf interface happens to use the asynchronous
callbacks instead of calling into the block layer directly like jbd et.al.
do.

-Andi

