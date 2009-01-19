Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZASMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZASMqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759038AbZASMqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:46:23 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:45253 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbZASMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:46:22 -0500
Date: Mon, 19 Jan 2009 13:45:28 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] async: Fix running list handling.
Message-ID: <20090119134528.54d0a33c@gondolin>
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

async_schedule() should pass in async_running as the running
list, and run_one_entry() should put the entry to be run on
the provided running list instead of always on the generic one.

Reported-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 kernel/async.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -133,7 +133,7 @@ static void run_one_entry(void)
 
 	/* 2) move it to the running queue */
 	list_del(&entry->list);
-	list_add_tail(&entry->list, &async_running);
+	list_add_tail(&entry->list, entry->running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 3) run it (and print duration)*/
@@ -207,7 +207,7 @@ static async_cookie_t __async_schedule(a
 
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
-	return __async_schedule(ptr, data, &async_pending);
+	return __async_schedule(ptr, data, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
