Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZGUKui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZGUKui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZGUKui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:50:38 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:61932 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZGUKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FJbN357SYaGnIw+7TmFMD56NAKZpRnRXZFjkvowJRJFe2UJDDZkFNm0KTUMc4uKQXH
         vyOj7A3Mhk8+1MAqGi+UlLDIgYnvNsOM8Hig/kbcRDmrNBz2b/aOIjr9P9QLxjeqtYr/
         4j74w6VdJ0nm9c1WH2B6WzAMHYrmTxTHPWdL8=
Message-ID: <4A659D75.3050004@tuffmail.co.uk>
Date: Tue, 21 Jul 2009 11:50:29 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arnd Schneider <arnd@de.ibm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: PM/hibernate swapfile regression
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <200907141821.06101.rjw@sisk.pl> <4A6077DE.6060202@tuffmail.co.uk> <20090720132456.GA29023@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090720132456.GA29023@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Fri, Jul 17, 2009 at 02:08:46PM +0100, Alan Jenkins wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> On Tuesday 14 July 2009, Heiko Carstens wrote:
>>>   
>>>       
>>>> We've seen this bug [...]
>>>>
>>>> Looks like this was introduced with git commit a1bb7d61 "PM/hibernate: fix "swap
>>>> breaks after hibernation failures"".
>>>> Calling bdget while holding a spinlock doesn't seem to be a good idea...
>>>>     
>>>>         
>>> Agreed, sorry for missing that.
>>>
>>> Alan, can you please prepare a fix?
>>>       
>> Here's a quick & dirty patch [...]
>>     
>
> Thanks for the patch. Unfortunately Arnd was unable to reproduce the original
> behaviour. But your patch makes sense anyway.
> I also tested it and nothing broke. So should this go upstream?  

I do want to fix it, but I think there's a better way.

It doesn't really need the sleeping bdget().  All we want is
atomic_inc(&bdev->bd_inode->i_count).  I think we should call it bdcopy().

---------->
>From 643014ec079610a8b01dfd78c6949c1e8727195b Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Tue, 21 Jul 2009 10:17:30 +0100
Subject: [PATCH] PM/hibernate: replace bdget call with bdcopy (simple atomic_inc of i_count)

Create bdcopy().  This function copies an existing reference to a
block_device.  It is safe to call from any context.

Hibernation code wishes to copy a reference to the active swap device.
Right now it calls bdget() under a spinlock, but this is wrong because
bdget() can sleep.  It doesn't need a full bdget() because we already
hold a reference to active swap devices (and the spinlock protects
against swapoff).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-fsdevel@vger.kernel.org
---
 fs/block_dev.c     |    8 ++++++++
 include/linux/fs.h |    1 +
 mm/swapfile.c      |    4 ++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3a6d4fb..0b04974 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -564,6 +564,14 @@ struct block_device *bdget(dev_t dev)
 
 EXPORT_SYMBOL(bdget);
 
+struct block_device *bdcopy(struct block_device *bdev)
+{
+	atomic_inc(&bdev->bd_inode->i_count);
+	return bdev;
+}
+
+EXPORT_SYMBOL(bdcopy);
+
 long nr_blockdev_pages(void)
 {
 	struct block_device *bdev;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0872372..eeb1091 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1946,6 +1946,7 @@ extern void putname(const char *name);
 extern int register_blkdev(unsigned int, const char *);
 extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
+extern struct block_device *bdcopy(struct block_device *bdev);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d1ade1a..272ea8e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -753,7 +753,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 
 		if (!bdev) {
 			if (bdev_p)
-				*bdev_p = bdget(sis->bdev->bd_dev);
+				*bdev_p = bdcopy(sis->bdev);
 
 			spin_unlock(&swap_lock);
 			return i;
@@ -765,7 +765,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 					struct swap_extent, list);
 			if (se->start_block == offset) {
 				if (bdev_p)
-					*bdev_p = bdget(sis->bdev->bd_dev);
+					*bdev_p = bdcopy(sis->bdev);
 
 				spin_unlock(&swap_lock);
 				bdput(bdev);
-- 
1.6.3.2



