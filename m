Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0BCJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:16:59 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57321 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab0BCJOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sHDyvsygyL9KJtjG8BxLoPj3kuenR31e8f9n/WayKv3srclmwEsx6G4uoJMaGI9wuI
         8UVzb/KWSdeOpntKqrPONzh+WvXrjuWB+4gUEOxzXPgzaJJFX3VGpYnNCrDMUudTV17s
         AAk0hK/CZ0eFZpPsWvSdg3A10+9PUWe0odA1k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/11] tracing: Add lock class id in lock_acquire event
Date: Wed,  3 Feb 2010 10:14:28 +0100
Message-Id: <1265188475-23509-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the lock class id to lock_acquire event. This will let us
remove the name copy from every lock events (except lock_class_init)
as we'll be able to retrieve the name of the lock class with
the class id.

The class id is represented by the lock name address, which is
the same in the corresponding lock class.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/trace/events/lock.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 6999f16..3c4a5c1 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -52,15 +52,18 @@ TRACE_EVENT(lock_acquire,
 		__field(unsigned int, flags)
 		__string(name, lock->name)
 		__field(void *, lockdep_addr)
+		__field(void *, class_id)
 	),
 
 	TP_fast_assign(
 		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
 		__assign_str(name, lock->name);
 		__entry->lockdep_addr = lock;
+		__entry->class_id = (void *)lock->name;
 	),
 
-	TP_printk("%p %s%s%s", __entry->lockdep_addr,
+	TP_printk("%p %p %s%s%s", __entry->lockdep_addr,
+		  __entry->class_id,
 		  (__entry->flags & 1) ? "try " : "",
 		  (__entry->flags & 2) ? "read " : "",
 		  __get_str(name))
-- 
1.6.2.3

