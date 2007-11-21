Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbXKUWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbXKUWna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXKUWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:43:23 -0500
Received: from smtp.cce.hp.com ([161.114.21.22]:47570 "EHLO
	ccerelrim01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbXKUWnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:43:22 -0500
X-Greylist: delayed 1577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 17:43:22 EST
Subject: Error returns not handled correctly by sysfs.c:subsys_attr_store()
From: Andrew Patterson <andrew.patterson@hp.com>
Reply-To: andrew.patterson@hp.com
To: linux-kernel@vger.kernel.org
Cc: linux-hotplug@vger.kernel.org
Content-Type: text/plain
Date: Wed, 21 Nov 2007 15:16:59 -0700
Message-Id: <1195683419.16019.225.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.11.21.134728
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The buf in fs/sysfs.c:subsys_attr_store() does not seem to be updated
correctly when returning a negative value (indicating that an error
condition has occurred) is returned.  If a negative value is returned,
the next subsequent call to subsys_attr_store will have the contents of
buf appended to the previous call.  Example: I have modified the
sd.c:sd_store_allow_restart to always print out the contents of the buf
and return an error using the following patch:

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -183,6 +183,9 @@ static ssize_t sd_store_allow_restart(struct class_device *c
        struct scsi_disk *sdkp = to_scsi_disk(cdev);
        struct scsi_device *sdp = sdkp->device;
 
+       printk(KERN_ERR "buf_ptr = 0x%p, buf = %s, count = %u\n", buf, buf, coun
+       return -EINVAL;
+
        if (!capable(CAP_SYS_ADMIN))
                return -EACCES;

I get the following output when writing invalid values to the
allow_restart sysfs file:

# echo x > /sys/class/scsi_disk/4:0:0:0/allow_restart
bash: echo: write error: Invalid argument
# echo y > /sys/class/scsi_disk/4:0:0:0/allow_restart
bash: echo: write error: Invalid argument
# echo z > /sys/class/scsi_disk/4:0:0:0/allow_restart
bash: echo: write error: Invalid argument

And the console output shows:

buf_ptr = 0xe00001004bdb0000, buf = x
, count = 2
buf_ptr = 0xe00001004bdb0000, buf = x
, count = 2
buf_ptr = 0xe00001004bdb0000, buf = x
y
, count = 4
buf_ptr = 0xe00001004bdb0000, buf = x
y
, count = 4
buf_ptr = 0xe00001004caf0000, buf = x
y
z
, count = 6
buf_ptr = 0xe00001004caf0000, buf = x
y
z
, count = 6

and the same append problem occurs when using another sysfs file:

# echo xyzzy > /sys/class/scsi_disk/4:0:1:0/allow_restart
bash: echo: write error: Invalid argument

buf_ptr = 0xe00001004caf0000, buf = x
y
z
xyzzy
, count = 12

I found this problem in 2.6.24-rc3 and and an earlier version of 2.6.23.

This seems to work correctly on 2.6.18 (at least with the RHEL5 kernel I
did some testing with), i.e. the contents of buf from the previous
failed called are thrown away/overwritten. I looked through sysfs.c to
see if I could find anything obvious but could not see anything.
Perhaps this is handled at a higher level. 

-- 
Andrew Patterson
Hewlett-Packard

