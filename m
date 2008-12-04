Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYLDQqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYLDQqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYLDQqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:46:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYLDQqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:46:23 -0500
Date: Thu, 4 Dec 2008 11:45:44 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
 barriers.)
In-Reply-To: <20081204145810.GR6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
 <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
 <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
 <20081204145810.GR6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > finished after the 2nd write) and you are in an interrupt context, where 
> > > > you can't reissue -EOPNOTSUPP request. So what do you want to do?
> > > 
> > > The barrier aware file systems I know of just resubmit synchronously when 
> > > a barrier fails.
> > 
> > ... and produce structure corruption for certain period in time, because 
> > the writes meant to be ordered are submitted unordered.
> 
> No there is nothing unordered. The file system path typically looks like
> 
> commit of a transaction
> 	if (i have never seen a barrier failing) 
> 		write block with barrier
> 		if (EOPNOTSUPP) {
> 			record failure
> 			submit synchronously
> 		}
> 	} else
> 		submit synchronously
> 

If you view this as a "right" way of using barriers, then you can drop 
barrier support at all and replace this code sequence with:

 flush disk cache
 submit write synchronously
 flush disk cache

--- because synchronous barriers bring you no performance advantage over 
the above sequence.

> So if a pvmove barrier fails it will just submit synchronously.
> 
> The write block with barrier bit varies, jbd/gfs2 do it synchronously
> too and xfs does it asynchronously (with io done callbacks), but

And how does xfs preserve write ordering, if the barrier asynchronously 
fails with -EOPNOTSUPP and there are other writes submitted after the 
barrier?

> in both cases they handle an EOPNOTSUPP comming out in the final
> io done.

Mikulas
