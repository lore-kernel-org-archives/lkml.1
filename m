Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752Ab0AJBjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0AJBjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565Ab0AJBjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:39:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:10729 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0AJBib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hyrWSmBQWhOTFkDPd1xLE3IgLIS+XMOafe8fs3AL0kilqipj92CVA5wRRuNT8tomG+
         qDnuXMB0cd3fzAsQCpv460A0yKYOEtNFimOiJQp9E47Ch6rKBpvlGfi/tso6S3F47n4j
         wxyaSGgRmwSvYHmC9NkcBAVK8qgx+bluvHH04=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf: Don't rotate pinned groups
Date: Sun, 10 Jan 2010 02:38:19 +0100
Message-Id: <1263087500-14215-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We round-robin pinned groups, which means we make them behaving
just like non-pinned groups. Currently, and in practice, the almost
only difference between pinned and non-pinned events is that the
formers are scheduled before the latters. And the latters also
stop scheduling non-software-only groups once one couldn't make
it.

Anyway, pinned groups don't need to be round-robined because if
a pinned group can't be scheduled, it is going to be put in an
error state, following the pinned logic: it is always or never
scheduled in a context.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7d00676..584e854 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1451,11 +1451,10 @@ static void rotate_ctx(struct perf_event_context *ctx)
 
 	raw_spin_lock(&ctx->lock);
 	/*
-	 * Rotate the first entry last (works just fine for group events too):
+	 * Rotate the first entry last of non-pinned groups
 	 */
 	perf_disable();
 
-	list_rotate_left(&ctx->pinned_groups);
 	list_rotate_left(&ctx->flexible_groups);
 
 	perf_enable();
-- 
1.6.2.3

