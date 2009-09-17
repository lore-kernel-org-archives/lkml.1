Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZIQWgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZIQWgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZIQWgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:36:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:46197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZIQWgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:36:14 -0400
Date: Thu, 17 Sep 2009 22:35:54 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB1F827.8040905@cn.fujitsu.com>
References: <4AB1F827.8040905@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf trace: Sample timestamp and cpu when using record flag
Message-ID: <tip-1281a49b7aa865a1f0d60e2b28410e6234fc686b@git.kernel.org>
Git-Commit-ID: 1281a49b7aa865a1f0d60e2b28410e6234fc686b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 22:35:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1281a49b7aa865a1f0d60e2b28410e6234fc686b
Gitweb:     http://git.kernel.org/tip/1281a49b7aa865a1f0d60e2b28410e6234fc686b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 17 Sep 2009 16:49:43 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 00:30:25 +0200

perf trace: Sample timestamp and cpu when using record flag

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
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4AB1F827.8040905@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 910283c..a9bdcab 100644
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
