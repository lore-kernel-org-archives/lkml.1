Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYJHVqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYJHVqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYJHVpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:45:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:14465 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYJHVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TzJ1PAjc+AoIrfvl9PJ2M1MtCi2+Lil2CB7Bb2RUmuAfI9JUBeRigSxqiiA1fI2S0u
         ic77SosIPuUXlmShArmNUZPSaiu6RHCVTeyFSrTHLp0g/BKrsElVol/STuiDii6PavVF
         0IAcmIZ3WPhvzKYPWPZADLDruBS9b6etUU1Ys=
Date: Thu, 9 Oct 2008 01:38:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in
	/proc/pid/smaps
Message-ID: <20081008213831.GA23729@x200.localdomain>
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie> <1223052415-18956-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223052415-18956-2-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 05:46:54PM +0100, Mel Gorman wrote:
> It is useful to verify a hugepage-aware application is using the expected
> pagesizes for its memory regions. This patch creates an entry called
> KernelPageSize in /proc/pid/smaps that is the size of page used by the
> kernel to back a VMA. The entry is not called PageSize as it is possible
> the MMU uses a different size. This extension should not break any sensible
> parser that skips lines containing unrecognised information.

> +		   "KernelPageSize: %8lu kB\n",

> +unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> +{
> +	struct hstate *hstate;
> +
> +	if (!is_vm_hugetlb_page(vma))
> +		return PAGE_SIZE;
> +
> +	hstate = hstate_vma(vma);
> +	VM_BUG_ON(!hstate);
> +
> +	return 1UL << (hstate->order + PAGE_SHIFT);
			    ^^^^
VM_BUG_ON is unneeded because kernel will oops here if hstate is NULL.

Also, in /proc/*/maps it's printed only for hugetlb vmas and called
hpagesize, in smaps it's printed for every vma and called
KernelPageSize. All of this is inconsistent.

And app will verify once that hugepages are of right size, so Pss cost
argument for changing /proc/*/maps seems weak to me.
