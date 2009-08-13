Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZHMRT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZHMRT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZHMRTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:19:55 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:56523 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbZHMRTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:19:55 -0400
X-Trace: 242964272/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.105.228/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.105.228
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAKfng0pQKWnk/2dsb2JhbACBUtNMhBkF
X-IronPort-AV: E=Sophos;i="4.43,375,1246834800"; 
   d="scan'208";a="242964272"
Date: Thu, 13 Aug 2009 18:19:32 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Matthew Wilcox <willy@linux.intel.com>
cc: Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
In-Reply-To: <20090813151312.GA13559@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0908131746350.8831@sister.anvils>
References: <200908122007.43522.ngupta@vflare.org>
 <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <20090813151312.GA13559@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Matthew Wilcox wrote:
> 
> So TRIM isn't free, and there's a better way for the drive to find
> out that the contents of a block no longer matter -- write some new
> data to it.  So if we just swapped a page in, and we're going to swap
> something else back out again soon, just write it to the same location
> instead of to a fresh location.  You've saved a command, and you've
> saved the drive some work, plus you've allowed other users to continue
> accessing the drive in the meantime.
> 
> I am planning a complete overhaul of the discard work.  Users can send
> down discard requests as frequently as they like.  The block layer will
> cache them, and invalidate them if writes come through.  Periodically,
> the block layer will send down a TRIM or an UNMAP (depending on the
> underlying device) and get rid of the blocks that have remained unwanted
> in the interim.

Very interesting report, thanks a lot for it.  Certainly your
good point about writes should dictate some change at the swap end.

I have assumed all along (even from just a block layer perspective)
that discard would entail more overhead than I really want, just to
say "forget about it": I never expected that discarding a page at a
time would be a sensible way to proceed.

So at present swap tends to be discarding a 1MB range at a time.
And even if we have to move the point of discard much closer to
freeing swap, it would still be trying for such amounts - when
a process is exiting, even given the accumulation you propose,
I would not want to be trying to allocate lots of bios to pass
the info down to you.

So it looks as if we'd be duplicating work.
And won't filesystems be discarding extents too?

Hugh
