Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXBFL6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXBFL6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXBFL6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:58:30 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33975 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbXBFL63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:58:29 -0500
Date: Tue, 6 Feb 2007 12:57:09 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm][AIO] AIO completion signal notification small cleanup
Message-ID: <20070206125709.1ec67113@frecb000686>
In-Reply-To: <20070206110539.GA129@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
	<20070205131839.6f601c3e@frecb000686>
	<20070205134314.GA283@tv-sign.ru>
	<20070205170056.6a29b19b@frecb000686>
	<20070205171335.GA528@tv-sign.ru>
	<20070206102253.20b121ae@frecb000686>
	<20070206110539.GA129@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 12:59:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 12:59:35,
	Serialize complete at 06/02/2007 12:59:35
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Andrew, one more cleanup to aio_setup_sigevent() to make it more readable.

  Sébastien.


From: Sébastien Dugué <sebastien.dugue@bull.net>

	AIO completion signal notification small cleanup

  This patch cleans up aio_setup_sigevent() to make it more readable.

 aio.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>


Index: linux-2.6.20-rc6-mm3/fs/aio.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/fs/aio.c	2007-02-06 09:33:55.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/aio.c	2007-02-06 12:43:52.000000000 +0100
@@ -962,21 +962,11 @@ static long aio_setup_sigevent(struct ai
 	    event.sigev_notify != SIGEV_THREAD_ID)
 		return -EINVAL;
 
-	notify->notify = event.sigev_notify;
-	notify->signo = event.sigev_signo;
-	notify->value = event.sigev_value;
-
 	rcu_read_lock();
 	target = sigevent_find_task(&event);
 
-	if (unlikely(!target)) {
-		/*
-		 * Revert notify to SIGEV_NONE so that really_put_req()
-		 * knows that no ref has been taken on a task.
-		 */
-		notify->notify = SIGEV_NONE;
+	if (unlikely(!target))
 		goto out_unlock;
-	}
 
 	/*
 	 * At this point, we know that notify is either SIGEV_SIGNAL or
@@ -988,6 +978,9 @@ static long aio_setup_sigevent(struct ai
 	notify->target = target;
 	rcu_read_unlock();
 
+	notify->notify = event.sigev_notify;
+	notify->signo = event.sigev_signo;
+	notify->value = event.sigev_value;
 	notify->sigq = __sigqueue_alloc(current, GFP_KERNEL, 0);
 
 	/*
