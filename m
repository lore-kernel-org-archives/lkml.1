Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZBIS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZBIS6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZBIS6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:58:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZBIS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:58:22 -0500
Subject: [PATCH -v2] futex: fix reference leak
From: Peter Zijlstra <peterz@infradead.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1234205595.4286.223.camel@localhost.localdomain>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
	 <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
	 <1234192363.5951.129.camel@laptop>  <1234197950.5951.132.camel@laptop>
	 <1234198023.5951.133.camel@laptop>
	 <1234200538.16083.52.camel@pc1117.cambridge.arm.com>
	 <1234203975.5951.143.camel@laptop>
	 <1234205595.4286.223.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 19:57:54 +0100
Message-Id: <1234205874.5951.151.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 10:53 -0800, Pallipadi, Venkatesh wrote:
> Yes. This patch fixes the problem on my system. With git, without the
> patch I see the same oops as before on reboot. With the patch, system
> reboots cleanly.
> 
> A minor typo in the patch
> + ret = -RESTART_RESTARTBLOCK;
> should be
> + ret = -ERESTART_RESTARTBLOCK;

Gah, so much for my copy-paste skillz ;-)

Thanks!

---
Catalin noticed that (38d47c1b7075: futex: rely on
get_user_pages() for shared futexes) caused an mm_struct leak.

Some tracing with the function graph tracer quickly pointed out that
futex_wait() has exit paths with unbalanced reference counts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
---
 kernel/futex.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f89d373..ff06c76 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1284,18 +1284,23 @@ retry:
 	 */
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
-	if (!unqueue_me(&q))
-		return 0;
-	if (rem)
-		return -ETIMEDOUT;
+	if (!unqueue_me(&q)) {
+		ret = 0;
+		goto out_put_key;
+	}
+	if (rem) {
+		ret = -ETIMEDOUT;
+		goto out_put_key;
+	}
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	if (!abs_time)
-		return -ERESTARTSYS;
-	else {
+	if (!abs_time) {
+		ret = -ERESTARTSYS;
+		goto out_put_key;
+	} else {
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
@@ -1309,11 +1314,13 @@ retry:
 			restart->futex.flags |= FLAGS_SHARED;
 		if (clockrt)
 			restart->futex.flags |= FLAGS_CLOCKRT;
-		return -ERESTART_RESTARTBLOCK;
+		ret = -ERESTART_RESTARTBLOCK;
+		goto out_put_key;
 	}
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
+out_put_key:
 	put_futex_key(fshared, &q.key);
 
 out:


