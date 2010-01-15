Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0AOUIu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136Ab0AOUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:08:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0AOUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:08:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf record: Intercept all events
Date: Fri, 15 Jan 2010 18:08:26 -0200
Message-Id: <1263586107-1756-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The event interception we need to to din 'perf record' to create a list
of all DSOs in PERF_RECORD_MMAP events wasn't seeing all events, make
sure that happens by checking size agains event_t->header.size.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 614fa9a..7bb9ca1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -113,16 +113,24 @@ static void write_output(void *buf, size_t size)
 
 static void write_event(event_t *buf, size_t size)
 {
-	/*
-	* Add it to the list of DSOs, so that when we finish this
-	 * record session we can pick the available build-ids.
-	 */
-	if (buf->header.type == PERF_RECORD_MMAP) {
-		struct list_head *head = &dsos__user;
-		if (buf->mmap.header.misc == 1)
-			head = &dsos__kernel;
-		__dsos__findnew(head, buf->mmap.filename);
-	}
+	size_t processed_size = buf->header.size;
+	event_t *ev = buf;
+
+	do {
+		/*
+		* Add it to the list of DSOs, so that when we finish this
+		 * record session we can pick the available build-ids.
+		 */
+		if (ev->header.type == PERF_RECORD_MMAP) {
+			struct list_head *head = &dsos__user;
+			if (ev->header.misc == 1)
+				head = &dsos__kernel;
+			__dsos__findnew(head, ev->mmap.filename);
+		}
+
+		ev = ((void *)ev) + ev->header.size;
+		processed_size += ev->header.size;
+	} while (processed_size < size);
 
 	write_output(buf, size);
 }
-- 
1.6.2.5

