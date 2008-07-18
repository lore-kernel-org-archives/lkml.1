Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbYGRRHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbYGRRHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbYGRRHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:07:14 -0400
Received: from ns.suse.de ([195.135.220.2]:54325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbYGRRHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:07:12 -0400
From: Bernhard Walle <bwalle@suse.de>
To: yhlu.kernel@gmail.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       akpm@linux-foundation.org, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: Move dma32_reserve_bootmem() after reserve_crashkernel()
Date: Fri, 18 Jul 2008 19:07:53 +0200
Message-Id: <1216400873-21862-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <86802c440807180922l3500082chf7dcf0a1bafc6629@mail.gmail.com>
References: <86802c440807180922l3500082chf7dcf0a1bafc6629@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a x86-64 machine (nothing special I could encounter) I had the problem that
crashkernel reservation with the usual "64M@16M" failed. While debugging that,
I encountered that dma32_reserve_bootmem() reserves a memory region which is in
that area.

Because dma32_reserve_bootmem() does not rely on a specific offset but
crashkernel does, it makes sense to move the dma32_reserve_bootmem()
reservation down a bit. I tested that patch and it works without problems. I
don't see any negative effects of that move, but maybe I oversaw something ...

While we strictly don't need that patch in 2.6.27 because we have the
automatic, dynamic offset detection, it makes sense to also include it here
because:

  - it's easier to get it in -stable then,
  - many people are still used to the 'crashkernel=...@16M' syntax,
  - not everybody may be using a reloatable kernel.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/setup.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 531b55b..74d110e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -792,10 +792,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn);
 
-#ifdef CONFIG_X86_64
-	dma32_reserve_bootmem();
-#endif
-
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
@@ -810,6 +806,15 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	reserve_crashkernel();
 
+#ifdef CONFIG_X86_64
+	/*
+	 * dma32_reserve_bootmem() allocates bootmem which may conflict
+	 * with the crashkernel command line, so do that after
+	 * reserve_crashkernel()
+	 */
+	dma32_reserve_bootmem();
+#endif
+
 	reserve_ibft_region();
 
 #ifdef CONFIG_KVM_CLOCK
-- 
1.5.6

