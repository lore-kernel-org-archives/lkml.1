Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZIOXFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZIOXFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZIOXFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:05:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:9342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZIOXFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,392,1249282800"; 
   d="scan'208";a="550901867"
Subject: Re: 2.6.31rc5 RAID10 lockdep report - sysfs_nofity_dirent locking
	issue
From: Dan Williams <dan.j.williams@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Neil Brown <neilb@suse.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20090915222511.GA13600@suse.de>
References: <20090804141425.GA2831@redhat.com>
	 <58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
	 <20090804212404.GA26390@suse.de> <19066.28054.65288.171564@notabene.brown>
	 <e9c3a7c20909151512y48d066a9m71d4bb92e34b5294@mail.gmail.com>
	 <20090915222511.GA13600@suse.de>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 16:05:51 -0700
Message-Id: <1253055951.20787.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1ee8b5bfeb2de765d3b2acbaf5357c4c0eb65dbe Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 6 Aug 2009 15:42:08 +1000
Subject: [PATCH] Allow sysfs_notify_dirent to be called from interrupt context.

sysfs_notify_dirent is a simple atomic operation that can be used to
alert user-space that new data can be read from a sysfs attribute.

Unfortunately it cannot currently be called from non-process context
because of its use of spin_lock which is sometimes taken with
interrupts enabled.

So change all lockers of sysfs_open_dirent_lock to disable interrupts,
thus making sysfs_notify_dirent safe to be called from non-process
context (as drivers/md does in md_safemode_timeout).

sysfs_get_open_dirent is (documented as being) only called from
process context, so it uses spin_lock_irq.  Other places
use spin_lock_irqsave.

The usage for sysfs_notify_dirent in md_safemode_timeout was
introduced in 2.6.28, so this patch is suitable for that and more
recent kernels.

Cc: <stable@kernel.org>
Reported-by: Joel Andres Granados <jgranado@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
> > Greg?
> > 
> > Looks like this never made it upstream, and now Hans is hitting this
> > in his tests.
> 
> Ok, I don't have this in my queue, so someone needs to resubmit it and
> tell me what kernel trees it should be applicable for.

As mentioned in the commit log should be applicable back to 2.6.28.

Thanks,
Dan


 fs/sysfs/file.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 561a9c0..f5ea468 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -268,7 +268,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	struct sysfs_open_dirent *od, *new_od = NULL;
 
  retry:
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irq(&sysfs_open_dirent_lock);
 
 	if (!sd->s_attr.open && new_od) {
 		sd->s_attr.open = new_od;
@@ -281,7 +281,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 		list_add_tail(&buffer->list, &od->buffers);
 	}
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irq(&sysfs_open_dirent_lock);
 
 	if (od) {
 		kfree(new_od);
@@ -315,8 +315,9 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 				  struct sysfs_buffer *buffer)
 {
 	struct sysfs_open_dirent *od = sd->s_attr.open;
+	unsigned long flags;
 
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	list_del(&buffer->list);
 	if (atomic_dec_and_test(&od->refcnt))
@@ -324,7 +325,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	else
 		od = NULL;
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 
 	kfree(od);
 }
@@ -456,8 +457,9 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 void sysfs_notify_dirent(struct sysfs_dirent *sd)
 {
 	struct sysfs_open_dirent *od;
+	unsigned long flags;
 
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	od = sd->s_attr.open;
 	if (od) {
@@ -465,7 +467,7 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 		wake_up_interruptible(&od->poll);
 	}
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 }
 EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
 
-- 
1.6.0.6



