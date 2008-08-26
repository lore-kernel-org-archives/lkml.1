Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYHZWrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYHZWrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYHZWro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:47:44 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:60312 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYHZWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:47:43 -0400
X-Greylist: delayed 1985 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 18:47:43 EDT
Date: Tue, 26 Aug 2008 15:14:36 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] exit signals: use of uninitialized field notify_count
Message-ID: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->signal->notify_count is only initialized if
task->signal->group_exit_task is not NULL.  Reorder a conditional so
that uninitialised memory is not used.  Found by Valgrind.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
---

Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c	2008-08-06 09:19:01.000000000 -0700
+++ linux/kernel/exit.c	2008-08-23 15:21:34.000000000 -0700
@@ -883,8 +883,8 @@

  	/* mt-exec, de_thread() is waiting for us */
  	if (thread_group_leader(tsk) &&
-	    tsk->signal->notify_count < 0 &&
-	    tsk->signal->group_exit_task)
+	    tsk->signal->group_exit_task &&
+	    tsk->signal->notify_count < 0)
  		wake_up_process(tsk->signal->group_exit_task);

  	write_unlock_irq(&tasklist_lock);
