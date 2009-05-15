Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbZEONTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbZEONTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZEONSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:18:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:34689 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336AbZEONSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:18:52 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] sysrq, intel_fb: fix sysrq g collision
Date: Fri, 15 May 2009 08:17:57 -0500
Message-Id: <1242393479-19351-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com>
References: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 May 2009 13:18:11.0580 (UTC) FILETIME=[989CEBC0:01C9D55F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 79e539453b34e35f39299a899d263b0a1f1670bd introduced a
regression where you cannot use sysrq 'g' to enter kgdb.  The solution
is to move the intel fb sysrq over to V for video instead of G for
graphics.  The SMP VOYAGER code to register for the sysrq-v is not
anywhere to be found in the mainline kernel, so the comments in the
code were cleaned up as well.

This patch also cleans up the sysrq definitions for kgdb to make it
generic for the kernel debugger, such that the sysrq 'g' can be used
in the future to enter a gdbstub or another kernel debugger.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/sysrq.c            |    4 ++--
 drivers/gpu/drm/i915/intel_fb.c |    4 ++--
 kernel/kgdb.c                   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index b0a6a3e..d6a807f 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -406,7 +406,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_showlocks_op,		/* d */
 	&sysrq_term_op,			/* e */
 	&sysrq_moom_op,			/* f */
-	/* g: May be registered by ppc for kgdb */
+	/* g: May be registered for the kernel debugger */
 	NULL,				/* g */
 	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
@@ -431,7 +431,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
 	&sysrq_mountro_op,		/* u */
-	/* v: May be registered at init time by SMP VOYAGER */
+	/* v: May be registered for frame buffer console restore */
 	NULL,				/* v */
 	&sysrq_showstate_blocked_op,	/* w */
 	/* x: May be registered on ppc/powerpc for xmon */
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 3e094be..e4652dc 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -864,7 +864,7 @@ static void intelfb_sysrq(int dummy1, struct tty_struct *dummy3)
 
 static struct sysrq_key_op sysrq_intelfb_restore_op = {
         .handler = intelfb_sysrq,
-        .help_msg = "force-fb(G)",
+        .help_msg = "force-fb(V)",
         .action_msg = "Restore framebuffer console",
 };
 
@@ -898,7 +898,7 @@ int intelfb_probe(struct drm_device *dev)
 		ret = intelfb_single_fb_probe(dev);
 	}
 
-	register_sysrq_key('g', &sysrq_intelfb_restore_op);
+	register_sysrq_key('v', &sysrq_intelfb_restore_op);
 
 	return ret;
 }
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..9147a31 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1583,8 +1583,8 @@ static void sysrq_handle_gdb(int key, struct tty_struct *tty)
 
 static struct sysrq_key_op sysrq_gdb_op = {
 	.handler	= sysrq_handle_gdb,
-	.help_msg	= "Gdb",
-	.action_msg	= "GDB",
+	.help_msg	= "debug(G)",
+	.action_msg	= "DEBUG",
 };
 #endif
 
-- 
1.6.3.1.9.g95405b

