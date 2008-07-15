Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYGODTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYGODTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbYGODTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:19:07 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:55554 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755806AbYGODTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:19:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHy0e0h5LFxA/2dsb2JhbACsMQ
X-IronPort-AV: E=Sophos;i="4.30,363,1212330600"; 
   d="scan'208";a="149216213"
Date: Tue, 15 Jul 2008 13:18:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080715031840.GB29319@disturbed>
Mail-Followup-To: Lachlan McIlroy <lachlan@sgi.com>,
	Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-mm@kvack.org
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se> <487B019B.9090401@sgi.com> <20080714121332.GX29319@disturbed> <487C07A4.70202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487C07A4.70202@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 12:12:52PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Mon, Jul 14, 2008 at 05:34:51PM +1000, Lachlan McIlroy wrote:
>>> This is a race between xfs_fsr and a mmap write. xfs_fsr acquires the
>>> iolock and then flushes the file and because it has the iolock it doesn't
>>> expect any new delayed allocations to occur.  A mmap write can allocate
>>> delayed allocations without acquiring the iolock so is able to get in
>>> after the flush but before the ASSERT.
>>
>> Christoph and I were contemplating this problem with ->page_mkwrite
>> reecently. The problem is that we can't, right now, return an
>> EAGAIN-like error to ->page_mkwrite() and have it retry the
>> page fault. Other parts of the page faulting code can do this,
>> so it seems like a solvable problem.
>>
>> The basic concept is that if we can return a EAGAIN result we can
>> try-lock the inode and hold the locks necessary to avoid this race
>> or prevent the page fault from dirtying the page until the
>> filesystem is unfrozen.
> Why do we need to try-lock the inode?  Will we have an ABBA deadlock
> if we block on the iolock in ->page_mkwrite()?

Yes. With the mmap_sem. Look at the rules in mm/filemap.c
and replace i_mutex with iolock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
