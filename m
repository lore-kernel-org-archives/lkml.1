Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZJAKIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZJAKIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZJAKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:08:10 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:48676 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758AbZJAKIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:08:09 -0400
X-Trace: 264865554/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.34.102/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.34.102
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAJscxEpPRSJm/2dsb2JhbACBUNUKhCgEgU0
X-IronPort-AV: E=Sophos;i="4.44,486,1249254000"; 
   d="scan'208";a="264865554"
Date: Thu, 1 Oct 2009 11:07:58 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Rafael Wysocki <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon when
 s_bdev is NULL
In-Reply-To: <4AC1FC41.2060807@suse.de>
Message-ID: <Pine.LNX.4.64.0910011052330.7682@sister.anvils>
References: <4AC1FC41.2060807@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Suresh Jayaraman wrote:

> While testing Swap over NFS patchset, I noticed an oops that was triggered
> during swapon. Investigating further, the NULL pointer deference is due to the
> SSD device check/optimization in the swapon code that assumes s_bdev could never
> be NULL.
> 
> inode->i_sb->s_bdev could be NULL in a few cases. For e.g. one such case is
> loopback NFS mount, there could be others as well. Fix this by ensuring s_bdev
> is not NULL before we try to deference s_bdev.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Thanks a lot for that: sorry to say I was ignorant of the possibility.

This is only an issue with an out-of-tree patch, is that correct?
I'd like it to be fixed anyway, but if there's a way in which it can
happen in unpatched 2.6.31, then we ought to send the fix to -stable.

I've added Rafael to the Cc, because CONFIG_HIBERNATION's swap_type_of()
looks also dangerous in this respect - and especially where it does that
"if (bdev == sis->bdev) {" match, I think it's assuming NULL bdev cannot
match against anything.

Hugh

> ---
>  mm/swapfile.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4de7f02..a1bc6b9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1974,12 +1974,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		goto bad_swap;
>  	}
>  
> -	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
> -		p->flags |= SWP_SOLIDSTATE;
> -		p->cluster_next = 1 + (random32() % p->highest_bit);
> +	if (p->bdev) {
> +		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
> +			p->flags |= SWP_SOLIDSTATE;
> +			p->cluster_next = 1 + (random32() % p->highest_bit);
> +		}
> +		if (discard_swap(p) == 0)
> +			p->flags |= SWP_DISCARDABLE;
>  	}
> -	if (discard_swap(p) == 0)
> -		p->flags |= SWP_DISCARDABLE;
>  
>  	mutex_lock(&swapon_mutex);
>  	spin_lock(&swap_lock);
