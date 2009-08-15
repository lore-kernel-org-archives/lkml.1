Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZHPAzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZHPAzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 20:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZHPAzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 20:55:19 -0400
Received: from sing.entic.net ([208.64.63.147]:34409 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZHPAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 20:55:18 -0400
Message-Id: <200908160054.n7G0sfF6025003@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Date: Sun, 16 Aug 2009 01:32:15 +0200
Subject: [PATCH 4/4] ipc/sem.c: optimize single sops when semval is zero
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

