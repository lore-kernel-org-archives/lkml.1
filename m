Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXIUDv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXIUDv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIUDvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:51:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXIUDvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:51:52 -0400
Date: Fri, 21 Sep 2007 12:54:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: GOTO <y-goto@jp.fujitsu.com>, takeuchi_satoru@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] make mis-configured cpu hotplug safer
Message-Id: <20070921125401.6777139f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to hot-add a new cpu,  it should be on cpu_possible_map.
On some archs, we have to specify additional_cpus= boot option.
(x86_64, ia64, s390 seems to need this. others ?)

If a user enable a cpu which is not counted as possible_cpu, the system
will panic. This patch disables to register cpu control if cpu is not in
possible_map.

Works as expected on ia64/cpu-hotplug-by-ACPI case.

Consideration:
handling this issue in cpu_up() is an another way. 

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


---
 drivers/base/cpu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.23-rc6-mm1/drivers/base/cpu.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/drivers/base/cpu.c
+++ linux-2.6.23-rc6-mm1/drivers/base/cpu.c
@@ -113,6 +113,17 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
 int __devinit register_cpu(struct cpu *cpu, int num)
 {
 	int error;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	if (!cpu_isset(num, cpu_possible_map)) {
+		printk("Newly added cpu is not configured"
+			"as hot-add-candidate at boot time\n");
+#if defined(CONFIG_X86_64) || defined(CONFIG_IA64) || defined(CONFIG_S390)
+		printk("please check additional_cpus= boot option\n");
+#endif
+		return -EINVAL;
+	}
+#endif
 	cpu->node_id = cpu_to_node(num);
 	cpu->sysdev.id = num;
 	cpu->sysdev.cls = &cpu_sysdev_class;

