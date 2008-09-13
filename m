Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbYIMRLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbYIMRLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYIMRK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:10:56 -0400
Received: from gw.goop.org ([64.81.55.164]:51597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYIMRKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:10:55 -0400
Message-ID: <48CBF41D.5080202@goop.org>
Date: Sat, 13 Sep 2008 10:10:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] x86, cpa: global flush tlb after splitting large
 page and before doing cpa
References: <20080911203048.929515000@linux-os.sc.intel.com> <20080911204151.287251000@linux-os.sc.intel.com>
In-Reply-To: <20080911204151.287251000@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Do a global flush tlb after splitting the large page and before we do the
> actual change page attribute in the PTE.
>
> With out this, we violate the TLB application note, which says
>     "The TLBs may contain both ordinary and large-page translations for
>      a 4-KByte range of linear addresses. This may occur if software
>      modifies the paging structures so that the page size used for the
>      address range changes. If the two translations differ with respect
>      to page frame or attributes (e.g., permissions), processor behavior
>      is undefined and may be implementation-specific."
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>
> Index: tip/arch/x86/mm/pageattr.c
> ===================================================================
> --- tip.orig/arch/x86/mm/pageattr.c	2008-09-11 13:25:55.000000000 -0700
> +++ tip/arch/x86/mm/pageattr.c	2008-09-11 13:25:57.000000000 -0700
> @@ -131,6 +131,18 @@
>  	mb();
>  }
>  
> +static void __global_flush_tlb(void *arg)
> +{
> +	__flush_tlb_all();
> +}
> +
> +static void global_flush_tlb(void)
> +{
> +	BUG_ON(irqs_disabled());
> +
> +	on_each_cpu(__global_flush_tlb, NULL, 1);
> +}
>   

Use flush_tlb_others(), which will get paravirtualized properly.

    J
