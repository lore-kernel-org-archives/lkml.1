Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYBMBN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYBMBN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYBMBNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:13:18 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:37880 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752847AbYBMBNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:13:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EVckUVpf0wJB3Ah/i4mExHRB/y0AWiHrr37eDlImLfZPE2c0a363ectIwCpcWKEutzPJjuUwJPnZLyt2KQios8zsnRxACkveF5XiYWpeqS9SIHF6EgAUh2BKgrq/1l6vbEvx4C3xBq3I7XJvVhvp1tQoDQQm9WxqXDviHxpqpy4=  ;
X-YMail-OSG: h29MhoIVM1kCJQI9YQoUgYq066b2iIcTgLSCQenn6Q4sndID
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: [PATCH 2/2 resend] mm: various cleanups in get_user_pages()
Date: Wed, 13 Feb 2008 12:13:04 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, corbet@lwn.net
References: <20080212112919.GB3481@kernel.sg> <20080212114024.GA4440@kernel.sg> <20080212131030.GA3332@kernel.sg>
In-Reply-To: <20080212131030.GA3332@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131213.04902.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 00:10, Eugene Teo wrote:
> Sorry for the repeated emails. Kindly ignore the previous resend. Please
> review this instead. Thanks. I have tested this.

If it is causing this much problems, can you split the cleanups into
their own patches.


> [PATCH 2/2] mm: various cleanups in get_user_pages()
>
> This patch contains various cleanups, including making sure vma is valid,
> and the return value of follow_hugetlb_page() is validated.
>
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  mm/memory.c |   24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 54f951b..c7e0610 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1003,7 +1003,9 @@ int get_user_pages(struct task_struct *tsk, struct
> mm_struct *mm, unsigned int foll_flags;
>
>  		vma = find_extend_vma(mm, start);
> -		if (!vma && in_gate_area(tsk, start)) {
> +		if (!vma)
> +			goto finish_or_fault;
> +		if (in_gate_area(tsk, start)) {
>  			unsigned long pg = start & PAGE_MASK;
>  			struct vm_area_struct *gate_vma = get_gate_vma(tsk);
>  			pgd_t *pgd;

Doesn't this break the logic?

If you don't have a vma, but you are in the gate area, then you
should use the gate vma. With your patch, gate area will fault.

> @@ -1011,7 +1013,7 @@ int get_user_pages(struct task_struct *tsk, struct
> mm_struct *mm, pmd_t *pmd;
>  			pte_t *pte;
>  			if (write) /* user gate pages are read-only */
> -				return i ? : -EFAULT;
> +				goto finish_or_fault;

I don't know if this is exactly a cleanup or not... I guess gcc
probably isn't smart enough to fold them all together, so it should
use a little less code in the unlikely branches. Does it?
