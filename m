Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbZENXNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbZENXNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762374AbZENW7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:59:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:43877 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760004AbZENW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:59:07 -0400
Message-ID: <4A0CA203.7050907@windriver.com>
Date: Thu, 14 May 2009 17:58:11 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org
CC: Andrew Morton <akpm@linux-foundation.org>, eric@anholt.net,
       airlied@redhat.com, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysrq, intel_fb: fix sysrq g collision
Content-Type: multipart/mixed;
 boundary="------------020401080406080701050509"
X-OriginalArrivalTime: 14 May 2009 22:58:11.0828 (UTC) FILETIME=[74C39B40:01C9D4E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020401080406080701050509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


This is patch is both a clean up and a regression fix because two things
in the mainline kernel can register for sysrq-g, which is certainly a
problem when you want to use both.

I talked to Randy and Jesse briefly about changing the intel fb video
driver to use 'v' instead of 'g' and they agreed it would be ok to see a
patch.  Hopefully each will ack this patch, or discuss it further.   If
they ack the patch, I can send it on to Linus for consideration.

The long term intent here is to get mode switching with a generic kernel
debug front end, with the short term intent to fix the sysrq collision.

Thanks,
Jason.

--------------020401080406080701050509
Content-Type: text/x-diff;
 name="0001-Cleanup-sysrq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Cleanup-sysrq.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 13 May 2009 21:56:59 -0500
Subject: [PATCH] sysrq, intel_fb: fix sysrq g collision

Commit 79e539453b34e35f39299a899d263b0a1f1670bd introduced a
regression where you cannot use sysrq 'g' to enter kgdb.  The solution
is to move the intel fb sysrq over to V for video instead of G for
graphics.  The SMP VOYAGER code to register for the sysrq-v is not
anywhere to be found in the mainline kernel, so the comments in the
code were cleaned up as well.

This patch also cleans up the sysrq definitions for kgdb to make it
generic for the kernel debugger, such that the sysrq 'g' can be used
in the future to enter a gdbstub or another kernel debugger.

Signed-off-by: Jason Vessel <jason.wessel@windriver.com>

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
+	/* v: May be registered for frame buffer video console restore */
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
1.6.3.9.g6345d


--------------020401080406080701050509--
