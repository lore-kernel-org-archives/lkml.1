Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbYBBKiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbYBBKiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761932AbYBBKiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:38:09 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40323 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761830AbYBBKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:38:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=07wseUU0pTIc+jB7dkoUl8SlPs90+gEk0irNUPwu6swkIItxVjwLxGTV9Ngy4s+r3+q/vQYZsRCo0gVAzmnLXQOCL/nhUYRysW56q4tVW8NxnFxdqpSVO3ELvciT4vmKoVqloYP+RwNW+DqQB1fUxZVhHKUv0xEctv/a8E644eQ=  ;
X-YMail-OSG: LSdWgEwVM1lKdlKZ2vy8BgQc0JiQjPCJT8p6E3_wVjdNK.xuqJM4n0hbfdteOUdFADvw9LaEKA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Denis Cheng <crquan@gmail.com>
Subject: Re: [PATCH 3/3] uio: vm_operations_struct ->nopage to ->fault method conversion
Date: Sat, 2 Feb 2008 21:37:45 +1100
User-Agent: KMail/1.9.5
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, cr_quan@163.com
References: < <1201945897-32297-1-git-send-email-crquan@gmail.com> <1201945897-32297-2-git-send-email-crquan@gmail.com> <1201945897-32297-3-git-send-email-crquan@gmail.com>
In-Reply-To: <1201945897-32297-3-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802022137.45493.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 20:51, Denis Cheng wrote:
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Thanks, but already patched in -mm.

> ---
>  drivers/uio/uio.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index cc246fa..47e0c32 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -417,30 +417,27 @@ static void uio_vma_close(struct vm_area_struct *vma)
>  	idev->vma_count--;
>  }
>
> -static struct page *uio_vma_nopage(struct vm_area_struct *vma,
> -				   unsigned long address, int *type)
> +static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct uio_device *idev = vma->vm_private_data;
> -	struct page* page = NOPAGE_SIGBUS;
>
>  	int mi = uio_find_mem_index(vma);
>  	if (mi < 0)
> -		return page;
> +		return VM_FAULT_SIGBUS;
>
>  	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
> -		page = virt_to_page(idev->info->mem[mi].addr);
> +		vmf->page = virt_to_page(idev->info->mem[mi].addr);
>  	else
> -		page = vmalloc_to_page((void*)idev->info->mem[mi].addr);
> -	get_page(page);
> -	if (type)
> -		*type = VM_FAULT_MINOR;
> -	return page;
> +		vmf->page = vmalloc_to_page((void *)idev->info->mem[mi].addr);
> +	get_page(vmf->page);
> +
> +	return 0;
>  }
>
>  static struct vm_operations_struct uio_vm_ops = {
>  	.open = uio_vma_open,
>  	.close = uio_vma_close,
> -	.nopage = uio_vma_nopage,
> +	.fault = uio_vma_fault,
>  };
>
>  static int uio_mmap_physical(struct vm_area_struct *vma)
