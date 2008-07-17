Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbYGQWPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbYGQWPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYGQWPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:15:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYGQWPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:15:05 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: Move crashkernel reservation before dma32_reserve_bootmem()
Date: Fri, 18 Jul 2008 00:15:45 +0200
Message-Id: <1216332945-17197-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a x86-64 machine (nothing special I could encounter) I had the problem that
crashkernel reservation with the usual "64M@16M" failed. While debugging that,
I encountered that dma32_reserve_bootmem() reserves a memory region which is in
that area.

Because dma32_reserve_bootmem() does not rely on a specific offset but
crashkernel does, it makes sense to move the crashkernel reservation up a bit.
I tested that patch and it works without problems. I don't see any negative
effects of that move, but maybe I oversaw something ...

While we strictly don't need that patch in 2.6.27 because we have the
automatic, dynamic offset detection, it makes sense to also include it here
because:

  - it's easier to get it in -stable then,
  - many people are still used to the 'crashkernel=...@16M' syntax,
  - not everybody may be using a reloatable kernel.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/setup.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 531b55b..16101c0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -792,6 +792,12 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn);
 
+	/*
+	 * dma32_reserve_bootmem() allocates bootmem which may conflict
+	 * with the crashkernel command line, so do that before
+	 */
+	reserve_crashkernel();
+
 #ifdef CONFIG_X86_64
 	dma32_reserve_bootmem();
 #endif
@@ -808,7 +814,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	find_smp_config();
 #endif
-	reserve_crashkernel();
 
 	reserve_ibft_region();
 
-- 
1.5.6

