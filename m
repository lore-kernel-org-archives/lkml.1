Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab0BCL2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:28:08 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:50216 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757099Ab0BCL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:28:03 -0500
Date: Wed, 3 Feb 2010 12:27:55 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: oleg@redhat.com, rusty@rustcorp.com.au, tj@kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: [PATCH] core: workqueue: BUG_ON on workqueue recursion
Message-ID: <20100203122755.0fd4fb7e@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the workqueue is flushed from workqueue context (recursively), the
system enters a strange state where things at random (dependent on the
global workqueue) start misbehaving. For example, for us the console and
logins locks up while the web server continues running.

Since the system becomes unstable, change this to a BUG_ON instead.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dee4865..e617d29 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -482,7 +482,7 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 	int active = 0;
 	struct wq_barrier barr;
 
-	WARN_ON(cwq->thread == current);
+	BUG_ON(cwq->thread == current);
 
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-- 
1.6.0.4

