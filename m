Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZFGKVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZFGKVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZFGKVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:21:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:41842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbZFGKVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:21:38 -0400
Date: Sun, 7 Jun 2009 10:21:15 GMT
From: tip-bot for Tim Bird <tim.bird@am.sony.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tim.bird@am.sony.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, tim.bird@am.sony.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A25BE9E.5090909@am.sony.com>
References: <4A25BE9E.5090909@am.sony.com>
Subject: [tip:tracing/core] ring-buffer: fix bug in ring_buffer_discard_commit
Message-ID: <tip-a2023556409cf7fec5d67a26f7fcfa57c5a4086d@git.kernel.org>
Git-Commit-ID: a2023556409cf7fec5d67a26f7fcfa57c5a4086d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 10:21:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2023556409cf7fec5d67a26f7fcfa57c5a4086d
Gitweb:     http://git.kernel.org/tip/a2023556409cf7fec5d67a26f7fcfa57c5a4086d
Author:     Tim Bird <tim.bird@am.sony.com>
AuthorDate: Tue, 2 Jun 2009 17:06:54 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 3 Jun 2009 10:15:06 -0400

ring-buffer: fix bug in ring_buffer_discard_commit

There's a bug in ring_buffer_discard_commit.  The wrong
pointer is being compared in order to check if the event
can be freed from the buffer rather than discarded
(i.e. marked as PAD).

I noticed this when I was working on duration filtering.
The bug is not deadly - it just results in lots of wasted
space in the buffer.  All filtered events are left in
the buffer and marked as discarded, rather than being
removed from the buffer to make space for other events.

Unfortunately, when I fixed this bug, I got errors doing a
filtered function trace.  Multiple TIME_EXTEND
events pile up in the buffer, and trigger the
following loop overage warning in rb_iter_peek():

again:
	...
	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
		return NULL;

I'm not sure what the best way is to fix this. I don't
know if I should extend the loop threshhold, or if I should
make the test more complex (ignore TIME_EXTEND
events), or just get rid of this loop check completely.

Note that if I implement a workaround for this, then I
see another problem from rb_advance_iter().  I haven't
tracked that one down yet.

In general, it seems like the case of removing filtered
events has not been working properly, and so some assumptions
about buffer invariant conditions need to be revisited.

Here's the patch for the simple fix:

Compare correct pointer for checking if an event can be
freed rather than left as discarded in the buffer.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
LKML-Reference: <4A25BE9E.5090909@am.sony.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 16b24d4..9453023 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1708,7 +1708,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 
 	bpage = cpu_buffer->tail_page;
 
-	if (bpage == (void *)addr && rb_page_write(bpage) == old_index) {
+	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
