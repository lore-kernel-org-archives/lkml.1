Return-Path: <linux-kernel-owner+w=401wt.eu-S936974AbZDCUkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936974AbZDCUkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936890AbZDCUjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:39:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58603 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936889AbZDCUju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:39:50 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 2/9] RFC: futex: futex_top_waiter()
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Fri, 03 Apr 2009 13:39:42 -0700
Message-ID: <20090403203942.9772.25875.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve legibility by wrapping finding the top waiter in a function.  This
will be used by the follow-on patches for enabling requeue pi.

Changelog:
V7: -Minor kernel doc comment update
V6: -Shortened function length after review from tglx
    -Corrected kernel-doc formatting
V4: -Simplified logic in the hb loop
    -Return the futex_q as the task can be had from there if needed
    -Updated comments and dropped the -safe iterator per review from tglx
V3: -Comment linewidth cleanup
V1: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Reviewed-by: Steven Rostedt <srostedt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
---

 kernel/futex.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index d1d3e67..a13369d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -276,6 +276,25 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
+/**
+ * futex_top_waiter() - Return the highest priority waiter on a futex
+ * @hb:     the hash bucket the futex_q's reside in
+ * @key:    the futex key (to distinguish it from other futex futex_q's)
+ *
+ * Must be called with the hb lock held.
+ */
+static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
+					union futex_key *key)
+{
+	struct futex_q *this;
+
+	plist_for_each_entry(this, &hb->chain, list) {
+		if (match_futex(&this->key, key))
+			return this;
+	}
+	return NULL;
+}
+
 static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
 {
 	u32 curval;

