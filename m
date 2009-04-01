Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZDAKus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZDAKus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZDAKuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:50:20 -0400
Received: from ozlabs.org ([203.10.76.45]:38003 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbZDAKuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:50:19 -0400
Date: Wed, 1 Apr 2009 21:48:46 +1100
From: Anton Blanchard <anton@samba.org>
To: linux-kernel@vger.kernel.org
Cc: arjan@infradead.org, akpm@osdl.org
Subject: [PATCH] Align vmstat_work
Message-ID: <20090401104846.GI27084@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even though vmstat_work is marked deferrable, there are still benefits to
aligning it. For certain applications we want to keep OS jitter as low as
possible and aligning timers and work so they occur together can reduce their
overall impact.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9114974..493c89d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -898,7 +898,7 @@ static void vmstat_update(struct work_struct *w)
 {
 	refresh_cpu_vm_stats(smp_processor_id());
 	schedule_delayed_work(&__get_cpu_var(vmstat_work),
-		sysctl_stat_interval);
+		round_jiffies_relative(sysctl_stat_interval));
 }
 
 static void __cpuinit start_cpu_timer(int cpu)
@@ -906,7 +906,8 @@ static void __cpuinit start_cpu_timer(int cpu)
 	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
 
 	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
-	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
+	schedule_delayed_work_on(cpu, vmstat_work,
+				 __round_jiffies_relative(HZ, cpu));
 }
 
 /*
