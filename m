Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392Ab0AKX3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0AKX3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949Ab0AKX3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:29:48 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:25724 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab0AKX3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:29:48 -0500
X-Trace: 325642133/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMBAEZDS0tPRRyw/2dsb2JhbAAI1n6ELwQ
X-IronPort-AV: E=Sophos;i="4.49,258,1262563200"; 
   d="scan'208";a="325642133"
Date: Mon, 11 Jan 2010 23:29:37 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] Fix fault count of task in GUP
In-Reply-To: <20100111114224.bbf0fc62.minchan.kim@barrios-desktop>
Message-ID: <alpine.LSU.2.00.1001112320490.7893@sister.anvils>
References: <20100111114224.bbf0fc62.minchan.kim@barrios-desktop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010, Minchan Kim wrote:
> 
> get_user_pages calls handle_mm_fault to pin the arguemented
> task's page. handle_mm_fault cause major or minor fault and
> get_user_pages counts it into task which is passed by argument.
> 
> But the fault happens in current task's context.
> So we have to count it not argumented task's context but current
> task's one.

Have to?

current simulates a fault into tsk's address space.
It is not a fault into current's address space.

I can see that this could be argued either way, or even
that such a "fault" should not be counted at all; but I do not
see a reason to change the way we have been counting it for years.

Sorry, but NAK (to this and to the v2) -
unless you have a stronger argument.

Hugh

> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> CC: Nick Piggin <npiggin@suse.de>
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>  mm/memory.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 521abf6..2513581 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1486,9 +1486,9 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  					BUG();
>  				}
>  				if (ret & VM_FAULT_MAJOR)
> -					tsk->maj_flt++;
> +					current->maj_flt++;
>  				else
> -					tsk->min_flt++;
> +					current->min_flt++;
>  
>  				/*
>  				 * The VM_FAULT_WRITE bit tells us that
> -- 
> 1.5.6.3
> 
> 
> -- 
> Kind regards,
> Minchan Kim
