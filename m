Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZGSLyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZGSLyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 07:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZGSLyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 07:54:12 -0400
Received: from bu3sch.de ([62.75.166.246]:60454 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbZGSLyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 07:54:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] acpi-video: Fix integer overflow and possible kernel stack trashing
Date: Sun, 19 Jul 2009 13:53:31 +0200
User-Agent: KMail/1.9.9
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907191353.32181.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a possible kernel crash through stack trashing triggered
by an integer overflow. If count passed from userspace is (size_t)-1lu, the
range check will overflow and return false. So the copy_from_user() will
end up attempting to copy 0xFFFFFFFF (or 0xFFFFFFFFFFFFFFFF) bytes to the kernel stack.
Of course the copy will fail at some point, because we can't allocate a buffer that big.
But it will copy as much as it can and then return with an -EFAULT.
This means the userspace process writing to this proc file controls
the kernel stack.

This is probably not useable for a privilege escalation, because the proc file s
have permissions (S_IFREG | S_IRUGO | S_IWUSR). So only root will be able to crash the machine.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org

---

version 2: Fix more functions with similar bugs.

This patch is completely untested, because I do not have a machine with acpi-video.

---
 drivers/acpi/video.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/acpi/video.c
+++ linux-2.6/drivers/acpi/video.c
@@ -1185,21 +1185,21 @@ acpi_video_device_write_state(struct fil
 			      const char __user * buffer,
 			      size_t count, loff_t * data)
 {
 	int status;
 	struct seq_file *m = file->private_data;
 	struct acpi_video_device *dev = m->private;
 	char str[12] = { 0 };
 	u32 state = 0;
 
 
-	if (!dev || count + 1 > sizeof str)
+	if (!dev || count >= sizeof str)
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
 		return -EFAULT;
 
 	str[count] = 0;
 	state = simple_strtoul(str, NULL, 0);
 	state &= ((1ul << 31) | (1ul << 30) | (1ul << 0));
 
 	status = acpi_video_device_set_state(dev, state);
@@ -1242,21 +1242,21 @@ acpi_video_device_write_brightness(struc
 				   const char __user * buffer,
 				   size_t count, loff_t * data)
 {
 	struct seq_file *m = file->private_data;
 	struct acpi_video_device *dev = m->private;
 	char str[5] = { 0 };
 	unsigned int level = 0;
 	int i;
 
 
-	if (!dev || !dev->brightness || count + 1 > sizeof str)
+	if (!dev || !dev->brightness || count >= sizeof str)
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
 		return -EFAULT;
 
 	str[count] = 0;
 	level = simple_strtoul(str, NULL, 0);
 
 	if (level > 100)
 		return -EFAULT;
@@ -1524,21 +1524,21 @@ acpi_video_bus_write_POST(struct file *f
 			  const char __user * buffer,
 			  size_t count, loff_t * data)
 {
 	int status;
 	struct seq_file *m = file->private_data;
 	struct acpi_video_bus *video = m->private;
 	char str[12] = { 0 };
 	unsigned long long opt, options;
 
 
-	if (!video || count + 1 > sizeof str)
+	if (!video || count >= sizeof str)
 		return -EINVAL;
 
 	status = acpi_video_bus_POST_options(video, &options);
 	if (!ACPI_SUCCESS(status))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
 		return -EFAULT;
 
 	str[count] = 0;
@@ -1564,21 +1564,21 @@ acpi_video_bus_write_DOS(struct file *fi
 			 const char __user * buffer,
 			 size_t count, loff_t * data)
 {
 	int status;
 	struct seq_file *m = file->private_data;
 	struct acpi_video_bus *video = m->private;
 	char str[12] = { 0 };
 	unsigned long opt;
 
 
-	if (!video || count + 1 > sizeof str)
+	if (!video || count >= sizeof str)
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
 		return -EFAULT;
 
 	str[count] = 0;
 	opt = strtoul(str, NULL, 0);
 	if (opt > 7)
 		return -EFAULT;
 

-- 
Greetings, Michael.
