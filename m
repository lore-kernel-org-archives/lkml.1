Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbYBGVNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbYBGVNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761415AbYBGUyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:46050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694AbYBGUyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:13 -0500
Date: Thu, 7 Feb 2008 12:48:14 -0800
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
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 40/45] sched: let +nice tasks have smaller impact
Message-ID: <20080207204814.GO16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="sched-let-nice-tasks-have-smaller-impact.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

patch ef9884e6f29bbe1075204f962a00f7533bf7e8f3 in mainline.

Michel Dänzr has bisected an interactivity problem with
plus-reniced tasks back to this commit:

 810e95ccd58d91369191aa4ecc9e6d4a10d8d0c8 is first bad commit
 commit 810e95ccd58d91369191aa4ecc9e6d4a10d8d0c8
 Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 Date:   Mon Oct 15 17:00:14 2007 +0200

 sched: another wakeup_granularity fix

      unit mis-match: wakeup_gran was used against a vruntime

fix this by assymetrically scaling the vtime of positive reniced
tasks.

Bisected-by: Michel Dänzer <michel@tungstengraphics.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -867,7 +867,11 @@ static void check_preempt_wakeup(struct 
 	}
 
 	gran = sysctl_sched_wakeup_granularity;
-	if (unlikely(se->load.weight != NICE_0_LOAD))
+	/*
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
+	 */
+	if (unlikely(se->load.weight > NICE_0_LOAD))
 		gran = calc_delta_fair(gran, &se->load);
 
 	if (pse->vruntime + gran < se->vruntime)

-- 
