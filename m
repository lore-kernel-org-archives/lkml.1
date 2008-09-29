Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYI2SXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYI2SXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYI2SXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:23:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58454 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYI2SXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:23:10 -0400
Message-ID: <48E11D0D.3040000@ct.jp.nec.com>
Date: Mon, 29 Sep 2008 11:23:09 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] sched: fix using uninilialzed rq in task_delta_exec()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

compiler warnings;

  CC      kernel/sched.o
kernel/sched.c: In function 'task_delta_exec':
kernel/sched.c:4055: warning: unused variable 'flags'
kernel/sched.c:4054: warning: 'rq' is used uninitialized in this function

calling task_delta_exec() may cause unexpected pointer access.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 30b73fc..b6c0dd8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4055,6 +4055,7 @@ unsigned long long task_delta_exec(struct task_struct *p)
 	unsigned long flags;
 	u64 ns = 0;
 
+	rq = task_rq_lock(p, &flags);
 	if (task_current(rq, p)) {
 		u64 delta_exec;
 
@@ -4063,6 +4064,7 @@ unsigned long long task_delta_exec(struct task_struct *p)
 		if ((s64)delta_exec > 0)
 			ns = delta_exec;
 	}
+	task_rq_unlock(rq, &flags);
 
 	return ns;
 }
-- 
1.5.6

