Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYHHRLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYHHRLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYHHRK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:10:57 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:57540 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYHHRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:10:56 -0400
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>
	 <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	 <1206382547.6437.131.camel@lappy>
	 <20080324115738.85c72bb5.akpm@linux-foundation.org>
	 <1218202249.8625.106.camel@twins>
	 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 19:10:54 +0200
Message-Id: <1218215454.8625.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 09:41 -0700, Linus Torvalds wrote:
> 
> On Fri, 8 Aug 2008, Peter Zijlstra wrote:
> > 
> > Something along the lines of the below patch?
> 
> Could we not literally just make this a RCU event? Unconditionally too?

Sure, but the RCU callback period is at least 3 jiffies and much longer
when busy - I'm not sure how long before we force a grace period, we do
that to avoid DoS, right Paul?

So this version would have a much higher risk of overflowing the console
buffer and making klogd miss bits. Then again, I really don't care about
klogd at _all_, I've been running with the wakeup patched out for ages.


Gah, the below doesn't boot - because I guess we start using rcu before
its properly set up.. should I poke at it more?

---
diff --git a/kernel/printk.c b/kernel/printk.c
index b51b156..3d80e30 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 
@@ -982,10 +983,38 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-void wake_up_klogd(void)
+void __wake_up_klogd(struct rcu_head *head);
+
+static struct {
+	struct rcu_head head;
+	spinlock_t	lock;
+	int		pending;
+} klogd_wakeup_state = {
+	.lock = __SPIN_LOCK_UNLOCKED(klogd_wakeup_state.lock),
+};
+
+void __wake_up_klogd(struct rcu_head *head)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&klogd_wakeup_state.lock, flags);
+	BUG_ON(!klogd_wakeup_state.pending);
 	if (!oops_in_progress && waitqueue_active(&log_wait))
 		wake_up_interruptible(&log_wait);
+	klogd_wakeup_state.pending = 0;
+	spin_unlock_irqrestore(&klogd_wakeup_state.lock, flags);
+}
+
+void wake_up_klogd(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&klogd_wakeup_state.lock, flags);
+	if (!klogd_wakeup_state.pending) {
+		call_rcu(&klogd_wakeup_state.head, __wake_up_klogd);
+		klogd_wakeup_state.pending = 1;
+	}
+	spin_unlock_irqrestore(&klogd_wakeup_state.lock, flags);
 }
 
 /**


