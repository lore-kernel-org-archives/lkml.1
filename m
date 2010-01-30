Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335Ab0A3Lzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0A3Lzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497Ab0A3Lzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:55:52 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52419 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0A3Lzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:55:51 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Revert "perf record: Intercept all events"
Date: Sat, 30 Jan 2010 20:55:41 +0900
Message-Id: <1264852541-8471-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ONLY FOR TEST USE!!!

This reverts commit f5a2c3dce03621b55f84496f58adc2d1a87ca16f.

This patch is required for making "perf lock rec" work.
The commit f5a2c3dce0 changes write_event() of builtin-record.c .
And changed write_event() sometimes doesn't stop with perf lock rec.

I'm researching what makes write_event() loop infinity,
and noticed that there are some events with event_t->header.size == 0.
But the detail of the problem,
like kind of these events, isn't clear...

*** I cannot sing this! ***
---
 tools/perf/builtin-record.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7bb9ca1..614fa9a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -113,24 +113,16 @@ static void write_output(void *buf, size_t size)
 
 static void write_event(event_t *buf, size_t size)
 {
-	size_t processed_size = buf->header.size;
-	event_t *ev = buf;
-
-	do {
-		/*
-		* Add it to the list of DSOs, so that when we finish this
-		 * record session we can pick the available build-ids.
-		 */
-		if (ev->header.type == PERF_RECORD_MMAP) {
-			struct list_head *head = &dsos__user;
-			if (ev->header.misc == 1)
-				head = &dsos__kernel;
-			__dsos__findnew(head, ev->mmap.filename);
-		}
-
-		ev = ((void *)ev) + ev->header.size;
-		processed_size += ev->header.size;
-	} while (processed_size < size);
+	/*
+	* Add it to the list of DSOs, so that when we finish this
+	 * record session we can pick the available build-ids.
+	 */
+	if (buf->header.type == PERF_RECORD_MMAP) {
+		struct list_head *head = &dsos__user;
+		if (buf->mmap.header.misc == 1)
+			head = &dsos__kernel;
+		__dsos__findnew(head, buf->mmap.filename);
+	}
 
 	write_output(buf, size);
 }
-- 
1.6.5.2

