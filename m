Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXDSHJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXDSHJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993159AbXDSHIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:08:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46299 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161227AbXDSHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:13 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] md: Remove broken SIGKILL support
Date: Thu, 19 Apr 2007 00:56:00 -0600
Message-Id: <11769658203016-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

Currently md_thread calls allow_signal so it can receive a
SIGKILL but then does nothing with it except flush the
sigkill so that it not can use an interruptible sleep.

This whole dance is silly so remove the unnecessary
and broken signal handling logic.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/md/md.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1299c23..dfd0cb9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4542,17 +4542,11 @@ static int md_thread(void * arg)
 	 */
 
 	current->flags |= PF_NOFREEZE;
-	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
 		/* We need to wait INTERRUPTIBLE so that
 		 * we don't add to the load-average.
-		 * That means we need to be sure no signals are
-		 * pending
 		 */
-		if (signal_pending(current))
-			flush_signals(current);
-
 		wait_event_interruptible_timeout
 			(thread->wqueue,
 			 test_bit(THREAD_WAKEUP, &thread->flags)
-- 
1.5.0.g53756

