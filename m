Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbZELIkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbZELIkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZELIkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:40:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:14159 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbZELIkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:40:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,181,1241420400"; 
   d="scan'208";a="689658379"
Subject: Re: [PATCH]X86: make sparse mem work in non-NUMA mode
From: Shaohua Li <shaohua.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, "Yang, Sheng" <sheng.yang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090512075933.GA26689@elte.hu>
References: <1242100517.10593.7.camel@sli10-desk.sh.intel.com>
	 <20090512075933.GA26689@elte.hu>
Content-Type: text/plain
Date: Tue, 12 May 2009 16:40:00 +0800
Message-Id: <1242117600.22431.0.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:59 +0800, Ingo Molnar wrote:
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > With sparse, memory holes should not be marked present for memmap.
> > This patch makes sparse really works on non-NUMA mode.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > Signed-off-by: Sheng Yang <sheng.yang@intel.com>
> 
> It does not apply cleanly to the latest x86 tree:
> 
>   patching file arch/x86/mm/init_32.c
>   Hunk #1 succeeded at 718 (offset -43 lines).
>   patching file arch/x86/mm/init_64.c
>   Hunk #1 FAILED at 638.
>   1 out of 1 hunk FAILED -- rejects in file arch/x86/mm/init_64.c
Looks the x64 code already has the fix.

With sparse, memory holes should not be marked present for memmap.
This patch makes sparse really works on SMP mode.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9cdd9b0..5da919b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -718,15 +718,15 @@ void __init initmem_init(unsigned long start_pfn,
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memory_present(0, 0, highend_pfn);
 	e820_register_active_regions(0, 0, highend_pfn);
+	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	memory_present(0, 0, max_low_pfn);
 	e820_register_active_regions(0, 0, max_low_pfn);
+	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif


