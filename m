Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbZEGHKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbZEGHKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZEGHKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:10:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbZEGHKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:10:22 -0400
Message-ID: <4A028993.7020509@cn.fujitsu.com>
Date: Thu, 07 May 2009 15:11:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mingo@redhat.com
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/events: fix concurrent access to ftrace_events
 list
References: <4A00F709.3080800@cn.fujitsu.com> <tip-20c8928abe70e204bd077ab6cfe23002d7788983@git.kernel.org>
In-Reply-To: <tip-20c8928abe70e204bd077ab6cfe23002d7788983@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Li Zefan wrote:
> Commit-ID:  20c8928abe70e204bd077ab6cfe23002d7788983
> Gitweb:     http://git.kernel.org/tip/20c8928abe70e204bd077ab6cfe23002d7788983
> Author:     Li Zefan <lizf@cn.fujitsu.com>
> AuthorDate: Wed, 6 May 2009 10:33:45 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 6 May 2009 10:38:19 +0200
> 
> tracing/events: fix concurrent access to ftrace_events list
> 

There is a deadlock in this patch, and I sent out a v2 patch and
expected it to be applied:
	http://lkml.org/lkml/2009/5/6/26

Below is a fix on top of this patch. Sorry for my carelessness.

=========

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] tracing/events: fix deadlock on event_mutex

In filter_add_subsystem_pred() we should release event_mutex before
calling filter_free_subsystem_preds(), since both functions hold
event_mutex.

[ Impact: fix deadlock when writing invalid pred into subsystem filter ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
 
-- 
1.5.4.rc3




