Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbXBEQCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbXBEQCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXBEQCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:02:14 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48421 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXBEQCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:02:13 -0500
Date: Mon, 5 Feb 2007 17:00:56 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm][AIO] Fix AIO completion signal notification possible
 ref leak
Message-ID: <20070205170056.6a29b19b@frecb000686>
In-Reply-To: <20070205134314.GA283@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
	<20070205131839.6f601c3e@frecb000686>
	<20070205134314.GA283@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 17:03:16,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 17:03:17,
	Serialize complete at 05/02/2007 17:03:17
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Andrew,

  here is an incremental patch to fix a possible ref leak when users
do weird things with the ->sigev_notify flags.

  Thanks Oleg for spotting this.

  Sébastien.


From: Sébastien Dugué <sebastien.dugue@bull.net>

         Fix AIO completion signal notification possible ref leak

  Make sure we only accept valid sigev_notify values in aio_setup_sigevent(),
namely SIGEV_NONE, SIGEV_THREAD_ID or SIGEV_SIGNAL.

 aio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>


Index: linux-2.6.20-rc6-mm3/fs/aio.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/fs/aio.c	2007-02-05 16:50:27.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/aio.c	2007-02-05 16:53:43.000000000 +0100
@@ -939,7 +939,7 @@ static int aio_send_signal(struct aio_no
 	info->si_uid = 0;
 	info->si_value = notify->value;
 
-	if (notify->notify & SIGEV_THREAD_ID)
+	if (notify->notify == SIGEV_THREAD_ID)
 		ret = send_sigqueue(notify->signo, sigq, notify->target);
 	else
 		ret = send_group_sigqueue(notify->signo, sigq, notify->target);
@@ -959,6 +959,10 @@ static long aio_setup_sigevent(struct ai
 	if (event.sigev_notify == SIGEV_NONE)
 		return 0;
 
+	if (event.sigev_notify != SIGEV_SIGNAL &&
+	    event.sigev_notify != SIGEV_THREAD_ID)
+		return -EINVAL;
+
 	notify->notify = event.sigev_notify;
 	notify->signo = event.sigev_signo;
 	notify->value = event.sigev_value;
