Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZEBJtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZEBJtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZEBJtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:49:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZEBJtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:49:15 -0400
Date: Sat, 2 May 2009 09:48:30 GMT
From: tip-bot for Magnus Damm <magnus.damm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
Subject: [tip:timers/clocksource] clocksource: setup mult_orig in clocksource_enable()
Message-ID: <tip-a25cbd045a2ffc42787d4dbcbb9c7118f5f42732@git.kernel.org>
Git-Commit-ID: a25cbd045a2ffc42787d4dbcbb9c7118f5f42732
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 02 May 2009 09:48:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a25cbd045a2ffc42787d4dbcbb9c7118f5f42732
Gitweb:     http://git.kernel.org/tip/a25cbd045a2ffc42787d4dbcbb9c7118f5f42732
Author:     Magnus Damm <magnus.damm@gmail.com>
AuthorDate: Fri, 1 May 2009 14:45:46 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 2 May 2009 11:45:15 +0200

clocksource: setup mult_orig in clocksource_enable()

Setup clocksource mult_orig in clocksource_enable().

Clocksource drivers can save power by using keeping the
device clock disabled while the clocksource is unused.

In practice this means that the enable() and disable()
callbacks perform clk_enable() and clk_disable().

The enable() callback may also use clk_get_rate() to get
the clock rate from the clock framework. This information
can then be used to calculate the shift and mult variables.

Currently the mult_orig variable is setup from mult at
registration time only. This is conflicting with the above
case since the clock is disabled and the mult variable is
not yet calculated at the time of registration.

Moving the mult_orig setup code to clocksource_enable()
allows us to both handle the common case with no enable()
callback and the mult-changed-after-enable() case.

[ Impact: allow dynamic clock source usage ]

Signed-off-by: Magnus Damm <damm@igel.co.jp>
LKML-Reference: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/linux/clocksource.h |   10 +++++++++-
 kernel/time/clocksource.c   |    3 ---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5a40d14..c56457c 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -288,7 +288,15 @@ static inline cycle_t clocksource_read(struct clocksource *cs)
  */
 static inline int clocksource_enable(struct clocksource *cs)
 {
-	return cs->enable ? cs->enable(cs) : 0;
+	int ret = 0;
+
+	if (cs->enable)
+		ret = cs->enable(cs);
+
+	/* save mult_orig on enable */
+	cs->mult_orig = cs->mult;
+
+	return ret;
 }
 
 /**
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ecfd7b5..80189f6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -402,9 +402,6 @@ int clocksource_register(struct clocksource *c)
 	unsigned long flags;
 	int ret;
 
-	/* save mult_orig on registration */
-	c->mult_orig = c->mult;
-
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
