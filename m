Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0CCVIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:08:48 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41411 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0CCVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:08:43 -0500
Subject: [PATCH] Forcing capacity sizes for block devices (RFC)
From: Clemens Fruhwirth <clemens@endorphin.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 03 Mar 2010 22:08:25 +0100
Message-ID: <1267650505.29681.20.camel@ghanima>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this mail I like to restart a discussion about a patch I proposed
on linux-scsi. Unfortunately my attempt to restart the discussion there
failed. That is why I like to try it with a broader audience.

My problem starts with my SD card reader, which is kind of broken in the
sense that it fails to detect the SD card size properly. My first mail
to linux-scsi http://marc.info/?l=linux-scsi&m=125555540311307&w=2
explains why it is broken (ignored additional device flags) and also
contains a patch to force the block device to a certain size. After the
kernel internal limit on device addresses is removed, my SD card --
despite not knowing the correct size -- is able to handle the write
requests correctly. 

My initial attempt was to patch the SCSI layer to raise the kernel
internal device address limit to the correct size (using a new ioctl
call + a little user space program). Grant Grundler gave the good
suggestion to make the "size" attribute of the block device in /sys
writable instead of using a new interface. I rewrote the patch:
http://marc.info/?l=linux-scsi&m=126098230006530&w=2 

Bartlomiej Zolnier joined
http://marc.info/?l=linux-scsi&m=126143291721837&w=2 and expressed his
preference for an automatic solution instead of manual intervention. He
favored to use the partition table to get the device sizes (iirc that's
the behavior we see on Windows). I tried to explain why this is a bad
idea http://marc.info/?l=linux-scsi&m=126166205514087&w=2 and why manual
intervention is still necessary, i.e. for unformated cards. 

The problem that is still open in my opinion is that the 

   p->nr_sects = val;

line in the following patch should be replaced by something that
properly informs the block layer about the size change. set_capacity
from include/linux/genhd.h is a potential candidate, which also sets
nr_sects but only after dereferencing a gendisk structure, so it is no
drop-in replacement for that line above.

Feedback is appreciated. Original patch below. 

Make the size attribute of block devices writable via sysfs. This allows userspace to force
device boundaries in cases where the device driver is unable to detect the correct size, as
with spec-incompliant SD card readers.

diff -uprN -X linux-2.6.32-vanilla/Documentation/dontdiff linux-2.6.32-vanilla/block/genhd.c linux-2.6.32-patched/block/genhd.c
--- linux-2.6.32-vanilla/block/genhd.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32-patched/block/genhd.c	2009-12-15 14:38:24.962463446 +0100
@@ -865,7 +865,7 @@ static DEVICE_ATTR(range, S_IRUGO, disk_
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO | S_IWUSR, part_size_show, part_size_set);
 static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
diff -uprN -X linux-2.6.32-vanilla/Documentation/dontdiff linux-2.6.32-vanilla/fs/partitions/check.c linux-2.6.32-patched/fs/partitions/check.c
--- linux-2.6.32-vanilla/fs/partitions/check.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32-patched/fs/partitions/check.c	2009-12-19 10:38:58.745294907 +0100
@@ -219,6 +219,18 @@ ssize_t part_size_show(struct device *de
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
+ssize_t part_size_set(struct device *dev,
+		      struct device_attribute *attr, char *buf, size_t len)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	unsigned long long val;
+	if (strict_strtoull(buf, 0, &val))
+		return -EINVAL;
+
+	p->nr_sects = val;
+	return len;
+}
+
 ssize_t part_alignment_offset_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
diff -uprN -X linux-2.6.32-vanilla/Documentation/dontdiff linux-2.6.32-vanilla/include/linux/genhd.h linux-2.6.32-patched/include/linux/genhd.h
--- linux-2.6.32-vanilla/include/linux/genhd.h	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32-patched/include/linux/genhd.h	2009-12-19 10:40:30.900871273 +0100
@@ -549,6 +549,9 @@ extern void blk_unregister_region(dev_t 
 
 extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+extern ssize_t part_size_set(struct device *dev,
+			     struct device_attribute *attr, char *buf,
+			     size_t len);
 extern ssize_t part_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
 extern ssize_t part_inflight_show(struct device *dev,

Signed-off-by: Clemens Fruhwirth <clemens@endorphin.org>
Reviewed-by: Grant Grundler <grundler@google.com>


