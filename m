Return-Path: <linux-kernel-owner+w=401wt.eu-S1764188AbYCSUKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764188AbYCSUKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYCSTin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129AbYCSTia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:30 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 51/79] [PATCH] don't span a new worker in __smp_prepare_cpu
Date: Wed, 19 Mar 2008 14:25:46 -0300
Message-Id: <12059478062779-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478013647-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We can do it now that do_boot_cpu has its own worker.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   30 ++----------------------------
 1 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index fc1eb52..c03596e 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -699,44 +699,18 @@ void cpu_exit_clear(void)
 }
 #endif
 
-struct warm_boot_cpu_info {
-	struct completion *complete;
-	struct work_struct task;
-	int apicid;
-	int cpu;
-};
-
-static void __cpuinit do_warm_boot_cpu(struct work_struct *work)
-{
-	struct warm_boot_cpu_info *info =
-		container_of(work, struct warm_boot_cpu_info, task);
-	do_boot_cpu(info->apicid, info->cpu);
-	complete(info->complete);
-}
-
 static void __cpuinit __smp_prepare_cpu(int cpu)
 {
-	DECLARE_COMPLETION_ONSTACK(done);
-	struct warm_boot_cpu_info info;
 	int	apicid;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 
-	info.complete = &done;
-	info.apicid = apicid;
-	info.cpu = cpu;
-	INIT_WORK(&info.task, do_warm_boot_cpu);
-
 	/* init low mem mapping */
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
 			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
 	flush_tlb_all();
-	if (!keventd_up() || current_is_keventd())
-		info.task.func(&info.task);
-	else {
-		schedule_work(&info.task);
-		wait_for_completion(&done);
-	}
+
+	do_boot_cpu(apicid, cpu);
 }
 
 static int boot_cpu_logical_apicid;
-- 
1.5.0.6

