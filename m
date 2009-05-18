Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZERLAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZERLAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZERLAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:00:43 -0400
Received: from SOUTH-STATION-ANNEX.MIT.EDU ([18.72.1.2]:47840 "EHLO
	south-station-annex.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbZERLAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:00:43 -0400
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 07:00:42 EDT
From: Geoffrey Thomas <geofft@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Geoffrey Thomas <geofft@MIT.EDU>
Subject: [PATCH] sysrq: Don't panic_on_oom if the user requested an OOM kill.
Date: Mon, 18 May 2009 06:41:14 -0400
Message-Id: <1242643274-26733-1-git-send-email-geofft@mit.edu>
X-Mailer: git-send-email 1.6.0
X-Spam-Score: 0
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I specifically request an OOM kill via magic sysrq, I don't want
panic_on_oom to apply and crash the machine. I ran into this on a server
with panic_on_oom and automatic reboot after panic configured on the
assumption that nobody is likely physically present. If I'm able to use
magic sysrq, though, I can use that to reboot the machine slightly more
safely, if that's what I wanted.

This patch adds an extra parameter to out_of_memory to ignore the value
of sysctl_panic_on_oom, and just proceed with the OOM kill.

Signed-off-by: Geoffrey Thomas <geofft@mit.edu>
---
 drivers/char/sysrq.c |    2 +-
 include/linux/oom.h  |    3 ++-
 mm/oom_kill.c        |    8 +++++---
 mm/page_alloc.c      |    2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index d6a807f..0233d5a 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -329,7 +329,7 @@ static struct sysrq_key_op sysrq_term_op = {
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0);
+	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, 1);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff --git a/include/linux/oom.h b/include/linux/oom.h
index a7979ba..b273c7c 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -26,7 +26,8 @@ enum oom_constraint {
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
+extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+			  int order, int dontpanic);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 92bcf1d..7bc4dcf 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -583,13 +583,15 @@ rest_and_return:
  * @zonelist: zonelist pointer
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
+ * @dontpanic: whether to ignore panic_on_oom (used by magic-sysrq)
  *
  * If we run out of memory, we have the choice between either
  * killing a random task (bad), letting the system crash (worse)
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
  */
-void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
+void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		   int order, int dontpanic)
 {
 	unsigned long freed = 0;
 	enum oom_constraint constraint;
@@ -599,7 +601,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom == 2)
+	if (!dontpanic && sysctl_panic_on_oom == 2)
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 
 	/*
@@ -616,7 +618,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		break;
 
 	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom)
+		if (!dontpanic && sysctl_panic_on_oom)
 			panic("out of memory. panic_on_oom is selected\n");
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fe753ec..b5f42d6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1625,7 +1625,7 @@ nofail_alloc:
 			goto nopage;
 		}
 
-		out_of_memory(zonelist, gfp_mask, order);
+		out_of_memory(zonelist, gfp_mask, order, 0);
 		clear_zonelist_oom(zonelist, gfp_mask);
 		goto restart;
 	}
-- 
1.6.0

