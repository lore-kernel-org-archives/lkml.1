Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbZEGJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbZEGJVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbZEGJVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:21:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:40265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbZEGJVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:21:09 -0400
Date: Thu, 7 May 2009 09:20:30 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A028993.7020509@cn.fujitsu.com>
References: <4A028993.7020509@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: fix concurrent access to ftrace_events list, fix
Message-ID: <tip-d94fc523f3c35bd8013f04827e94756cbc0212f4@git.kernel.org>
Git-Commit-ID: d94fc523f3c35bd8013f04827e94756cbc0212f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:20:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d94fc523f3c35bd8013f04827e94756cbc0212f4
Gitweb:     http://git.kernel.org/tip/d94fc523f3c35bd8013f04827e94756cbc0212f4
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 7 May 2009 15:11:15 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 7 May 2009 10:07:28 +0200

tracing/events: fix concurrent access to ftrace_events list, fix

In filter_add_subsystem_pred() we should release event_mutex before
calling filter_free_subsystem_preds(), since both functions hold
event_mutex.

[ Impact: fix deadlock when writing invalid pred into subsystem filter ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: tzanussi@gmail.com
Cc: a.p.zijlstra@chello.nl
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <4A028993.7020509@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8c62e5b..85ad6a8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -636,14 +636,15 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 
 		err = filter_add_pred(ps, call, pred);
 		if (err) {
+			mutex_unlock(&event_mutex);
 			filter_free_subsystem_preds(system);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
-			break;
+			goto out;
 		}
 		replace_filter_string(call->filter, filter_string);
 	}
 	mutex_unlock(&event_mutex);
-
+out:
 	return err;
 }
 
