Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZGYV6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZGYV6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZGYV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:58:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZGYV6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:58:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: PM/hibernate swapfile regression
Date: Sat, 25 Jul 2009 23:58:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       "Hans-Joachim Picht" <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arnd Schneider <arnd@de.ibm.com>, linux-fsdevel@vger.kernel.org
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <4A659D75.3050004@tuffmail.co.uk> <20090721215536.GA9502@infradead.org>
In-Reply-To: <20090721215536.GA9502@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252358.26434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Christoph Hellwig wrote:
> On Tue, Jul 21, 2009 at 11:50:29AM +0100, Alan Jenkins wrote:
> > +struct block_device *bdcopy(struct block_device *bdev)
> > +{
> > +	atomic_inc(&bdev->bd_inode->i_count);
> > +	return bdev;
> > +}
> > +
> > +EXPORT_SYMBOL(bdcopy);
> 
> The function name doesn't make any sense.  You don't copy anything
> here, but you grab a reference to it.  A better name would be bdgrab,
> mirroing the names of functions like igrab.  A kerneldoc comment
> documenting it would also be very helpful.
> 
> Why do you export it?  The swapfile code is not actually modular.

Thanks for the comments.  Does the one below look better?

Rafael

---
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: PM / Hibernate: Replace bdget call with simple atomic_inc of i_count

Create bdgrab().  This function copies an existing reference to a
block_device.  It is safe to call from any context.

Hibernation code wishes to copy a reference to the active swap device.
Right now it calls bdget() under a spinlock, but this is wrong because
bdget() can sleep.  It doesn't need a full bdget() because we already
hold a reference to active swap devices (and the spinlock protects
against swapoff).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/block_dev.c     |   10 ++++++++++
 include/linux/fs.h |    1 +
 mm/swapfile.c      |    4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -564,6 +564,16 @@ struct block_device *bdget(dev_t dev)
 
 EXPORT_SYMBOL(bdget);
 
+/**
+ * bdgrab -- Grab a reference to an already referenced block device
+ * @bdev:	Block device to grab a reference to.
+ */
+struct block_device *bdgrab(struct block_device *bdev)
+{
+	atomic_inc(&bdev->bd_inode->i_count);
+	return bdev;
+}
+
 long nr_blockdev_pages(void)
 {
 	struct block_device *bdev;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1946,6 +1946,7 @@ extern void putname(const char *name);
 extern int register_blkdev(unsigned int, const char *);
 extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
+extern struct block_device *bdgrab(struct block_device *bdev);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c
+++ linux-2.6/mm/swapfile.c
@@ -753,7 +753,7 @@ int swap_type_of(dev_t device, sector_t 
 
 		if (!bdev) {
 			if (bdev_p)
-				*bdev_p = bdget(sis->bdev->bd_dev);
+				*bdev_p = bdgrab(sis->bdev);
 
 			spin_unlock(&swap_lock);
 			return i;
@@ -765,7 +765,7 @@ int swap_type_of(dev_t device, sector_t 
 					struct swap_extent, list);
 			if (se->start_block == offset) {
 				if (bdev_p)
-					*bdev_p = bdget(sis->bdev->bd_dev);
+					*bdev_p = bdgrab(sis->bdev);
 
 				spin_unlock(&swap_lock);
 				bdput(bdev);
