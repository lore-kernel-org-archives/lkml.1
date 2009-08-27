Return-Path: <linux-kernel-owner+w=401wt.eu-S1751166AbZH0Kkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbZH0Kkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZH0Kkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:40:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZH0Kkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:40:42 -0400
Message-ID: <4A966288.8020402@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 18:40:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: [PATCH 1/3] drop_monitor: fix trace_napi_poll_hit()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: : ISVW-6.0.0.2339-3.52.0.1010-13974000
X-TM-AS-Result: : No
X-TM-AS-Category-Info: : 31:0.000000
X-TM-AS-MatchedID: : 1-150644-151251-110549-188019-186003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The net_dev of backlog napi is NULL, like below:

__get_cpu_var(softnet_data).backlog.dev == NULL

So, we should check it in napi tracepoint's probe function

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 net/core/drop_monitor.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9d66fa9..d311202 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -182,7 +182,8 @@ static void trace_napi_poll_hit(struct napi_struct *napi)
 	/*
 	 * Ratelimit our check time to dm_hw_check_delta jiffies
 	 */
-	if (!time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
+	if (!napi->dev ||
+	    !time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
 		return;
 
 	rcu_read_lock();
-- 
1.6.1.2

