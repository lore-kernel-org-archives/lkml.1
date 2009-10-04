Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZJDH4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZJDH4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 03:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZJDH4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 03:56:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:34458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZJDH4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 03:56:01 -0400
Date: Sun, 4 Oct 2009 07:54:41 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: dvhltc@us.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, stable@kernel.org,
       rercola@acm.jhu.edu, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dvhltc@us.ibm.com, a.p.zijlstra@chello.nl, rercola@acm.jhu.edu,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Fix locking imbalance
Message-ID: <tip-9694d494b7f462bffb86654fabe9e1ec2b2b0c47@git.kernel.org>
Git-Commit-ID: 9694d494b7f462bffb86654fabe9e1ec2b2b0c47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 04 Oct 2009 07:54:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9694d494b7f462bffb86654fabe9e1ec2b2b0c47
Gitweb:     http://git.kernel.org/tip/9694d494b7f462bffb86654fabe9e1ec2b2b0c47
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 4 Oct 2009 09:34:17 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 4 Oct 2009 09:46:56 +0200

futex: Fix locking imbalance

Rich reported a lock imbalance in the futex code.
(http://bugzilla.kernel.org/show_bug.cgi?id=14288)

It's caused by the displacement of the retry_private label in
futex_wake_op(). The code unlocks the hash bucket locks in the error
handling path and retries without locking them again which makes the
next unlock fail.

Move retry_private so we lock the hash bucket locks when we retry.

Reported-by: Rich Ercolany <rercola@acm.jhu.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: stable-2.6.31 <stable@kernel.org>


---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b911adc..a2f7538 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -916,8 +916,8 @@ retry:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
-	double_lock_hb(hb1, hb2);
 retry_private:
+	double_lock_hb(hb1, hb2);
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
 
