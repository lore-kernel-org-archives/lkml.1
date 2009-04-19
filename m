Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZDSFC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZDSFC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 01:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZDSFBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 01:01:44 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58354 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZDSFBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 01:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ub1u+IzYF1JKdu7VPeFq71HzLz/ymrkaf9zglD+kNtspaev80QaBtZY5YNR0gYZ+5h
         293kWanuCJqnLZaLG8DzbCTNZQpASQa0+RqXmmYrLjumPFIq5PFxhWQp/AJc8lpSepDs
         003n2iUnp1w+CnvOvx3u5XlYCbj+ff7gB0P3A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2 v3] tracing/lock: provide lock_acquired event support for dynamic size string
Date: Sun, 19 Apr 2009 07:01:35 +0200
Message-Id: <1240117295-6873-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1240117295-6873-1-git-send-email-fweisbec@gmail.com>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can support the dynamic sized string, make the lock tracing
able to use it, making it safe against modules removal and consuming
the right amount of memory needed for each lock name

Changes in v2:
adapt to the __ending_string() updates and the opening_string() removal.

[ Impact: protect against module removal ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lockdep.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 45e326b..3ca315c 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -38,16 +38,16 @@ TRACE_EVENT(lock_acquired,
 	TP_ARGS(lock, ip, waittime),
 
 	TP_STRUCT__entry(
-		__field(const char *, name)
+		__string(name, lock->name)
 		__field(unsigned long, wait_usec)
 		__field(unsigned long, wait_nsec_rem)
 	),
 	TP_fast_assign(
-		__entry->name = lock->name;
+		__assign_str(name, lock->name);
 		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
 		__entry->wait_usec = (unsigned long) waittime;
 	),
-	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
+	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
 				       __entry->wait_nsec_rem)
 );
 
-- 
1.6.1

