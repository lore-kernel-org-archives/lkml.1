Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZHGKws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZHGKws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZHGKws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:52:48 -0400
Received: from [222.73.24.84] ([222.73.24.84]:55385 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbZHGKwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:52:47 -0400
Message-ID: <4A7C0834.20303@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 18:55:48 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] ftrace: Unify effect of writing to trace_options and
 option/*
References: <4A7A4D7B.7010706@cn.fujitsu.com> <4A7A4DBC.6020403@cn.fujitsu.com> <4A7A6470.60305@cn.fujitsu.com>
In-Reply-To: <4A7A6470.60305@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"echo noglobal-clock > trace_options" can be used to change trace
clock but "echo 0 > options/global-clock" can't.

We can fix it by using set_tracer_flags() in trace_options_core_write().

Changelog:
v1->v2: Simplied switch() by Li Zefan <lizf@cn.fujitsu.com>'s suggest.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6c5f67f..06a2dfa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3718,17 +3718,9 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
-	switch (val) {
-	case 0:
-		trace_flags &= ~(1 << index);
-		break;
-	case 1:
-		trace_flags |= 1 << index;
-		break;
-
-	default:
+	if (val != 0 && val != 1)
 		return -EINVAL;
-	}
+	set_tracer_flags(1 << index, val);
 
 	*ppos += cnt;
 
-- 
1.5.5.3


