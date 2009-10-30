Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZJ3IUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZJ3IUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZJ3IUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:20:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49662 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZJ3IUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:20:38 -0400
Date: Fri, 30 Oct 2009 19:20:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: manual merge of the percpu tree with the kgdb tree
Message-Id: <20091030192038.381eba2d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
kernel/softlockup.c between commit
b460e1994445b5ebb97aaec0c29f893c246bd830 ("softlockup: add
sched_clock_tick() to avoid kernel warning on kgdb resume") from the kgdb
tree and commit 1871e52c76dd95895caeb772f845a1718dcbcd75 ("percpu: make
percpu symbols under kernel/ and mm/ unique") from the percpu tree.

Just context changes.  I fixed it up (see below) and can carry the
changes as necessary.

I do wonder if the local variable name changes in the percpu tree change
were a good idea?

I also needed a further merge fixup (see further below).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/softlockup.c
index a85ace2,d225790..0000000
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@@ -125,15 -117,7 +125,15 @@@ void softlockup_tick(void
  		return;
  	}
  
- 	if (touch_timestamp == 0) {
+ 	if (touch_ts == 0) {
 +		if (unlikely(softlock_touch_sync[this_cpu])) {
 +			/*
 +			 * If the time stamp was touched atomically
 +			 * make sure the scheduler tick is up to date.
 +			 */
 +			softlock_touch_sync[this_cpu] = 0;
 +			sched_clock_tick();
 +		}
  		__touch_softlockup_watchdog();
  		return;
  	}

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Oct 2009 18:58:07 +1100
Subject: [PATCH] percpu: merge fixup for variable renaming

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/softlockup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 560a01d..57f1295 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -84,7 +84,7 @@ static int softlock_touch_sync[NR_CPUS];
 void touch_softlockup_watchdog_sync(void)
 {
 	softlock_touch_sync[raw_smp_processor_id()] = 1;
-	__raw_get_cpu_var(touch_timestamp) = 0;
+	__raw_get_cpu_var(softlockup_touch_ts) = 0;
 }
 
 void touch_all_softlockup_watchdogs(void)
-- 
1.6.5.2

