Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYCSULD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYCSULD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYCSTip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbYCSTib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:31 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 37/79] [PATCH] include smpboot_hooks.h in smpboot_64.c
Date: Wed, 19 Mar 2008 14:25:32 -0300
Message-Id: <12059477421707-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477371787-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We do it and also fix conflicts, which makes x86_64 automatically
closer to i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   29 +++--------------------------
 1 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index c6c993f..b9384b3 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -61,6 +61,7 @@
 #include <asm/numa.h>
 
 #include <mach_wakecpu.h>
+#include <smpboot_hooks.h>
 
 /* Set when the idlers are all forked */
 int smp_threads_ready;
@@ -517,14 +518,7 @@ do_rest:
 
 	Dprintk("Setting warm reset code and vector.\n");
 
-	CMOS_WRITE(0xa, 0xf);
-	local_flush_tlb();
-	Dprintk("1.\n");
-	*((volatile unsigned short *) phys_to_virt(0x469)) = start_rip >> 4;
-	Dprintk("2.\n");
-	*((volatile unsigned short *) phys_to_virt(0x467)) = start_rip & 0xf;
-	Dprintk("3.\n");
-
+	smpboot_setup_warm_reset_vector(start_rip);
 	/*
 	 * Be paranoid about clearing APIC errors.
 	 */
@@ -594,23 +588,6 @@ cycles_t cacheflush_time;
 unsigned long cache_decay_ticks;
 
 /*
- * Cleanup possible dangling ends...
- */
-static __cpuinit void smp_cleanup_boot(void)
-{
-	/*
-	 * Paranoid:  Set warm reset code and vector here back
-	 * to default values.
-	 */
-	CMOS_WRITE(0, 0xf);
-
-	/*
-	 * Reset trampoline flag
-	 */
-	*((volatile int *) phys_to_virt(0x467)) = 0;
-}
-
-/*
  * Fall back to non SMP mode after errors.
  *
  * RED-PEN audit/test this more. I bet there is more state messed up here.
@@ -827,7 +804,7 @@ extern void smp_checks(void);
  */
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
-	smp_cleanup_boot();
+	smpboot_restore_warm_reset_vector();
 
 	Dprintk("Boot done.\n");
 
-- 
1.5.0.6

