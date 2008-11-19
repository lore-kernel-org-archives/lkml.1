Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbYKSGoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbYKSGoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYKSGnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:43:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYKSGnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:43:52 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Do not free io context when taking recursive faults in do_exit
Date: Wed, 19 Nov 2008 12:15:35 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191215.35438.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When taking recursive faults in do_exit, if the io_context is not null, 
exit_io_context() is being called. But it might decrement the refcount 
more than once. It is better to leave this task alone.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/kernel/exit.c b/kernel/exit.c
index 80137a5..22dedf5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1024,8 +1024,6 @@ NORET_TYPE void do_exit(long code)
 		 * task into the wait for ever nirwana as well.
 		 */
 		tsk->flags |= PF_EXITPIDONE;
-		if (tsk->io_context)
-			exit_io_context();
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 	}

