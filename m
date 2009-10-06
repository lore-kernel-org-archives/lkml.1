Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZJFCmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZJFCmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbZJFCmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:42:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41579 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZJFCmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:42:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mlock use lru_add_drain_all_async()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20091006112803.5FA5.A69D9226@jp.fujitsu.com>
References: <20091006112803.5FA5.A69D9226@jp.fujitsu.com>
Message-Id: <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 11:41:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently, Peter Zijlstra reported RT-task can lead to prevent mlock
very long time.

  Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
  cpu0 does mlock()->lru_add_drain_all(), which does
  schedule_on_each_cpu(), which then waits for all cpus to complete the
  work. Except that cpu1, which is busy with the RT task, will never run
  keventd until the RT load goes away.

  This is not so much an actual deadlock as a serious starvation case.

Actually, mlock() doesn't need to wait to finish lru_add_drain_all().
Thus, this patch replace it with lru_add_drain_all_async().

Cc: Oleg Nesterov <onestero@redhat.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mlock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 22041aa..46a016f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -458,7 +458,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 	if (!can_do_mlock())
 		return -EPERM;
 
-	lru_add_drain_all();	/* flush pagevec */
+	lru_add_drain_all_async();	/* flush pagevec */
 
 	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
@@ -526,7 +526,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		goto out;
 
-	lru_add_drain_all();	/* flush pagevec */
+	lru_add_drain_all_async();	/* flush pagevec */
 
 	down_write(&current->mm->mmap_sem);
 
-- 
1.6.2.5



