Return-Path: <linux-kernel-owner+w=401wt.eu-S936532AbZLQE2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936532AbZLQE2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936512AbZLQE1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:27:42 -0500
Received: from kroah.org ([198.145.64.141]:55744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935708AbZLQEEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035654.540949610@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [090/151] xen: dont call dpm_resume_noirq() with interrupts disabled.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 922cc38ab71d1360978e65207e4a4f4988987127 upstream.

dpm_resume_noirq() takes a mutex, so it can't be called from a no-interrupt
context.  Don't call it from within the stop-machine function, but just
afterwards, since we're resuming anyway, regardless of what happened.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/manage.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -43,7 +43,6 @@ static int xen_suspend(void *data)
 	if (err) {
 		printk(KERN_ERR "xen_suspend: sysdev_suspend failed: %d\n",
 			err);
-		dpm_resume_noirq(PMSG_RESUME);
 		return err;
 	}
 
@@ -69,7 +68,6 @@ static int xen_suspend(void *data)
 	}
 
 	sysdev_resume();
-	dpm_resume_noirq(PMSG_RESUME);
 
 	return 0;
 }
@@ -108,6 +106,9 @@ static void do_suspend(void)
 	}
 
 	err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
+
+	dpm_resume_noirq(PMSG_RESUME);
+
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
 		goto out;
@@ -119,8 +120,6 @@ static void do_suspend(void)
 	} else
 		xs_suspend_cancel();
 
-	dpm_resume_noirq(PMSG_RESUME);
-
 resume_devices:
 	dpm_resume_end(PMSG_RESUME);
 


