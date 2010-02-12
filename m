Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab0BLWoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:44:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:45173 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab0BLWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:43:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/8] kgdboc: Add ekgdboc for early use of the kernel debugger
Date: Fri, 12 Feb 2010 16:39:26 -0600
Message-Id: <1266014369-29547-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
References: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:43:10.0702 (UTC) FILETIME=[C0D630E0:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ekgdboc= differs from kgdboc= in that you can begin debuggin as
soon as the exceptions are setup and the kgdb I/O driver is available,
instead of waiting until the tty subsystem is available.

CC: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/serial/kgdboc.c             |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b340445..5227565 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -699,6 +699,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			The VGA output is eventually overwritten by the real
 			console.
 
+	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
+			ekgdboc=kbd
+
+			This is desgined to be used in conjunction with
+			the boot argument: earlyprintk=vga
+
 	eata=		[HW,SCSI]
 
 	edd=		[EDD]
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 246b7c3..91ca95a 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -263,6 +263,25 @@ static struct kgdb_io kgdboc_io_ops = {
 	.post_exception		= kgdboc_post_exp_handler,
 };
 
+#ifdef CONFIG_KGDB_SERIAL_CONSOLE
+/* This is only available if kgdboc is a built in for early debugging */
+int __init kgdboc_early_init(char *opt)
+{
+	/* save the first character of the config string because the
+	 * init routine can destroy it.
+	 */
+	char save_ch;
+
+	kgdboc_option_setup(opt);
+	save_ch = config[0];
+	init_kgdboc();
+	config[0] = save_ch;
+	return 0;
+}
+
+early_param("ekgdboc", kgdboc_early_init);
+#endif /* CONFIG_KGDB_SERIAL_CONSOLE */
+
 module_init(init_kgdboc);
 module_exit(cleanup_kgdboc);
 module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
-- 
1.6.4.rc1

