Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZDVLEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZDVLEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZDVLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:04:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZDVLEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:04:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Delete slow-work timers properly
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
       David Howells <dhowells@redhat.com>
Date: Wed, 22 Apr 2009 12:01:49 +0100
Message-ID: <20090422110149.18114.76962.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>

Slow-work appears to delete its timer as soon as the first user
unregisters, even though other users could be active.  At the same time, it
never seems to delete slow_work_oom_timer.  Arrange for both to happen in
the shutdown path.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: David Howells <dhowells@redhat.com>
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

