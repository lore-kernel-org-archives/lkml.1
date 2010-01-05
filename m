Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290Ab0AEK6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0AEK6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794Ab0AEK6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:58:12 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:44158 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab0AEK6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:58:10 -0500
X-Trace: 317434396/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4BAJipQktPRRyw/2dsb2JhbAAI0yCEMAQ
X-IronPort-AV: E=Sophos;i="4.47,505,1257120000"; 
   d="scan'208";a="317434396"
Date: Tue, 5 Jan 2010 10:58:00 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add swap slot free callback to
 block_device_operations
In-Reply-To: <1262661514-4148-1-git-send-email-ngupta@vflare.org>
Message-ID: <alpine.LSU.2.00.1001051045510.26135@sister.anvils>
References: <1262661514-4148-1-git-send-email-ngupta@vflare.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Nitin Gupta wrote:

> This callback is required when RAM based devices are
> used as swap disks. One such device is ramzswap[1] which
> is used as compressed in-memory swap disk. For such
> devices, we need a callback as soon as a swap slot is no
> longer used to allow freeing memory allocated for this
> slot. Without this callback, stale data can quickly
> accumulate in memory defeating the whole purpose of
> such devices.
> 
> Another user of this callback will be "preswap" as
> introduced by "Transcendent Memory" patches:
> http://lwn.net/Articles/367286/
> (I intend to integrade preswap with ramzswap).
> 
> [1] ramzswap: http://code.google.com/p/compcache/
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Yes, thanks for your patience in putting this together:
I much prefer this version to all the other ways considered.

(Though you should later add a comment, pointing out that this
callback is with swap_lock and often page table lock also held.)

We know that's unsatisfactory, but it is the nature of swap:
cutting some corners to get the job done without allocating
more memory.  Having tried myself to do proper discard at
swap_free time, I know that is hard: and I believe you've
made the right decision to do it in this way for ramzswap.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  include/linux/blkdev.h |    1 +
>  mm/swapfile.c          |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 784a919..14b95a3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1295,6 +1295,7 @@ struct block_device_operations {
>  						unsigned long long);
>  	int (*revalidate_disk) (struct gendisk *);
>  	int (*getgeo)(struct block_device *, struct hd_geometry *);
> +	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
>  	struct module *owner;
>  };
>  
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6c0585b..0c373bc 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -574,6 +574,7 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
>  
>  	/* free if no reference */
>  	if (!usage) {
> +		struct gendisk *disk = p->bdev->bd_disk;
>  		if (offset < p->lowest_bit)
>  			p->lowest_bit = offset;
>  		if (offset > p->highest_bit)
> @@ -583,6 +584,8 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
>  			swap_list.next = p->type;
>  		nr_swap_pages++;
>  		p->inuse_pages--;
> +		if (disk->fops->swap_slot_free_notify)
> +			disk->fops->swap_slot_free_notify(p->bdev, offset);
>  	}
>  
>  	return usage;
> -- 
> 1.6.2.5
