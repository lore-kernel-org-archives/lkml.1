Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXCUVfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXCUVfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXCUVfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:35:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbXCUVfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:35:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Wed, 21 Mar 2007 22:38:33 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       David Chinner <dgc@sgi.com>
References: <200703211840.53242.maximlevitsky@gmail.com> <1174512160.6665.97.camel@nigel.suspend2.net>
In-Reply-To: <1174512160.6665.97.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212238.33897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 March 2007 22:22, Nigel Cunningham wrote:
> Hi.
> 
> On Wed, 2007-03-21 at 18:40 +0200, Maxim Levitsky wrote:
> > Hi,
> > 
> > Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> > 
> > I did a git-bisect and found that those commits break it:
> > 
> > e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> > ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> > 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> > 
> > I already reported about it, but now i know the reason why suspend breaks.
> > 
> > The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> > and it did work because those functions could be called only in process context
> > (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> > 
> > But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> > that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> > 
> > I tested this and all results are positive:
> > 
> > I disabled 2nd cpu by hand, and then suspend to ram was successfull.
> > Suspend to disk went correctly, but it hang on resume, and I know why.
> > It hang in old kernel trying to disable 2nd cpu that was enabled by it.
> > 
> > I was able using kdb to confirm that this is true because it was still possible to enter kdb, and see that
> > idle thread (swapper) was active, and uswsusp was waiting on mutex inside workqueue_cpu_callback.
> > 
> > The solution for this problem seems to be ether complete audit of code that uses register_cpu_notifier,
> > to ensure that it doesn't sleep. 
> > Also documentation should be changed to note about it.
> > 
> > Or, it is also possible to revert this change.
> 
> Do you know exactly which mutex was being waited on and where it was
> taken? If you can say that, it would be much more helpful.

I think this is the XFS problem with freezable workqueues.

Maxim, please try to apply the appended patch and see if it helps.

Greetings,
Rafael


---
Since freezable workqueues are broken in 2.6.21-rc
(cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
it's better to remove them altogether for 2.6.21 and change the only user of
them (XFS) accordingly.

---
 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.21-rc4.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
@@ -1829,11 +1829,11 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
-	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
+	xfslogd_workqueue = create_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
+	xfsdatad_workqueue = create_workqueue("xfsdatad");
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
