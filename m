Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZIWUNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZIWUNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZIWUNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:13:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZIWUNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:13:46 -0400
Date: Wed, 23 Sep 2009 23:22:21 +0300
From: Izik Eidus <ieidus@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, davem@redhat.com, hugh.dickins@tiscali.co.uk,
       aarcange@redhat.com, gleb@redhat.com
Subject: update_mmu_cache() when write protecting pte.
Message-ID: <20090923232221.1d566a5c@woof.woof>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hugh just found out that ksm was not calling to update_mmu_cache()
after it set new pte when it changed ptes mapping to point into the new
shared-readonly page (ksmpage).

It is understandable that it is a bug and ksm have to call it right
after set_pte_at_notify() get called, but the question is: does ksm
have to call it only there or should it call it even when it
write-protect pte (while not changing the physical address the pte is
pointing to).

I am asking this question because it seems that fork() dont call it...

(below a patch that fix the problem in case we need it just when we
change the physical mapping, if we need it even when we write protect
the pages, then we need to add another update_mmu_cache()  call)

Thanks.

>From 82d27f67a8b20767dc6119422189f73b52168c8d Mon Sep 17 00:00:00 2001
From: Izik Eidus <ieidus@redhat.com>
Date: Wed, 23 Sep 2009 22:37:34 +0300
Subject: [PATCH] ksm: add update_mmu_cache() when changing pte mapping.

This patch add update_mmu_cache() call right after set_pte_at_notify()
Without this function ksm is probably broken for powerpc and sparc archs.

(Noticed by Hugh Dickins)

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/ksm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index f7edac3..e8d16eb 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -719,6 +719,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *oldpage,
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(newpage, prot));
+	update_mmu_cache(vma, addr, pte);
 
 	page_remove_rmap(oldpage);
 	put_page(oldpage);
-- 
1.5.6.5

