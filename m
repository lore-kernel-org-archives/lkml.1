Return-Path: <linux-kernel-owner+w=401wt.eu-S937296AbZAPTMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937296AbZAPTMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937139AbZAPTLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:11:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35262 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936646AbZAPTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:11:10 -0500
Message-Id: <20090116191108.671229000@polaris-admin.engr.sgi.com>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Jan 2009 11:11:11 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
Content-Disposition: inline; filename=7503bfba.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new work_on_cpu function to reduce stack usage

Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr() with
a work_on_cpu function for drv_read() and drv_write().

Basically converts do_drv_{read,write} into "work_on_cpu" functions that
are now called by drv_read and drv_write.

Note: This patch basically reverts 50c668d6 which reverted 7503bfba, now
that the work_on_cpu() function is more stable.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Dieter Ries <clip2@gmx.de>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <cpufreq@vger.kernel.org>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -150,8 +150,9 @@ struct drv_cmd {
 	u32 val;
 };
 
-static void do_drv_read(struct drv_cmd *cmd)
+static long do_drv_read(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -166,10 +167,12 @@ static void do_drv_read(struct drv_cmd *
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void do_drv_write(struct drv_cmd *cmd)
+static long do_drv_write(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -186,30 +189,23 @@ static void do_drv_write(struct drv_cmd 
 	default:
 		break;
 	}
+	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, cmd->mask);
-	do_drv_read(cmd);
-	set_cpus_allowed_ptr(current, &saved_mask);
+	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
 	for_each_cpu(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, cpumask_of(i));
-		do_drv_write(cmd);
+		work_on_cpu(i, do_drv_write, cmd);
 	}
-
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return;
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -367,7 +363,7 @@ static unsigned int get_cur_freq_on_cpu(
 	return freq;
 }
 
-static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
+static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;

-- 
