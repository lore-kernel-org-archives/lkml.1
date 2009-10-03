Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZJCRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZJCRUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZJCRUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:20:12 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:43497 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbZJCRUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:20:04 -0400
From: manfred@colorfullife.com
To: linux-kernel@vger.kernel.org
Cc: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 7/7] ipc/sem.c: optimize single sops when semval is zero
Date: Sat,  3 Oct 2009 19:19:24 +0200
Message-Id: <1254590364-2876-5-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254590364-2876-4-git-send-email-manfred@colorfullife.com>
References: <1254590364-2876-1-git-send-email-manfred@colorfullife.com>
 <1254590364-2876-2-git-send-email-manfred@colorfullife.com>
 <1254590364-2876-3-git-send-email-manfred@colorfullife.com>
 <1254590364-2876-4-git-send-email-manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>

If multiple simple decrements on the same semaphore are pending, then the
current code scans all decrement operations, even if the semaphore value is
already 0.
The patch optimizes that: if the semaphore value is 0, then there is no need
to scan the q->alter entries.
Note that this is a common case: It happens if 100 decrements by one are
pending and now an increment by one increases the semaphore value from 0 to 1.
Without this patch, all 100 entries are scanned. With the patch, only
one entry is scanned, then woken up. Then the new rule triggers and the
scanning is aborted, without looking at the remaining 99 tasks.

With this patch, single sop increment/decrement by 1 are now O(1).
(same as with Nick's patch)

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 66192c2..aab39fb 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -473,6 +473,17 @@ again:
 		q = (struct sem_queue *)((char *)walk - offset);
 		walk = walk->next;
 
+		/* If we are scanning the single sop, per-semaphore list of
+		 * one semaphore and that semaphore is 0, then it is not
+		 * necessary to scan the "alter" entries: simple increments
+		 * that affect only one entry succeed immediately and cannot
+		 * be in the  per semaphore pending queue, and decrements
+		 * cannot be successful if the value is already 0.
+		 */
+		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
+				q->alter)
+			break;
+
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
-- 
1.6.2.5

