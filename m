Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab0BYVYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:24:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:63751 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995Ab0BYVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:23:12 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/8] kgdboc: Add ekgdboc for early use of the kernel debugger
Date: Thu, 25 Feb 2010 15:22:03 -0600
Message-Id: <1267132926-23685-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132926-23685-1-git-send-email-jason.wessel@windriver.com>
References: <1267132926-23685-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:22:49.0429 (UTC) FILETIME=[AE811050:01CAB660]
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
index c6936b2..aaeb992 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -708,6 +708,12 @@ and is between 256 and 4096 characters. It is defined in the file
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
index 201cdf5..e8557a5 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -236,6 +236,25 @@ static struct kgdb_io kgdboc_io_ops = {
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

