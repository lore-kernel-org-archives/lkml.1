Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0AOBpo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887Ab0AOBpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:45:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0AOBpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:45:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf record: Encode the domain while synthesizing MMAP events
Date: Thu, 14 Jan 2010 23:45:28 -0200
Message-Id: <1263519930-22803-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263519930-22803-1-git-send-email-acme@infradead.org>
References: <1263519930-22803-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In the past 'perf record' had to process only userspace MMAP events, the
ones generated in the kernel, but after we reused the MMAP events to
encode the module mapings we ended up adding them first to the list of
userspace DSOs (dsos__user) and to the kernel one (dsos__kernel).

Fix this by encoding the header.misc field and then using it, like other
parts to decide the right DSOs list to insert/find.

The gotcha here is that since the kernel puts zero in .misc, which isn't
PERF_RECORD_MISC_KERNEL (1 << 1), to differentiate, we put 1 in .misc.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    8 ++++++--
 tools/perf/util/event.c     |   11 +++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c130df2..614fa9a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -117,8 +117,12 @@ static void write_event(event_t *buf, size_t size)
 	* Add it to the list of DSOs, so that when we finish this
 	 * record session we can pick the available build-ids.
 	 */
-	if (buf->header.type == PERF_RECORD_MMAP)
-		dsos__findnew(buf->mmap.filename);
+	if (buf->header.type == PERF_RECORD_MMAP) {
+		struct list_head *head = &dsos__user;
+		if (buf->mmap.header.misc == 1)
+			head = &dsos__kernel;
+		__dsos__findnew(head, buf->mmap.filename);
+	}
 
 	write_output(buf, size);
 }
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 0e9820a..1abaefc 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -110,7 +110,10 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 	while (1) {
 		char bf[BUFSIZ], *pbf = bf;
 		event_t ev = {
-			.header = { .type = PERF_RECORD_MMAP },
+			.header = {
+				.type = PERF_RECORD_MMAP,
+				.misc = 0, /* Just like the kernel, see kernel/perf_event.c __perf_event_mmap */
+			 },
 		};
 		int n;
 		size_t size;
@@ -170,6 +173,7 @@ int event__synthesize_modules(event__handler_t process,
 
 		size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
 		memset(&ev, 0, sizeof(ev));
+		ev.mmap.header.misc = 1; /* kernel uses 0 for user space maps, see kernel/perf_event.c __perf_event_mmap */
 		ev.mmap.header.type = PERF_RECORD_MMAP;
 		ev.mmap.header.size = (sizeof(ev.mmap) -
 				        (sizeof(ev.mmap.filename) - size));
@@ -236,7 +240,10 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 {
 	size_t size;
 	event_t ev = {
-		.header = { .type = PERF_RECORD_MMAP },
+		.header = {
+			.type = PERF_RECORD_MMAP,
+			.misc = 1, /* kernel uses 0 for user space maps, see kernel/perf_event.c __perf_event_mmap */
+		},
 	};
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
-- 
1.6.2.5

