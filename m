Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZIQJkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZIQJkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZIQJkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:40:16 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:23146 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZIQJkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:40:14 -0400
X-SourceIP: 213.93.53.227
Subject: Re: aim7 scalability issue on 4 socket machine
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
In-Reply-To: <1253179879.2606.37.camel@ymzhang>
References: <1253179879.2606.37.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 11:40:11 +0200
Message-Id: <1253180411.8497.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 17:31 +0800, Zhang, Yanmin wrote:
> ﻿Aim7 result is bad on my new Nehalem machines (4*8*2 logical cpu). Perf counter
> shows spinlock consumes 70% cpu time on the machine. Lock_stat shows
> anon_vma->lock causes most of the spinlock contention. Function tracer shows
> below call chain creates the spinlock.
> 
> do_brk => vma_merge =>vma_adjust
> 
> Aim7 consists of lots of subtests. One test is to fork lots of processes and
> every process calls sbrk for 1000 times to grow/shrink the heap. All the vma of
> the heap of all sub-processes point to the same anon_vma and use the same
> anon_vma->lock. When sbrk is called, kernel calls do_brk => vma_merge =>vma_adjust
> and lock anon_vma->lock to create spinlock contentions.
> 
> There is a comment section in front of spin_lock(&anon_vma->lock. It says
> anon_vma lock can be optimized when just changing vma->vm_end. As a matter
> of fact, anon_vma->lock is used to protect anon_vma->list when an entry is
> deleted/inserted or the list is accessed. There is no such deletion/insertion
> if only vma->end is changed in function vma_adjust.
> 
> Below patch fixes it.
> 
> Test results with kernel 2.6.31-rc8. The improvement on the machine is about 150%.

Did you see Lee's patch?:

 http://lkml.org/lkml/2009/9/9/290

Added Lee and Hugh to CC, retained the below patch for them.

> ﻿﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> ---
> 
> --- linux-2.6.31-rc8/mm/mmap.c	2009-09-03 10:03:57.000000000 +0800
> +++ linux-2.6.31-rc8_aim7/mm/mmap.c	2009-09-17 19:11:20.000000000 +0800
> @@ -512,6 +512,7 @@ void vma_adjust(struct vm_area_struct *v
>  	struct anon_vma *anon_vma = NULL;
>  	long adjust_next = 0;
>  	int remove_next = 0;
> +	int anon_vma_use_lock;
>  
>  	if (next && !insert) {
>  		if (end >= next->vm_end) {
> @@ -568,22 +569,32 @@ again:			remove_next = 1 + (end > next->
>  		}
>  	}
>  
> -	/*
> -	 * When changing only vma->vm_end, we don't really need
> -	 * anon_vma lock: but is that case worth optimizing out?
> -	 */
>  	if (vma->anon_vma)
>  		anon_vma = vma->anon_vma;
> +	anon_vma_use_lock = 0;
>  	if (anon_vma) {
> -		spin_lock(&anon_vma->lock);
>  		/*
> -		 * Easily overlooked: when mprotect shifts the boundary,
> -		 * make sure the expanding vma has anon_vma set if the
> -		 * shrinking vma had, to cover any anon pages imported.
> +		 * When changing only vma->vm_end, we don't really need
> +		 * anon_vma lock.
> +		 * ana_vma->lock is to protect the access to the list
> +		 * started from anon_vma->head. If we don't remove or
> +		 * insert a vma to the list, and also don't access
> +		 * the list, we don't need  ana_vma->lock.
>  		 */
> -		if (importer && !importer->anon_vma) {
> -			importer->anon_vma = anon_vma;
> -			__anon_vma_link(importer);
> +		if (remove_next ||
> +			insert ||
> +			(importer && !importer->anon_vma)) {
> +			anon_vma_use_lock = 1;
> +			spin_lock(&anon_vma->lock);
> +			/*
> +			 * Easily overlooked: when mprotect shifts the boundary,
> +			 * make sure the expanding vma has anon_vma set if the
> +			 * shrinking vma had, to cover any anon pages imported.
> +			 */
> +			if (importer && !importer->anon_vma) {
> +				importer->anon_vma = anon_vma;
> +				__anon_vma_link(importer);
> +			}
>  		}
>  	}
>  
> @@ -628,7 +639,7 @@ again:			remove_next = 1 + (end > next->
>  		__insert_vm_struct(mm, insert);
>  	}
>  
> -	if (anon_vma)
> +	if (anon_vma_use_lock)
>  		spin_unlock(&anon_vma->lock);
>  	if (mapping)
>  		spin_unlock(&mapping->i_mmap_lock);
> 
> 

