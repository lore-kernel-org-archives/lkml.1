Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0APNk2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 08:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859Ab0APNkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 08:40:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63866 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0APNkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 08:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BnzBRdoiujI2wylSGK2tBbIruE5UoRJ8WlwziYMqhJNiPZyn6uXXmfnnotazCaO3pL
         WJn+DXPLMZws7KvitlW0P9IXMpT1rSYQao2rTBiXUVs7k9WELHI4M2q1j/8bmsBc7tMI
         cAZG9TYOmU7IyuS96zYM2jAx14T7TBFYdrdTs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] perf: Round robin flexible groups of events using list_rotate_left()
Date: Sat, 16 Jan 2010 14:40:08 +0100
Message-Id: <1263649209-4343-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
References: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more proper that doing it through a list_for_each_entry()
that breaks after the first entry.

v2: Don't rotate pinned groups as its not needed to time share
them.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 kernel/perf_event.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c9f8a75..bbebe28 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1454,25 +1454,16 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	struct perf_event *event;
-
 	if (!ctx->nr_events)
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	/*
-	 * Rotate the first entry last (works just fine for group events too):
-	 */
+
+	/* Rotate the first entry last of non-pinned groups */
 	perf_disable();
-	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->pinned_groups);
-		break;
-	}
 
-	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->flexible_groups);
-		break;
-	}
+	list_rotate_left(&ctx->flexible_groups);
+
 	perf_enable();
 
 	raw_spin_unlock(&ctx->lock);
-- 
1.6.2.3

