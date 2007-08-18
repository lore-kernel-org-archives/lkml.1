Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbXHRRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbXHRRif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXHRRhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:37:14 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41990 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbXHRRhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:37:08 -0400
Date: Sat, 18 Aug 2007 21:39:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] exec: consolidate 2 fast-paths
Message-ID: <20070818173956.GA215@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we don't pre-allocate the new ->sighand, we can kill the first fast
path, it doesn't make sense any longer. At best, it can save one "list_empty()"
check but leads to the code duplication.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/exec.c~4_FASTPATH	2007-08-18 19:10:58.000000000 +0400
+++ t/fs/exec.c	2007-08-18 19:34:12.000000000 +0400
@@ -779,16 +779,6 @@ static int de_thread(struct task_struct 
 	struct task_struct *leader = NULL;
 	int count;
 
-	/*
-	 * If we don't share sighandlers, then we aren't sharing anything
-	 * and we can just re-use it all.
-	 */
-	if (atomic_read(&oldsighand->count) <= 1) {
-		signalfd_detach(tsk);
-		exit_itimers(sig);
-		return 0;
-	}
-
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
 

