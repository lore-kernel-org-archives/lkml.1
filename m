Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZDUXdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZDUXdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZDUXcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:32:51 -0400
Received: from vena.lwn.net ([206.168.112.25]:48316 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZDUXcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:32:51 -0400
Date: Tue, 21 Apr 2009 17:32:49 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Howells <dhowells@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH/question] Delete slow-work timers properly
Message-ID: <20090421173249.3927807a@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David,

One more question: it looks to me like slow_work_unregister_user()
deletes the cull timer when it shouldn't, and it never deletes the OOM
timer at all.  I *think* the following patch makes sense; disagree?

Thanks,

jon

---
Delete slow-work timers properly

Slow-work appears to delete its timer as soon as the first user
unregisters, even though other users could be active.  At the same time, it
never seems to delete slow_work_oom_timer.  Arrange for both to happen in
the shutdown path.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 kernel/slow-work.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index cf2bc01..b28d191 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -609,14 +609,14 @@ void slow_work_unregister_user(void)
 	if (slow_work_user_count == 0) {
 		printk(KERN_NOTICE "Slow work thread pool: Shutting down\n");
 		slow_work_threads_should_exit = true;
+		del_timer_sync(&slow_work_cull_timer);
+		del_timer_sync(&slow_work_oom_timer);
 		wake_up_all(&slow_work_thread_wq);
 		wait_for_completion(&slow_work_last_thread_exited);
 		printk(KERN_NOTICE "Slow work thread pool:"
 		       " Shut down complete\n");
 	}
 
-	del_timer_sync(&slow_work_cull_timer);
-
 	mutex_unlock(&slow_work_user_lock);
 }
 EXPORT_SYMBOL(slow_work_unregister_user);
-- 
1.6.2.2

