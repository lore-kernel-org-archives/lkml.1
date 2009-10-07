Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZJGSr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZJGSr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZJGSr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:47:58 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48031 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZJGSr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:47:57 -0400
Message-ID: <4ACCE21E.5030805@us.ibm.com>
Date: Wed, 07 Oct 2009 11:46:54 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Helge Bahmann <hcb@chaoticmind.net>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] futex: fix requeue_pi key imbalance
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex: fix requeue_pi key imbalance

From: Darren Hart <dvhltc@us.ibm.com>

If futex_wait_requeue_pi() wakes prior to requeue, we drop the reference to the
source futex_key twice, once in handle_early_requeue_pi_wakeup() and once on
our way out. Remove the drop from the handle_early_requeue_pi_wakeup() and keep
the get/drops together in futex_wait_requeue_pi().

Reported-by: Helge Bahmann <hcb@chaoticmind.net>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


Index: linux-2.6.git/kernel/futex.c
===================================================================
--- linux-2.6.git.orig/kernel/futex.c
+++ linux-2.6.git/kernel/futex.c
@@ -2117,7 +2117,6 @@ int handle_early_requeue_pi_wakeup(struc
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &q->list.plist);
-		drop_futex_key_refs(&q->key);
 
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
