Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYGVXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYGVXeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbYGVXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:53752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbYGVXXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:39 -0400
Date: Tue, 22 Jul 2008 16:17:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [patch 46/47] hrtimer: prevent migration for raising softirq
Message-ID: <20080722231743.GU8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-prevent-migration-for-raising-softirq.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Steven Rostedt <rostedt@goodmis.org>

commit ee3ece830f6db9837f7ac67008f532a8c1e755f4 upstream.

Due to a possible deadlock, the waking of the softirq was pushed outside
of the hrtimer base locks. See commit 0c96c5979a522c3323c30a078a70120e29b5bdbc

Unfortunately this allows the task to migrate after setting up the softirq
and raising it. Since softirqs run a queue that is per-cpu we may raise the
softirq on the wrong CPU and this will keep the queued softirq task from
running.

To solve this issue, this patch disables preemption around the releasing
of the hrtimer lock and raising of the softirq.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -896,10 +896,18 @@ hrtimer_start(struct hrtimer *timer, kti
 	 */
 	raise = timer->state == HRTIMER_STATE_PENDING;
 
+	/*
+	 * We use preempt_disable to prevent this task from migrating after
+	 * setting up the softirq and raising it. Otherwise, if me migrate
+	 * we will raise the softirq on the wrong CPU.
+	 */
+	preempt_disable();
+
 	unlock_hrtimer_base(timer, &flags);
 
 	if (raise)
 		hrtimer_raise_softirq();
+	preempt_enable();
 
 	return ret;
 }

-- 
