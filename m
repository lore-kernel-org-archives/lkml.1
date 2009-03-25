Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbZCYRf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbZCYRf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbZCYRfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:35:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:54399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZCYRf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:35:29 -0400
Date: Wed, 25 Mar 2009 17:33:35 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49C9F23F.5040307@cn.fujitsu.com>
References: <49C9F23F.5040307@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] trace_stat: keep original order
Message-ID: <tip-220ba351dfa57eca4bec5ce0098a276446a47958@git.kernel.org>
Git-Commit-ID: 220ba351dfa57eca4bec5ce0098a276446a47958
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 17:33:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  220ba351dfa57eca4bec5ce0098a276446a47958
Gitweb:     http://git.kernel.org/tip/220ba351dfa57eca4bec5ce0098a276446a47958
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 16:58:39 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 18:32:34 +0100

trace_stat: keep original order

Impact: make trace_stat files show items with the original order

trace_stat tracer reverse the items, it makes the output
looks a little ugly.

Example, when we read trace_stat/workqueues, we get cpu#7's stat.
at first, and then cpu#6... cpu#0.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C9F23F.5040307@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_stat.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 8c129dd..acdebd7 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -125,23 +125,21 @@ static int stat_seq_init(struct tracer_stat_session *session)
 		INIT_LIST_HEAD(&new_entry->list);
 		new_entry->stat = stat;
 
-		list_for_each_entry(iter_entry, &session->stat_list, list) {
+		list_for_each_entry_reverse(iter_entry, &session->stat_list,
+				list) {
 
 			/* Insertion with a descendent sorting */
-			if (ts->stat_cmp(new_entry->stat,
-						iter_entry->stat) > 0) {
+			if (ts->stat_cmp(iter_entry->stat,
+					new_entry->stat) >= 0) {
 
-				list_add_tail(&new_entry->list,
-						&iter_entry->list);
-				break;
-
-			/* The current smaller value */
-			} else if (list_is_last(&iter_entry->list,
-						&session->stat_list)) {
 				list_add(&new_entry->list, &iter_entry->list);
 				break;
 			}
 		}
+
+		/* The current larger value */
+		if (list_empty(&new_entry->list))
+			list_add(&new_entry->list, &session->stat_list);
 	}
 exit:
 	mutex_unlock(&session->stat_mutex);
