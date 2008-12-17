Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753337AbYLQWPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYLQWPE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLQWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:14:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYLQWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:14:37 -0500
Date: Wed, 17 Dec 2008 17:14:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH] ftrace: add not to regex on filtering functions
Message-ID: <alpine.DEB.1.10.0812171713310.4839@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      ftrace: add not to regex on filtering functions

----
 kernel/trace/ftrace.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)
---------------------------
commit 697732357fc9af46c5cbd865877495c9b52fb1e0
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 17 15:05:36 2008 -0500

    ftrace: add not to regex on filtering functions
    
    Impact: enhancement
    
    Ingo Molnar has asked about a way to remove items from the filter
    lists. Currently, you can only add or replace items. The way
    items are added to the list is through opening one of the list
    files (set_ftrace_filter or set_ftrace_notrace) via append.
    If the file is opened for truncate, the list is cleared.
    
      echo spin_lock > /debug/tracing/set_ftrace_filter
    
    The above will replace the list with only spin_lock
    
      echo spin_lock >> /debug/tracing/set_ftrace_filter
    
    The above will add spin_lock to the list.
    
    Now this patch adds:
    
      echo '!spin_lock' >> /debug/tracing/set_ftrace_filter
    
    This will remove spin_lock from the list.
    
    The limited glob features of these lists also can be notted.
    
      echo '!spin_*' >> /debug/tracing/set_ftrace_filter
    
    This will remove all functions that start with 'spin_'
    
    Note:
    
      echo '!spin_*' > /debug/tracing/set_ftrace_filter
    
    will simply clear out the list (notice the '>' instead of '>>')
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a12f80e..2f32969 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1047,6 +1047,13 @@ ftrace_match(unsigned char *buff, int len, int enable)
 	int type = MATCH_FULL;
 	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	unsigned i, match = 0, search_len = 0;
+	int not = 0;
+
+	if (buff[0] == '!') {
+		not = 1;
+		buff++;
+		len--;
+	}
 
 	for (i = 0; i < len; i++) {
 		if (buff[i] == '*') {
@@ -1100,8 +1107,12 @@ ftrace_match(unsigned char *buff, int len, int enable)
 					matched = 1;
 				break;
 			}
-			if (matched)
-				rec->flags |= flag;
+			if (matched) {
+				if (not)
+					rec->flags &= ~flag;
+				else
+					rec->flags |= flag;
+			}
 		}
 		pg = pg->next;
 	}

