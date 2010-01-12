Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0ALCro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ALCro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659Ab0ALCrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:47:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62513 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0ALCrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:47:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 11 Jan 2010 18:45:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: 
In-reply-to: <1263264358-3896-1-git-send-email-yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1263264358-3896-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263264358-3896-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some systems that have disable cpus entries because same
  BIOS will support 2 sockets and 4 sockets and more at
  same time, BIOS just leave some disable entries, but
  those system do not support cpu hotplug. we don't need
  treat disabled_cpus as hotplug cpus.
so we can make nr_cpu_ids smaller and save more space
  (pcpu data allocations), and could make some systems run
  with logical flat instead of physical flat apic mode

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/smpboot.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -47,6 +47,7 @@
 #include <linux/bootmem.h>
 #include <linux/err.h>
 #include <linux/nmi.h>
+#include <linux/dmi.h>
 #include <linux/tboot.h>
 
 #include <asm/acpi.h>
@@ -1180,6 +1181,24 @@ static int __init _setup_possible_cpus(c
 }
 early_param("possible_cpus", _setup_possible_cpus);
 
+static __initdata int treat_disabled_cpus_as_hotplug;
+static __init int hotplug_cpus_check(const struct dmi_system_id *d)
+{
+        printk(KERN_NOTICE "%s detected: treat disabled cpus as hotplug ones\n", d->ident);
+        treat_disabled_cpus_as_hotplug = 1;
+
+        return 0;
+}
+
+static struct dmi_system_id hotplug_cpus_dmi_table[] __initdata = {
+        { hotplug_cpus_check, "WHICH VENDOR WHAT SYSTEM",
+                {       DMI_MATCH(DMI_BIOS_VENDOR, "WHAT VENDOR"),
+                        DMI_MATCH(DMI_BIOS_VERSION, "WHAT VER"),
+                }
+        },
+        { } /* NULL entry stops DMI scanning */
+};
+
 
 /*
  * cpu_possible_mask should be static, it cannot change as cpu's
@@ -1206,8 +1225,24 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
+	if (setup_possible_cpus == -1) {
+		possible = num_processors;
+		/*
+		 * do we have better way to detect hotplug cpus?
+		 *
+		 * some systems that have disable cpus entries because same
+		 *  BIOS will support 2 sockets and 4 sockets and more at
+		 *  same time, BIOS just leave some disable entries, but
+		 *  those system do not support cpu hotplug. we don't need
+		 *  treat disabled_cpus as hotplug cpus.
+		 * so we can make nr_cpu_ids smaller and save more space
+		 *  (pcpu data allocations), and could make some systems run
+		 *  with logical flat instead of physical flat apic mode
+		 */
+		dmi_check_system(hotplug_cpus_dmi_table);
+		if (treat_disabled_cpus_as_hotplug)
+			possible += disabled_cpus;
+	}
 	else
 		possible = setup_possible_cpus;
 
