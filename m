Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYIFFJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYIFFJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYIFFJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:09:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYIFFJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:09:08 -0400
Message-Id: <20080906050906.111265558@goodmis.org>
References: <20080906050602.409299112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 01:06:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: fix unlocking of hash
Content-Disposition: inline; filename=ftrace-ppc-dynamic-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This must be brown paper bag week for Steven Rostedt!

While working on ftrace for PPC, I discovered that the hash locking done
when CONFIG_FTRACE_MCOUNT_RECORD is not set, is totally incorrect.

With a cut and paste error, I had the hash lock macro to lock for both
hash_lock _and_ hash_unlock!

This bug did not affect x86 since this bug was introduced when
CONFIG_FTRACE_MCOUNT_RECORD was added to x86.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-09-05 21:53:46.000000000 -0700
+++ linux-tip.git/kernel/trace/ftrace.c	2008-09-05 21:57:57.000000000 -0700
@@ -170,7 +170,8 @@ static int __unregister_ftrace_function(
  */
 static DEFINE_SPINLOCK(ftrace_hash_lock);
 #define ftrace_hash_lock(flags)	  spin_lock_irqsave(&ftrace_hash_lock, flags)
-#define ftrace_hash_unlock(flags) spin_lock_irqsave(&ftrace_hash_lock, flags)
+#define ftrace_hash_unlock(flags) \
+			spin_unlock_irqrestore(&ftrace_hash_lock, flags)
 #else
 /* This is protected via the ftrace_lock with MCOUNT_RECORD. */
 #define ftrace_hash_lock(flags)   do { (void)(flags); } while (0)

-- 
