Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbYBGJW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbYBGJW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbYBGJUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:14 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18517 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbYBGJUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:03 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/8] ia64: add support for remotely triggering the block softirq
Date: Thu,  7 Feb 2008 10:19:03 +0100
Message-Id: <1202375945-29525-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/ia64/kernel/smp.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 4e446aa..96f8ffa 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -80,6 +80,7 @@ static volatile struct call_data_struct *call_data;
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
 #define IPI_KDUMP_CPU_STOP	3
+#define IPI_BLOCK_SOFTIRQ	4
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
 static DEFINE_PER_CPU_SHARED_ALIGNED(u64, ipi_operation);
@@ -174,6 +175,14 @@ handle_IPI (int irq, void *dev_id)
 				unw_init_running(kdump_cpu_freeze, NULL);
 				break;
 #endif
+			      case IPI_BLOCK_SOFTIRQ: {
+				unsigned long flags;
+
+				local_irq_save(flags);
+				raise_softirq_irqoff(BLOCK_SOFTIRQ);
+				local_irq_restore(flags);
+				break;
+			      }
 			      default:
 				printk(KERN_CRIT "Unknown IPI on CPU %d: %lu\n", this_cpu, which);
 				break;
@@ -461,6 +470,11 @@ smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wai
 }
 EXPORT_SYMBOL(smp_call_function);
 
+void arch_raise_softirq_on_cpu(int cpuid)
+{
+	send_IPI_single(cpuid, IPI_BLOCK_SOFTIRQ);
+}
+
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
  */
-- 
1.5.4.22.g7a20

