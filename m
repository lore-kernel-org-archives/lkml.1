Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXEaVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXEaVYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXEaVYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:24:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbXEaVYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:24:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] Freezer: migration_thread should not be freezable (was: Re: [linux-pm] Re: 2.6.22-rc3-mm1)
Date: Thu, 31 May 2007 23:30:08 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <465EE9F2.8080905@googlemail.com> <200705312158.26560.rjw@sisk.pl>
In-Reply-To: <200705312158.26560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705312330.09157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 May 2007 21:58, Rafael J. Wysocki wrote:
> On Thursday, 31 May 2007 17:29, Michal Piotrowski wrote:
> > Hi,
> > 
> > Andrew Morton napisał(a):
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> > > 
> > 
> > FYI suspend to disk doesn't work anymore on my box, system hangs after "Suspending console(s)" message.
> > 
> > [  186.297753] Shrinking memory...  -\|/-\|done (113064 pages freed)
> > [  187.841914] Freed 452256 kbytes in 1.54 seconds (293.67 MB/s)
> > [  187.847730] Suspending console(s)
> > 
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/console.log
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/mm-config
> 
> Hmm, that might be a couple of things, actually.
> 
> To see if the patches directly related to hibernation/suspend cause this, can
> you please test 2.6.22-rc3 with the patch series at
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/
> 
> applied?

Ahem, I broke it. :-(

Andrew, the following fix is needed on top of
freezer-make-kernel-threads-nonfreezable-by-default.patch

---
From: Rafael J. Wysocki <rjw@sisk.pl>

migration_thread should not be freezable, or it will break hibernation and
suspend on SMP.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/sched.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.22-rc3/kernel/sched.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/sched.c
+++ linux-2.6.22-rc3/kernel/sched.c
@@ -5157,13 +5157,10 @@ static int migration_thread(void *data)
 	BUG_ON(rq->migration_thread != current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	set_freezable();
 	while (!kthread_should_stop()) {
 		struct migration_req *req;
 		struct list_head *head;
 
-		try_to_freeze();
-
 		spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
