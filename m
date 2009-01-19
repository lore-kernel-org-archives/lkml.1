Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZASMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZASMrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbZASMq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:46:29 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:46932 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996AbZASMq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:46:28 -0500
Date: Mon, 19 Jan 2009 13:45:31 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] async: Handle kthread_run() return codes.
Message-ID: <20090119134531.04c3725c@gondolin>
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
If we fail to create an async thread, try again after waiting for
a bit.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 kernel/async.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -54,6 +54,7 @@ asynchronous and synchronous parts of th
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 #include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
@@ -315,7 +316,11 @@ static int async_manager_thread(void *un
 		ec = atomic_read(&entry_count);
 
 		while (tc < ec && tc < MAX_THREADS) {
-			kthread_run(async_thread, NULL, "async/%i", tc);
+			if (IS_ERR(kthread_run(async_thread, NULL, "async/%i",
+					       tc))) {
+				msleep(100);
+				continue;
+			}
 			atomic_inc(&thread_count);
 			tc++;
 		}
@@ -330,7 +335,9 @@ static int async_manager_thread(void *un
 static int __init async_init(void)
 {
 	if (async_enabled)
-		kthread_run(async_manager_thread, NULL, "async/mgr");
+		if (IS_ERR(kthread_run(async_manager_thread, NULL,
+				       "async/mgr")))
+			async_enabled = 0;
 	return 0;
 }
 
