Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZJGDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZJGDy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZJGDy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:54:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:33313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZJGDy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:54:27 -0400
Message-ID: <4ACC111A.8020500@suse.de>
Date: Wed, 07 Oct 2009 09:25:06 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rafael Wysocki <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon when
 s_bdev is NULL
References: <4AC1FC41.2060807@suse.de> <Pine.LNX.4.64.0910011052330.7682@sister.anvils> <4AC492E2.7060205@suse.de> <Pine.LNX.4.64.0910011252220.13515@sister.anvils> <4AC49B95.2040504@suse.de> <Pine.LNX.4.64.0910062157300.16308@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910062157300.16308@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
>> Hugh Dickins wrote:
>>> On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
>>>> The call sequence is add_to_swap() -> get_swap_page() ->  scan_swap_map()
>>>> -> discard_swap_cluster() -> blkdev_issue_discard().
>>>>
>>>> Wrapping the code around a NULL check fixes the Oops for me.
>>> That's odd: scan_swap_map() should only discard_swap_cluster() if
>>> SWP_DISCARDABLE got set, and your first patch made sure that it wasn't.
>> I forgot to mention, this is not on loopback NFS mount but an remote NFS
>> mount (so possibly s_bdev is not NULL) when doing swapon. The oops was
>> triggered when memhog program tries to use the swap space on the newly
>> created swapfile on NFS. I have not completely investigated the issue,
>> perhaps s_bdev is not being set when it ought to be..
> 
> I'm happy to see your first patch already in 2.6.32-rc3, but still
> suspicious of this second patch you sent afterwards.  A quick skim
> through your patchset suggests 23/31 is probably responsible:

Thanks for skimming through those patches. I noticed this already during
my review and thought I had already fixed this, but apparently I missed
out. I'll test after fixing this and report.

> --- mmotm.orig/include/linux/swap.h
> +++ mmotm/include/linux/swap.h
> @@ -120,6 +120,7 @@ struct swap_extent {
>  enum {
>  	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
>  	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
> +	SWP_FILE	= (1 << 2),	/* file swap area */
>  	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
>  	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
>  	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
> 
> Hugh

Thanks,

-- 
Suresh Jayaraman
