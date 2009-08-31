Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZHaEp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZHaEp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZHaEp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:45:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:38646 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZHaEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cu+LjhLkh9JpWAki6TIzui4UgiF2MdWZidUx+BMyc71KUCBltbK2Pgm2IqtbjfUsh+
         BQumGXcy+hIRRIMBBnE3iyGGWLwFrjQLHnYmpUbYOslOSDVdmfVuUkONGpJZv7at1XXB
         8NGCKs+CgUd98Cz+d1bIj1UXJI6a6Y/3pWRkA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf tools: Unify swapper tasks naming
Date: Mon, 31 Aug 2009 06:45:20 +0200
Message-Id: <1251693921-6579-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In perf tools, we hardcode the pid 0 cmdline resolving to "idle"
because the init task is not included in the COMM events.

But the idle tasks secondary cpus are resolved into their "init"
name through the COMM events.
We have then such strange result in perf report (ditto with trace):

    19.66%       init    [kernel]          [k] acpi_idle_enter_c1
    17.32%       [idle]  [kernel]          [k] acpi_idle_enter_c1

It's then better to unify the swapper tasks into a single init name.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 3acd37f..7635928 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -85,7 +85,7 @@ register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
 
-	if (!thread || thread__set_comm(thread, "[idle]")) {
+	if (!thread || thread__set_comm(thread, "[init]")) {
 		fprintf(stderr, "problem inserting idle task.\n");
 		exit(-1);
 	}
-- 
1.6.2.3

