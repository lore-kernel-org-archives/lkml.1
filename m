Return-Path: <linux-kernel-owner+w=401wt.eu-S933744AbZLFLkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbZLFLkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933716AbZLFLkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:40:23 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54398 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703AbZLFLkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:40:22 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perf: Fix timechart header handling
Date: Sun, 06 Dec 2009 20:07:29 +0900
Message-ID: <87ljhg8ioe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Update "struct trace_entry" to match with current one. And remove
"size" field from it.

If it has "size", it become cause of alignment mismatch of structure
with kernel.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 tools/perf/builtin-timechart.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN tools/perf/builtin-timechart.c~perf-fix-timechart-header-handling tools/perf/builtin-timechart.c
--- linux-2.6/tools/perf/builtin-timechart.c~perf-fix-timechart-header-handling	2009-12-06 19:27:33.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/builtin-timechart.c	2009-12-06 19:27:44.000000000 +0900
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
 
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
