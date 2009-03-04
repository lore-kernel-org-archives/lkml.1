Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZCDRko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZCDRko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZCDRkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:40:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:35629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbZCDRkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:40:31 -0500
Date: Wed, 4 Mar 2009 17:39:25 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236172646.5330.7450.camel@laptop>
References: <1236172646.5330.7450.camel@laptop>
Subject: [tip:core/locking] lockdep: fix incorrect state name
Message-ID: <tip-1c21f14ec48a2256fb03682b24dddd23eacdc96f@git.kernel.org>
Git-Commit-ID: 1c21f14ec48a2256fb03682b24dddd23eacdc96f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 17:39:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c21f14ec48a2256fb03682b24dddd23eacdc96f
Gitweb:     http://git.kernel.org/tip/1c21f14ec48a2256fb03682b24dddd23eacdc96f
Author:     "Peter Zijlstra" <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 4 Mar 2009 13:51:13 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 18:38:33 +0100

lockdep: fix incorrect state name

In the recent mark_lock_irq() rework a bug snuck in that would report the
state of write locks causing irq inversion under a read lock as a read
lock.

Fix this by masking the read bit of the state when validating write
dependencies.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1236172646.5330.7450.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 022d2ed..ef6584f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2015,7 +2015,8 @@ typedef int (*check_usage_f)(struct task_struct *, struct held_lock *,
 			     enum lock_usage_bit bit, const char *name);
 
 static int
-mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
+mark_lock_irq(struct task_struct *curr, struct held_lock *this,
+		enum lock_usage_bit new_bit)
 {
 	int excl_bit = exclusive_bit(new_bit);
 	int read = new_bit & 1;
@@ -2043,7 +2044,7 @@ mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
 	 * states.
 	 */
 	if ((!read || !dir || STRICT_READ_CHECKS) &&
-			!usage(curr, this, excl_bit, state_name(new_bit)))
+			!usage(curr, this, excl_bit, state_name(new_bit & ~1)))
 		return 0;
 
 	/*
