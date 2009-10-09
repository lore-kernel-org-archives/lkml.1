Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbZJIXVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbZJIXVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761671AbZJIXVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:21:10 -0400
Received: from kroah.org ([198.145.64.141]:36850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761633AbZJIXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.413018337@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 10/26] futex: Fix locking imbalance
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=futex-fix-locking-imbalance.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit eaaea8036d0261d87d7072c5bc88c7ea730c18ac upstream.

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
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -912,8 +912,8 @@ retry:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
-	double_lock_hb(hb1, hb2);
 retry_private:
+	double_lock_hb(hb1, hb2);
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
 


