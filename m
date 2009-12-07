Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbZLGOuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbZLGOuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbZLGOuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:50:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51214 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476AbZLGOuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:50:10 -0500
Date: Mon, 7 Dec 2009 14:50:11 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel problem
Message-ID: <20091207145011.GA14743@csn.ul.ie>
References: <web-100877149@zbackend1.aha.ru> <20091204154109.GB1716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091204154109.GB1716@goodmis.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 10:41:09AM -0500, Steven Rostedt wrote:
> [ Added Cc's of people that may be interested in this ]
> > <SNIP>
> > ------------[ cut here ]------------
> > WARNING: at mm/page_alloc.c:1805
> > __alloc_pages_nodemask+0x127/0x48f()
> > Hardware name: System Product Name
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
> > Call Trace:
> >  [<c103d94b>] warn_slowpath_common+0x65/0x95
> >  [<c103d98d>] warn_slowpath_null+0x12/0x15
> >  [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
> >  [<c10be964>] ? get_slab+0x8/0x50
> >  [<c10b8979>] alloc_page_interleave+0x2e/0x6e
> >  [<c10b8a10>] alloc_pages_current+0x57/0x99
> >  [<c2083a4a>] ? xd_init+0x0/0x482
> >  [<c1094c38>] __get_free_pages+0xd/0x1e
> >  [<c2083a94>] xd_init+0x4a/0x482
> >  [<c2082df0>] ? loop_init+0x104/0x16a
> >  [<c169162d>] ? loop_probe+0x0/0xaf
> >  [<c2083a4a>] ? xd_init+0x0/0x482
> >  [<c1001143>] do_one_initcall+0x51/0x13f
> >  [<c204a307>] kernel_init+0x10b/0x15f
> >  [<c204a1fc>] ? kernel_init+0x0/0x15f
> >  [<c1004347>] kernel_thread_helper+0x7/0x10
> > ---[ end trace 686db6333ade6e7a ]---
> > xd: Out of memory.

First off, it would appear that every block driver under the sun is
being loaded. I seriously doubt this controller really exists in the
machine.

Second, it's a real warning as the driver is trying to allocate a buffer of
size 0 which get_order() chokes on. For bonus points, it tries to allocate
a buffer before it knows what size it should be. This patch should resolve
the problem but because I don't have the hardware to test it on, it could
do with a second set of eyes just to be sure the rejigged logic makes sense.

If this is ok, what is the appropriate submission path for unmaintained
block drivers? Is it the block maintainer or someone else?

==== CUT HERE ====
block,xd: Delay allocation of DMA buffers until device is known

Loading the XD module triggers a warning like

 WARNING: at mm/page_alloc.c:1805
 __alloc_pages_nodemask+0x127/0x48f()
 Hardware name: System Product Name
 Modules linked in:
 Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
 Call Trace:
  [<c103d94b>] warn_slowpath_common+0x65/0x95
  [<c103d98d>] warn_slowpath_null+0x12/0x15
  [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
  [<c10be964>] ? get_slab+0x8/0x50
  [<c10b8979>] alloc_page_interleave+0x2e/0x6e
  [<c10b8a10>] alloc_pages_current+0x57/0x99
  [<c2083a4a>] ? xd_init+0x0/0x482
  [<c1094c38>] __get_free_pages+0xd/0x1e
  [<c2083a94>] xd_init+0x4a/0x482
  [<c2082df0>] ? loop_init+0x104/0x16a
  [<c169162d>] ? loop_probe+0x0/0xaf
  [<c2083a4a>] ? xd_init+0x0/0x482
  [<c1001143>] do_one_initcall+0x51/0x13f
  [<c204a307>] kernel_init+0x10b/0x15f
  [<c204a1fc>] ? kernel_init+0x0/0x15f
  [<c1004347>] kernel_thread_helper+0x7/0x10
 ---[ end trace 686db6333ade6e7a ]---
 xd: Out of memory.

The warning is because the alloc_pages is called with an
order >= MAX_ORDER. The simplistic reason is that get_order(0) returns garbage
values when given 0 as a size. The more complex reason is that the XD driver
initialisation is broken.

It's not clear why this ever worked. XD allocates a buffer for DMA based
on the value of xd_maxsectors. This value is determined by the exact
type of controller in use but the value is determined *after* an attempt
has been made to allocate the buffer. i.e. the requested size of the DMA
buffer will always be 0.

This patch alters how XD is initialised slightly by allocating the
buffer when and if a device has actually been detected. The error paths
are updated to suit the new logic.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 drivers/block/xd.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 0877d36..d1fd032 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -169,13 +169,6 @@ static int __init xd_init(void)
 
 	init_timer (&xd_watchdog_int); xd_watchdog_int.function = xd_watchdog;
 
-	if (!xd_dma_buffer)
-		xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
-	if (!xd_dma_buffer) {
-		printk(KERN_ERR "xd: Out of memory.\n");
-		return -ENOMEM;
-	}
-
 	err = -EBUSY;
 	if (register_blkdev(XT_DISK_MAJOR, "xd"))
 		goto out1;
@@ -202,6 +195,19 @@ static int __init xd_init(void)
 			xd_drives,xd_drives == 1 ? "" : "s",xd_irq,xd_dma);
 	}
 
+	/*
+	 * With the drive detected, xd_maxsectors should now be known.
+	 * If xd_maxsectors is 0, nothing was detected and we fall through
+	 * to return -ENODEV
+	 */
+	if (!xd_dma_buffer && xd_maxsectors) {
+		xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
+		if (!xd_dma_buffer) {
+			printk(KERN_ERR "xd: Out of memory.\n");
+			goto out3;
+		}
+	}
+
 	err = -ENODEV;
 	if (!xd_drives)
 		goto out3;
@@ -249,15 +255,17 @@ out4:
 	for (i = 0; i < xd_drives; i++)
 		put_disk(xd_gendisk[i]);
 out3:
-	release_region(xd_iobase,4);
+	if (xd_maxsectors)
+		release_region(xd_iobase,4);
+
+	if (xd_dma_buffer)
+		xd_dma_mem_free((unsigned long)xd_dma_buffer,
+				xd_maxsectors * 0x200);
 out2:
 	blk_cleanup_queue(xd_queue);
 out1a:
 	unregister_blkdev(XT_DISK_MAJOR, "xd");
 out1:
-	if (xd_dma_buffer)
-		xd_dma_mem_free((unsigned long)xd_dma_buffer,
-				xd_maxsectors * 0x200);
 	return err;
 Enomem:
 	err = -ENOMEM;
