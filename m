Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0AJBis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0AJBis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399Ab0AJBic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:38:32 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49789 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0AJBi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ntiy9Vz1zT6oO9mHF7vVV513OnHgyfSysn8qHpRyJh6Dpwdn6TfuPK01V834hyP1qB
         dwFmx5/DOZzw9F7Qs2bfznznwwR5YlFdEl4qyOYFmrA81M8UDhAg0644/ssmwdj+YJLe
         VFAmVGA20P0+8rEHJtKlBt+ZEOzJ85xNxEOS8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/6] perf: Round robin groups of events using list_rotate_left()
Date: Sun, 10 Jan 2010 02:38:17 +0100
Message-Id: <1263087500-14215-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more proper that doing it through a list_for_each_entry()
that breaks after the first entry.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c9f8a75..d7254f5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1454,8 +1454,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	struct perf_event *event;
-
 	if (!ctx->nr_events)
 		return;
 
@@ -1464,15 +1462,10 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	 * Rotate the first entry last (works just fine for group events too):
 	 */
 	perf_disable();
-	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->pinned_groups);
-		break;
-	}
 
-	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->flexible_groups);
-		break;
-	}
+	list_rotate_left(&ctx->pinned_groups);
+	list_rotate_left(&ctx->flexible_groups);
+
 	perf_enable();
 
 	raw_spin_unlock(&ctx->lock);
-- 
1.6.2.3

