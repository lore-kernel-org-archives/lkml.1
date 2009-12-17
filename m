Return-Path: <linux-kernel-owner+w=401wt.eu-S936504AbZLQE1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936504AbZLQE1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935726AbZLQE0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:26:13 -0500
Received: from kroah.org ([198.145.64.141]:55773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935662AbZLQEE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.451425681@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [096/151] xen: explicitly create/destroy stop_machine workqueues outside suspend/resume region.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit b4606f2165153833247823e8c04c5e88cb3d298b upstream.

I have observed cases where the implicit stop_machine_destroy() done by
stop_machine() hangs while destroying the workqueues, specifically in
kthread_stop(). This seems to be because timer ticks are not restarted
until after stop_machine() returns.

Fortunately stop_machine provides a facility to pre-create/post-destroy
the workqueues so use this to ensure that workqueues are only destroyed
after everything is really up and running again.

I only actually observed this failure with 2.6.30. It seems that newer
kernels are somehow more robust against doing kthread_stop() without timer
interrupts (I tried some backports of some likely looking candidates but
did not track down the commit which added this robustness). However this
change seems like a reasonable belt&braces thing to do.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/manage.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -79,6 +79,12 @@ static void do_suspend(void)
 
 	shutting_down = SHUTDOWN_SUSPEND;
 
+	err = stop_machine_create();
+	if (err) {
+		printk(KERN_ERR "xen suspend: failed to setup stop_machine %d\n", err);
+		goto out;
+	}
+
 #ifdef CONFIG_PREEMPT
 	/* If the kernel is preemptible, we need to freeze all the processes
 	   to prevent them from being in the middle of a pagetable update
@@ -86,7 +92,7 @@ static void do_suspend(void)
 	err = freeze_processes();
 	if (err) {
 		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
-		goto out;
+		goto out_destroy_sm;
 	}
 #endif
 
@@ -129,7 +135,11 @@ out_resume:
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
+
+out_destroy_sm:
 #endif
+	stop_machine_destroy();
+
 out:
 	shutting_down = SHUTDOWN_INVALID;
 }


