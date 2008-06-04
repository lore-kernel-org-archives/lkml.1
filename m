Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYFDDU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYFDDU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFDDUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:20:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35300 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYFDDUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:20:50 -0400
Date: Tue, 3 Jun 2008 20:20:50 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/4] per-task-delay-accounting: update taskstats for memory
 reclaim delay
Message-Id: <20080603202050.1191de61.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080604115828.9405.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
	<20080603194216.fdf42dd4.kobayashi.kk@ncos.nec.co.jp>
	<20080604115828.9405.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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
On Wed, 04 Jun 2008 11:59:04 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> > ---
> 
> Please write patch desctiption :)

Thank you for your comment.
Here is update version.

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
