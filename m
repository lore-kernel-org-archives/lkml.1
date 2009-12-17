Return-Path: <linux-kernel-owner+w=401wt.eu-S936163AbZLQEFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936163AbZLQEFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935954AbZLQEFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:06 -0500
Received: from kroah.org ([198.145.64.141]:55760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935712AbZLQEEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.039523877@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [093/151] xen: improve error handling in do_suspend.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 65f63384b391bf4d384327d8a7c6de9860290b5c upstream.

The existing error handling has a few issues:
- If freeze_processes() fails it exits with shutting_down = SHUTDOWN_SUSPEND.
- If dpm_suspend_noirq() fails it exits without resuming xenbus.
- If stop_machine() fails it exits without resuming xenbus or calling
  dpm_resume_end().
- xs_suspend()/xs_resume() and dpm_suspend_noirq()/dpm_resume_noirq() were not
  nested in the obvious way.

Fix by ensuring each failure case goto's the correct label. Treat a failure of
stop_machine() as a cancelled suspend in order to follow the correct resume
path.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/manage.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -86,32 +86,32 @@ static void do_suspend(void)
 	err = freeze_processes();
 	if (err) {
 		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
-		return;
+		goto out;
 	}
 #endif
 
 	err = dpm_suspend_start(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "xen suspend: dpm_suspend_start %d\n", err);
-		goto out;
+		goto out_thaw;
 	}
 
-	printk(KERN_DEBUG "suspending xenstore...\n");
-	xs_suspend();
-
 	err = dpm_suspend_noirq(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "dpm_suspend_noirq failed: %d\n", err);
-		goto resume_devices;
+		goto out_resume;
 	}
 
+	printk(KERN_DEBUG "suspending xenstore...\n");
+	xs_suspend();
+
 	err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
 
 	dpm_resume_noirq(PMSG_RESUME);
 
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
-		goto out;
+		cancelled = 1;
 	}
 
 	if (!cancelled) {
@@ -120,15 +120,17 @@ static void do_suspend(void)
 	} else
 		xs_suspend_cancel();
 
-resume_devices:
+out_resume:
 	dpm_resume_end(PMSG_RESUME);
 
 	/* Make sure timer events get retriggered on all CPUs */
 	clock_was_set();
-out:
+
+out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
 #endif
+out:
 	shutting_down = SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_PM_SLEEP */


