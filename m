Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYIAXRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYIAXRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYIAXPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:45026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYIAXPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:46 -0400
Date: Mon, 1 Sep 2008 16:07:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 4/13] hrtimer: convert net::sched_cbq to the new hrtimer
 apis
Message-ID: <20080901160713.1c9a85d5@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert net::sched_cbq to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts sched_cbq to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 net/sched/sch_cbq.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 9b720ad..0fa7270 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -545,9 +545,10 @@ static void cbq_ovl_delay(struct cbq_class *cl)
 			expires = ktime_set(0, 0);
 			expires = ktime_add_ns(expires, PSCHED_US2NS(sched));
 			if (hrtimer_try_to_cancel(&q->delay_timer) &&
-			    ktime_to_ns(ktime_sub(q->delay_timer.expires,
-						  expires)) > 0)
-				q->delay_timer.expires = expires;
+			    ktime_to_ns(ktime_sub(
+					hrtimer_get_expires(&q->delay_timer),
+					expires)) > 0)
+				hrtimer_set_expires(&q->delay_timer, expires);
 			hrtimer_restart(&q->delay_timer);
 			cl->delayed = 1;
 			cl->xstats.overactions++;
-- 
1.5.5.1

