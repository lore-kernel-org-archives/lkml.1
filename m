Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZDHNFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZDHNFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765288AbZDHNDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765298AbZDHND3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:29 -0400
Message-Id: <20090408130408.947197470@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/9] perf_counter: kerneltop: keep up with ABI changes
Content-Disposition: inline; filename=kerneltop-new-header.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kerneltop to use PERF_EVENT_MISC_OVERFLOW

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -1276,22 +1276,22 @@ static void mmap_read(struct mmap_data *
 
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
 

-- 

