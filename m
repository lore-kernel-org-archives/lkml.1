Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZJCRUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZJCRUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZJCRUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:20:13 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58232 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZJCRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:19:58 -0400
From: manfred@colorfullife.com
To: linux-kernel@vger.kernel.org
Cc: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 4/7] ipc/sem.c: optimize if semops fail
Date: Sat,  3 Oct 2009 19:19:21 +0200
Message-Id: <1254590364-2876-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254590364-2876-1-git-send-email-manfred@colorfullife.com>
References: <1254590364-2876-1-git-send-email-manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>

Reduce the amount of scanning of the list of pending semaphore operations:
If try_atomic_semop failed, then no changes were applied. Thus no need to
restart.
Additionally, this patch correct an incorrect comment:
It's possible to wait for arbitrary semaphore values (do a dec by <x>,
wait-for-zero, inc by <x> in one atomic operation)

Both changes are from Nick Piggin, the patch is the result of a different
split of the individual changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 3629ef8..9425817 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -444,13 +444,13 @@ again:
 		 * of the completed operation:
 		 * - if the operation modified the array, then restart from the
 		 *   head of the queue and check for threads that might be
-		 *   waiting for semaphore values to become 0.
+		 *   waiting for the new semaphore values.
 		 * - if the operation didn't modify the array, then just
 		 *   continue.
 		 */
 		alter = q->alter;
 		wake_up_sem_queue(q, error);
-		if (alter)
+		if (alter && !error)
 			goto again;
 	}
 }
-- 
1.6.2.5

