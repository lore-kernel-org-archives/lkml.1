Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393Ab0ANWdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0ANWdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742Ab0ANWdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:33:31 -0500
Received: from kroah.org ([198.145.64.141]:60642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab0ANW2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Ian Campbell <ian.campbell@citrix.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/52] xen: fix hang on suspend.
Date: Thu, 14 Jan 2010 14:27:17 -0800
Message-Id: <1263508051-7868-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-37-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

commit c5cae661d6cf808b6984762f763261adf35f3eb7 upstream.

In 65f63384 "xen: improve error handling in do_suspend" I said:
    - xs_suspend()/xs_resume() and dpm_suspend_noirq()/dpm_resume_noirq() were not
      nested in the obvious way.
and changed the ordering of the calls as so:
    BEFORE		AFTER
    xs_suspend		dpm_suspend_noirq
    dpm_suspend_noirq	xs_suspend
    *SUSPEND*		*SUSPEND*
    dpm_resume_noirq	dpm_resume_noirq
    xs_resume		xs_resume
Clearly this is not an improvement and I was talking rubbish.

In particular the new ordering is susceptible to a hang if a xenstore write is
in progress at the point at which the suspend kicks in. When the suspend
process calls xs_suspend it tries to take the request_mutex but if a write is
in progress it could be looping in xenbus_xs.c:read_reply() waiting for
something to arrive on &xs_state.reply_list while holding the request_mutex
(taken in the caller of read_reply).

However if we have done dpm_suspend_noirq before xs_suspend then we won't get
any more xenstore interrupts and process_msg() will never be woken up to add
anything to the reply_list.

Fix this by calling xs_suspend before dpm_suspend_noirq. If dpm_suspend_noirq
fails then make sure we go through the xs_suspend_cancel() code path.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/xen/manage.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index c499793..5d42d55 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -102,15 +102,15 @@ static void do_suspend(void)
 		goto out_thaw;
 	}
 
+	printk(KERN_DEBUG "suspending xenstore...\n");
+	xs_suspend();
+
 	err = dpm_suspend_noirq(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "dpm_suspend_noirq failed: %d\n", err);
 		goto out_resume;
 	}
 
-	printk(KERN_DEBUG "suspending xenstore...\n");
-	xs_suspend();
-
 	err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
 
 	dpm_resume_noirq(PMSG_RESUME);
@@ -120,13 +120,13 @@ static void do_suspend(void)
 		cancelled = 1;
 	}
 
+out_resume:
 	if (!cancelled) {
 		xen_arch_resume();
 		xs_resume();
 	} else
 		xs_suspend_cancel();
 
-out_resume:
 	dpm_resume_end(PMSG_RESUME);
 
 	/* Make sure timer events get retriggered on all CPUs */
-- 
1.6.6

