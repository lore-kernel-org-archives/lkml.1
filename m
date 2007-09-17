Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXIQTNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXIQTNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXIQTNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:13:22 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57542 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbXIQTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:13:22 -0400
Message-ID: <46EED1A7.5080606@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2007 00:42:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mm] fix swapoff breakage; however...
References: <Pine.LNX.4.64.0709171947130.15413@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0709171947130.15413@blonde.wat.veritas.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> rc4-mm1's memory-controller-memory-accounting-v7.patch broke swapoff:
> it extended unuse_pte_range's boolean "found" return code to allow an
> error return too; but ended up returning found (1) as an error.
> Replace that by success (0) before it gets to the upper level.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> More fundamentally, it looks like any container brought over its limit in
> unuse_pte will abort swapoff: that doesn't doesn't seem "contained" to me.
> Maybe unuse_pte should just let containers go over their limits without
> error?  Or swap should be counted along with RSS?  Needs reconsideration.
> 
>  mm/swapfile.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.23-rc4-mm1/mm/swapfile.c	2007-09-07 13:09:42.000000000 +0100
> +++ linux/mm/swapfile.c	2007-09-17 15:14:47.000000000 +0100
> @@ -642,7 +642,7 @@ static int unuse_mm(struct mm_struct *mm
>  			break;
>  	}
>  	up_read(&mm->mmap_sem);
> -	return ret;
> +	return (ret < 0)? ret: 0;

Thanks, for the catching this. There are three possible solutions

1. Account each RSS page with a probable swap cache page, double
   the RSS accounting to ensure that swapoff will not fail.
2. Account for the RSS page just once, do not account swap cache
   pages
3. Follow your suggestion and let containers go over their limits
   without error

With the current approach, a container over it's limit will not
be able to call swapoff successfully, is that bad?

We plan to implement per container/per cpuset swap in the future.
Given that, isn't this expected functionality. You are over it's
limit cannot really swapoff a swap device. If we allow pages to
be unused, we could end up with a container that could exceed
it's limit by a significant amount by calling swapoff.


>  }
> 
>  /*


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
