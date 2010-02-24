Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0BXUWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:22:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040Ab0BXUWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:22:12 -0500
Date: Wed, 24 Feb 2010 21:20:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] workqueues: microoptimize set_wq_data()
Message-ID: <20100224202035.GA26991@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment correctly states that the _PENDING bit must be set and
we even have the BUG_ON() check. But this means there is no need to
set WORK_STRUCT_PENDING explicitely and load work_data_bits() twice,
we can rely on WORK_STRUCT_FLAG_MASK which contains _PENDING.

Shaves 32 bytes from workqueue.o.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/workqueue.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- wq/kernel/workqueue.c~2_CLEANUP_SET_DATA	2010-02-24 20:55:53.000000000 +0100
+++ wq/kernel/workqueue.c	2010-02-24 20:58:37.000000000 +0100
@@ -220,12 +220,9 @@ struct cpu_workqueue_struct *wq_per_cpu(
 static inline void set_wq_data(struct work_struct *work,
 				struct cpu_workqueue_struct *cwq)
 {
-	unsigned long new;
-
-	BUG_ON(!work_pending(work));
-
-	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
+	unsigned long new = (unsigned long)cwq;
 	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
+	BUG_ON(!(new & (1UL << WORK_STRUCT_PENDING)));
 	atomic_long_set(&work->data, new);
 }
 

