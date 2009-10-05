Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZJETNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZJETNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZJETNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:13:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:42875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZJETNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:13:02 -0400
Date: Mon, 5 Oct 2009 19:11:41 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rercola@acm.jhu.edu,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, stable@kernel.org,
       rercola@acm.jhu.edu, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Fix locking imbalance
Message-ID: <tip-eaaea8036d0261d87d7072c5bc88c7ea730c18ac@git.kernel.org>
Git-Commit-ID: eaaea8036d0261d87d7072c5bc88c7ea730c18ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 19:11:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eaaea8036d0261d87d7072c5bc88c7ea730c18ac
Gitweb:     http://git.kernel.org/tip/eaaea8036d0261d87d7072c5bc88c7ea730c18ac
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 4 Oct 2009 09:34:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 21:08:14 +0200

futex: Fix locking imbalance

Rich reported a lock imbalance in the futex code:

   http://bugzilla.kernel.org/show_bug.cgi?id=14288

It's caused by the displacement of the retry_private label in
futex_wake_op(). The code unlocks the hash bucket locks in the
error handling path and retries without locking them again which
makes the next unlock fail.

Move retry_private so we lock the hash bucket locks when we retry.

Reported-by: Rich Ercolany <rercola@acm.jhu.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: stable-2.6.31 <stable@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 463af2e..1e176f3 100644
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
 
