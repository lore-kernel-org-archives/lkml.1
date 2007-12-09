Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXLIDuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXLIDuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 22:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbXLIDuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 22:50:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbXLIDup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 22:50:45 -0500
Date: Sat, 8 Dec 2007 19:50:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jon Nelson" <jnelson@jamponi.net>
Cc: "Ed L. Cashin" <ecashin@coraid.com>, jnelson-kernel-bugzilla@jamponi.net,
       bugme-daemon@bugzilla.kernel.org, nickpiggin@yahoo.com.au,
       clameter@sgi.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       a.p.zijlstra@chello.nl
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-Id: <20071208195015.b4b22e35.akpm@linux-foundation.org>
In-Reply-To: <cccedfc60712081459u764de23ck953750fbdb391d16@mail.gmail.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/>
	<20071201122302.10dd9c44.akpm@linux-foundation.org>
	<20071203162137.GB25251@coraid.com>
	<20071203113459.d36c1a01.akpm@linux-foundation.org>
	<20071203210005.GB27094@coraid.com>
	<20071203213837.GE27094@coraid.com>
	<20071203144722.4188f476.akpm@linux-foundation.org>
	<20071203151349.0ebf497c.akpm@linux-foundation.org>
	<20071203234228.GG27094@coraid.com>
	<cccedfc60712081459u764de23ck953750fbdb391d16@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 16:59:30 -0600 "Jon Nelson" <jnelson@jamponi.net> wrote:

> I can confirm that 2.6.24rc4 with the (second) patch works fine.

OK, thanks.

We haven't heard back from Ed yet.   I'll sit on this for a few more days.


From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: <stable@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-properly-initialise-the-request_queues-backing_dev_info drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-properly-initialise-the-request_queues-backing_dev_info
+++ a/drivers/block/aoe/aoeblk.c
@@ -6,6 +6,7 @@
 
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
+#include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/genhd.h>
@@ -210,25 +211,20 @@ aoeblk_gdalloc(void *vp)
 	if (gd == NULL) {
 		printk(KERN_ERR "aoe: cannot allocate disk structure for %ld.%ld\n",
 			d->aoemajor, d->aoeminor);
-		spin_lock_irqsave(&d->lock, flags);
-		d->flags &= ~DEVFL_GDALLOC;
-		spin_unlock_irqrestore(&d->lock, flags);
-		return;
+		goto err;
 	}
 
 	d->bufpool = mempool_create_slab_pool(MIN_BUFS, buf_pool_cache);
 	if (d->bufpool == NULL) {
 		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%ld\n",
 			d->aoemajor, d->aoeminor);
-		put_disk(gd);
-		spin_lock_irqsave(&d->lock, flags);
-		d->flags &= ~DEVFL_GDALLOC;
-		spin_unlock_irqrestore(&d->lock, flags);
-		return;
+		goto err_disk;
 	}
 
-	spin_lock_irqsave(&d->lock, flags);
 	blk_queue_make_request(&d->blkq, aoeblk_make_request);
+	if (bdi_init(&d->blkq.backing_dev_info))
+		goto err_mempool;
+	spin_lock_irqsave(&d->lock, flags);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
@@ -246,6 +242,16 @@ aoeblk_gdalloc(void *vp)
 
 	add_disk(gd);
 	aoedisk_add_sysfs(d);
+	return;
+
+err_mempool:
+	mempool_destroy(d->bufpool);
+err_disk:
+	put_disk(gd);
+err:
+	spin_lock_irqsave(&d->lock, flags);
+	d->flags &= ~DEVFL_GDALLOC;
+	spin_unlock_irqrestore(&d->lock, flags);
 }
 
 void
_

