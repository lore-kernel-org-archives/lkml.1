Return-Path: <linux-kernel-owner+w=401wt.eu-S1763560AbYFEXcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560AbYFEXcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYFEXcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:32:23 -0400
Received: from homer.mvista.com ([63.81.120.158]:19498 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYFEXcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:32:22 -0400
Date: Thu, 5 Jun 2008 16:32:20 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nagar@watson.ibm.com, balbir@in.ibm.com,
       sekharan@us.ibm.com, kosaki.motohiro@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 2/3 v2] per-task-delay-accounting: update taskstats for
 memory reclaim delay
Message-Id: <20080605163220.8397bed6.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp>
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add members for memory reclaim delay to taskstats,
and accumulate them in __delayacct_add_tsk() .

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
---
 include/linux/taskstats.h |    4 ++++
 kernel/delayacct.c        |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 5d69c07..87aae21 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -81,6 +81,10 @@ struct taskstats {
 	__u64	swapin_count;
 	__u64	swapin_delay_total;
 
+	/* Delay waiting for memory reclaim */
+	__u64	freepages_count;
+	__u64	freepages_delay_total;
+
 	/* cpu "wall-clock" running time
 	 * On some architectures, value will adjust for cpu time stolen
 	 * from the kernel in involuntary waits due to virtualization.
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 84b6782..b3179da 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -145,8 +145,11 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
 	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
 	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
+	tmp = d->freepages_delay_total + tsk->delays->freepages_delay;
+	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
+	d->freepages_count += tsk->delays->freepages_count;
 	spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 done:
-- 
1.5.0.6

