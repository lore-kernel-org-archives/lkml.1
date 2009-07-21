Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZGUFvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZGUFvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZGUFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:51:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbZGUFvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:51:13 -0400
Date: Mon, 20 Jul 2009 22:49:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 04/16] drbd: dirty bitmap
Message-Id: <20090720224957.a8a36701.akpm@linux-foundation.org>
In-Reply-To: <1246894775-10855-5-git-send-email-philipp.reisner@linbit.com>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
	<1246894775-10855-2-git-send-email-philipp.reisner@linbit.com>
	<1246894775-10855-3-git-send-email-philipp.reisner@linbit.com>
	<1246894775-10855-4-git-send-email-philipp.reisner@linbit.com>
	<1246894775-10855-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Jul 2009 17:39:23 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> DRBD maintains a dirty bitmap in case it has to run without peer node or
> without local disk. Writes to the on disk dirty bitmap are minimized by the
> activity log (=AL). Each time an extent is evicted from the AL the part of
> the bitmap no longer covered by the AL is written to disk.
> 
> ...
>
> +static struct page **bm_realloc_pages(struct drbd_bitmap *b, unsigned long want)
> +{
> +	struct page **old_pages = b->bm_pages;
> +	struct page **new_pages, *page;
> +	unsigned int i, bytes, vmalloced = 0;
> +	unsigned long have = b->bm_number_of_pages;
> +
> +	BUG_ON(have == 0 && old_pages != NULL);
> +	BUG_ON(have != 0 && old_pages == NULL);
> +
> +	if (have == want)
> +		return old_pages;
> +
> +	/* Trying kmalloc first, falling back to vmalloc.
> +	 * GFP_KERNEL is ok, as this is done when a lower level disk is
> +	 * "attached" to the drbd.  Context is receiver thread or cqueue
> +	 * thread.  As we have no disk yet, we are not in the IO path,
> +	 * not even the IO path of the peer. */
> +	bytes = sizeof(struct page *)*want;
> +	new_pages = kmalloc(bytes, GFP_KERNEL);
> +	if (!new_pages) {
> +		new_pages = vmalloc(bytes);
> +		if (!new_pages)
> +			return NULL;
> +		vmalloced = 1;
> +	}
> +
> +	memset(new_pages, 0, bytes);
> +	if (want >= have) {
> +		for (i = 0; i < have; i++)
> +			new_pages[i] = old_pages[i];
> +		for (; i < want; i++) {
> +			page = alloc_page(GFP_HIGHUSER);
> +			if (!page) {
> +				bm_free_pages(new_pages + have, i - have);
> +				bm_vk_free(new_pages, vmalloced);
> +				return NULL;
> +			}
> +			new_pages[i] = page;
> +		}
> +	} else {
> +		for (i = 0; i < want; i++)
> +			new_pages[i] = old_pages[i];
> +		/* NOT HERE, we are outside the spinlock!
> +		bm_free_pages(old_pages + want, have - want);
> +		*/
> +	}
> +
> +	if (vmalloced)
> +		set_bit(BM_P_VMALLOCED, &b->bm_flags);
> +	else
> +		clear_bit(BM_P_VMALLOCED, &b->bm_flags);
> +
> +	return new_pages;
> +}

The vmalloc is always troublesome.

It's a pretty commonly-occurring pattern and I've been suggesting that
we implement a generic dynamic-array facility so that those callsites
which wish to do huge contiguous allocations need no longer do that.

Please take a look at this thread: http://lkml.org/lkml/2009/7/2/464
and let's see if there's any useful commonality here.  I think there
is...

