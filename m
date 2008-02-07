Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbYBGVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbYBGVNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYBGUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:46077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbYBGUyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:24 -0500
Date: Thu, 7 Feb 2008 12:48:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 41/45] sched: fix high wake up latencies with
	FAIR_USER_SCHED
Message-ID: <20080207204817.GP16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-high-wake-up-latencies-with-fair_user_sched.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

patch 296825cbe14d4c95ee9c41ca5824f7487bfb4d9d in mainline.

The reason why we are getting better wakeup latencies for
!FAIR_USER_SCHED is because of this snippet of code in place_entity():

	if (!initial) {
		/* sleeps upto a single latency don't count. */
		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
						     ^^^^^^^^^^^^^^^^^^
			vruntime -= sysctl_sched_latency;

		/* ensure we never gain time by being placed backwards. */
		vruntime = max_vruntime(se->vruntime, vruntime);
	}

NEW_FAIR_SLEEPERS feature gives credit for sleeping only to tasks and
not group-level entities. With the patch attached, I could see that
wakeup latencies with FAIR_USER_SCHED are restored to the same level as
!FAIR_USER_SCHED.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -511,7 +511,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
+		if (sched_feat(NEW_FAIR_SLEEPERS))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */

-- 
