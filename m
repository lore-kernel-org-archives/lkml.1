Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXFEUy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXFEUy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764584AbXFEUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:54:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58725 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764032AbXFEUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:54:48 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 5 Jun 2007 16:53:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: schwidefsky@de.ibm.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] S390: Replace calls to __get_free_pages() with __get_dma_pages().
Message-ID: <Pine.LNX.4.64.0706051650110.19661@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.646, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_CM 0.08, TW_VP 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace a number of calls to __get_free_pages() with the corresponding
calls to __get_dma_pages().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  once the __GFP_DMA argument is removed, it does look weird to see
the first argument of just 0.  should that be filled in with
GFP_ATOMIC as christopher lameter suggested?

  *not* compile tested.


 drivers/s390/block/dasd.c   |    2 +-
 drivers/s390/char/tty3270.c |    2 +-
 drivers/s390/cio/cmf.c      |    3 +--
 drivers/s390/net/claw.c     |   22 +++++++++++-----------
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index bfeca57..7e0f71d 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -77,7 +77,7 @@ dasd_alloc_device(void)
 	atomic_set(&device->open_count, -1);

 	/* Get two pages for normal block device operations. */
-	device->ccw_mem = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
+	device->ccw_mem = (void *) __get_dma_pages(GFP_ATOMIC, 1);
 	if (device->ccw_mem == NULL) {
 		kfree(device);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index bc33068..4fae5e2 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -699,7 +699,7 @@ tty3270_alloc_view(void)
 	INIT_LIST_HEAD(&tp->freemem);
 	for (pages = 0; pages < TTY3270_STRING_PAGES; pages++) {
 		tp->freemem_pages[pages] = (void *)
-			__get_free_pages(GFP_KERNEL|GFP_DMA, 0);
+			__get_dma_pages(GFP_KERNEL, 0);
 		if (!tp->freemem_pages[pages])
 			goto out_pages;
 		add_string_memory(&tp->freemem,
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 28abd69..4371224 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -585,8 +585,7 @@ alloc_cmb (struct ccw_device *cdev)
 		WARN_ON(!list_empty(&cmb_area.list));

 		spin_unlock(&cmb_area.lock);
-		mem = (void*)__get_free_pages(GFP_KERNEL | GFP_DMA,
-				 get_order(size));
+		mem = (void*)__get_dma_pages(GFP_KERNEL, get_order(size));
 		spin_lock(&cmb_area.lock);

 		if (cmb_area.mem) {
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index 6dd64d0..67ec924 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -2193,11 +2193,11 @@ init_ccw_bk(struct net_device *dev)
         */
         if (privptr->p_buff_ccw==NULL) {
                 privptr->p_buff_ccw=
-			(void *)__get_free_pages(__GFP_DMA,
+			(void *)__get_dma_pages(0,
 		        (int)pages_to_order_of_mag(ccw_pages_required ));
                 if (privptr->p_buff_ccw==NULL) {
                         printk(KERN_INFO "%s: %s()  "
-				"__get_free_pages for CCWs failed : "
+				"__get_dma_pages for CCWs failed : "
 				"pages is %d\n",
                                 dev->name,__FUNCTION__,
 				ccw_pages_required );
@@ -2349,10 +2349,10 @@ init_ccw_bk(struct net_device *dev)
         if (privptr->p_buff_write==NULL) {
             if (privptr->p_env->write_size < PAGE_SIZE) {
                 privptr->p_buff_write=
-			(void *)__get_free_pages(__GFP_DMA,
+			(void *)__get_dma_pages(0,
 			(int)pages_to_order_of_mag(claw_write_pages ));
                 if (privptr->p_buff_write==NULL) {
-                        printk(KERN_INFO "%s: %s() __get_free_pages for write"
+                        printk(KERN_INFO "%s: %s() __get_dma_pages for write"
 				" bufs failed : get is for %d pages\n",
                                 dev->name,__FUNCTION__,claw_write_pages );
                         free_pages((unsigned long)privptr->p_buff_ccw,
@@ -2408,17 +2408,17 @@ init_ccw_bk(struct net_device *dev)
            {
                privptr->p_write_free_chain=NULL;
                for (i = 0; i< privptr->p_env->write_buffers ; i++) {
-                   p_buff=(void *)__get_free_pages(__GFP_DMA,
+                   p_buff=(void *)__get_dma_pages(0,
 		        (int)pages_to_order_of_mag(
 			privptr->p_buff_pages_perwrite) );
 #ifdef IOTRACE
-                   printk(KERN_INFO "%s:%s __get_free_pages "
+                   printk(KERN_INFO "%s:%s __get_dma_pages "
 		    "for writes buf: get for %d pages\n",
 		    dev->name,__FUNCTION__,
 		    privptr->p_buff_pages_perwrite);
 #endif
                    if (p_buff==NULL) {
-                        printk(KERN_INFO "%s:%s __get_free_pages"
+                        printk(KERN_INFO "%s:%s __get_dma_pages"
 			 	"for writes buf failed : get is for %d pages\n",
 				dev->name,
 				__FUNCTION__,
@@ -2484,11 +2484,11 @@ init_ccw_bk(struct net_device *dev)
         if (privptr->p_buff_read==NULL) {
             if (privptr->p_env->read_size < PAGE_SIZE)  {
                 privptr->p_buff_read=
-			(void *)__get_free_pages(__GFP_DMA,
+			(void *)__get_dma_pages(0,
 			(int)pages_to_order_of_mag(claw_read_pages) );
                 if (privptr->p_buff_read==NULL) {
                         printk(KERN_INFO "%s: %s() "
-			 	"__get_free_pages for read buf failed : "
+			 	"__get_dma_pages for read buf failed : "
 			 	"get is for %d pages\n",
                                 dev->name,__FUNCTION__,claw_read_pages );
                         free_pages((unsigned long)privptr->p_buff_ccw,
@@ -2598,10 +2598,10 @@ init_ccw_bk(struct net_device *dev)
 		dev->name,__FUNCTION__);
 #endif
                 for (i=0 ; i< privptr->p_env->read_buffers ; i++) {
-                        p_buff = (void *)__get_free_pages(__GFP_DMA,
+                        p_buff = (void *)__get_dma_pages(0,
 				(int)pages_to_order_of_mag(privptr->p_buff_pages_perread) );
                         if (p_buff==NULL) {
-                                printk(KERN_INFO "%s: %s() __get_free_pages for read "
+                                printk(KERN_INFO "%s: %s() __get_dma_pages for read "
 					"buf failed : get is for %d pages\n",
 					dev->name,__FUNCTION__,
                                         privptr->p_buff_pages_perread );
 --
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
