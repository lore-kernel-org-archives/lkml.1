Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200Ab0ANPKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0ANPKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182Ab0ANPKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:10:30 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:24957 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108Ab0ANPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:10:27 -0500
X-Trace: 327677030/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMBAGbCTktPRRyw/2dsb2JhbAAI2HGEMAQ
X-IronPort-AV: E=Sophos;i="4.49,275,1262563200"; 
   d="scan'208";a="327677030"
Date: Thu, 14 Jan 2010 15:10:14 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [mmotm] comment on swap notify locking constraints
In-Reply-To: <1263479571-7873-1-git-send-email-ngupta@vflare.org>
Message-ID: <alpine.LSU.2.00.1001141503140.1943@sister.anvils>
References: <1263479571-7873-1-git-send-email-ngupta@vflare.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Nitin Gupta wrote:

> A block device makes swap_slot_free_notify() callback
> when the last reference to a swap slot is dropped.
> 
> This callback is made under swap_lock and often with
> lock for corresponding swapcache page also held. This
> is a note of warning for registered callback function
> which must meet these constraints.

You're right that the page lock of the corresponding swapcache page
may be held there, but that isn't what worried me enough to ask for
a comment: it's the page table lock (sometimes we call it pte lock),
a spinlock like the swap_lock, being held there that particularly
deserves comment.  We don't want someone going to lots of effort
to avoid holding swap_lock there, only to find that effort wasted
because page table lock is also held.

Hugh

> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  include/linux/blkdev.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 14b95a3..e3dcff6 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1295,6 +1295,7 @@ struct block_device_operations {
>  						unsigned long long);
>  	int (*revalidate_disk) (struct gendisk *);
>  	int (*getgeo)(struct block_device *, struct hd_geometry *);
> +	/* this callback is with swap_lock and often page lock also held */

                                                     and page table lock

>  	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
>  	struct module *owner;
>  };
> -- 
> 1.6.2.5
