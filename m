Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZDPUB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZDPUB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbZDPUA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:00:56 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34990 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900AbZDPUAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=beJjRbWgsB3Vw708+gFib5g8pZxagxUbl080lQ/tYlRKMixDa6DCWWnBiuC2NrVcdL
         I/RP2952PcI3K57a5SqIDHXpAsVxS2lkBh5H0EtHcJ3aWrwsR9T2/wXtPIx/v+cC02h5
         zDszz8DuvOJSFvCcMts27DkbZOko6bAu0+jvE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2 v2] tracing/lock: provide lock_acquired event support for dynamic size string
Date: Thu, 16 Apr 2009 22:00:47 +0200
Message-Id: <1239912047-6282-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can support the dynamic sized string, make the lock tracing
able to use it, making it safe against modules removal and consuming
the right amount of memory needed for each lock name

Changes in v2:
adapt to the __ending_string() updates and the opening_string() removal.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/lockdep.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 45e326b..e649fbc 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -38,14 +38,14 @@ TRACE_EVENT(lock_acquired,
 	TP_ARGS(lock, ip, waittime),
 
 	TP_STRUCT__entry(
-		__field(const char *, name)
 		__field(unsigned long, wait_usec)
 		__field(unsigned long, wait_nsec_rem)
+		__ending_string(name, lock->name)
 	),
 	TP_fast_assign(
-		__entry->name = lock->name;
 		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
 		__entry->wait_usec = (unsigned long) waittime;
+		strcpy(__entry->name, lock->name);
 	),
 	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
 				       __entry->wait_nsec_rem)
-- 
1.6.1

