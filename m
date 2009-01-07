Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbZAGT7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbZAGT7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbZAGT6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:58:37 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53571 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754925AbZAGT6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:58:36 -0500
Message-Id: <20090107195832.871689000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 07 Jan 2009 11:58:36 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Ben Hutchings <bhutchings@solarflare.com>,
       linux-net-drivers@solarflare.com
Subject: [PATCH 4/5] cpumask: convert drivers/net/sfc
Content-Disposition: inline; filename=cpumask:convert-drivers_net_sfc_efx.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: reduce stack usage, use new cpumask API.

Remove a cpumask from the stack.  Ben Hutchings indicated that printing
a warning and returning 1 was acceptable for the corner case where allocation
fails.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-net-drivers@solarflare.com
---
 drivers/net/sfc/efx.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -854,20 +854,27 @@ static void efx_fini_io(struct efx_nic *
  * interrupts across them. */
 static int efx_wanted_rx_queues(void)
 {
-	cpumask_t core_mask;
+	cpumask_var_t core_mask;
 	int count;
 	int cpu;
 
-	cpus_clear(core_mask);
+	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
+		printk(KERN_WARNING
+		       "efx.c: allocation failure, irq balancing hobbled\n");
+		return 1;
+	}
+
+	cpumask_clear(core_mask);
 	count = 0;
 	for_each_online_cpu(cpu) {
-		if (!cpu_isset(cpu, core_mask)) {
+		if (!cpumask_test_cpu(cpu, core_mask)) {
 			++count;
-			cpumask_or(&core_mask, &core_mask,
+			cpumask_or(core_mask, core_mask,
 				   topology_core_cpumask(cpu));
 		}
 	}
 
+	free_cpumask_var(core_mask);
 	return count;
 }
 

-- 
