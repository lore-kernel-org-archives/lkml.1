Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYCZLv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYCZLv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYCZLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:51:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33934
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbYCZLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:51:44 -0400
Date: Wed, 26 Mar 2008 04:51:43 -0700 (PDT)
Message-Id: <20080326.045143.218956952.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: sparc64 BUG: using smp_processor_id() in preemptible
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803261246.53770.m.kozlowski@tuxland.pl>
References: <20080326.041626.224135350.davem@davemloft.net>
	<20080326.042516.261621639.davem@davemloft.net>
	<200803261246.53770.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Wed, 26 Mar 2008 12:46:53 +0100

> Ok it worked. Now I get a bunch of these:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: pidof/2471
> caller is flush_ptrace_access+0xc0/0x1a0

Here ya go:

commit f6a843d939ade435e060d580f5c56d958464f8a5
Author: David S. Miller <davem@davemloft.net>
Date:   Wed Mar 26 04:51:12 2008 -0700

    [SPARC64]: flush_ptrace_access() needs preemption disable.
    
    Based upon a report by Mariusz Kozlowski.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/ptrace.c b/arch/sparc64/kernel/ptrace.c
index bcf58ec..aaae865 100644
--- a/arch/sparc64/kernel/ptrace.c
+++ b/arch/sparc64/kernel/ptrace.c
@@ -70,6 +70,8 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 	if (tlb_type == hypervisor)
 		return;
 
+	preempt_disable();
+
 #ifdef DCACHE_ALIASING_POSSIBLE
 	/* If bit 13 of the kernel address we used to access the
 	 * user page is the same as the virtual address that page
@@ -108,6 +110,8 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 		for (; start < end; start += icache_line_size)
 			flushi(start);
 	}
+
+	preempt_enable();
 }
 
 enum sparc_regset {
