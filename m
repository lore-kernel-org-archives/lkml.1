Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbZDHQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbZDHQ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbZDHQ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:59:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:60391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762695AbZDHQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:59:35 -0400
Date: Wed, 8 Apr 2009 16:58:09 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130408.947197470@chello.nl>
References: <20090408130408.947197470@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: kerneltop: keep up with ABI changes
Message-ID: <tip-808382b33bb4c60df6379ec2db39f332cc56b82a@git.kernel.org>
Git-Commit-ID: 808382b33bb4c60df6379ec2db39f332cc56b82a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:58:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  808382b33bb4c60df6379ec2db39f332cc56b82a
Gitweb:     http://git.kernel.org/tip/808382b33bb4c60df6379ec2db39f332cc56b82a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:53:29 +0200

perf_counter: kerneltop: keep up with ABI changes

Update kerneltop to use PERF_EVENT_MISC_OVERFLOW

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130408.947197470@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 15f3a5f..042c1b8 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -1277,22 +1277,22 @@ static void mmap_read(struct mmap_data *md)
 
 		old += size;
 
-		switch (event->header.type) {
-		case PERF_EVENT_COUNTER_OVERFLOW | __PERF_EVENT_IP:
-		case PERF_EVENT_COUNTER_OVERFLOW | __PERF_EVENT_IP | __PERF_EVENT_TID:
-			process_event(event->ip.ip, md->counter);
-			break;
-
-		case PERF_EVENT_MMAP:
-		case PERF_EVENT_MUNMAP:
-			printf("%s: %Lu %Lu %Lu %s\n",
-					event->header.type == PERF_EVENT_MMAP
-					  ? "mmap" : "munmap",
-					event->mmap.start,
-					event->mmap.len,
-					event->mmap.pgoff,
-					event->mmap.filename);
-			break;
+		if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
+			if (event->header.type & PERF_RECORD_IP)
+				process_event(event->ip.ip, md->counter);
+		} else {
+			switch (event->header.type) {
+				case PERF_EVENT_MMAP:
+				case PERF_EVENT_MUNMAP:
+					printf("%s: %Lu %Lu %Lu %s\n",
+							event->header.type == PERF_EVENT_MMAP
+							? "mmap" : "munmap",
+							event->mmap.start,
+							event->mmap.len,
+							event->mmap.pgoff,
+							event->mmap.filename);
+					break;
+			}
 		}
 	}
 
