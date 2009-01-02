Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbZABWgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbZABWgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZABWgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:36:18 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46837 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZABWgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:36:17 -0500
X-IronPort-AV: E=Sophos;i="4.36,319,1228089600"; 
   d="scan'208";a="222991580"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb: Add missing __init annotations
References: <adamyedq8p3.fsf@cisco.com>
	<20090101130255.GA21886@uranus.ravnborg.org>
	<20090102192502.GF14249@elte.hu> <adasko1pjck.fsf@cisco.com>
	<20090102204649.GB21988@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 Jan 2009 14:36:14 -0800
In-Reply-To: <20090102204649.GB21988@elte.hu> (Ingo Molnar's message of "Fri,
	2 Jan 2009 21:46:49 +0100")
Message-ID: <adak59dpc81.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jan 2009 22:36:14.0587 (UTC) FILETIME=[851994B0:01C96D2A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > no need - so it wasnt needed to make a section warning go away - i.e. your 
 > patch sans the last hunk is tested to solve the problem, right?

I hadn't tested without that hunk... so I just redid it.  For
simplicity, here's the exact patch I just tested to solve the warnings:

===

The current kernel build warns:

    WARNING: vmlinux.o(.text+0x11458): Section mismatch in reference from the function swiotlb_alloc_boot() to the function .init.text:__alloc_bootmem_low()
    The function swiotlb_alloc_boot() references
    the function __init __alloc_bootmem_low().
    This is often because swiotlb_alloc_boot lacks a __init
    annotation or the annotation of __alloc_bootmem_low is wrong.
    
    WARNING: vmlinux.o(.text+0x1011f2): Section mismatch in reference from the function swiotlb_late_init_with_default_size() to the function .init.text:__alloc_bootmem_low()
    The function swiotlb_late_init_with_default_size() references
    the function __init __alloc_bootmem_low().
    This is often because swiotlb_late_init_with_default_size lacks a __init
    annotation or the annotation of __alloc_bootmem_low is wrong.

and indeed the functions calling __alloc_bootmem_low() can be marked
__init as well.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 lib/swiotlb.c                    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 242c344..8cba374 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -13,7 +13,7 @@
 
 int swiotlb __read_mostly;
 
-void *swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 {
 	return alloc_bootmem_low_pages(size);
 }
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index fa2dc4e..f684d55 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -116,7 +116,7 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-void * __weak swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 {
 	return alloc_bootmem_low_pages(size);
 }
@@ -238,7 +238,7 @@ swiotlb_init(void)
  * initialize the swiotlb later using the slab allocator if needed.
  * This should be just like above, but with some error catching.
  */
-int
+int __init
 swiotlb_late_init_with_default_size(size_t default_size)
 {
 	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
