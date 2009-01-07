Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZAGPjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZAGPjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZAGPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:39:44 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:54840 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZAGPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:39:43 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/1] cpu: create stop machine in disable_nonboot_cpus
Date: Wed,  7 Jan 2009 16:39:15 +0100
Message-Id: <1231342755-5122-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit
772cd49cfa4002439b16dd6b553a11771ac096fd
(stop_machine: introduce stop_machine_create/destroy.)
introduced stop_machine_create/destroy, but omitted to call them from
disable_nonboot_cpus (it's called only from cpu_down).

Create and destroy the stop machine even in disable_nonboot_cpus
(which calls _cpu_down too) to avoid NULL-pointer dereference oops on
suspend.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/cpu.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 30e74dd..79e40f0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -379,8 +379,11 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error = 0;
+	int cpu, first_cpu, error;
 
+	error = stop_machine_create();
+	if (error)
+		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
@@ -409,6 +412,7 @@ int disable_nonboot_cpus(void)
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
+	stop_machine_destroy();
 	return error;
 }
 
-- 
1.6.0.6

