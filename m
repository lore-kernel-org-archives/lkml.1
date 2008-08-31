Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYHaRbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYHaRbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYHaRbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:31:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48378 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbYHaRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:31:30 -0400
Date: Sun, 31 Aug 2008 10:31:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com,
       tnt@246tNt.com, grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       manfred@colorfullife.com, akpm@linux-foundation.org
Subject: [PATCH] prevent powerpc from invoking irq handlers on offline CPUs
Message-ID: <20080831173127.GA15296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make powerpc refrain from clearing a given to-be-offlined CPU's bit in the
cpu_online_mask until it has processed pending irqs.  This change
prevents other CPUs from being blindsided by an apparently offline CPU
nevertheless changing globally visible state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5337ca7..1fedd7d 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -250,11 +250,11 @@ int generic_cpu_disable(void)
 	if (cpu == boot_cpuid)
 		return -EBUSY;
 
-	cpu_clear(cpu, cpu_online_map);
 #ifdef CONFIG_PPC64
 	vdso_data->processorCount--;
 	fixup_irqs(cpu_online_map);
 #endif
+	cpu_clear(cpu, cpu_online_map);
 	return 0;
 }
 
