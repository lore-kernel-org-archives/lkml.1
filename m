Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZDMWgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZDMWgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDMWgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:36:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:29547 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZDMWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GuPD+XmX1jLX8KX0lhbrk0F8oq9FixKmfdhIKXmNu7o/PlNCGS61wUA/NRGmJR/2z3
         LaIPIczYYwVAWeFHIn+4/SyGwUqKabkCys6joKsnVYO2+1QOIXRoiGEbhlyZa3kjcH16
         /Qxt45JjSiYIFvXKNRo9yPNZiLN2h9QlvuJU4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] tracing/lockdep: turn lock->name into an array
Date: Tue, 14 Apr 2009 00:36:06 +0200
Message-Id: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow filtering by lock name / fix module tracing

Currently, the "lock acquired" event is traced using a TRACE_EVENT.
But we can't use the char * type for the name without risking to
dereference a freed pointer. A lock name can come from a module
towards lockdep and it is risky to only store its address because we
defer its name printing.

That's why this patch uses a fixed array size and copy the name.
Also it lets us filter the lock name because the event filtering
doesn't handle the char pointers. Such support is not needed yet since
the events don't use it for now because it is rarely easy to keep track
of a string while we defer its output.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/lockdep_event_types.h |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
index 863f1e4..68f84f4 100644
--- a/include/trace/lockdep_event_types.h
+++ b/include/trace/lockdep_event_types.h
@@ -32,18 +32,27 @@ TRACE_FORMAT(lock_contended,
 	TP_FMT("%s", lock->name)
 	);
 
+#define LOCK_NAME_SIZE	25
+
+/*
+ * We might loose the name if it comes from a module
+ * so we keep a fixed array size of 25, enough for most
+ * usecases.
+ */
+
 TRACE_EVENT(lock_acquired,
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
 
 	TP_ARGS(lock, ip, waittime),
 
 	TP_STRUCT__entry(
-		__field(const char *, name)
+		__array(char, name, LOCK_NAME_SIZE)
 		__field(unsigned long, wait_usec)
 		__field(unsigned long, wait_nsec_rem)
 	),
 	TP_fast_assign(
-		__entry->name = lock->name;
+		strncpy(__entry->name, lock->name, LOCK_NAME_SIZE - 1);
+		__entry->name[LOCK_NAME_SIZE - 1] = 0;
 		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
 		__entry->wait_usec = (unsigned long) waittime;
 	),
-- 
1.6.1

