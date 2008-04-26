Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbYDZUHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbYDZUHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761497AbYDZUH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:07:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762259AbYDZUHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:07:25 -0400
Date: Sat, 26 Apr 2008 22:07:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem
Message-ID: <20080426200708.GA14223@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu> <alpine.LFD.1.10.0804261247020.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261247020.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Having preprocessor conditionals that mix things up is not an excuse, 
> and it might be an argument for not doing the conditional that way (ie 
> maybe just make sure that when NUMA is not on, nid/next_nid will 
> always be different, and in a way that the compiler can perhaps see 
> statically that they are different - so that you can have the 
> conditional there even with NUMA off, but the compiler will just fold 
> it away?).

for now i cleaned it up the way below, but i also queued up a cleanup 
patch separately (second patch attached below) that removes the #ifdef. 
The current version is the tested one so i'll keep that in the tree and 
will treat the cleanup separately.

	Ingo

------------------------>
Subject: x86_64: make reserve_bootmem_generic() use new reserve_bootmem()
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Tue, 18 Mar 2008 12:50:21 -0700

"mm: make reserve_bootmem can crossed the nodes" provides new
reserve_bootmem(), let reserve_bootmem_generic() use that.

reserve_bootmem_generic() is used to reserve initramdisk, so this way
we can make sure even when bootloader or kexec load ranges cross the
node memory boundaries, reserve_bootmem still works.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/mm/init_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/init_64.c
+++ linux-x86.q/arch/x86/mm/init_64.c
@@ -810,7 +810,7 @@ void free_initrd_mem(unsigned long start
 void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 {
 #ifdef CONFIG_NUMA
-	int nid = phys_to_nid(phys);
+	int nid, next_nid;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
@@ -829,10 +829,16 @@ void __init reserve_bootmem_generic(unsi
 
 	/* Should check here against the e820 map to avoid double free */
 #ifdef CONFIG_NUMA
-	reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+	nid = phys_to_nid(phys);
+	next_nid = phys_to_nid(phys + len - 1);
+	if (nid == next_nid)
+		reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+	else
+		reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #else
 	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #endif
+
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
 		set_dma_reserve(dma_reserve);

------------->
Subject: x86: reserve bootmem cleanup
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 21:50:20 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-x86.q/arch/x86/mm/init_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/init_64.c
+++ linux-x86.q/arch/x86/mm/init_64.c
@@ -810,10 +810,8 @@ void free_initrd_mem(unsigned long start
 
 void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 {
-#ifdef CONFIG_NUMA
-	int nid, next_nid;
-#endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
+	int nid, next_nid;
 
 	if (pfn >= end_pfn) {
 		/*
@@ -829,16 +827,12 @@ void __init reserve_bootmem_generic(unsi
 	}
 
 	/* Should check here against the e820 map to avoid double free */
-#ifdef CONFIG_NUMA
 	nid = phys_to_nid(phys);
 	next_nid = phys_to_nid(phys + len - 1);
 	if (nid == next_nid)
 		reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
 	else
 		reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
-#else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
-#endif
 
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
