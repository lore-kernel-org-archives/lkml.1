Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbYKMLF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbYKMLF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYKMLFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:05:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38869 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYKMLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:05:46 -0500
Message-ID: <491C0A01.5040106@jp.fujitsu.com>
Date: Thu, 13 Nov 2008 20:05:37 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>
Subject: [PATCH] accelerate newidle balancing in relax_domain
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increasing the value of 'sched_relax_domain_level' in cpuset expands
the searching range of task balancing on some schedule events.
As the result it makes the task balancing in the range more aggressive,
so it will benefit some situation, such as where the latency is required
even it sacrifices cache hit rate etc. (for such situation, it would be
ideally best that cpus do not be idle until there are no runnable task.)

This patch aimed to accelerate the balancing in the relax_domain.

The newidle balancing is kicked when tasks in a runqueue run out.
It finds and pulls runnable tasks from other busy cpus, checking load
imbalance between cpus.  Considering above situation, using loads in
short term is preferred than that in long term because it makes balancing
more aggressive otherwise it becomes relatively conservative.
The referenced load is selected by the newidle_idx parameter of scheduler
domains, so this patch tunes the parameters only when domains are in the
relax_domain's range.  There are no effects if you don't use relax_domain.

Following is a result of my short-lightweight-transaction test, showing
average of requester's latency (ms), 300 couple of threads running 30 sec
on 8cpu/Itanium:

  1) v2.6.28-rc4
     Average 0.748783 Std Div 1.688022 Throughput 165313
  2) v2.6.28-rc4 + relax_domain
     Average 0.536867 Std Div 1.115383 Throughput 168492
  3) v2.6.28-rc4 + relax_domain + patch
     Average 0.385164 Std Div 0.801875 Throughput 170069

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 57c933f..c970239 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7366,6 +7366,8 @@ static void set_domain_attribute(struct sched_domain *sd,
 	} else {
 		/* turn on idle balance on this domain */
 		sd->flags |= (SD_WAKE_IDLE_FAR|SD_BALANCE_NEWIDLE);
+		/* make newidle balancing more aggressive */
+		sd->newidle_idx = 0;
 	}
 }
 
-- 
1.6.0.GIT

