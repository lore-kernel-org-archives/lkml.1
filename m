Return-Path: <linux-kernel-owner+w=401wt.eu-S1422720AbXBAJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422720AbXBAJkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422723AbXBAJjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:39:35 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35845 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422716AbXBAJjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:39:16 -0500
Date: Thu, 1 Feb 2007 10:31:30 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-aio <linux-aio@kvack.org>,
       Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm 5/7][AIO] - Make __sigqueue_free() and
 __sigqueue_alloc() non static
Message-ID: <20070201103130.406d90cd@frecb000686>
In-Reply-To: <20070201102252.240130c6@frecb000686>
References: <20070201102252.240130c6@frecb000686>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:04,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:10,
	Serialize complete at 01/02/2007 10:40:10
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sébastien Dugué <sebastien.dugue@bull.net>

             Make __sigqueue_alloc() and __sigqueue_free() non static

  Allow subsystems to directly call into __sigqueue_alloc() and __sigqueue_free.
This is used by the AIO signal notification patch.


 include/linux/signal.h |    3 +++
 kernel/signal.c        |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>


Index: linux-2.6.20-rc6-mm3/include/linux/signal.h
===================================================================
--- linux-2.6.20-rc6-mm3.orig/include/linux/signal.h	2007-01-30 11:41:36.000000000 +0100
+++ linux-2.6.20-rc6-mm3/include/linux/signal.h	2007-01-30 11:41:39.000000000 +0100
@@ -241,6 +241,9 @@ extern int sigprocmask(int, sigset_t *, 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern struct task_struct * sigevent_find_task(sigevent_t *);
+extern struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
+					 int override_rlimit);
+extern void __sigqueue_free(struct sigqueue *q);
 
 extern struct kmem_cache *sighand_cachep;
 
Index: linux-2.6.20-rc6-mm3/kernel/signal.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/kernel/signal.c	2007-01-30 11:41:36.000000000 +0100
+++ linux-2.6.20-rc6-mm3/kernel/signal.c	2007-01-30 11:41:39.000000000 +0100
@@ -268,8 +268,8 @@ next_signal(struct sigpending *pending, 
 	return sig;
 }
 
-static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
-					 int override_rlimit)
+struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
+				  int override_rlimit)
 {
 	struct sigqueue *q = NULL;
 	struct user_struct *user;
@@ -295,7 +295,7 @@ static struct sigqueue *__sigqueue_alloc
 	return(q);
 }
 
-static void __sigqueue_free(struct sigqueue *q)
+void __sigqueue_free(struct sigqueue *q)
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
