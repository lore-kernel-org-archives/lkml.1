Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZJMGQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZJMGQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbZJMGQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:16:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:53189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595AbZJMGQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:16:11 -0400
Date: Tue, 13 Oct 2009 06:14:57 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AD3D7D9.4070400@cn.fujitsu.com>
References: <4AD3D7D9.4070400@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/filters: Fix memory leak when setting a filter
Message-ID: <tip-8ad807318fcd62aba0e18c7c7fbfcc1af3fcdbab@git.kernel.org>
Git-Commit-ID: 8ad807318fcd62aba0e18c7c7fbfcc1af3fcdbab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 06:14:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ad807318fcd62aba0e18c7c7fbfcc1af3fcdbab
Gitweb:     http://git.kernel.org/tip/8ad807318fcd62aba0e18c7c7fbfcc1af3fcdbab
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 13 Oct 2009 09:28:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 08:05:17 +0200

tracing/filters: Fix memory leak when setting a filter

Every time we set a filter, we leak memory allocated by
postfix_append_operand() and postfix_append_op().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: <stable@kernel.org> # for v2.6.31.x
LKML-Reference: <4AD3D7D9.4070400@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_events_filter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2324578..98a6cc5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -933,8 +933,9 @@ static void postfix_clear(struct filter_parse_state *ps)
 
 	while (!list_empty(&ps->postfix)) {
 		elt = list_first_entry(&ps->postfix, struct postfix_elt, list);
-		kfree(elt->operand);
 		list_del(&elt->list);
+		kfree(elt->operand);
+		kfree(elt);
 	}
 }
 
