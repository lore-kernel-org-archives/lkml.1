Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbZCCAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbZCCAL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbZCCALq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:11:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58346 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbZCCALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:11:44 -0500
Message-ID: <49AC75BA.3030006@us.ibm.com>
Date: Mon, 02 Mar 2009 16:11:38 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 2/7] futex: futex_top_waiter()
References: <49AC73A9.4040804@us.ibm.com>
In-Reply-To: <49AC73A9.4040804@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

Improve legibility by wrapping finding the top waiter in a function.  This
will be used by the follow-on patches for enabling requeue pi.

Changelog:
V4: -Simplified logic in the hb loop
    -Return the futex_q as the task can be had from there if needed
    -Updated comments and dropped the -safe iterator per review from tglx
V3: -Comment linewidth cleanup
V1: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/futex.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index 16459c2..d02962b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -277,6 +277,32 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
+/*
+ * futex_top_waiter - return the highest priority waiter on the futex specified
+ *                    by key
+ * @hb: the hash bucket the futex_q's reside in
+ * @key: the futex key (to distinguish it from other futex futex_q's)
+ *
+ * Must be called with the hb lock held.
+ *
+ */
+static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
+					union futex_key *key)
+{
+	struct plist_head *head;
+	struct futex_q *this;
+	struct futex_q *top_waiter = NULL;
+
+	head = &hb->chain;
+	plist_for_each_entry(this, head, list) {
+		if (match_futex(&this->key, key)) {
+			top_waiter = this;
+			break;
+		}
+	}
+	return top_waiter;
+}
+
 static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
 {
 	u32 curval;
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
