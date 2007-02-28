Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbXB1U2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbXB1U2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXB1U2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:28:52 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:32722 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXB1U2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:28:51 -0500
X-AuditID: d80ac287-9eb9bbb000002978-58-45e5e60234a7 
Date: Wed, 28 Feb 2007 19:48:23 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adapt page_lock_anon_vma() to PREEMPT_RCU
In-Reply-To: <20070225200621.GA2259@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0702281946140.5568@blonde.wat.veritas.com>
References: <20070225200621.GA2259@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 28 Feb 2007 20:28:29.0507 (UTC) FILETIME=[01EFB130:01C75B77]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007, Oleg Nesterov wrote:

> page_lock_anon_vma() uses spin_lock() to block RCU. This doesn't work with
> PREEMPT_RCU, we have to do rcu_read_lock() explicitely. Otherwise, it is
> theoretically possible that slab returns anon_vma's memory to the system
> before we do spin_unlock(&anon_vma->lock).
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Hugh Dickins <hugh@veritas.com>

Thanks for doing this, and sorry for my delay.

Hugh

> 
> --- WQ/mm/rmap.c~	2007-02-18 22:56:49.000000000 +0300
> +++ WQ/mm/rmap.c	2007-02-25 22:43:00.000000000 +0300
> @@ -183,7 +183,7 @@ void __init anon_vma_init(void)
>   */
>  static struct anon_vma *page_lock_anon_vma(struct page *page)
>  {
> -	struct anon_vma *anon_vma = NULL;
> +	struct anon_vma *anon_vma;
>  	unsigned long anon_mapping;
>  
>  	rcu_read_lock();
> @@ -195,9 +195,16 @@ static struct anon_vma *page_lock_anon_v
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
>  	spin_lock(&anon_vma->lock);
> +	return anon_vma;
>  out:
>  	rcu_read_unlock();
> -	return anon_vma;
> +	return NULL;
> +}
> +
> +static void page_unlock_anon_vma(struct anon_vma *anon_vma)
> +{
> +	spin_unlock(&anon_vma->lock);
> +	rcu_read_unlock();
>  }
>  
>  /*
> @@ -333,7 +340,8 @@ static int page_referenced_anon(struct p
>  		if (!mapcount)
>  			break;
>  	}
> -	spin_unlock(&anon_vma->lock);
> +
> +	page_unlock_anon_vma(anon_vma);
>  	return referenced;
>  }
>  
> @@ -809,7 +817,8 @@ static int try_to_unmap_anon(struct page
>  				!page_mapped(page))
>  			break;
>  	}
> -	spin_unlock(&anon_vma->lock);
> +
> +	page_unlock_anon_vma(anon_vma);
>  	return ret;
>  }
>  
> 
