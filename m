Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZIMDGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZIMDGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZIMDGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:06:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZIMDGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:06:14 -0400
Message-Id: <20090913030617.309043490@goodmis.org>
References: <20090913030543.204871396@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:05:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/4] tracing/profile: fix profile_disable vs module_unload
Content-Disposition: inline; filename=0003-tracing-profile-fix-profile_disable-vs-module_unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

If the correspoding module is unloaded before ftrace_profile_disable()
is called, event->profile_disable() won't be called, which can
cause oops:

  # insmod trace-events-sample.ko
  # perf record -f -a -e sample:foo_bar sleep 3 &
  # sleep 1
  # rmmod trace_events_sample
  # insmod trace-events-sample.ko
  OOPS!

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A9214E3.2070807@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_event_profile.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 11ba5bb..55a25c9 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -5,6 +5,7 @@
  *
  */
 
+#include <linux/module.h>
 #include "trace.h"
 
 int ftrace_profile_enable(int event_id)
@@ -14,7 +15,8 @@ int ftrace_profile_enable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->profile_enable) {
+		if (event->id == event_id && event->profile_enable &&
+		    try_module_get(event->mod)) {
 			ret = event->profile_enable(event);
 			break;
 		}
@@ -32,6 +34,7 @@ void ftrace_profile_disable(int event_id)
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id) {
 			event->profile_disable(event);
+			module_put(event->mod);
 			break;
 		}
 	}
-- 
1.6.3.3

-- 
