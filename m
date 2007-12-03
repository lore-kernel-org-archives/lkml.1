Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbXLCWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbXLCWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXLCWsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:48:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXLCWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:48:07 -0500
Date: Mon, 3 Dec 2007 14:47:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Message-Id: <20071203144722.4188f476.akpm@linux-foundation.org>
In-Reply-To: <20071203213837.GE27094@coraid.com>
References: <bug-9482-10286@http.bugzilla.kernel.org/>
	<20071201122302.10dd9c44.akpm@linux-foundation.org>
	<20071203162137.GB25251@coraid.com>
	<20071203113459.d36c1a01.akpm@linux-foundation.org>
	<20071203210005.GB27094@coraid.com>
	<20071203213837.GE27094@coraid.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 16:38:37 -0500
"Ed L. Cashin" <ecashin@coraid.com> wrote:

> >   --- lx/lib/percpu_counter.c.20071130    2007-12-03 15:43:19.000000000 -0500
> >   +++ lx/lib/percpu_counter.c     2007-12-03 15:47:38.000000000 -0500
> >   @@ -33,7 +33,9 @@ void __percpu_counter_add(struct percpu_
> >           s64 count;
> >           s32 *pcount;
> >           int cpu = get_cpu();
> >   +       u64 badval = 0xffffffffffffffffULL;
> >    
> >   +       BUG_ON(!cpu_possible(cpu));
> >           pcount = per_cpu_ptr(fbc->counters, cpu);
> >           count = *pcount + amount;
> >           if (count >= batch || count <= -batch) {
> 
> It appears that the fbc->counters pointer is NULL.

Does this fix?

--- a/drivers/block/aoe/aoeblk.c~a
+++ a/drivers/block/aoe/aoeblk.c
@@ -6,6 +6,7 @@
 
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
+#include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/genhd.h>
@@ -228,6 +229,7 @@ aoeblk_gdalloc(void *vp)
 
 	spin_lock_irqsave(&d->lock, flags);
 	blk_queue_make_request(&d->blkq, aoeblk_make_request);
+	bdi_init(&d->blkq.backing_dev_info);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
_


<wonders whether blk_queue_make_request() should be running bdi_init()?>
