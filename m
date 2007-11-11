Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbXKKEZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbXKKEZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 23:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXKKEZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 23:25:43 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:60408 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbXKKEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 23:25:42 -0500
Date: Sun, 11 Nov 2007 09:55:10 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Olof Johansson <olof@lixom.net>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] [POWERPC] Fix CONFIG_SMP=n build error on ppc64
Message-ID: <20071111042510.GA9597@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20071110205929.GA4845@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110205929.GA4845@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 02:59:29PM -0600, Olof Johansson wrote:
> [POWERPC] Fix CONFIG_SMP=n build error
> 
> The patch "KVM: fix !SMP build error" change the way smp_call_function()
> actually uses the passed in function names on non-SMP builds. So
> previously it was never caught that the function passed in was never
> actually defined.
> 
> This causes a build error on ppc64_defconfig + CONFIG_SMP=n:
> 
> arch/powerpc/mm/tlb_64.c: In function 'pgtable_free_now':
> arch/powerpc/mm/tlb_64.c:71: error: 'pte_free_smp_sync' undeclared (first use in this function)
> arch/powerpc/mm/tlb_64.c:71: error: (Each undeclared identifier is reported only once
> arch/powerpc/mm/tlb_64.c:71: error: for each function it appears in.)
> 
> So we need to define it even if CONFIG_SMP is off. Either that or ifdef
> out the smp_call_function() call, but that's ugly.
Hi,

Thanks, the patch fixes the build failure.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/arch/powerpc/mm/tlb_64.c b/arch/powerpc/mm/tlb_64.c
index eafbca5..e2d867c 100644
--- a/arch/powerpc/mm/tlb_64.c
+++ b/arch/powerpc/mm/tlb_64.c
@@ -54,12 +54,10 @@ unsigned long pte_freelist_forced_free;
      ((PAGE_SIZE - sizeof(struct pte_freelist_batch)) \ 
        / sizeof(pgtable_free_t))

-#ifdef CONFIG_SMP
 static void pte_free_smp_sync(void *arg)
 { 
      /* Do nothing, just ensure we sync with all CPUs */
 } 
-#endif

 /* This is only called when we are critically out of memory
  * (and fail to get a page in pte_free_tlb).

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
