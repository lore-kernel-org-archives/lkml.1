Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbXE0So0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbXE0So0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 14:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXE0SoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 14:44:17 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:46953 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbXE0SoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 14:44:16 -0400
Date: Sun, 27 May 2007 19:44:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Message-ID: <20070527184402.GA21161@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> <20070527164300.GA20355@srcf.ucam.org> <200705272032.15971.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272032.15971.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 08:32:14PM +0200, Rafael J. Wysocki wrote:

> In particular, please see this message:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012301.html

Yes, there's also the notifier chain for the hardware. However, very few 
drivers seem to use that - adb seems to be the only one still in the 
tree. For everything else, the device tree is used in exactly the same 
way as on x86. If it's safe on Macs but not on x86, then (as far as I 
can tell) it looks like it's only by luck.

Anyway. I've tested the following patch on a dual-core x86. No obvious 
issues yet, but I'll try to put it through a few hundred cycles.

diff --git a/include/linux/pm.h b/include/linux/pm.h
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 8812985..1db3012 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -19,7 +19,6 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/resume-trace.h>
-#include <linux/freezer.h>
 #include <linux/vmstat.h>
 
 #include "power.h"
@@ -66,9 +65,10 @@ static inline void pm_finish(suspend_state_t state)
  *	suspend_prepare - Do prep work before entering low-power state.
  *	@state:		State we're entering.
  *
- *	This is common code that is called for each state that we're 
- *	entering. Allocate a console, stop all processes, then make sure
- *	the platform can enter the requested state.
+ *	This is common code that is called for each state that we're
+ *	entering. Allocate a console, then make sure the platform can
+ *	enter the requested state. This is not called for
+ *	suspend-to-disk.
  */
 
 static int suspend_prepare(suspend_state_t state)
@@ -81,11 +81,6 @@ static int suspend_prepare(suspend_state_t state)
 
 	pm_prepare_console();
 
-	if (freeze_processes()) {
-		error = -EAGAIN;
-		goto Thaw;
-	}
-
 	if ((free_pages = global_page_state(NR_FREE_PAGES))
 			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -93,7 +88,7 @@ static int suspend_prepare(suspend_state_t state)
 		if (nr_free_pages() < FREE_PAGE_NUMBER) {
 			error = -ENOMEM;
 			printk(KERN_ERR "PM: No enough memory\n");
-			goto Thaw;
+			goto Exit;
 		}
 	}
 
@@ -118,8 +113,7 @@ static int suspend_prepare(suspend_state_t state)
 	device_resume();
  Resume_console:
 	resume_console();
- Thaw:
-	thaw_processes();
+ Exit:
 	pm_restore_console();
 	return error;
 }
@@ -160,8 +154,8 @@ int suspend_enter(suspend_state_t state)
  *	suspend_finish - Do final work before exiting suspend sequence.
  *	@state:		State we're coming out of.
  *
- *	Call platform code to clean up, restart processes, and free the 
- *	console that we've allocated. This is not called for suspend-to-disk.
+ *	Call platform code to clean up and free the console that we've
+ *	allocated. This is not called for suspend-to-disk.
  */
 
 static void suspend_finish(suspend_state_t state)
@@ -170,7 +164,6 @@ static void suspend_finish(suspend_state_t state)
 	pm_finish(state);
 	device_resume();
 	resume_console();
-	thaw_processes();
 	pm_restore_console();
 }
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
