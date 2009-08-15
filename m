Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZHPAtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZHPAtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 20:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZHPAtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 20:49:31 -0400
Received: from sing.entic.net ([208.64.63.147]:34193 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbZHPAtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 20:49:31 -0400
Message-Id: <200908160049.n7G0n1Sg023832@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Date: Sat, 15 Aug 2009 23:57:12 +0200
Subject: [PATCH 1/4] ipc/sem.c: optimize if semops fail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first of four patches that reduce the amount of scanning of the
list of pending semaphore operations:
Part 1: if try_atomic_semop failed, then no changes were applied. Thus
no need to restart.
Additionally, this patch correct an incorrect comment.

The changes are from Nick Piggin, the patch is just splitted differently.

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

