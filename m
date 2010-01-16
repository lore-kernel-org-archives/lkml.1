Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0APNlO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 08:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972Ab0APNk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 08:40:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36922 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab0APNkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 08:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q8c2sA/bfckdgfqEIzpK/KirWRQoQf8M8OwxCFPKrPanTzcm+VdylVur5MjQARji1G
         gtwW5F5TSGMuagGrLY3XLQNwPN+4neQUbO5MdM0EJA6ukEeiYHSkjDM/dNi3S2bRH4k4
         MJsohxXIXpYZ8jpTpOtwroTKoQ2DmclnCtbuE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] perf: Export software-only event group characteristic as a flag
Date: Sat, 16 Jan 2010 14:40:09 +0100
Message-Id: <1263649209-4343-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
References: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before scheduling an event group, we first check if a group can go
on. We first check if the group is made of software only events
first, in which case it is enough to know if the group can be
scheduled in.

For that purpose, we iterate through the whole group, which is
wasteful as we could do this check when we add/delete an event to
a group.

So we create a group_flags field in perf event that can host
characteristics from a group of events, starting with a first
PERF_GROUP_SOFTWARE flag that reduces the check on the fast path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 include/linux/perf_event.h |    5 +++++
 kernel/perf_event.c        |   30 +++++++++++-------------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cdbc2aa..c6f812e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -565,6 +565,10 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
 					struct perf_sample_data *,
 					struct pt_regs *regs);
 
+enum perf_group_flag {
+	PERF_GROUP_SOFTWARE = 0x1,
+};
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -574,6 +578,7 @@ struct perf_event {
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
 	int				nr_siblings;
+	int				group_flags;
 	struct perf_event		*group_leader;
 	struct perf_event		*output;
 	const struct pmu		*pmu;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bbebe28..eae6ff6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -315,9 +315,16 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (group_leader == event) {
 		struct list_head *list;
 
+		if (is_software_event(event))
+			event->group_flags |= PERF_GROUP_SOFTWARE;
+
 		list = ctx_group_list(event, ctx);
 		list_add_tail(&event->group_entry, list);
 	} else {
+		if (group_leader->group_flags & PERF_GROUP_SOFTWARE &&
+		    !is_software_event(event))
+			group_leader->group_flags &= ~PERF_GROUP_SOFTWARE;
+
 		list_add_tail(&event->group_entry, &group_leader->sibling_list);
 		group_leader->nr_siblings++;
 	}
@@ -372,6 +379,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 		list = ctx_group_list(event, ctx);
 		list_move_tail(&sibling->group_entry, list);
 		sibling->group_leader = sibling;
+
+		/* Inherit group flags from the previous leader */
+		sibling->group_flags = event->group_flags;
 	}
 }
 
@@ -700,24 +710,6 @@ group_error:
 }
 
 /*
- * Return 1 for a group consisting entirely of software events,
- * 0 if the group contains any hardware events.
- */
-static int is_software_only_group(struct perf_event *leader)
-{
-	struct perf_event *event;
-
-	if (!is_software_event(leader))
-		return 0;
-
-	list_for_each_entry(event, &leader->sibling_list, group_entry)
-		if (!is_software_event(event))
-			return 0;
-
-	return 1;
-}
-
-/*
  * Work out whether we can put this event group on the CPU now.
  */
 static int group_can_go_on(struct perf_event *event,
@@ -727,7 +719,7 @@ static int group_can_go_on(struct perf_event *event,
 	/*
 	 * Groups consisting entirely of software events can always go on.
 	 */
-	if (is_software_only_group(event))
+	if (event->group_flags & PERF_GROUP_SOFTWARE)
 		return 1;
 	/*
 	 * If an exclusive group is already on, no other hardware
-- 
1.6.2.3

