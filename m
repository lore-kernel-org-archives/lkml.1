Return-Path: <linux-kernel-owner+w=401wt.eu-S1763954AbXHWVll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763954AbXHWVll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764205AbXHWViy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:38:54 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55582 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbXHWViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:38:52 -0400
Date: Thu, 23 Aug 2007 17:38:09 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Antoine Martin <antoine@nagafix.co.uk>
Subject: [PATCH 5/7] UML - Sysrq and mconsole fixes
Message-ID: <20070823213809.GA9100@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the passing of printk output back to the mconsole client.  The
existing code was somewhat confused, accumulating output in a buffer,
but writing it out entirely whenever a new chunk was added.  This is
fixed.

The earlier include cleanups caused linux/sysrq.h to not be included -
this is fixed by adding the include back, under CONFIG_MAGIC_SYSRQ.

CONFIG_MAGIC_SYSRQ is also defaulted to on in defconfig.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/defconfig               |    2 +-
 arch/um/drivers/mconsole_kern.c |   23 +++++++++--------------
 2 files changed, 10 insertions(+), 15 deletions(-)

Index: linux-2.6.22/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/mconsole_kern.c	2007-08-23 12:56:16.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/mconsole_kern.c	2007-08-23 13:10:11.000000000 -0400
@@ -632,10 +632,9 @@ struct mconsole_output {
 static DEFINE_SPINLOCK(client_lock);
 static LIST_HEAD(clients);
 static char console_buf[MCONSOLE_MAX_DATA];
-static int console_index = 0;
 
 static void console_write(struct console *console, const char *string,
-			  unsigned len)
+			  unsigned int len)
 {
 	struct list_head *ele;
 	int n;
@@ -643,24 +642,18 @@ static void console_write(struct console
 	if (list_empty(&clients))
 		return;
 
-	while (1) {
-		n = min((size_t) len, ARRAY_SIZE(console_buf) - console_index);
-		strncpy(&console_buf[console_index], string, n);
-		console_index += n;
+	while (len > 0) {
+		n = min((size_t) len, ARRAY_SIZE(console_buf));
+		strncpy(console_buf, string, n);
 		string += n;
 		len -= n;
-		if (len == 0)
-			return;
 
 		list_for_each(ele, &clients) {
 			struct mconsole_output *entry;
 
 			entry = list_entry(ele, struct mconsole_output, list);
-			mconsole_reply_len(entry->req, console_buf,
-					   console_index, 0, 1);
+			mconsole_reply_len(entry->req, console_buf, n, 0, 1);
 		}
-
-		console_index = 0;
 	}
 }
 
@@ -690,8 +683,7 @@ static void with_console(struct mc_reque
 
 	(*proc)(arg);
 
-	mconsole_reply_len(req, console_buf, console_index, 0, 0);
-	console_index = 0;
+	mconsole_reply_len(req, "", 0, 0, 0);
 
 	spin_lock_irqsave(&client_lock, flags);
 	list_del(&entry.list);
@@ -699,6 +691,9 @@ static void with_console(struct mc_reque
 }
 
 #ifdef CONFIG_MAGIC_SYSRQ
+
+#include <linux/sysrq.h>
+
 static void sysrq_proc(void *arg)
 {
 	char *op = arg;
Index: linux-2.6.22/arch/um/defconfig
===================================================================
--- linux-2.6.22.orig/arch/um/defconfig	2007-08-23 12:56:15.000000000 -0400
+++ linux-2.6.22/arch/um/defconfig	2007-08-23 14:28:40.000000000 -0400
@@ -80,7 +80,7 @@ CONFIG_BINFMT_MISC=m
 # CONFIG_HOSTFS is not set
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
-# CONFIG_MAGIC_SYSRQ is not set
+CONFIG_MAGIC_SYSRQ=y
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
 CONFIG_KERNEL_STACK_ORDER=0
