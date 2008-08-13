Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYHMG1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYHMG1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHMG0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:26:53 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:58178 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYHMG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:26:52 -0400
Message-Id: <6.0.0.20.2.20080813150454.03b13e30@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Wed, 13 Aug 2008 15:24:40 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] vmscan: set try_to_release_page's gfp_mask to 0
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <20080812202127.b88e8250.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080813111835.03d345b0@172.19.0.2>
 <20080812202127.b88e8250.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 12:21 08/08/13, Andrew Morton wrote:
>On Wed, 13 Aug 2008 11:21:16 +0900 Hisashi Hifumi 
><hifumi.hisashi@oss.ntt.co.jp> wrote:
>
>> Hi.
>> 
>> shrink_page_list passes gfp_mask to try_to_release_page.
>> When shrink_page_list is called from kswapd or buddy system, gfp_mask is set
>> and (gfp_mask & __GFP_WAIT) and (gfp_mask & __GFP_FS) check is positive.
>> releasepage of jbd/jbd2(ext3/4, ocfs2) and XFS use this parameter. 
>> If try_to_free_page fails due to bh busy in jbd/jbd2, jbd/jbd2 lets a 
>thread wait for 
>> committing transaction. I think this has big performance impacts for vmscan.
>> So I modified shrink_page_list not to pass gfp_mask to try_to_release_page
>> in ordered to improve vmscan performance.
>> 
>> Thanks.
>> 
>> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>> 
>> diff -Nrup linux-2.6.27-rc2.org/mm/vmscan.c linux-2.6.27-rc2.vmscan/mm/vmscan.c
>> --- linux-2.6.27-rc2.org/mm/vmscan.c	2008-08-11 14:33:24.000000000 +0900
>> +++ linux-2.6.27-rc2.vmscan/mm/vmscan.c	2008-08-12 18:57:05.000000000 +0900
>> @@ -614,7 +614,7 @@ static unsigned long shrink_page_list(st
>>  		* Otherwise, leave the page on the LRU so it is swappable.
>>  		*/
>>  		if (PagePrivate(page)) {
>> -			if (!try_to_release_page(page, sc->gfp_mask))
>> +			if (!try_to_release_page(page, 0))
>>  				goto activate_locked;
>>  			if (!mapping && page_count(page) == 1) {
>>  				unlock_page(page);
>
>I think the change makes sense.
>
>Has this change been shown to improve any workloads?  If so, please
>provide full information for the changelog.  If not, please mention
>this and explain why benefits were not demonstrable.  This information
>should _always_ be present in a "performance" patch's changelog!

Sorry, I do not have performance number yet. I'll try this.

>
>Probably a better fix would be to explicitly tell
>journal_try_to_free_buffers() when it need to block on journal commit,
>rather than (mis)interpreting the gfp_t in this fashion.  I assume the
>only caller who really cares is direct-io.  That would be quite a bit
>of churn, and the asynchronous behaviour perhaps makes sense _anyway_
>when called from page reclaim.
>
>otoh, there is a risk that this change will cause page reclaim to sit
>there burning huge amounts of CPU time and not achieving anything,
>because all it is doing is scanning over busy pages.  In that case,
>blocking behind a commit which would make those pages reclaimable is
>correct behaviour.  But given that the offending code in
>journal_try_to_free_buffers() has only been there for a few weeks, I
>guess this isn't a concern.
>
>
>Really, I think what this patch tells us is that 3f31fddf ("jbd: fix
>race between free buffer and commit transaction") was an unpleasant
>hack which had undesirable and unexpected side-effects.  I think - that
>depends upon your as-yet-undisclosed testing results?
>
>Perhaps we should revert 3f31fddf and have another think about how to
>fix the direct-io -EIO problem.  One option would be to hold our noses
>and add a new gfp_t flag for this specific purpose?

Currently, we are discussing about direct-io -EIO problem because the patch
 ("jbd: fix race between free buffer and commit transaction") was not 
enough to fix the issue.
The ML subject of this discussion is 
"[PATCH] jbd jbd2: fix diowritereturningEIOwhentry_to_release_page fails".

