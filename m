Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbZCXNMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbZCXNMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZCXNLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:11:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZCXNLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:11:50 -0400
Date: Tue, 24 Mar 2009 09:11:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
In-Reply-To: <20090324112050.GC6386@elte.hu>
Message-ID: <alpine.DEB.2.00.0903240909320.22830@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903210251100.13615@gandalf.stny.rr.com> <20090321094348.GB5594@elte.hu> <49C88F0B.7070901@cn.fujitsu.com> <20090324112050.GC6386@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 24 Mar 2009, Ingo Molnar wrote:

> 
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > >> Steven Rostedt (1):
> > >>       tracing: fix memory leak in trace_stat

[...]

> > 
> > Hi, Ingo
> > 
> > I found this patch is not in the tip tree.
> 
> It was tied to the function profiler which is still being debated. 
> Steve, mind re-anchoring that commit?

Hi Ingo,

Just created a branch from your latest tracing/ftrace and cherry picked
this change. I'll rebase my tip/tracing/ftrace branch on your changes
as soon as I see it in. I have more changes for the function profiler that
I think will make it worth having. Soon to be announced.

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (1):
      tracing: fix memory leak in trace_stat

----
 kernel/trace/trace_stat.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)
---------------------------
commit 098335215a4921a8a54193829eaed602dca24df5
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat Mar 21 02:44:50 2009 -0400

    tracing: fix memory leak in trace_stat
    
    If the function profiler does not have any items recorded and one were
    to cat the function stat file, the kernel would take a BUG with a NULL
    pointer dereference.
    
    Looking further into this, I found that returning NULL from stat_start
    did not stop the stat logic, and would later call stat_next. This breaks
    from the way seq_file works, so I looked into fixing the stat code.
    
    This is where I noticed that the last next_entry is never freed.
    It is allocated, and if the stat_next returns NULL, the code breaks out
    of the loop, unlocks the mutex and exits. We never link the next_entry
    nor do we free it. Thus it is a real memory leak.
    
    This patch rearranges the code a bit to not only fix the memory leak,
    but also to act more like seq_file where nothing is printed if there
    is nothing to print. That is, stat_start returns NULL.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 39310e3..f71b85b 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -75,7 +75,7 @@ static int stat_seq_init(struct tracer_stat_session *session)
 {
 	struct trace_stat_list *iter_entry, *new_entry;
 	struct tracer_stat *ts = session->ts;
-	void *prev_stat;
+	void *stat;
 	int ret = 0;
 	int i;
 
@@ -85,6 +85,10 @@ static int stat_seq_init(struct tracer_stat_session *session)
 	if (!ts->stat_cmp)
 		ts->stat_cmp = dummy_cmp;
 
+	stat = ts->stat_start();
+	if (!stat)
+		goto exit;
+
 	/*
 	 * The first entry. Actually this is the second, but the first
 	 * one (the stat_list head) is pointless.
@@ -99,14 +103,19 @@ static int stat_seq_init(struct tracer_stat_session *session)
 
 	list_add(&new_entry->list, &session->stat_list);
 
-	new_entry->stat = ts->stat_start();
-	prev_stat = new_entry->stat;
+	new_entry->stat = stat;
 
 	/*
 	 * Iterate over the tracer stat entries and store them in a sorted
 	 * list.
 	 */
 	for (i = 1; ; i++) {
+		stat = ts->stat_next(stat, i);
+
+		/* End of insertion */
+		if (!stat)
+			break;
+
 		new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
 		if (!new_entry) {
 			ret = -ENOMEM;
@@ -114,11 +123,7 @@ static int stat_seq_init(struct tracer_stat_session *session)
 		}
 
 		INIT_LIST_HEAD(&new_entry->list);
-		new_entry->stat = ts->stat_next(prev_stat, i);
-
-		/* End of insertion */
-		if (!new_entry->stat)
-			break;
+		new_entry->stat = stat;
 
 		list_for_each_entry(iter_entry, &session->stat_list, list) {
 
@@ -137,8 +142,6 @@ static int stat_seq_init(struct tracer_stat_session *session)
 				break;
 			}
 		}
-
-		prev_stat = new_entry->stat;
 	}
 exit:
 	mutex_unlock(&session->stat_mutex);
