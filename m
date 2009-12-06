Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbZLFRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbZLFRTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbZLFRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:19:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:47475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933887AbZLFRTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:19:18 -0500
Date: Sun, 6 Dec 2009 17:18:40 GMT
From: tip-bot for OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@infradead.org,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <87ljhg8ioe.fsf@devron.myhome.or.jp>
References: <87ljhg8ioe.fsf@devron.myhome.or.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf timechart: Fix header handling
Message-ID: <tip-028c515253761084c6594bf9ac9b194b51d87065@git.kernel.org>
Git-Commit-ID: 028c515253761084c6594bf9ac9b194b51d87065
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  028c515253761084c6594bf9ac9b194b51d87065
Gitweb:     http://git.kernel.org/tip/028c515253761084c6594bf9ac9b194b51d87065
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Sun, 6 Dec 2009 20:07:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 18:15:01 +0100

perf timechart: Fix header handling

Update "struct trace_entry" to match with current one. And
remove "size" field from it.

If it has "size", it become cause of alignment mismatch of
structure with kernel.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <87ljhg8ioe.fsf@devron.myhome.or.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-timechart.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index cb58b66..c0f29ed 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -302,12 +302,11 @@ process_exit_event(event_t *event)
 }
 
 struct trace_entry {
-	u32			size;
 	unsigned short		type;
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			tgid;
+	int			lock_depth;
 };
 
 struct power_entry {
@@ -489,6 +488,7 @@ process_sample_event(event_t *event)
 	u64 stamp = 0;
 	u32 cpu = 0;
 	u32 pid = 0;
+	u32 size, *size_ptr;
 	struct trace_entry *te;
 
 	if (sample_type & PERF_SAMPLE_IP)
@@ -518,9 +518,13 @@ process_sample_event(event_t *event)
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		cursor++;
 
-	te = (void *)&event->sample.array[cursor];
+	size_ptr = (void *)&event->sample.array[cursor];
 
-	if (sample_type & PERF_SAMPLE_RAW && te->size > 0) {
+	size = *size_ptr;
+	size_ptr++;
+
+	te = (void *)size_ptr;
+	if (sample_type & PERF_SAMPLE_RAW && size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
