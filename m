Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbZLJEQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbZLJEQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 23:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbZLJEQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 23:16:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52450 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbZLJEQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 23:16:16 -0500
Message-ID: <4B2075B0.10805@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 12:14:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_event: fix perf_swevent_hrtimer()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
 [<c0477471>] ? printk+0x1d/0x24
 [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
 [<c0149231>] warn_slowpath_common+0x71/0xd0
 [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
 [<c01492aa>] warn_slowpath_null+0x1a/0x20
 [<c01c98f9>] perf_prepare_sample+0x269/0x280
 [<c016e9f3>] ? cpu_clock+0x53/0x90
 [<c01cc368>] __perf_event_overflow+0x2a8/0x300
 [<c01ccc3b>] perf_event_overflow+0x1b/0x30
 [<c01ccccf>] perf_swevent_hrtimer+0x7f/0x120

This is because 'data' variable not initialize.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0bd0f67..41c2dde 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4009,7 +4009,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	event	= container_of(hrtimer, struct perf_event, hw.hrtimer);
 	event->pmu->read(event);
 
-	data.addr = 0;
+	memset(&data, 0, sizeof(data));
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
-- 
1.6.1.2

