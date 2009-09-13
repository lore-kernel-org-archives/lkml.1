Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZIMPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZIMPDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZIMPDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:03:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:32858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbZIMPDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:03:09 -0400
Date: Sun, 13 Sep 2009 15:02:48 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A9214E3.2070807@cn.fujitsu.com>
References: <4A9214E3.2070807@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/profile: fix profile_disable vs module_unload
Message-ID: <tip-558e6547e4b8a2b13608a24a9d3679802f91c4c7@git.kernel.org>
Git-Commit-ID: 558e6547e4b8a2b13608a24a9d3679802f91c4c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 13 Sep 2009 15:02:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  558e6547e4b8a2b13608a24a9d3679802f91c4c7
Gitweb:     http://git.kernel.org/tip/558e6547e4b8a2b13608a24a9d3679802f91c4c7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 Aug 2009 12:19:47 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 12 Sep 2009 22:28:38 -0400

tracing/profile: fix profile_disable vs module_unload

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
