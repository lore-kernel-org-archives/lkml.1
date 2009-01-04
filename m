Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZADNUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZADNUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZADNSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:15 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56766 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbZADNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:08 -0500
Message-Id: <20090104131801.227168000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:09 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 10/11] cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:use-work_on_cpu-in-acpi-cpufreq_c-p1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce stack usage, use new cpumask API.

Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr() with
a work_on_cpu function for drv_read() and drv_write().

Basically converts do_drv_{read,write} into "work_on_cpu" functions that
are now called by drv_read and drv_write.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

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
@@ -235,10 +231,15 @@ static u32 get_cur_val(const struct cpum
 		return 0;
 	}
 
+	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
+		return 0;
+
 	cpumask_copy(cmd.mask, mask);
 
 	drv_read(&cmd);
 
+	free_cpumask_var(cmd.mask);
+
 	dprintk("get_cur_val = %u\n", cmd.val);
 
 	return cmd.val;

