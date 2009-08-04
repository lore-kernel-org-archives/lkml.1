Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbZHDVuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbZHDVuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbZHDVuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:50:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090AbZHDVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:50:10 -0400
Date: Tue, 4 Aug 2009 14:49:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: ieidus@redhat.com, aarcange@redhat.com, riel@redhat.com, chrisw@redhat.com,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/12] ksm: pages_unshared and pages_volatile
Message-Id: <20090804144920.bfc6a44f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0908031311061.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
	<Pine.LNX.4.64.0908031311061.16754@sister.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 13:11:53 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> The pages_shared and pages_sharing counts give a good picture of how
> successful KSM is at sharing; but no clue to how much wasted work it's
> doing to get there.  Add pages_unshared (count of unique pages waiting
> in the unstable tree, hoping to find a mate) and pages_volatile.
> 
> pages_volatile is harder to define.  It includes those pages changing
> too fast to get into the unstable tree, but also whatever other edge
> conditions prevent a page getting into the trees: a high value may
> deserve investigation.  Don't try to calculate it from the various
> conditions: it's the total of rmap_items less those accounted for.
> 
> Also show full_scans: the number of completed scans of everything
> registered in the mm list.
> 
> The locking for all these counts is simply ksm_thread_mutex.
> 
> ...
>
>  static inline struct rmap_item *alloc_rmap_item(void)
>  {
> -	return kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
> +	struct rmap_item *rmap_item;
> +
> +	rmap_item = kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
> +	if (rmap_item)
> +		ksm_rmap_items++;
> +	return rmap_item;
>  }

ksm_rmap_items was already available via /proc/slabinfo.  I guess that
wasn't a particularly nice user interface ;)

