Return-Path: <linux-kernel-owner+w=401wt.eu-S1764670AbZEHV2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764670AbZEHV2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762600AbZEHVXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:44772 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620AbZEHVXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:38 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 12/13] RFC ONLY - kgdb,kdb: use async breakpoint for sysrq for usb
Date: Fri,  8 May 2009 16:23:19 -0500
Message-Id: <1241817800-9320-13-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-12-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-7-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-8-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-9-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-10-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-11-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-12-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:33.0372 (UTC) FILETIME=[3DA97BC0:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

For kdb, the usb keyboard will become disabled if you use a sysrq
sequence to enter kdb.  Using a tasklet solves the problem.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index f303410..034f6eb 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1817,8 +1817,18 @@ static void sysrq_handle_gdb(int key, struct tty_struct *tty)
 		printk(KERN_CRIT "Entering KGDB\n");
 #endif
 	}
-
+#ifdef CONFIG_KDB_USB
+	/* XXX FIX ME XXX
+	 * For now force the sysrq break point to be in a tasklet
+	 * else if you send it from a usb keyboard, the keyboard cannot be
+	 * used to interact with kdb because all the locks for the USB hcd
+	 * device will be held.  This probably needs a run time check
+	 * against what i/o driver submitted the breakpoint request.
+	 */
+	kgdb_schedule_breakpoint();
+#else /* ! CONFIG_KDB_USB */
 	kgdb_breakpoint();
+#endif /* CONFIG_KDB_USB */
 }
 
 static struct sysrq_key_op sysrq_gdb_op = {
-- 
1.6.3.rc0.1.gf800

