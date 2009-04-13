Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZDMCil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZDMCil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZDMCic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:38:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50375 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZDMCib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:38:31 -0400
Message-ID: <49E2A5D5.6070203@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 10:39:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/filters: don't remove old filters when failed
 to write subsys->filter
References: <49E2A594.4060306@cn.fujitsu.com>
In-Reply-To: <49E2A594.4060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If writing subsys->filter returns EINVAL or ENOSPC, the original
filters in subsys/ and subsys/events/ will be removed. This is
definitely wrong.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

This bug is not revealed in mainline, since subsys/filter is disabled,
and it's re-enabled in -tip by a002587bf18c3b316bcf48542fccbc4ae2fc972e:

"tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT event"

---
 kernel/trace/trace_events.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 789e14e..4511cdb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -591,7 +591,6 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	err = filter_add_subsystem_pred(system, pred);
 	if (err < 0) {
-		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
 		return err;
 	}
-- 
1.5.4.rc3

