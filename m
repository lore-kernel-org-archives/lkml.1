Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZHXEVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZHXEVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZHXEVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:21:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58410 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZHXEVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:21:08 -0400
Message-ID: <4A9214E3.2070807@cn.fujitsu.com>
Date: Mon, 24 Aug 2009 12:19:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

resend, CC LKML..

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
1.6.3
