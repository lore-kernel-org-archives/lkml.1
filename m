Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYKUQcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYKUQcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKUQci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:32:38 -0500
Received: from gw.goop.org ([64.81.55.164]:54996 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYKUQch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:32:37 -0500
Message-ID: <4926E2A2.2060602@goop.org>
Date: Fri, 21 Nov 2008 08:32:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] xen: pin correct PGD on suspend
References: <1227262893-27335-1-git-send-email-Ian.Campbell@citrix.com>
In-Reply-To: <1227262893-27335-1-git-send-email-Ian.Campbell@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> commit eefb47f6a1e855653d275cb90592a3587ea93a09 ("xen: use
> spin_lock_nest_lock when pinning a pagetable") changed xen_pgd_walk to
> walk over mm->pgd rather than taking pgd as an argument.
>
> This breaks xen_mm_(un)pin_all() because it makes init_mm.pgd readonly
> instead of the pgd we are interested in and therefore the pin subsequently
> fails.
>   

Oh, yeah, that was a bit dense.  This is needed for .28.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Thanks,
    J

> (XEN) mm.c:2280:d15 Bad type (saw 00000000e8000001 != exp 0000000060000000) for mfn bc464 (pfn 21ca7)
> (XEN) mm.c:2665:d15 Error while pinning mfn bc464
>
> [   14.586913] 1 multicall(s) failed: cpu 0
> [   14.586926] Pid: 14, comm: kstop/0 Not tainted 2.6.28-rc5-x86_32p-xenU-00172-gee2f6cc #200
> [   14.586940] Call Trace:
> [   14.586955]  [<c030c17a>] ? printk+0x18/0x1e
> [   14.586972]  [<c0103df3>] xen_mc_flush+0x163/0x1d0
> [   14.586986]  [<c0104bc1>] __xen_pgd_pin+0xa1/0x110
> [   14.587000]  [<c015a330>] ? stop_cpu+0x0/0xf0
> [   14.587015]  [<c0104d7b>] xen_mm_pin_all+0x4b/0x70
> [   14.587029]  [<c022bcb9>] xen_suspend+0x39/0xe0
> [   14.587042]  [<c015a330>] ? stop_cpu+0x0/0xf0
> [   14.587054]  [<c015a3cd>] stop_cpu+0x9d/0xf0
> [   14.587067]  [<c01417cd>] run_workqueue+0x8d/0x150
> [   14.587080]  [<c030e4b3>] ? _spin_unlock_irqrestore+0x23/0x40
> [   14.587094]  [<c014558a>] ? prepare_to_wait+0x3a/0x70
> [   14.587107]  [<c0141918>] worker_thread+0x88/0xf0
> [   14.587120]  [<c01453c0>] ? autoremove_wake_function+0x0/0x50
> [   14.587133]  [<c0141890>] ? worker_thread+0x0/0xf0
> [   14.587146]  [<c014509c>] kthread+0x3c/0x70
> [   14.587157]  [<c0145060>] ? kthread+0x0/0x70
> [   14.587170]  [<c0109d1b>] kernel_thread_helper+0x7/0x10
> [   14.587181]   call  1/3: op=14 arg=[c0415000] result=0
> [   14.587192]   call  2/3: op=14 arg=[e1ca2000] result=0
> [   14.587204]   call  3/3: op=26 arg=[c1808860] result=-22
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/xen/mmu.c |   21 ++++++++++++++-------
>  1 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 6889360..636ef4c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -661,12 +661,11 @@ void xen_set_pgd(pgd_t *ptr, pgd_t val)
>   * For 64-bit, we must skip the Xen hole in the middle of the address
>   * space, just after the big x86-64 virtual hole.
>   */
> -static int xen_pgd_walk(struct mm_struct *mm,
> -			int (*func)(struct mm_struct *mm, struct page *,
> -				    enum pt_level),
> -			unsigned long limit)
> +static int __xen_pgd_walk(struct mm_struct *mm, pgd_t *pgd,
> +			  int (*func)(struct mm_struct *mm, struct page *,
> +				      enum pt_level),
> +			  unsigned long limit)
>  {
> -	pgd_t *pgd = mm->pgd;
>  	int flush = 0;
>  	unsigned hole_low, hole_high;
>  	unsigned pgdidx_limit, pudidx_limit, pmdidx_limit;
> @@ -753,6 +752,14 @@ out:
>  	return flush;
>  }
>  
> +static int xen_pgd_walk(struct mm_struct *mm,
> +			int (*func)(struct mm_struct *mm, struct page *,
> +				    enum pt_level),
> +			unsigned long limit)
> +{
> +	return __xen_pgd_walk(mm, mm->pgd, func, limit);
> +}
> +
>  /* If we're using split pte locks, then take the page's lock and
>     return a pointer to it.  Otherwise return NULL. */
>  static spinlock_t *xen_pte_lock(struct page *page, struct mm_struct *mm)
> @@ -854,7 +861,7 @@ static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
>  
>  	xen_mc_batch();
>  
> -	 if (xen_pgd_walk(mm, xen_pin_page, USER_LIMIT)) {
> +	if (__xen_pgd_walk(mm, pgd, xen_pin_page, USER_LIMIT)) {
>  		/* re-enable interrupts for flushing */
>  		xen_mc_issue(0);
>  
> @@ -998,7 +1005,7 @@ static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
>  		       PT_PMD);
>  #endif
>  
> -	xen_pgd_walk(mm, xen_unpin_page, USER_LIMIT);
> +	__xen_pgd_walk(mm, pgd, xen_unpin_page, USER_LIMIT);
>  
>  	xen_mc_issue(0);
>  }
>   

