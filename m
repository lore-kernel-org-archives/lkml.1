Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZIWIOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZIWIOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZIWIO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:14:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZIWIO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:14:28 -0400
Message-ID: <4AB9D8B1.4020000@cn.fujitsu.com>
Date: Wed, 23 Sep 2009 16:13:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf_counter: optimize for perf_event_init_task()
References: <4AB88F06.10900@cn.fujitsu.com>	<19128.39768.149110.673711@cargo.ozlabs.ibm.com>	<4AB98BB0.6020202@cn.fujitsu.com> <19129.38627.94363.857137@cargo.ozlabs.ibm.com> <4AB9D7FA.5040707@cn.fujitsu.com>
In-Reply-To: <4AB9D7FA.5040707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can traverse ctx->group_list to get all group leader, it should be safe
since we hold ctx->mutex

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9ca975a..4e6e822 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4786,9 +4786,8 @@ int perf_event_init_task(struct task_struct *child)
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
-	list_for_each_entry_rcu(event, &parent_ctx->event_list, event_entry) {
-		if (event != event->group_leader)
-			continue;
+	list_for_each_entry(event, &parent_ctx->group_list, group_entry) {
+		WARN_ON_ONCE(event != event->group_leader);
 
 		if (!event->attr.inherit) {
 			inherited_all = 0;
-- 
1.6.1.2


