Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYGNMNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYGNMNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYGNMNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:13:39 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:51016 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbYGNMNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:13:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJXdekh5LFxA/2dsb2JhbACpCg
X-IronPort-AV: E=Sophos;i="4.30,359,1212330600"; 
   d="scan'208";a="148648254"
Date: Mon, 14 Jul 2008 22:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080714121332.GX29319@disturbed>
Mail-Followup-To: Lachlan McIlroy <lachlan@sgi.com>,
	Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-mm@kvack.org
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se> <487B019B.9090401@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487B019B.9090401@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 05:34:51PM +1000, Lachlan McIlroy wrote:
> Mikael Abrahamsson wrote:
>> On Fri, 11 Jul 2008, Dave Chinner wrote:
>>
>>> That aside, what was the assert failure reported prior to the oops?  
>>> i.e. paste the lines in the log before the ---[ cut here ]--- line?  
>>> One of them will start with 'Assertion failed:', I think....
>>
>> These ones?
>>
>> Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork 
>> == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c,  
>> line: 5879
>> Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork  
>> == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c,  
>> line: 5879
>
> 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>
> 	if (whichfork == XFS_DATA_FORK &&
> 		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
> 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
> 		error = xfs_flush_pages(ip, (xfs_off_t)0,
> 					       -1, 0, FI_REMAPF);
> 		if (error) {
> 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> 		return error;
> 		}
> 	}
>
> 	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);
>
> This is a race between xfs_fsr and a mmap write. xfs_fsr acquires the
> iolock and then flushes the file and because it has the iolock it doesn't
> expect any new delayed allocations to occur.  A mmap write can allocate
> delayed allocations without acquiring the iolock so is able to get in
> after the flush but before the ASSERT.

Christoph and I were contemplating this problem with ->page_mkwrite
reecently. The problem is that we can't, right now, return an
EAGAIN-like error to ->page_mkwrite() and have it retry the
page fault. Other parts of the page faulting code can do this,
so it seems like a solvable problem.

The basic concept is that if we can return a EAGAIN result we can
try-lock the inode and hold the locks necessary to avoid this race
or prevent the page fault from dirtying the page until the
filesystem is unfrozen.

Added linux-mm to the cc list for discussion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
