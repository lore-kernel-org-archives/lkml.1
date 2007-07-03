Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbXGCE3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbXGCE3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXGCE3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:29:25 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:58456 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXGCE3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:29:24 -0400
Date: Tue, 3 Jul 2007 05:29:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org
Message-ID: <20070703042916.GA17240@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
a screaming nightmare - either the suspend fails because syslog (for 
instance) can't be frozen, or the machine deadlocks for some other 
reason I haven't tracked down. We could "fix" fuse, or alternatively we 
could do what we do for suspend to RAM on other platforms (PPC and APM) 
and just not use the freezer.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 8812985..5f109d5 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -19,7 +19,6 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/resume-trace.h>
-#include <linux/freezer.h>
 #include <linux/vmstat.h>
 
 #include "power.h"
@@ -81,11 +80,6 @@ static int suspend_prepare(suspend_state_t state)
 
 	pm_prepare_console();
 
-	if (freeze_processes()) {
-		error = -EAGAIN;
-		goto Thaw;
-	}
-
 	if ((free_pages = global_page_state(NR_FREE_PAGES))
 			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -93,7 +87,7 @@ static int suspend_prepare(suspend_state_t state)
 		if (nr_free_pages() < FREE_PAGE_NUMBER) {
 			error = -ENOMEM;
 			printk(KERN_ERR "PM: No enough memory\n");
-			goto Thaw;
+			goto Restore_console;
 		}
 	}
 
@@ -118,8 +112,7 @@ static int suspend_prepare(suspend_state_t state)
 	device_resume();
  Resume_console:
 	resume_console();
- Thaw:
-	thaw_processes();
+ Restore_console:
 	pm_restore_console();
 	return error;
 }
@@ -170,7 +163,6 @@ static void suspend_finish(suspend_state_t state)
 	pm_finish(state);
 	device_resume();
 	resume_console();
-	thaw_processes();
 	pm_restore_console();
 }

-- 
Matthew Garrett | mjg59@srcf.ucam.org
