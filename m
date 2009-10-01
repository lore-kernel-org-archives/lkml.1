Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbZJAMco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbZJAMco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbZJAMcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:32:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:32768 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbZJAMcn (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 08:32:43 -0400
Message-ID: <4AC49B95.2040504@suse.de>
Date: Thu, 01 Oct 2009 17:37:49 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Rafael Wysocki <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon when
 s_bdev is NULL
References: <4AC1FC41.2060807@suse.de> <Pine.LNX.4.64.0910011052330.7682@sister.anvils> <4AC492E2.7060205@suse.de> <Pine.LNX.4.64.0910011252220.13515@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910011252220.13515@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
>> Yeah, perhaps. I stumbled upon one more of such error - a NULL pointer
>> dereference in blkdev_issue_discard() called from get_swap_page() when I ran
>> memhog, a simple program to generate a memory hog with Swap over NFS patches.
>>
>> The call sequence is add_to_swap() -> get_swap_page() ->  scan_swap_map()
>> -> discard_swap_cluster() -> blkdev_issue_discard().
>>
>> Wrapping the code around a NULL check fixes the Oops for me.
> 
> That's odd: scan_swap_map() should only discard_swap_cluster() if
> SWP_DISCARDABLE got set, and your first patch made sure that it wasn't.

I forgot to mention, this is not on loopback NFS mount but an remote NFS
mount (so possibly s_bdev is not NULL) when doing swapon. The oops was
triggered when memhog program tries to use the swap space on the newly
created swapfile on NFS. I have not completely investigated the issue,
perhaps s_bdev is not being set when it ought to be..

> So I don't think this second patch should be necessary: you did have
> your first applied when you found this?

yes, I had the first patch applied when it oopsed and I don't use SSD at
all.

> I wonder if there's a funny little issue like si->lowest_alloc not
> being reset to 0 where it should be.  Were you switching between
> NFS swap and SSD swap in your testing?

No.

Thanks,

-- 
Suresh Jayaraman
