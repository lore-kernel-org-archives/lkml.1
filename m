Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZAMRq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZAMRq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZAMRqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:46:47 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:59177 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZAMRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:46:46 -0500
Date: Tue, 13 Jan 2009 18:46:43 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] async: Handle kthread_run() return codes.
Message-ID: <20090113184643.0614470d@gondolin>
In-Reply-To: <20090113165115.GR12431@fluff.org.uk>
References: <20090113174304.2186532c@gondolin>
	<20090113165115.GR12431@fluff.org.uk>
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

On Tue, 13 Jan 2009 16:51:15 +0000,
Ben Dooks <ben-linux@fluff.org> wrote:

> > @@ -315,11 +315,14 @@ static int async_manager_thread(void *un
> >  		ec = atomic_read(&entry_count);
> >  
> >  		while (tc < ec && tc < MAX_THREADS) {
> 
> why not add the following to stop the wrapping of kthread_run:
> 
> +   	    		struct task_struct *kt;
> 			kt = kthread_run(async_thread, NULL, "async/%i", tc);

Hm, I don't think avoiding wrapping is worth adding another variable.

> 			if (IS_ERR(kt))
> 				goto schedule;
> 
> also, I belive the goto isn't necessary, just break out of the while
> 
> 			if (IS_ERR(kt))
> 				break;

OK, that's a bit nicer. Updated patch follows.


If we fail to create the manager thread, fall back to non-fastboot.
If we fail to create an async thread, try again when the manager
thread runs again.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 kernel/async.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -315,7 +315,10 @@ static int async_manager_thread(void *un
 		ec = atomic_read(&entry_count);
 
 		while (tc < ec && tc < MAX_THREADS) {
-			kthread_run(async_thread, NULL, "async/%i", tc);
+			if (IS_ERR(kthread_run(async_thread, NULL, "async/%i",
+					       tc)))
+				/* Try again later. */
+				break;
 			atomic_inc(&thread_count);
 			tc++;
 		}
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
 

