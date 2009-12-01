Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZLAG4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZLAG4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLAG4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:56:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbZLAG4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:56:17 -0500
Date: Tue, 1 Dec 2009 07:56:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, steved@redhat.com,
       jens.axboe@oracle.com, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: [PATCH] slow-work: Fix build bug in the !CONFIG_MODULES case
Message-ID: <20091201065605.GA5361@elte.hu>
References: <13590.1258714119@redhat.com>
 <17633.1258758083@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17633.1258758083@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Hi Linus,
> 
> Could you pull the attached patches before 2.6.32 please?  I've added three
> one-liner patches to fix some silly bugs.
> 
> For the most part these patches are bug fixes for the slow-work, FS-Cache and
> CacheFiles facilities, with a few patches to produce better debugging
> information, and a couple of patches to slow work from Jens that all the rest
> are built on top of.

these slow-work changes have introduced a new !CONFIG_MODULES build bug 
on x86 (and all other architectures i suspect):

kernel/slow-work.c: In function ‘slow_work_execute’:
kernel/slow-work.c:313: error: ‘slow_work_thread_processing’ undeclared (first use in this function)
kernel/slow-work.c:313: error: (Each undeclared identifier is reported only once
kernel/slow-work.c:313: error: for each function it appears in.)
kernel/slow-work.c: In function ‘slow_work_wait_for_items’:
kernel/slow-work.c:950: error: ‘slow_work_unreg_sync_lock’ undeclared (first use in this function)
kernel/slow-work.c:951: error: ‘slow_work_unreg_wq’ undeclared (first use in this function)
kernel/slow-work.c:961: error: ‘slow_work_unreg_work_item’ undeclared (first use in this function)
kernel/slow-work.c:974: error: ‘slow_work_unreg_module’ undeclared (first use in this function)
kernel/slow-work.c:977: error: ‘slow_work_thread_processing’ undeclared (first use in this function)

Commit 3bde31a ("SLOW_WORK: Allow a requeueable work item to sleep till 
the thread is needed") broke the !CONFIG_MODULES build by relying on 
variables that are only available (and only make sense) with module 
support enabled. Fix it.

Note, to fix it in a minimal way for .32 i've simply extended the 
existing #ifdef's. In v2.6.33 a cleaner change would be to move the 
whole wait-for-modules block into a separate slow-work-wait-modules.c 
file or so - that will allow the removal of 6 #ifdefs.

Thanks,

	Ingo

--------------------------->
>From ac73995e9be78ba5dcf3db843d7e04295decabcd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 1 Dec 2009 07:47:52 +0100
Subject: [PATCH] slow-work: Fix build bug in the !CONFIG_MODULES case

Commit 3bde31a ("SLOW_WORK: Allow a requeueable work item to sleep till
the thread is needed") broke the !CONFIG_MODULES build by relying on
variables that are only available (and only make sense) with module
support enabled. Fix it.

Cc: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/slow-work.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index da94f3c..5bae807 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -310,7 +310,9 @@ auto_requeue:
 	else
 		list_add_tail(&work->link, &slow_work_queue);
 	spin_unlock_irq(&slow_work_queue_lock);
+#ifdef CONFIG_MODULES
 	slow_work_thread_processing[id] = NULL;
+#endif
 	return true;
 }
 
@@ -943,6 +945,7 @@ EXPORT_SYMBOL(slow_work_register_user);
  */
 static void slow_work_wait_for_items(struct module *module)
 {
+#ifdef CONFIG_MODULES
 	DECLARE_WAITQUEUE(myself, current);
 	struct slow_work *work;
 	int loop;
@@ -989,6 +992,7 @@ static void slow_work_wait_for_items(struct module *module)
 
 	remove_wait_queue(&slow_work_unreg_wq, &myself);
 	mutex_unlock(&slow_work_unreg_sync_lock);
+#endif
 }
 
 /**
