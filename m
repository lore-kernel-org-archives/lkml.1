Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYHaReF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYHaReF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYHaRdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:33:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51533 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYHaRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:33:52 -0400
Date: Sun, 31 Aug 2008 10:33:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, wli@holomorphy.com, sparclinux@vger.kernel.org,
       manfred@colorfullife.com, akpm@linux-foundation.org
Subject: [PATCH] prevent sparc64 from invoking irq handlers on offline CPUs
Message-ID: <20080831173349.GA15393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sparc64 refrain from clearing a given to-be-offlined CPU's bit in the
cpu_online_mask until it has processed pending irqs.  This change
prevents other CPUs from being blindsided by an apparently offline CPU
nevertheless changing globally visible state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 smp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 743ccad..b83a683 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -1305,10 +1305,6 @@ int __cpu_disable(void)
 	c->core_id = 0;
 	c->proc_id = -1;
 
-	spin_lock(&call_lock);
-	cpu_clear(cpu, cpu_online_map);
-	spin_unlock(&call_lock);
-
 	smp_wmb();
 
 	/* Make sure no interrupts point to this cpu.  */
@@ -1318,6 +1314,10 @@ int __cpu_disable(void)
 	mdelay(1);
 	local_irq_disable();
 
+	spin_lock(&call_lock);
+	cpu_clear(cpu, cpu_online_map);
+	spin_unlock(&call_lock);
+
 	return 0;
 }
 
