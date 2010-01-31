Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121Ab0AaIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab0AaIbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885Ab0AaIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:31:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:51256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab0AaIbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:31:43 -0500
Date: Sun, 31 Jan 2010 08:31:09 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, tzanussi@gmail.com, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, srostedt@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1264851813-8413-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add __data_loc support
Message-ID: <tip-86d8d29634de4464d568e7c335c0da6cba64e8ab@git.kernel.org>
Git-Commit-ID: 86d8d29634de4464d568e7c335c0da6cba64e8ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 08:31:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86d8d29634de4464d568e7c335c0da6cba64e8ab
Gitweb:     http://git.kernel.org/tip/86d8d29634de4464d568e7c335c0da6cba64e8ab
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sat, 30 Jan 2010 20:43:23 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Jan 2010 08:27:52 +0100

perf tools: Add __data_loc support

This patch is required to test the next patch for perf lock.

At 064739bc4b3d7f424b2f25547e6611bcf0132415 ,
support for the modifier "__data_loc" of format is added.

But, when I wanted to parse format of lock_acquired (or some
event else), raw_field_ptr() did not returned correct pointer.

So I modified raw_field_ptr() like this patch. Then
raw_field_ptr() works well.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <1264851813-8413-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
[ v3: fixed minor stylistic detail ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c5c32be..c4b3cb8 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1925,6 +1925,15 @@ void *raw_field_ptr(struct event *event, const char *name, void *data)
 	if (!field)
 		return NULL;
 
+	if (field->flags & FIELD_IS_STRING) {
+		int offset;
+
+		offset = *(int *)(data + field->offset);
+		offset &= 0xffff;
+
+		return data + offset;
+	}
+
 	return data + field->offset;
 }
 
