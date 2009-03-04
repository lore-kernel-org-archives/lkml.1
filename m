Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZCDNRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZCDNRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZCDNRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:17:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:38681 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZCDNRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:17:35 -0500
Subject: [PATCH] lockdep: fix incorrect state name
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 14:17:26 +0100
Message-Id: <1236172646.5330.7450.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: fix incorrect state name
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Mar 04 13:51:13 CET 2009

In the recent mark_lock_irq() rework a bug snuck in that would report the
state of write locks causing irq inversion under a read lock as a read
lock.

Fix this by masking the read bit of the state when validating write
dependencies.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2016,7 +2016,8 @@ typedef int (*check_usage_f)(struct task
 			     enum lock_usage_bit bit, const char *name);
 
 static int
-mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
+mark_lock_irq(struct task_struct *curr, struct held_lock *this,
+		enum lock_usage_bit new_bit)
 {
 	int excl_bit = exclusive_bit(new_bit);
 	int read = new_bit & 1;
@@ -2044,7 +2045,7 @@ mark_lock_irq(struct task_struct *curr, 
 	 * states.
 	 */
 	if ((!read || !dir || STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit, state_name(new_bit)))
+			!usage(curr, this, excl_bit, state_name(new_bit & ~1)))
 		return 0;
 
 	/*


