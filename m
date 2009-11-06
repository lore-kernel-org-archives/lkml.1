Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbZKFWWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbZKFWWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbZKFWW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:29 -0500
Received: from kroah.org ([198.145.64.141]:56674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbZKFWW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221540.169575447@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [11/99] futex: Move drop_futex_key_refs out of spinlocked region
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=futex-move-drop_futex_key_refs-out-of-spinlock-ed-region.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darren Hart <dvhltc@us.ibm.com>

commit 89061d3d58e1f0742139605dc6a7950aa1ecc019 upstream.

When requeuing tasks from one futex to another, the reference held
by the requeued task to the original futex location needs to be
dropped eventually.

Dropping the reference may ultimately lead to a call to
"iput_final" and subsequently call into filesystem- specific code -
which may be non-atomic.

It is therefore safer to defer this drop operation until after the
futex_hash_bucket spinlock has been dropped.

Originally-From: Helge Bahmann <hcb@chaoticmind.net>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <4AD7A298.5040802@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1028,7 +1028,6 @@ static inline
 void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 			   struct futex_hash_bucket *hb)
 {
-	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
 	q->key = *key;
 
@@ -1226,6 +1225,7 @@ retry_private:
 		 */
 		if (ret == 1) {
 			WARN_ON(pi_state);
+			drop_count++;
 			task_count++;
 			ret = get_futex_value_locked(&curval2, uaddr2);
 			if (!ret)
@@ -1304,6 +1304,7 @@ retry_private:
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
+				drop_count++;
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */


