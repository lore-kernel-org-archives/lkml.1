Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZGKAFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZGKAFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 20:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbZGKAFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 20:05:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8597 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbZGKAFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 20:05:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:user-agent:mime-version:content-type;
	b=X7XUNS7mvSZ7Xje/OpOBfuomnHopSsOjiG+Vi6sq4iH6nNCm5XDlIAh2g0PpOhZ01
	T4yTXfr245BOuTkujOMYA==
Date: Fri, 10 Jul 2009 17:05:16 -0700 (PDT)
From: Paul Turner <pjt@google.com>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Bug in SCHED_IDLE interaction with group scheduling?
Message-ID: <alpine.DEB.1.00.0907101649570.29914@kitami.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

It seems like there's an assumption in the sched_idle policy check in 
place_entity that the sched_entity we are looking at belongs to a task?

- Paul

--

sched: bug in SCHED_IDLE interaction with group scheduling

One of the isolation modifications for SCHED_IDLE is the unitization of sleeper
credit.  However the check for this assumes that the sched_entity we're placing
always belongs to a task.

This is potentially not true with group scheduling and leaves us rummaging
randomly when we try to pull the policy.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ba7fd6e..7c248dc 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -687,7 +687,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 			 * all of which have the same weight.
 			 */
 			if (sched_feat(NORMALIZED_SLEEPER) &&
-					task_of(se)->policy != SCHED_IDLE)
+					(!entity_is_task(se) ||
+					 task_of(se)->policy != SCHED_IDLE))
 				thresh = calc_delta_fair(thresh, se);
 
 			vruntime -= thresh;
-- 
1.5.4.3

