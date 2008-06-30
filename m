Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbYF3TAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbYF3TAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYF3S7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:59:52 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:57140 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYF3S7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:59:51 -0400
Date: Mon, 30 Jun 2008 20:00:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Benny Halevy <bhalevy@panasas.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix uninitialized variables for find_vma_prepare
 callers
In-Reply-To: <1214844882-22560-1-git-send-email-bhalevy@panasas.com>
Message-ID: <Pine.LNX.4.64.0806301942220.22984@blonde.site>
References: <1214844882-22560-1-git-send-email-bhalevy@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Benny Halevy wrote:
> gcc 4.3.0 correctly emits the following warnings.
> When a vma covering addr is found, find_vma_prepare indeed returns without
> setting pprev, rb_link, and rb_parent.

That's amusing, thank you.

You may wonder how the vma rb_tree has been working all these years
despite that.  The answer is that we only use find_vma_prepare when
about to insert a new vma: if there's anything already there, it's
either an error condition, or we go off and unmap the overlap without
taking any interest in those uninitialized values for linking.

It would be nicer to initialize them, and your patch is certainly
nice and simple.  Would it have the effect, that it returns with
vma == *pprev when addr falls within an existing vma?
That would be a sensible outcome, I think.

Hugh

> [warnings snipped]
> 
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  mm/mmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3354fdd..81b9873 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -366,7 +366,7 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
>  		if (vma_tmp->vm_end > addr) {
>  			vma = vma_tmp;
>  			if (vma_tmp->vm_start <= addr)
> -				return vma;
> +				break;
>  			__rb_link = &__rb_parent->rb_left;
>  		} else {
>  			rb_prev = __rb_parent;
