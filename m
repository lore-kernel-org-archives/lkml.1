Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYHMA7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYHMA7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYHMA65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:58:57 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:64603 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbYHMA64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:58:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAO/OoUh5LAMb/2dsb2JhbAC4AYFS
X-IronPort-AV: E=Sophos;i="4.32,198,1217773800"; 
   d="scan'208";a="180704784"
Date: Wed, 13 Aug 2008 10:58:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Lock debugging noise or real problem?
Message-ID: <20080813005852.GW6119@disturbed>
Mail-Followup-To: "Linda A. Walsh" <xfs@tlinx.org>,
	xfs-oss <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org> <48A0F9FC.1070805@sandeen.net> <48A20E9E.9090100@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A20E9E.9090100@tlinx.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:28:46PM -0700, Linda A. Walsh wrote:
> Eric Sandeen wrote:
>>   ...
> Is it also known, (and the same bug) when you get the lock warnings when  
> doing
> "xfs_restore", as well (dio_get_page and xfs_ilock)...

That's the mm code calling fput() with the mmap_sem held. That's a
problem in the VM code, which XFS can do nothing about. The normal
I/O paths always lock the inode first, then (if a page fault occurs
during copyin/out or we need to lock down pages for direct I/O) grab
the mmap_sem at that point. This one could deadlock if you are mixing
read/write with mmap on the same file in different threads of a
multithreaded app. Unlikely, but possible, though it would
only hang that app (not the rest of the machine).

> The bugs with 'sort', & imap were both with xfs_ilock and  
> shrink_icache_memory.

Once again, a problem with the generic code inverting the normal
lock order. This one cannot deadlock, though, because by definition
any inode on the unused list is, well, unused and hence we can't be
holding a reference to it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
