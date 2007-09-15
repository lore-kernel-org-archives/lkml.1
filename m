Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXIOKly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXIOKly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXIOKln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:41:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbXIOKlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:41:42 -0400
Date: Sat, 15 Sep 2007 03:41:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH] 9p: add readahead support for loose mode
Message-Id: <20070915034126.cd2c2073.akpm@linux-foundation.org>
In-Reply-To: <11897857601214-git-send-email-ericvh@gmail.com>
References: <11897857601214-git-send-email-ericvh@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 11:02:40 -0500 Eric Van Hensbergen <ericvh@gmail.com> wrote:

> +	list_for_each_entry_reverse(tmp_page, page_list, lru) {
> +		BUG_ON(count > num_pages);
> +		if (add_to_page_cache(tmp_page, mapping,
> +					tmp_page->index, GFP_KERNEL)) {
> +			page_cache_release(tmp_page);
> +			continue;
> +		}
> +
> +		kv[count].iov_base = kmap(tmp_page);
> +		kv[count].iov_len = PAGE_CACHE_SIZE;
> +		count++;
> +	}
> +
> +	read_size = count * PAGE_CACHE_SIZE;
> +	if (!read_size)
> +		goto cleanup;
> +
> +	retval = p9_client_readv(fid, kv, offset, count);
> +
> +cleanup:
> +	list_for_each_safe(p, n, page_list) {
> +		tmp_page = list_entry(p, struct page, lru);
> +		list_del(&tmp_page->lru);
> +		if (!pagevec_add(&lru_pvec, tmp_page))
> +			__pagevec_lru_add(&lru_pvec);
> +		kunmap(tmp_page);
> +		flush_dcache_page(tmp_page);
> +		SetPageUptodate(tmp_page);
> +		unlock_page(tmp_page);
> +	}

eww, kmap.  Large amounts of them, apparently.

Be aware that kmap is a) slow and b) deadlockable.  The latter happens when
multiple tasks want to take more than one kmap simultaneously: they all
wait for someone else to release one.  Your code here seems especially
vulnerable to this.

Nick had a kmap-speedup patchset a while back which addressed a) but I
don't know if it addressed the deadlock.  But that patch seemed to die.

Strongly recommend that the code be reworked to use kmap_atomic()


