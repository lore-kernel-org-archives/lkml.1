Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZEGGwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZEGGwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZEGGvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:51:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36270 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbZEGGvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:51:19 -0400
Date: Thu, 7 May 2009 08:46:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] do_wait: kill the old BUG_ON, use while_each_thread()
Message-ID: <20090507064646.GA15871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait() does BUG_ON(tsk->signal != current->signal), this looks like
a raher obsolete check. At least, I don't think do_wait() is the best
place to verify that all threads have the same ->signal. Remove it.

Also, change the code to use while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- PTRACE/kernel/exit.c~4_WHILE	2009-05-07 05:09:51.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-07 05:34:40.000000000 +0200
@@ -1595,9 +1595,7 @@ repeat:
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
-		tsk = next_thread(tsk);
-		BUG_ON(tsk->signal != current->signal);
-	} while (tsk != current);
+	} while_each_thread(current, tsk);
 	read_unlock(&tasklist_lock);
 
 notask:

