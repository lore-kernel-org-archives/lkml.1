Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXBFJYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXBFJYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXBFJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:24:13 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49893 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXBFJYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:24:12 -0500
Date: Tue, 6 Feb 2007 10:22:53 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm][AIO] AIO completion signal notification fixes and
 cleanups
Message-ID: <20070206102253.20b121ae@frecb000686>
In-Reply-To: <20070205171335.GA528@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
	<20070205131839.6f601c3e@frecb000686>
	<20070205134314.GA283@tv-sign.ru>
	<20070205170056.6a29b19b@frecb000686>
	<20070205171335.GA528@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 10:25:16,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 10:25:17,
	Serialize complete at 06/02/2007 10:25:17
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Andrew, here is another incremental patch which does a bit of cleanup
as well as fixing a possible release on a task ref that was not taken.

  Thanks,

  Sébastien.


From: Sébastien Dugué <sebastien.dugue@bull.net>

	AIO completion signal notification misc fixes and cleanups

  This patches cleans up the notification path and fixes a possible
release on a task ref that was not taken in aio_setup_sigevent().


 aio.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>


Index: linux-2.6.20-rc6-mm3/fs/aio.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/fs/aio.c	2007-02-05 16:53:43.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/aio.c	2007-02-06 09:33:55.000000000 +0100
@@ -469,8 +469,7 @@ static inline void really_put_req(struct
 		kfree(req->ki_iovec);
 
 	/* Release task ref */
-	if (req->ki_notify.notify == SIGEV_THREAD_ID ||
-	    req->ki_notify.notify == SIGEV_SIGNAL)
+	if (req->ki_notify.notify != SIGEV_NONE)
 		put_task_struct(req->ki_notify.target);
 
 	kmem_cache_free(kiocb_cachep, req);
@@ -970,8 +969,14 @@ static long aio_setup_sigevent(struct ai
 	rcu_read_lock();
 	target = sigevent_find_task(&event);
 
-	if (unlikely(!target))
+	if (unlikely(!target)) {
+		/*
+		 * Revert notify to SIGEV_NONE so that really_put_req()
+		 * knows that no ref has been taken on a task.
+		 */
+		notify->notify = SIGEV_NONE;
 		goto out_unlock;
+	}
 
 	/*
 	 * At this point, we know that notify is either SIGEV_SIGNAL or
@@ -996,7 +1001,7 @@ static long aio_setup_sigevent(struct ai
 	return 0;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return -EINVAL;
 }
 
@@ -1763,7 +1768,7 @@ int fastcall io_submit_one(struct kioctx
 					 (struct sigevent __user *)(unsigned long)
 					 iocb->aio_sigeventp);
 		if (ret)
-			goto out_put_req;
+			goto out_sigqfree;
 	}
 
 	/* Attach this iocb to its lio */
