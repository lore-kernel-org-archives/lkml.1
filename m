Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYGTWPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYGTWPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYGTWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:14:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:38181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYGTWOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:14:50 -0400
Date: Sun, 20 Jul 2008 15:12:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: [patch 1/4] fastboot: make fastboot a config option
Message-ID: <20080720151234.4535ee73@infradead.org>
In-Reply-To: <20080720151140.4aa7c682@infradead.org>
References: <20080720151140.4aa7c682@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 20 Jul 2008 10:20:49 -0700
Subject: [PATCH] fastboot: make fastboot a config option

to mitigate the risks of async bootup, make fastboot a configuration
option...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig |   11 +++++++++++
 init/main.c  |    4 ++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..7545c8b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -524,6 +524,17 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+config FASTBOOT
+	bool "Fast boot support"
+	help
+	  The fastboot option will cause the kernel to try to optimize
+	  for faster boot. 
+
+	  This includes doing some of the device initialization asynchronous
+	  as well as opportunistically trying to mount the root fs early.
+
+	  If unsure, say N.
+
 config SYSCTL
 	bool
 
diff --git a/init/main.c b/init/main.c
index 6be1756..bb97add 100644
--- a/init/main.c
+++ b/init/main.c
@@ -776,7 +776,11 @@ static void __init do_initcalls(void)
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		if (phase == 0 && call >= __async_initcall_start) {
 			phase = 1;
+#ifdef CONFIG_FASTBOOT
 			queue_work(async_init_wq, &async_work);
+#else
+			do_async_initcalls(NULL);
+#endif
 		}
 		if (phase == 1 && call >= __async_initcall_end)
 			phase = 2;
-- 
1.5.5.1

