Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYLCQci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYLCQci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLCQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:32:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYLCQcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:32:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2008 16:32:07 +0000
Message-ID: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make MN10300 use the new core parameter code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/setup.c |   50 +++++++++++++++----------------------------
 1 files changed, 18 insertions(+), 32 deletions(-)


diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index e8c5d0b..310d542 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -60,6 +60,7 @@ static struct resource data_resource = {
 static unsigned long __initdata phys_memory_base;
 static unsigned long __initdata phys_memory_end;
 static unsigned long __initdata memory_end;
+static unsigned long __initdata memory_param;
 unsigned long memory_size;
 
 struct thread_info *__current_ti = &init_thread_union.thread_info;
@@ -79,41 +80,17 @@ void __init arch_get_boot_command_line(void)
 }
 
 /*
- * FIXME: use core_param
+ * handle a specific memory limit handed over the kernel command line
  */
-static void __init parse_mem_cmdline(void)
+static int __init mem_parameter(char *data)
 {
-	char *from, *to, c;
+	if (!data || !*data)
+		return 0;
 
-	/* see if there's an explicit memory size option */
-	from = redboot_command_line;
-	to = redboot_command_line;
-	c = ' ';
-
-	for (;;) {
-		if (c == ' ' && !memcmp(from, "mem=", 4)) {
-			if (to != redboot_command_line)
-				to--;
-			memory_size = memparse(from + 4, &from);
-		}
-
-		c = *(from++);
-		if (!c)
-			break;
-
-		*(to++) = c;
-	}
-
-	*to = '\0';
-
-	if (memory_size == 0)
-		panic("Memory size not known\n");
-
-	memory_end = (unsigned long) CONFIG_KERNEL_RAM_BASE_ADDRESS +
-		memory_size;
-	if (memory_end > phys_memory_end)
-		memory_end = phys_memory_end;
+	memory_param = memparse(data, NULL);
+	return 0;
 }
+early_param("mem", mem_parameter);
 
 /*
  * architecture specific setup
@@ -125,7 +102,6 @@ void __init setup_arch(void)
 
 	cpu_init();
 	unit_setup();
-	parse_mem_cmdline();
 
 	init_mm.start_code = (unsigned long)&_text;
 	init_mm.end_code = (unsigned long) &_etext;
@@ -223,6 +199,16 @@ void __init cpu_init(void)
 
 	phys_memory_end = phys_memory_base + memory_size;
 
+	if (memory_param)
+		memory_size = memory_param;
+	if (memory_size == 0)
+		panic("Memory size not known\n");
+
+	memory_end = (unsigned long) CONFIG_KERNEL_RAM_BASE_ADDRESS +
+		memory_size;
+	if (memory_end > phys_memory_end)
+		memory_end = phys_memory_end;
+
 #ifdef CONFIG_FPU
 	fpu_init_state();
 #endif

