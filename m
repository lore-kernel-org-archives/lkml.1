Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYGNHaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYGNHaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbYGNHaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:30:04 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37375 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755071AbYGNHaD (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:30:03 -0400
Message-ID: <487B019B.9090401@sgi.com>
Date: Mon, 14 Jul 2008 17:34:51 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Abrahamsson wrote:
> On Fri, 11 Jul 2008, Dave Chinner wrote:
> 
>> That aside, what was the assert failure reported prior to the oops? 
>> i.e. paste the lines in the log before the ---[ cut here ]--- line? 
>> One of them will start with 'Assertion failed:', I think....
> 
> These ones?
> 
> Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork 
> == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, 
> line: 5879
> Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork 
> == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, 
> line: 5879

	xfs_ilock(ip, XFS_IOLOCK_SHARED);

	if (whichfork == XFS_DATA_FORK &&
		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
		error = xfs_flush_pages(ip, (xfs_off_t)0,
					       -1, 0, FI_REMAPF);
		if (error) {
			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
		return error;
		}
	}

	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);

This is a race between xfs_fsr and a mmap write.  xfs_fsr acquires the
iolock and then flushes the file and because it has the iolock it doesn't
expect any new delayed allocations to occur.  A mmap write can allocate
delayed allocations without acquiring the iolock so is able to get in
after the flush but before the ASSERT.

> 
> I'll happily rebuild the kernel without the debug option and do 
> xfs_check to weed out any possible logical problem with the volume, if 
> you don't need any further information from the current state of my volume.
> 
> I should also say that this assert failue happened two nights in a row 
> so I guess it's fairly reproducible (didn't happen on the 10th, and 
> today, the 11th it seems to have panic:ed around 03:30 (I start the 
> defragmentation via cron at 03:00) which I think is related.
> 
