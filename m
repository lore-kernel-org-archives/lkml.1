Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZAMQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZAMQnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZAMQnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:43:09 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:43079 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZAMQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:43:07 -0500
Date: Tue, 13 Jan 2009 17:43:04 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] async: Handle kthread_run() return codes.
Message-ID: <20090113174304.2186532c@gondolin>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to create the manager thread, fall back to non-fastboot.
If we fail to create an async thread, try again when the manager
thread runs again.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 kernel/async.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -315,11 +315,14 @@ static int async_manager_thread(void *un
 		ec = atomic_read(&entry_count);
 
 		while (tc < ec && tc < MAX_THREADS) {
-			kthread_run(async_thread, NULL, "async/%i", tc);
+			if (IS_ERR(kthread_run(async_thread, NULL, "async/%i",
+					       tc)))
+				/* Try again later. */
+				goto schedule;
 			atomic_inc(&thread_count);
 			tc++;
 		}
-
+schedule:
 		schedule();
 	}
 	remove_wait_queue(&async_new, &wq);
@@ -330,7 +333,9 @@ static int async_manager_thread(void *un
 static int __init async_init(void)
 {
 	if (async_enabled)
-		kthread_run(async_manager_thread, NULL, "async/mgr");
+		if (IS_ERR(kthread_run(async_manager_thread, NULL,
+				       "async/mgr")))
+			async_enabled = 0;
 	return 0;
 }
 
