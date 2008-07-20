Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYGTWP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYGTWP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYGTWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:14:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:38184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYGTWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:14:52 -0400
Date: Sun, 20 Jul 2008 15:13:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: [patch 2/4] fastboot: retry mounting the root fs if we can't find
 init
Message-ID: <20080720151304.59b06786@infradead.org>
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
Date: Sun, 20 Jul 2008 13:01:28 -0700
Subject: [PATCH] fastboot: retry mounting the root fs if we can't find init

currently we wait until all device init is done before trying to mount
the root fs, and to consequently execute init.

In preparation for relaxing the first delay, this patch adds a retry
attempt in case /sbin/init is not found. Before retrying, the code
will wait for all device init to complete.

While this patch by itself doesn't gain boot time yet (it needs follow on
patches), the alternative already is to panic()...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 init/main.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3575b84..73785a4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -853,6 +853,7 @@ static void run_init_process(char *init_filename)
  */
 static int noinline init_post(void)
 {
+	int retry_count = 1;
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
@@ -873,6 +874,7 @@ static int noinline init_post(void)
 				ramdisk_execute_command);
 	}
 
+retry:
 	/*
 	 * We try each of these until one succeeds.
 	 *
@@ -885,6 +887,23 @@ static int noinline init_post(void)
 					"defaults...\n", execute_command);
 	}
 	run_init_process("/sbin/init");
+
+	if (retry_count > 0) {
+		retry_count--;
+		/*
+		 * We haven't found init yet... potentially because the device
+		 * is still being probed. We need to
+		 * - flush keventd and friends
+		 * - wait for the known devices to complete their probing
+		 * - try to mount the root fs again
+		 */
+		flush_scheduled_work();
+		while (driver_probe_done() != 0)
+			msleep(100);
+		prepare_namespace();
+		goto retry;
+	}
+
 	run_init_process("/etc/init");
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
-- 
1.5.5.1

