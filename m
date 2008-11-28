Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYK1EVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYK1EVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYK1EV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:21:28 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:25872 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYK1EV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GKg96Q+lzGhTpJszFCoi60CXnwMdfOU57zHriAA/Wo6bqaGZVppoJJsqzSeRCSpPq0
         S1kjmBhTP8kME8M9TfB1pLA1KcCtsN0UipB2q5Y47ivsUzrzE7gLxFGZSXTzElS22hnE
         2VmmhwZ0mqfdGij9Wo32ZbV90UHOIH3K+att0=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ftrace: improve document
Date: Fri, 28 Nov 2008 12:21:19 +0800
Message-Id: <1227846079-9197-1-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <alpine.DEB.1.10.0811272251180.7113@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811272251180.7113@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add notice of using wild cards correctly

We know that we can use wild cards to set set_ftrace_filter, but there's
problem when using such as "echo h* > /debug/tracing/set_ftrace_filter".
If there are files named with "h" prefix in current directory, echo "h*"
will echo these files' name to set_ftrace_filter, not "h*".
For example:
$cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
23
$ls
$touch hraa hrdd
$ls
hraa  hrdd
$echo hr* > /debug/tracing/set_ftrace_filter
$cat /debug/tracing/set_ftrace_filter

No output in /debug/tracing/set_ftrace_filter!
If we use '' to enclose wild cards, it works:

$ls
hraa  hrdd
$echo "hr*" > /debug/tracing/set_ftrace_filter
$cat /debug/tracing/set_ftrace_filter |wc -l
23

This problem can lead to unexpected result if current directory has a
lot of files.

Signed-off-by: walimis <walimisdev@gmail.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index de05042..803b131 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1251,7 +1251,11 @@ These are the only wild cards which are supported.
 
   <match>*<match> will not work.
 
- # echo hrtimer_* > /debug/tracing/set_ftrace_filter
+Note: It is better to use quotes to enclose the wild cards, otherwise
+  the shell may expand the parameters into names of files in the local
+  directory.
+
+ # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
 
 Produces:
 
@@ -1306,7 +1310,7 @@ Again, now we want to append.
  # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
  # cat /debug/tracing/set_ftrace_filter
 sys_nanosleep
- # echo hrtimer_* >> /debug/tracing/set_ftrace_filter
+ # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
  # cat /debug/tracing/set_ftrace_filter
 hrtimer_run_queues
 hrtimer_run_pending
-- 
1.6.0.3

