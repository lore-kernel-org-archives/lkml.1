Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYHYNA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYHYNA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYHYNAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:00:50 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:57413
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753779AbYHYNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:00:49 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] Subject: x86: Move crashkernel reservation before
	dma32_reserve_bootmem()
To: srostedt@redhat.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>, Gregory Haskins <ghaskins@novell.com>
Date: Mon, 25 Aug 2008 08:58:31 -0400
Message-ID: <20080825125639.26874.80623.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven, Ingo, Thomas,
  Bernard (cc'd) sent me this patch for 26.3-rt3 to fix an issue where a kdump
  kernel will fail to load, thereby disabling the crashdump feature.  Please
  consider this patch for -rt4.  IIUC, this patch is already upstream in the
  .27 series.

-Greg

-----------------
From: Bernhard Walle <bernhard.walle@gmx.de>

On a x86-64 machine (nothing special I could encounter) I had the problem that
crashkernel reservation with the usual "64M@16M" failed. While debugging that,
I encountered that dma32_reserve_bootmem() reserves a memory region which is in
that area.

Because dma32_reserve_bootmem() does not rely on a specific offset but
crashkernel does, it makes sense to move the crashkernel reservation up a bit.
I tested that patch and it works without problems. I don't see any negative
effects of that move, but maybe I oversaw something ...

While the long-term solution is to make the crashkernel reservation dynamic
(which is already done in -tip), this bug should be fixed also short-term for
2.6.26 (or 2.6.26-stable if it's too short), and that's why I made that patch.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kernel/setup_64.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 6dff128..158cefe 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -444,6 +444,12 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
+	/*
+	 * dma32_reserve_bootmem() allocates bootmem which may conflict
+	 * with the crashkernel command line, so do that before
+	 */
+	reserve_crashkernel();
+
 	dma32_reserve_bootmem();
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -484,7 +490,6 @@ void __init setup_arch(char **cmdline_p)
 		}
 	}
 #endif
-	reserve_crashkernel();
 
 	reserve_ibft_region();
 

