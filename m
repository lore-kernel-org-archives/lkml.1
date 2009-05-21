Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZEUD24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZEUD24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZEUD2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:28:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:32493 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbZEUD2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,225,1241420400"; 
   d="scan'208";a="517535276"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
Date: Thu, 21 May 2009 11:27:12 +0800
Subject: RE: [PATCH v3] zone_reclaim is always 0 by default
Thread-Topic: [PATCH v3] zone_reclaim is always 0 by default
Thread-Index: AcnZvnDPAczU+LdbRdakseMjYrEUdAABGj9g
Message-ID: <4D05DB80B95B23498C72C700BD6C2E0B2F35B8FA@pdsmsx502.ccr.corp.intel.com>
References: <20090521114408.63D0.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090521114408.63D0.A69D9226@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4L3TWlL017621

>>-----Original Message-----
>>From: KOSAKI Motohiro [mailto:kosaki.motohiro@jp.fujitsu.com]
>>Sent: 2009Äê5ÔÂ21ÈÕ 10:47
>>To: LKML; linux-mm; Andrew Morton; Rik van Riel; Christoph Lameter; Robin Holt;
>>Zhang, Yanmin; Wu, Fengguang
>>Cc: kosaki.motohiro@jp.fujitsu.com
>>Subject: [PATCH v3] zone_reclaim is always 0 by default
>>
>>
>>Subject: [PATCH v3] zone_reclaim is always 0 by default
>>
>>Current linux policy is, zone_reclaim_mode is enabled by default if the machine
>>has large remote node distance. it's because we could assume that large distance
>>mean large server until recently.
>>
>>Unfortunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P
>>transport
>>memory controller. IOW it's seen as NUMA from software view.
>>Some Core i7 machine has large remote node distance.
>>
>>Yanmin reported zone_reclaim_mode=1 cause large apache regression.
>>
>>    One Nehalem machine has 12GB memory,
>>    but there is always 2GB free although applications accesses lots of files.
>>    Eventually we located the root cause as zone_reclaim_mode=1.
>>
>>Actually, zone_reclaim_mode=1 mean "I dislike remote node allocation rather
>>than
>>disk access", it makes performance improvement to HPC workload.
>>but it makes performance degression desktop, file server and web server.
>>
>>In general, workload depended configration shouldn't put into default
>>settings.
>>Plus, desktop and file/web server eco-system is much larger than hpc's.
>>
>>Thus, zone_reclaim == 0 is better by default.
[YM] Thanks. I started a series of testing on 2 Nehalem machines by setting
zone_reclaim_mode=0 (The default is 1 on the 2 machines). I didn't find
regression with non-disk_I/O (mostly cpubound) benchmarks. disk I/O benchmarks 
could benefit a little from zone_reclaim_mode=0. As I start benchmark fio with 
numactl --interleave=all, so the fio improvement is not so bigger like before.

One thing I need mention is my testing with non-disk_I/O might be not good examples
for this patch, because every node has far more memory than the testing needs.
Only some disk I/O benchmarks have big requirement on page cache memory, so they could benefit from zone_reclaim_mode=0.


>>
>>
>>Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>Cc: Christoph Lameter <cl@linux-foundation.org>
>>Cc: Rik van Riel <riel@redhat.com>
>>Cc: Robin Holt <holt@sgi.com>
>>Tested-by: "Zhang, Yanmin" <yanmin.zhang@intel.com>
>>Acked-by: Wu Fengguang <fengguang.wu@intel.com>
>>---
>> arch/ia64/include/asm/topology.h |    5 -----
>> include/linux/topology.h         |    9 +--------
>> mm/page_alloc.c                  |    7 -------
>> 3 files changed, 1 insertion(+), 20 deletions(-)
>>
>>Index: b/mm/page_alloc.c
>>===================================================================
>>--- a/mm/page_alloc.c
>>+++ b/mm/page_alloc.c
>>@@ -2494,13 +2494,6 @@ static void build_zonelists(pg_data_t *p
>> 		int distance = node_distance(local_node, node);
>>
>> 		/*
>>-		 * If another node is sufficiently far away then it is better
>>-		 * to reclaim pages in a zone before going off node.
>>-		 */
>>-		if (distance > RECLAIM_DISTANCE)
>>-			zone_reclaim_mode = 1;
>>-
>>-		/*
>> 		 * We don't want to pressure a particular node.
>> 		 * So adding penalty to the first node in same
>> 		 * distance group to make it round-robin.
>>Index: b/arch/ia64/include/asm/topology.h
>>===================================================================
>>--- a/arch/ia64/include/asm/topology.h
>>+++ b/arch/ia64/include/asm/topology.h
>>@@ -21,11 +21,6 @@
>> #define PENALTY_FOR_NODE_WITH_CPUS 255
>>
>> /*
>>- * Distance above which we begin to use zone reclaim
>>- */
>>-#define RECLAIM_DISTANCE 15
>>-
>>-/*
>>  * Returns the number of the node containing CPU 'cpu'
>>  */
>> #define cpu_to_node(cpu) (int)(cpu_to_node_map[cpu])
>>Index: b/include/linux/topology.h
>>===================================================================
>>--- a/include/linux/topology.h
>>+++ b/include/linux/topology.h
>>@@ -53,14 +53,7 @@ int arch_update_cpu_topology(void);
>> #ifndef node_distance
>> #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE :
>>REMOTE_DISTANCE)
>> #endif
>>-#ifndef RECLAIM_DISTANCE
>>-/*
>>- * If the distance between nodes in a system is larger than RECLAIM_DISTANCE
>>- * (in whatever arch specific measurement units returned by node_distance())
>>- * then switch on zone reclaim on boot.
>>- */
>>-#define RECLAIM_DISTANCE 20
>>-#endif
>>+
>> #ifndef PENALTY_FOR_NODE_WITH_CPUS
>> #define PENALTY_FOR_NODE_WITH_CPUS	(1)
>> #endif
>>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
