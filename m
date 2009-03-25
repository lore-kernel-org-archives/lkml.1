Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZCYXE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZCYXE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZCYXEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:04:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbZCYXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:04:32 -0400
Date: Wed, 25 Mar 2009 19:04:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH][GIT PULL] ftrace: Using FTRACE_WARN_ON() to check "freed
 record" in ftrace_release()
Message-ID: <alpine.DEB.2.00.0903251903260.5675@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Zhaolei (1):
      ftrace: Using FTRACE_WARN_ON() to check "freed record" in ftrace_release()

----
 kernel/trace/ftrace.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)
---------------------------
commit 2a4efa42450762cbfa5c5712aa4cc9f06924c9fd
Author: Zhaolei <zhaolei@cn.fujitsu.com>
Date:   Wed Mar 25 12:06:05 2009 +0800

    ftrace: Using FTRACE_WARN_ON() to check "freed record" in ftrace_release()
    
     "Because when we call ftrace_free_rec we change the rec->ip to point to the
      next record in the chain. Something is very wrong if rec->ip >= s &&
      rec->ip < e and the record is already free."
    
     "Note, use FTRACE_WARN_ON() macro. This way it shuts down ftrace if it is
      hit and helps to avoid further damage later."
                       -- Steven Rostedt <rostedt@goodmis.org>
    
    Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7b8722b..1752a63 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -358,9 +358,14 @@ void ftrace_release(void *start, unsigned long size)
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e) &&
-		    !(rec->flags & FTRACE_FL_FREE))
+		if ((rec->ip >= s) && (rec->ip < e)) {
+			/*
+			 * rec->ip is changed in ftrace_free_rec()
+			 * It should not between s and e if record was freed.
+			 */
+			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
 			ftrace_free_rec(rec);
+		}
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
 }

