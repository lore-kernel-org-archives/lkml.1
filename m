Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYKBWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYKBWp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYKBWpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:45:19 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:11128 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYKBWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:45:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM8S9kh5LJ4K/2dsb2JhbADCJoFr
X-IronPort-AV: E=Sophos;i="4.33,531,1220193000"; 
   d="scan'208";a="223572550"
Date: Mon, 3 Nov 2008 09:45:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chad Talbott <ctalbott@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@google.com>,
       Michael Rubin <mrubin@google.com>
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
Message-ID: <20081102224513.GH19509@disturbed>
Mail-Followup-To: Chad Talbott <ctalbott@google.com>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 01:54:14PM -0700, Chad Talbott wrote:
> We are looking at adding calls to posix_fadvise(DONTNEED) to various
> data logging routines.  This has two benefits:
> 
>   - frequent write-out -> shorter queues give lower latency, also disk
>     is more utilized as writeout begins immediately
> 
>   - less useless stuff in page cache
> 
> One problem with fadvise() (and ext2, at least) is that associated
> metadata isn't scheduled with the data. So, for a large log file with
> a high append rate, hundreds of indirect blocks are left to be written
> out by periodic writeback.  This metadata consists of single blocks
> spaced by 4MB, leading to spikes of very inefficient disk utilization,
> deep queues and high latency.

Sounds like a filesystem bug to me, not a problem with
posix_fadvise(DONTNEED).

> Andrew suggests a new SYNC_FILE_RANGE_METADATA flag for
> sys_sync_file_range(), and leaving posix_fadvise() alone.

What is the interface that a filesystem will see? No filesystem has
a "metadata sync" method - is this going to fall through to some new
convoluted combination of writeback flags to an inode/mapping
that more filesystems than not can get wrong?

FWIW, sys_sync_file_range() is fundamentally broken for data
integrity writeback - at no time does it call a filesystem method
that can result in a barrier I/O being issued to disk after
writeback is complete. So, unlike fsync() or fdatasync(), the data
can still be lost after completion due to power failure on drives
with volatile write caches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
