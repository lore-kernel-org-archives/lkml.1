Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbZKZRYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbZKZRYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZKZRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:24:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:29574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZKZRYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:24:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:subject:from:reply-to:to:cc:x-system-of-record;
	b=ba+++o3pSNyiMAZM+WJheM0rAhO4mUtGTgh8LmWQtD5Rv/wcjrvkdL0fcwDGj1Pyb
	m8uiv+rXYD5aKr9zVfgTQ==
Message-ID: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
Date: Thu, 26 Nov 2009 09:24:30 -0800 (PST)
Subject: [PATCH] perf_events: fix read() bogus counts when in error state
From: Stephane Eranian <eranian@google.com>
Reply-to: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net, eranian@google.com,
       eranian@gmail.com
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	When a pinned group cannot be scheduled it goes into error state.
	Normally a group cannot go out of error state without being explicitly
	re-enabled or disabled. There was a bug in per-thread mode, whereby
	upon termination of the thread, the group would transition from error
	to off leading to bogus counts and timing information returned by
	read().

	It is important to realize that the current perf_events implementation
	assigns higher priority to system-wide events over per-thread events
	and that regardless of the fact that per-thread events may be pinned.
	It is not clear to me whether this is per design of the API or just a
	side effect of the implementation. I believe it is desirable that a
	system-wide tool gets priority access to the PMU but then this causes
	issues with per-thread events and especially when they request pinning.

	A per-thread pinned event can be evicted until there is enough PMU
	resource freed by system-wide events. Although, with this patch it is
	now possible to detect this when counting, it remains unclear how this
	situation could be detected when sampling, as it incurs potientially
	large blind spots and thus bias degrading the quality of the data
	collected.

	The API is missing a clear definition of what it means to be pinned
	for a per-thread event vs. system-wide event. Just like it does not
	clearly state that system-wide event have higher priority than per
	thread events.

	Signed-off-by: Stephane Eranian <eranian@google.com>
	
---
 perf_event.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0b0d5f7..7a8bb5b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -333,7 +333,16 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 		event->group_leader->nr_siblings--;
 
 	update_event_times(event);
-	event->state = PERF_EVENT_STATE_OFF;
+
+	/*
+	 * If event was in error state, then keep it
+	 * that way, otherwise bogus counts will be
+	 * returned on read(). The only way to get out
+	 * of error state is by explicit re-enabling
+	 * of the event
+	 */
+	if (event->state > PERF_EVENT_STATE_OFF)
+		event->state = PERF_EVENT_STATE_OFF;
 
 	/*
 	 * If this was a group event with sibling events then
