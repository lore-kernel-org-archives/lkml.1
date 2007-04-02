Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbXDBLcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbXDBLcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXDBLcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:32:54 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18256 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbXDBLcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:32:53 -0400
Date: Mon, 2 Apr 2007 15:39:47 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org, cpufreq@lists.linux.org.uk,
       hpa@zytor.com, ak@suse.de, davej@codemonkey.org.uk
Subject: [PATCH 3/3] cpuid: switch to cpuid_on_cpu()
Message-ID: <20070402113947.GC6785@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cpuid_on_cpu() is in core, cpuid driver can be shrinked.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/i386/kernel/cpuid.c |   41 +----------------------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

--- a/arch/i386/kernel/cpuid.c
+++ b/arch/i386/kernel/cpuid.c
@@ -45,45 +45,6 @@ #include <asm/system.h>
 
 static struct class *cpuid_class;
 
-#ifdef CONFIG_SMP
-
-struct cpuid_command {
-	u32 reg;
-	u32 *data;
-};
-
-static void cpuid_smp_cpuid(void *cmd_block)
-{
-	struct cpuid_command *cmd = (struct cpuid_command *)cmd_block;
-
-	cpuid(cmd->reg, &cmd->data[0], &cmd->data[1], &cmd->data[2],
-		      &cmd->data[3]);
-}
-
-static inline void do_cpuid(int cpu, u32 reg, u32 * data)
-{
-	struct cpuid_command cmd;
-
-	preempt_disable();
-	if (cpu == smp_processor_id()) {
-		cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-	} else {
-		cmd.reg = reg;
-		cmd.data = data;
-
-		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
-	}
-	preempt_enable();
-}
-#else				/* ! CONFIG_SMP */
-
-static inline void do_cpuid(int cpu, u32 reg, u32 * data)
-{
-	cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-}
-
-#endif				/* ! CONFIG_SMP */
-
 static loff_t cpuid_seek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret;
@@ -119,7 +80,7 @@ static ssize_t cpuid_read(struct file *f
 		return -EINVAL;	/* Invalid chunk size */
 
 	for (; count; count -= 16) {
-		do_cpuid(cpu, reg, data);
+		cpuid_on_cpu(cpu, reg, &data[0], &data[1], &data[2], &data[3]);
 		if (copy_to_user(tmp, &data, 16))
 			return -EFAULT;
 		tmp += 16;

