Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZAOB6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZAOB6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZAOB5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:57:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49077 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZAOB5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:57:54 -0500
Date: Wed, 14 Jan 2009 20:57:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tracing/ftrace: add missing unlock in
 register_stat_tracer()
Message-ID: <alpine.DEB.1.10.0901142056470.22004@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Li Zefan (1):
      tracing/ftrace: add missing unlock in register_stat_tracer()

----
 kernel/trace/trace_stat.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)
---------------------------
commit 6af81ac4701bf80dde4b723f28a777daefdf512c
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Thu Jan 15 09:30:52 2009 +0800

    tracing/ftrace: add missing unlock in register_stat_tracer()
    
    We should unlock all_stat_sessions_mutex before returning failure.
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index cb29282..8669f3c 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -73,8 +73,10 @@ int register_stat_tracer(struct tracer_stat *trace)
 	/* Already registered? */
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
-		if (node->ts == trace)
+		if (node->ts == trace) {
+			mutex_unlock(all_stat_sessions_mutex);
 			return -EINVAL;
+		}
 	}
 	mutex_unlock(&all_stat_sessions_mutex);
 

