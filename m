Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZE1QLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZE1QLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZE1QLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:11:24 -0400
Received: from monster.nessie.de ([84.200.20.120]:51239 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZE1QLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:11:23 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 12:11:23 EDT
From: Michael Roth <mroth@nessie.de>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Michael Roth <mroth@nessie.de>
Subject: [PATCH] freezer: cleanup printk call sequences
Date: Thu, 28 May 2009 18:02:21 +0200
Message-Id: <1243526541-2436-1-git-send-email-mroth@nessie.de>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct and ease printk() interaction among freeze_processes()
and try_to_freeze_tasks().

Move printk("done") in thaw_processes() before schedule() to
prevent implicit interferences from it.

Signed-off-by: Michael Roth <mroth@nessie.de>
---
 kernel/power/process.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index ca63401..f6bd3de 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -92,7 +92,7 @@ static int try_to_freeze_tasks(bool sig_only)
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	} else {
-		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
+		printk("(elapsed %d.%02d seconds) done.\n", elapsed_csecs / 100,
 			elapsed_csecs % 100);
 	}
 
@@ -110,16 +110,12 @@ int freeze_processes(void)
 	error = try_to_freeze_tasks(true);
 	if (error)
 		goto Exit;
-	printk("done.\n");
 
 	printk("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(false);
-	if (error)
-		goto Exit;
-	printk("done.");
+
  Exit:
 	BUG_ON(in_atomic());
-	printk("\n");
 	return error;
 }
 
@@ -148,7 +144,7 @@ void thaw_processes(void)
 	printk("Restarting tasks ... ");
 	thaw_tasks(true);
 	thaw_tasks(false);
-	schedule();
 	printk("done.\n");
+	schedule();
 }
 
-- 
1.6.0.6

