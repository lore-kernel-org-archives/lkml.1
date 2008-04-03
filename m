Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYDCSau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYDCSau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbYDCSaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:30:39 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:29786 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653AbYDCSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:30:38 -0400
Message-ID: <47F5224C.3020604@hp.com>
Date: Thu, 03 Apr 2008 14:30:36 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: [PATCH] Fix unlock ordering in smp_callin
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One should normally unlock in the reverse order of the lock calls,
and in this case there certainly is no reason not to.

To better see the results (with locks included), here's the complete
section of corrected code:

        lock_ipi_calllock();
        spin_lock(&vector_lock);
        /* Setup the per cpu irq handling data structures */
        __setup_vector_irq(cpuid);
        cpu_set(cpuid, cpu_online_map);
        per_cpu(cpu_state, cpuid) = CPU_ONLINE;
        spin_unlock(&vector_lock);
        unlock_ipi_calllock();

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 arch/ia64/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 32ee597..16483be 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -400,9 +400,9 @@ smp_callin (void)
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	cpu_set(cpuid, cpu_online_map);
-	unlock_ipi_calllock();
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
+	unlock_ipi_calllock();

 	smp_setup_percpu_timer();

-- 
1.5.2.5


