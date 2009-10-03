Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZJCNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZJCNrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbZJCNrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:47:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:26741 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbZJCNra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Uz+xmYlC9zk4K4zzO2jLC94ACDXi0D4hmJJb/6HwEiDhzHCh0/8UBk4f06J9bwxtcn
         73TJEPdyC885qgxRQ5xbUrezd3oEQUhVJT8+FOyLjQdMtatga4jp/bhDRSK3Al9qJi7h
         H0oTBKx130ObAFXRLECylotU5Jle3hkbPhy34=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing: Check total refcount before releasing bufs in profile_enable failure
Date: Sat,  3 Oct 2009 15:47:29 +0200
Message-Id: <1254577650-5623-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we call the profile_enable() callback of an event, we release the
shared perf event tracing buffers unconditionnaly in the failure path.
This is wrong because there may be other users of these. Then check the
total refcount before doing this.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_event_profile.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index dd44b87..e52784b 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -31,7 +31,7 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 	if (atomic_inc_return(&event->profile_count))
 		return 0;
 
-	if (!total_profile_count++) {
+	if (!total_profile_count) {
 		buf = (char *)alloc_percpu(profile_buf_t);
 		if (!buf)
 			goto fail_buf;
@@ -46,14 +46,19 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 	}
 
 	ret = event->profile_enable();
-	if (!ret)
+	if (!ret) {
+		total_profile_count++;
 		return 0;
+	}
 
-	kfree(trace_profile_buf_nmi);
 fail_buf_nmi:
-	kfree(trace_profile_buf);
+	if (!total_profile_count) {
+		kfree(trace_profile_buf_nmi);
+		kfree(trace_profile_buf);
+		trace_profile_buf_nmi = NULL;
+		trace_profile_buf = NULL;
+	}
 fail_buf:
-	total_profile_count--;
 	atomic_dec(&event->profile_count);
 
 	return ret;
-- 
1.6.2.3

