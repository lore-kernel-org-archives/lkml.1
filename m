Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbZJIXR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbZJIXR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761632AbZJIXR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:27 -0400
Received: from kroah.org ([198.145.64.141]:36848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761601AbZJIXR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231000.985919710@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Hart <dvhltc@us.ibm.com>, Helge Bahmann <hcb@chaoticmind.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 07/26] futex: fix requeue_pi key imbalance
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=futex-fix-requeue_pi-key-imbalance.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darren Hart <dvhltc@us.ibm.com>

commit da085681014fb43d67d9bf6d14bc068e9254bd49 upstream.

If futex_wait_requeue_pi() wakes prior to requeue, we drop the
reference to the source futex_key twice, once in
handle_early_requeue_pi_wakeup() and once on our way out.

Remove the drop from the handle_early_requeue_pi_wakeup() and keep
the get/drops together in futex_wait_requeue_pi().

Reported-by: Helge Bahmann <hcb@chaoticmind.net>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Helge Bahmann <hcb@chaoticmind.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <4ACCE21E.5030805@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2087,7 +2087,6 @@ int handle_early_requeue_pi_wakeup(struc
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &q->list.plist);
-		drop_futex_key_refs(&q->key);
 
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;


