Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZKHUNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZKHUNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZKHUN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:13:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZKHUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZxFy8IeCunAgJ+X00Ldz+tkoze44+uuzQ7FKLJTd4qLTc+wwngasLiWdHJv5ckUk8u
         /ysDy6fRiJWQqAzZ59hQQvNnXQcFaEUC4oyp7bcWMX6QNY8P/BMb6CKxoawQaUSbzwfK
         kXaGm2fAEr8R2BnvDt65tl+n5Lxdz6QQvPdjM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 2/4] perf/core: Optimize a bit rotate_ctx()
Date: Sun,  8 Nov 2009 21:13:24 +0100
Message-Id: <1257711206-12243-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use list_for_each_entry() just to swap the first and
last entry in the list.

Instead, use a direct list->next derefencing. This saves up a
useless prefetch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/perf_event.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b3a31c8..0432c1c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1432,7 +1432,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	struct perf_event *event;
+	struct list_head *list;
 
 	if (!ctx->nr_events)
 		return;
@@ -1442,15 +1442,17 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	 * Rotate the first entry last (works just fine for group events too):
 	 */
 	perf_disable();
-	list_for_each_entry(event, &ctx->pinned_grp_list, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->pinned_grp_list);
-		break;
+
+	if (!list_empty(&ctx->pinned_grp_list)) {
+		list = ctx->pinned_grp_list.next;
+		list_move_tail(list, &ctx->pinned_grp_list);
 	}
 
-	list_for_each_entry(event, &ctx->volatile_grp_list, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->volatile_grp_list);
-		break;
+	if (!list_empty(&ctx->volatile_grp_list)) {
+		list = ctx->volatile_grp_list.next;
+		list_move_tail(list, &ctx->volatile_grp_list);
 	}
+
 	perf_enable();
 
 	spin_unlock(&ctx->lock);
-- 
1.6.2.3

