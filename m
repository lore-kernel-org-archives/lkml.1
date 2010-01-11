Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0AKXk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0AKXk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0AKXk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:40:58 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:38179 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529Ab0AKXk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:40:58 -0500
X-Trace: 325645898/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMBAJ9FS0tPRRyw/2dsb2JhbAAI1nqELwQ
X-IronPort-AV: E=Sophos;i="4.49,258,1262563200"; 
   d="scan'208";a="325645898"
Date: Mon, 11 Jan 2010 23:40:47 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] Count minor fault in break_ksm
In-Reply-To: <20100111114607.1d8cd1e0.minchan.kim@barrios-desktop>
Message-ID: <alpine.LSU.2.00.1001112334250.7893@sister.anvils>
References: <20100111114607.1d8cd1e0.minchan.kim@barrios-desktop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010, Minchan Kim wrote:

> We have counted task's maj/min fault after handle_mm_fault.
> break_ksm misses that.
> 
> I wanted to check by VM_FAULT_ERROR. 
> But now break_ksm doesn't handle HWPOISON error. 

Sorry, no, I just don't see a good reason to add this.
Imagine it this way: these aren't really faults, KSM simply
happens to be using "handle_mm_fault" to achieve what it needs.

(And, of course, if we did add something like this, I'd be
disagreeing with you about which tsk's min_flt to increment.)

Hugh

> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> CC: Izik Eidus <ieidus@redhat.com>
> ---
>  mm/ksm.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 56a0da1..3a1fda4 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -367,9 +367,13 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
>  		page = follow_page(vma, addr, FOLL_GET);
>  		if (!page)
>  			break;
> -		if (PageKsm(page))
> +		if (PageKsm(page)) {
>  			ret = handle_mm_fault(vma->vm_mm, vma, addr,
>  							FAULT_FLAG_WRITE);
> +			if (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_OOM)
> +					|| current->flags & PF_KTHREAD))
> +				current->min_flt++;
> +		}
>  		else
>  			ret = VM_FAULT_WRITE;
>  		put_page(page);
> -- 
> 1.5.6.3
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
