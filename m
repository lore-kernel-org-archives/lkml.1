Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbXI1G5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbXI1G5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbXI1G5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:57:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47354 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbXI1G5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:57:08 -0400
Date: Fri, 28 Sep 2007 15:58:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] CPU HOTPLUG: Avoid hotadd when proper possible_map isn't
 specified.
Message-Id: <20070928155853.1e4393c7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpu-hot-add should be fail if cpu is not set in cpu_possible_map.
If go ahead, the system will panic soon.

Especially, arch which requires additional_cpus= parameter should handle this.
Tested on ia64.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 kernel/cpu.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.23-rc8-mm2/kernel/cpu.c
===================================================================
--- linux-2.6.23-rc8-mm2.orig/kernel/cpu.c
+++ linux-2.6.23-rc8-mm2/kernel/cpu.c
@@ -265,6 +265,14 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
+	if (!cpu_isset(cpu, cpu_possible_map)) {
+		printk("can't online cpu %d because it is not configured "
+		       "as may-hotadded at boot time\n", cpu);
+#if defined(CONFIG_IA64) || defined (CONFIG_X86_64) || defined(CONFIG_S390)
+		printk("please check additional_cpus= boot parameter\n");
+#endif
+		return -EINVAL;
+	}
 
 	mutex_lock(&cpu_add_remove_lock);
 	if (cpu_hotplug_disabled)

