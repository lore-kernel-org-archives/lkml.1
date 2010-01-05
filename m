Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334Ab0AEK7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0AEK7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898Ab0AEK7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:59:08 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:44444 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab0AEK7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:59:01 -0500
X-Trace: 317435107/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4BALuqQktPRRyw/2dsb2JhbAAI0yWEMAQ
X-IronPort-AV: E=Sophos;i="4.47,505,1257120000"; 
   d="scan'208";a="317435107"
Date: Tue, 5 Jan 2010 10:58:58 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] [mmotm] ramzswap: use slot free callback to eliminate
 stale data
In-Reply-To: <1262661514-4148-2-git-send-email-ngupta@vflare.org>
Message-ID: <alpine.LSU.2.00.1001051058070.26135@sister.anvils>
References: <1262661514-4148-1-git-send-email-ngupta@vflare.org> <1262661514-4148-2-git-send-email-ngupta@vflare.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Nitin Gupta wrote:

> ramzswap driver creates RAM backed block devices which are
> used as swap disks. Pages swapped to these disks are compressed
> and stored in memory itself. However, when a swap page becomes
> stale i.e. it is no longer referenced by any process (say, when
> owning process exits), the driver does not get any notification
> about this. So, it has to keep such pages in memory until kernel
> swaps to the same swap slot again thereby overwriting previous
> (stale) page.
> 
> Often, a large number of such stale pages accumulate which defeats
> the whole purpose of in-memory compressed swapping and it begins
> to have a negative impact on system performance.
> 
> To overcome this problem, we now register a callback function
> which is called as soon as a swap slot is freed which allows
> us to free corresponding memory, eliminating any stale data
> in (compressed) memory.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  drivers/staging/ramzswap/ramzswap_drv.c   |   15 ++++++++++++++-
>  drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
>  drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
>  3 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
> index b839f05..bada4ae 100644
> --- a/drivers/staging/ramzswap/ramzswap_drv.c
> +++ b/drivers/staging/ramzswap/ramzswap_drv.c
> @@ -276,6 +276,7 @@ void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
>  	s->failed_reads = rs->failed_reads;
>  	s->failed_writes = rs->failed_writes;
>  	s->invalid_io = rs->invalid_io;
> +	s->notify_free = rs->notify_free;
>  	s->pages_zero = rs->pages_zero;
>  
>  	s->good_compress_pct = good_compress_perc;
> @@ -1310,9 +1311,21 @@ out:
>  	return ret;
>  }
>  
> +void ramzswap_slot_free_notify(struct block_device *bdev, unsigned long index)
> +{
> +	struct ramzswap *rzs;
> +
> +	rzs = bdev->bd_disk->private_data;
> +	ramzswap_free_page(rzs, index);
> +	stat_inc(rzs->stats.notify_free);
> +
> +	return;
> +}
> +
>  static struct block_device_operations ramzswap_devops = {
>  	.ioctl = ramzswap_ioctl,
> -	.owner = THIS_MODULE,
> +	.swap_slot_free_notify = ramzswap_slot_free_notify,
> +	.owner = THIS_MODULE
>  };
>  
>  static void create_device(struct ramzswap *rzs, int device_id)
> diff --git a/drivers/staging/ramzswap/ramzswap_drv.h b/drivers/staging/ramzswap/ramzswap_drv.h
> index a6ea240..adc841a 100644
> --- a/drivers/staging/ramzswap/ramzswap_drv.h
> +++ b/drivers/staging/ramzswap/ramzswap_drv.h
> @@ -124,6 +124,7 @@ struct ramzswap_stats {
>  	u64 failed_reads;	/* can happen when memory is too low */
>  	u64 failed_writes;	/* should NEVER! happen */
>  	u64 invalid_io;		/* non-swap I/O requests */
> +	u64 notify_free;	/* no. of swap slot free notifications */
>  	u32 pages_zero;		/* no. of zero filled pages */
>  	u32 pages_stored;	/* no. of pages currently stored */
>  	u32 good_compress;	/* % of pages with compression ratio<=50% */
> diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h b/drivers/staging/ramzswap/ramzswap_ioctl.h
> index c713a09..ec50416 100644
> --- a/drivers/staging/ramzswap/ramzswap_ioctl.h
> +++ b/drivers/staging/ramzswap/ramzswap_ioctl.h
> @@ -27,6 +27,7 @@ struct ramzswap_ioctl_stats {
>  	u64 failed_reads;	/* can happen when memory is too low */
>  	u64 failed_writes;	/* should NEVER! happen */
>  	u64 invalid_io;		/* non-swap I/O requests */
> +	u64 notify_free;	/* no. of swap slot free notifications */
>  	u32 pages_zero;		/* no. of zero filled pages */
>  	u32 good_compress_pct;	/* no. of pages with compression ratio<=50% */
>  	u32 pages_expand_pct;	/* no. of incompressible pages */
> -- 
> 1.6.2.5
