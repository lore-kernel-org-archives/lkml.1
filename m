Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYLaESS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYLaESS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLaESF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:18:05 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:37398 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYLaESD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:18:03 -0500
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: swiotlb: Add missing __init annotations
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Dec 2008 20:18:00 -0800
Message-ID: <adamyedq8p3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Dec 2008 04:18:01.0175 (UTC) FILETIME=[C4BD5670:01C96AFE]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Not 100% sure if this is the correct fix but it seems OK for me.

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
index fa2dc4e..1b76f78 100644
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
@@ -186,7 +186,7 @@ static void swiotlb_print_info(unsigned long bytes)
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
  */
-void __init
+void __init __weak
 swiotlb_init_with_default_size(size_t default_size)
 {
 	unsigned long i, bytes;
