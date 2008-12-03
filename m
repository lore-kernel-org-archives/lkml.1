Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYLCQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYLCQdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYLCQcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:32:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60393 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYLCQcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:32:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] [PATCH] param: Adapt FRV to the new parameter handling
	regime
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2008 16:32:17 +0000
Message-ID: <20081203163217.13965.77996.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
References: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make FRV use the new core parameter code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/setup.c |   43 ++++++++++++++-----------------------------
 1 files changed, 14 insertions(+), 29 deletions(-)


diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 9548961..2f1506d 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -718,36 +718,25 @@ void __cpuinit calibrate_delay(void)
 
 } /* end calibrate_delay() */
 
-/*****************************************************************************/
 /*
- * look through the command line for some things we need to know immediately
- * FIXME: Use core_param or early_param.
+ * handle a specific memory limit handed over the kernel command line
  */
-static void __init parse_cmdline_early(char *cmdline)
+static int __init mem_parameter(char *data)
 {
-	if (!cmdline)
-		return;
-
-	while (*cmdline) {
-		if (*cmdline == ' ')
-			cmdline++;
-
-		/* "mem=XXX[kKmM]" sets SDRAM size to <mem>, overriding the value we worked
-		 * out from the SDRAM controller mask register
-		 */
-		if (!memcmp(cmdline, "mem=", 4)) {
-			unsigned long long mem_size;
-
-			mem_size = memparse(cmdline + 4, &cmdline);
-			memory_end = memory_start + mem_size;
-		}
-
-		while (*cmdline && *cmdline != ' ')
-			cmdline++;
-	}
+	unsigned long long mem_size;
 
-} /* end parse_cmdline_early() */
+	if (!data || !*data)
+		return 0;
+	mem_size = memparse(data, NULL);
+	memory_end = memory_start + mem_size;
+	return 0;
+}
+early_param("mem", mem_parameter);
 
+/*
+ * retrieve the boot command line from RedBoot and stash it somewhere more
+ * appropriate
+ */
 void __init arch_get_boot_command_line(void)
 {
 	memcpy(boot_command_line, redboot_command_line, COMMAND_LINE_SIZE);
@@ -796,10 +785,6 @@ void __init setup_arch(void)
 #endif
 #endif
 
-	/* deal with the command line - RedBoot may have passed one to the kernel */
-	memcpy(command_line, boot_command_line, sizeof(command_line));
-	parse_cmdline_early(command_line);
-
 	/* set up the memory description
 	 * - by now the stack is part of the init task */
 	printk("Memory %08lx-%08lx\n", memory_start, memory_end);

