Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZIQIvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZIQIvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIQIu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:50:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53341 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbZIQIu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:50:58 -0400
Message-ID: <4AB1F827.8040905@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 16:49:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf trace: Sample timestamp and cpu when using record flag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sample timestamp and cpu just like the -R option.

Before:
            init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=18 handler=eth0
            init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=18 handler=eth0
            init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=1 handler=i8042
            init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=18 handler=eth0
            init-0     [-01] 1266874889.17179869184709551615: irq_handler_entry: irq=1 handler=i8042

After:
            init-0     [001]  7364.568965353: irq_handler_entry: irq=18 handler=eth0
            init-0     [001]  7365.530226877: irq_handler_entry: irq=1 handler=i8042
            init-0     [001]  7365.542831563: irq_handler_entry: irq=18 handler=eth0
            init-0     [001]  7365.644156299: irq_handler_entry: irq=18 handler=eth0
            init-0     [001]  7365.694556201: irq_handler_entry: irq=18 handler=eth0

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c9ef944..2156269 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -425,8 +425,11 @@ parse_single_tracepoint_event(char *sys_name,
 	int fd;
 
 	if (flags) {
-		if (!strncmp(flags, "record", strlen(flags)))
+		if (!strncmp(flags, "record", strlen(flags))) {
 			attr->sample_type |= PERF_SAMPLE_RAW;
+			attr->sample_type |= PERF_SAMPLE_TIME;
+			attr->sample_type |= PERF_SAMPLE_CPU;
+		}
 	}
 
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
-- 
1.6.3

