Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZHaGLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZHaGLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 02:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZHaGLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 02:11:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbZHaGLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 02:11:18 -0400
Message-ID: <4A9B6963.5090207@cn.fujitsu.com>
Date: Mon, 31 Aug 2009 14:10:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The net_dev of backlog napi is NULL, like below:

__get_cpu_var(softnet_data).backlog.dev == NULL

So, we should check it in napi tracepoint's probe function

Acked-by: Neil Horman <nhorman@tuxdriver.com>
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

