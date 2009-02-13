Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZBMAfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZBMAfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZBMAfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:35:33 -0500
Received: from gw.goop.org ([64.81.55.164]:58114 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZBMAfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:35:33 -0500
Message-ID: <4994C052.9060907@goop.org>
Date: Thu, 12 Feb 2009 16:35:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
References: <4994BCF0.30005@goop.org>
In-Reply-To: <4994BCF0.30005@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> commit 79d9c90453a7bc9e7613ae889a97ff6b44ab8380

Scratch that.  This instead.
    J

    mm: disable preemption in apply_to_pte_range
    
    Lazy mmu mode needs preemption disabled, so if we're apply to
    init_mm (which doesn't require any pte locks), then explicitly
    disable preemption.  (Do it unconditionally after checking we've
    successfully done the allocation to simplify the error handling.)
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/mm/memory.c b/mm/memory.c
index baa999e..b80cc31 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1718,6 +1718,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	BUG_ON(pmd_huge(*pmd));
 
+	preempt_disable();
 	arch_enter_lazy_mmu_mode();
 
 	token = pmd_pgtable(*pmd);
@@ -1729,6 +1730,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
+	preempt_enable();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);


