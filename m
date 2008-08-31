Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYHaR20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYHaR20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYHaR2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:28:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46696 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbYHaR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:28:17 -0400
Date: Sun, 31 Aug 2008 10:28:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, jes@sgi.com, manfred@colorfullife.com,
       akpm@linux-foundation.org
Subject: [PATCH] prevent ia64 from invoking irq handlers on offline CPUs
Message-ID: <20080831172814.GA15087@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ia64 refrain from clearing a given to-be-offlined CPU's bit in the
cpu_online_mask until it has processed pending irqs.  This change
prevents other CPUs from being blindsided by an apparently offline CPU
nevertheless changing globally visible state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 smpboot.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index bcea81e..7a90f42 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -741,8 +741,6 @@ int __cpu_disable(void)
 			return -EBUSY;
 	}
 
-	cpu_clear(cpu, cpu_online_map);
-
 	if (migrate_platform_irqs(cpu)) {
 		cpu_set(cpu, cpu_online_map);
 		return (-EBUSY);
@@ -751,6 +749,7 @@ int __cpu_disable(void)
 	remove_siblinginfo(cpu);
 	cpu_clear(cpu, cpu_online_map);
 	fixup_irqs();
+	cpu_clear(cpu, cpu_online_map);
 	local_flush_tlb_all();
 	cpu_clear(cpu, cpu_callin_map);
 	return 0;
