Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYBGHUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYBGHUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbYBGHT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:19:58 -0500
Received: from mx1.suse.de ([195.135.220.2]:54694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389AbYBGHT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:19:56 -0500
Date: Wed, 6 Feb 2008 23:18:07 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207071807.GA13866@suse.de>
References: <20080207064210.GA22896@suse.de> <20080206.223944.200455039.davem@davemloft.net> <20080207070044.GA4851@suse.de> <20080206.231144.174648341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.231144.174648341.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:11:44PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 23:00:44 -0800
> 
> > On Wed, Feb 06, 2008 at 10:39:44PM -0800, David Miller wrote:
> > > From: Greg KH <gregkh@suse.de>
> > > Date: Wed, 6 Feb 2008 22:42:10 -0800
> > > 
> > > > On Wed, Feb 06, 2008 at 10:05:44PM -0800, David Miller wrote:
> > > > > I found the problem, it's the "whole_disk" partition attribute.
> > > > 
> > > > I don't understand that code at all, on 2.6.24, what does reading that
> > > > file give you?  At first glance, I don't see how that file would spit
> > > > out anything and not give you the same kind of oops.
> > > > 
> > > > you are in a maze of kobject pointers, all alike...
> > > 
> > > It's supposed to just exist, and be an empty zero length file.
> > > That's why it's given no ->show method pointer.
> > > 
> > > It's existence just means that the partition is a "whole disk"
> > > partition type.
> > 
> > Can you try this patch to see if it solves the oops, and that the file
> > is still there and works properly?
> 
> It doesn't crash, but the file returns -EIO instead of zero when read.

How about this attempt?

thanks for your patience,

greg "Kay owes me a beer" k-h

---
 fs/partitions/check.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -319,6 +319,14 @@ void delete_partition(struct gendisk *di
 	put_device(&p->dev);
 }
 
+static ssize_t whole_disk_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	return 0;
+}
+static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
+		   whole_disk_show, NULL);
+
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
@@ -352,13 +360,8 @@ void add_partition(struct gendisk *disk,
 	device_add(&p->dev);
 	partition_sysfs_add_subdir(p);
 	p->dev.uevent_suppress = 0;
-	if (flags & ADDPART_FLAG_WHOLEDISK) {
-		static struct attribute addpartattr = {
-			.name = "whole_disk",
-			.mode = S_IRUSR | S_IRGRP | S_IROTH,
-		};
-		err = sysfs_create_file(&p->dev.kobj, &addpartattr);
-	}
+	if (flags & ADDPART_FLAG_WHOLEDISK)
+		err = device_create_file(&p->dev, &dev_attr_whole_disk);
 
 	/* suppress uevent if the disk supresses it */
 	if (!disk->dev.uevent_suppress)
