Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXC1IE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXC1IE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXC1IE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:04:28 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:28613 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752109AbXC1IE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:04:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Qx2AX1BQA2CAOP6xHIn2lGpP8PuSlLZAhuRI16H1pxItGBQYpGqQ+TRjgc2Vwngg3aBVu4ygu6qoYnyFY4mHuWjSjLlkBsCU8sw3Mrsy9HTmEMdux1WzyIR5/jVne3BQHraYIY18gByJf6zGSaWahtsj5Emlw5ra546bc0v7TQ8=  ;
X-YMail-OSG: A8Mzfz8VM1n0ooSSXRF0gkUprGyFJtib.qp98oLGgD9wRQ_O57jhM41UspCFzrnpZxN3dpxSRVVNQ.8WLynOZC720kIxvC4vTgmBBSKVoW_5Cd.DI3U-
Message-ID: <460A2184.8060207@yahoo.com.au>
Date: Wed, 28 Mar 2007 18:04:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] revoke: break cow for private mappings
References: <Pine.LNX.4.64.0703271014100.793@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703271014100.793@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> We need to break COW for private mappings to make sure a process cannot
> read new data after an inode has been revoked.

Seems OK.

> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/revoke.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 73 insertions(+), 12 deletions(-)
> 
> Index: uml-2.6/fs/revoke.c
> ===================================================================
> --- uml-2.6.orig/fs/revoke.c	2007-03-26 18:10:24.000000000 +0300
> +++ uml-2.6/fs/revoke.c	2007-03-26 18:27:25.000000000 +0300
> @@ -174,12 +174,58 @@ static inline bool need_revoke(struct vm
>  	if (file->f_path.dentry->d_inode != inode)
>  		return false;
>  
> -	if (!(vma->vm_flags & VM_SHARED))
> -		return false;
> -
>  	return file != to_exclude;
>  }
>  
> +static int __revoke_break_cow(struct task_struct *tsk, struct inode *inode,
> +			      struct file *to_exclude)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +	struct vm_area_struct *vma;
> +	int err = 0;
> +
> +	down_write(&mm->mmap_sem);
> +	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
> +		int ret;
> +
> +		if (vma->vm_flags & VM_SHARED)
> +			continue;
> +
> +		if (!need_revoke(vma, inode, to_exclude))
> +			continue;
> +
> +		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
> +				     vma->vm_end-vma->vm_start, 1, 1, NULL,
> +				     NULL);

get_user_pages length argument is in # of pages, rather than address range,
I think. vma_pages is what you want?

> +		if (ret < 0) {
> +			err = ret;
> +			break;
> +		}
> +	}
> +	up_write(&mm->mmap_sem);

I think you just need down_read of mmap_sem here?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
