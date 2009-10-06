Return-Path: <linux-kernel-owner+w=401wt.eu-S933394AbZJFVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394AbZJFVEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbZJFVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:04:34 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:47657 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933259AbZJFVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:04:33 -0400
X-Trace: 270986246/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.37.213/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.37.213
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACZNy0pPRSXV/2dsb2JhbACBUtJRgjiBcgQ
X-IronPort-AV: E=Sophos;i="4.44,515,1249254000"; 
   d="scan'208";a="270986246"
Date: Tue, 6 Oct 2009 22:03:40 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Rafael Wysocki <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon when
 s_bdev is NULL
In-Reply-To: <4AC49B95.2040504@suse.de>
Message-ID: <Pine.LNX.4.64.0910062157300.16308@sister.anvils>
References: <4AC1FC41.2060807@suse.de> <Pine.LNX.4.64.0910011052330.7682@sister.anvils>
 <4AC492E2.7060205@suse.de> <Pine.LNX.4.64.0910011252220.13515@sister.anvils>
 <4AC49B95.2040504@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
> Hugh Dickins wrote:
> > On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
> >>
> >> The call sequence is add_to_swap() -> get_swap_page() ->  scan_swap_map()
> >> -> discard_swap_cluster() -> blkdev_issue_discard().
> >>
> >> Wrapping the code around a NULL check fixes the Oops for me.
> > 
> > That's odd: scan_swap_map() should only discard_swap_cluster() if
> > SWP_DISCARDABLE got set, and your first patch made sure that it wasn't.
> 
> I forgot to mention, this is not on loopback NFS mount but an remote NFS
> mount (so possibly s_bdev is not NULL) when doing swapon. The oops was
> triggered when memhog program tries to use the swap space on the newly
> created swapfile on NFS. I have not completely investigated the issue,
> perhaps s_bdev is not being set when it ought to be..

I'm happy to see your first patch already in 2.6.32-rc3, but still
suspicious of this second patch you sent afterwards.  A quick skim
through your patchset suggests 23/31 is probably responsible:

--- mmotm.orig/include/linux/swap.h
+++ mmotm/include/linux/swap.h
@@ -120,6 +120,7 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
+	SWP_FILE	= (1 << 2),	/* file swap area */
 	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
 	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */

Hugh
