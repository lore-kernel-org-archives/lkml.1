Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZCKUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZCKUEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZCKUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:04:24 -0400
Received: from eastrmmtao102.cox.net ([68.230.240.8]:63662 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZCKUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:04:23 -0400
X-Authority-Analysis: v=1.0 c=1 a=C8-Ro45AKfYA:10 a=p6uzxP4KKmUA:10
 a=kviXuzpPAAAA:8 a=C3I3ZF1iAAAA:8 a=pGLkceISAAAA:8 a=6xnDzA74Ug3tLNbHiAgA:9
 a=mKxH_WGPe8BSz-6OOs0A:7 a=2i-EvYjVAZhTpKAbeM521OaTIh8A:4 a=a_lYcm-iImQA:10
 a=QRhfiUhj_KgA:10 a=4vB-4DCPJfMA:10 a=MSl-tDqOz04A:10 a=AwJGzDs1KtCrW4Nu:21
 a=QCCzI-VcPfnvRSNQ:21
X-CM-Score: 0.00
From: Christopher Brannon <cmbrannon@cox.net>
To: linux-kernel@vger.kernel.org
Date: Wed, 11 Mar 2009 10:10:23 -0500
Subject: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-Id: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under Plan 9 from Bell Labs, one queries or sets the system clock by
reading or writing text strings to a special file named /dev/time.
I implemented such a facility for Linux.  A read of /dev/time produces
four decimal numbers: epoch seconds, nanoseconds since start of epoch,
nanoseconds since boot, and nanoseconds per second.  Writing a decimal number
to /dev/time sets the system clock to the given number of epoch seconds.
Anyone who is permitted to write to /dev/time may set the clock.
Granting this privilege becomes as easy as modifying groups and file
permissions.

Signed-off-by: Christopher Brannon <cmbrannon@cox.net>
---
 Documentation/time-device.txt |   51 +++++++++++++++++
 arch/um/Kconfig.char          |   11 ++++
 drivers/char/Kconfig          |   11 ++++
 drivers/char/Makefile         |    2 +
 drivers/char/devtime.c        |  124 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 199 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/time-device.txt
 create mode 100644 drivers/char/devtime.c

diff --git a/Documentation/time-device.txt b/Documentation/time-device.txt
new file mode 100644
index 0000000..c3145a0
--- /dev/null
+++ b/Documentation/time-device.txt
@@ -0,0 +1,51 @@
+/dev/time for Linux
+===================
+
+Christopher M. Brannon <cmbrannon@cox.net>
+
+Inspiration
+-----------
+This document describes an implementation for the Linux kernel of a facility
+that is provided by the Plan 9 operating system from Bell Laboratories [1].
+
+Functionality
+-------------
+/dev/time provides a file-based interface to the system clock.
+Using this interface, one can query or set the system clock by reading or
+writing text strings.  A read of /dev/time yields four decimal integers:
+seconds since start of epoch, nanoseconds since start of epoch,
+nanoseconds since boot, and nanoseconds per second.
+The fourth value is redundant; it is kept in order to be faithful to the
+original interface.
+Writing a decimal number n to /dev/time sets the system clock to the
+date and time which is n seconds greater than January 1, 1970, 00:00:00 GMT.
+
+Examples
+--------
+cat /dev/time
+# Produces: 1236121128 123612012877063000 495497 300,
+# at time of writing on a test machine.
+echo 287604960 > /dev/time
+# sets the clock to the approximate time of my birth.
+
+Use Case
+--------
+Traditionally, super-user privileges were required in order to set the
+system clock under Linux.
+Since the advent of capabilities, any process having the CAP_SYS_TIME
+capability may perform this operation.
+The /dev/time device ties privileges to file permissions.  If a user
+can write to /dev/time, then he can set the system clock.
+
+Difference from Plan 9
+-----------------------
+This implementation differs from Plan 9 in one respect.  the Plan 9
+Programmer's Manual exactly specifies the format of data read from the
+device, including the widths of the four numeric fields [1].  This Linux
+implementation does not pad values with whitespace, so the four fields
+are of variable width.
+
+References
+----------
+[1] Plan 9 Programmers Manual, section 3.
+http://plan9.bell-labs.com/magic/man2html/3/cons
diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
index 70dabd1..7d0da78 100644
--- a/arch/um/Kconfig.char
+++ b/arch/um/Kconfig.char
@@ -236,4 +236,15 @@ config MMAPPER
 	  This driver allows a host file to be used as emulated IO memory inside
 	  UML.
 
+config DEVTIME
+	tristate "/dev/time virtual device support."
+	depends on EXPERIMENTAL
+	help
+	  This device provides a file-based interface to the system clock.
+	  The interface is based on the /dev/time device used in the
+	  Plan 9 operating system from Bell Labs.
+	  See <file:Documentation/time-device.txt> for a full description.
+	  To compile this driver as a module, choose M here: the
+	  module will be called devtime.
+
 endmenu
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 735bbe2..5bad918 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -97,6 +97,17 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
+config DEVTIME
+	tristate "/dev/time virtual device support."
+	depends on EXPERIMENTAL
+	help
+	  This device provides a file-based interface to the system clock.
+	  The interface is based on the /dev/time device used in the
+	  Plan 9 operating system from Bell Labs.
+	  See <file:Documentation/time-device.txt> for a full description.
+	  To compile this driver as a module, choose M here: the
+	  module will be called devtime.
+
 config SERIAL_NONSTANDARD
 	bool "Non-standard serial port support"
 	depends on HAS_IOMEM
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 9caf5b5..aba7403 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -111,6 +111,8 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
+obj-$(CONFIG_DEVTIME)		+= devtime.o
+
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
diff --git a/drivers/char/devtime.c b/drivers/char/devtime.c
new file mode 100644
index 0000000..0349ea8
--- /dev/null
+++ b/drivers/char/devtime.c
@@ -0,0 +1,124 @@
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/ktime.h>
+#include <linux/time.h>
+#include <linux/uaccess.h>
+
+MODULE_AUTHOR("Christopher Brannon <cmbrannon79@gmail.com>");
+MODULE_LICENSE("GPL");
+
+#define NS_PER_SEC 1000000000
+#define TIME_BUFSIZE 256
+
+static ssize_t time_read(struct file *, char __user *, size_t, loff_t *);
+static ssize_t time_write(struct file *, const char __user *, size_t,
+			  loff_t *);
+
+static const struct file_operations time_fops = {
+	.owner = THIS_MODULE,
+	.read = time_read,
+	.write = time_write,
+};
+
+static struct miscdevice timedev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "time",
+	.fops = &time_fops
+};
+
+static int time2text(char *buffer, size_t bufsize)
+{
+	int count = 0;
+	struct timespec abs_time;
+	struct timespec boot_time;
+	s64 abs_nanos;	/* nanoseconds since epoch */
+	s64 boot_nanos;	/* nanoseconds since boot */
+
+	getnstimeofday(&abs_time);
+
+	/*
+	 * The next two lines calculate uptime and store it in boot_time.
+	 * Taken from fs/proc/uptime.c.
+	 */
+	do_posix_clock_monotonic_gettime(&boot_time);
+	monotonic_to_bootbased(&boot_time);
+
+	/* Convert both time structs to nanoseconds. */
+	boot_nanos = timespec_to_ns(&boot_time);
+	abs_nanos = timespec_to_ns(&abs_time);
+
+	count =
+	    scnprintf(buffer, bufsize, "%ld %lld %lld %d\n", abs_time.tv_sec,
+		      abs_nanos, boot_nanos, NS_PER_SEC);
+
+	return count;
+}
+
+static int text2time(char *buffer)
+{
+	struct timespec ts;
+	int result = strict_strtol(buffer, 10, &ts.tv_sec);
+	if ((result == 0) && (ts.tv_sec > 0)) {
+		ts.tv_nsec = 0;
+		do_settimeofday(&ts);
+	} else
+		result = -EINVAL;	/* only positive longs are valid. */
+	return result;
+}
+
+static ssize_t
+time_read(struct file *f, char __user * buffer, size_t count, loff_t *offset)
+{
+	int result = 0;
+	if (*offset != 0)
+		result = 0;
+	else {
+		char tmpbuf[TIME_BUFSIZE];
+		int timetextlen = time2text(tmpbuf, TIME_BUFSIZE);
+		unsigned long readcount = min(count, (size_t) timetextlen);
+		if (timetextlen <= 0)
+			return -EAGAIN;
+		if (!copy_to_user(buffer, tmpbuf, readcount)) {
+			*offset += readcount;
+			result = readcount;
+		} else
+			result = -EFAULT;
+	}
+	return result;
+}
+
+static ssize_t
+time_write(struct file *f, const char __user * buffer, size_t count,
+	   loff_t *offset)
+{
+	unsigned int result = 0;
+	char tmpbuf[TIME_BUFSIZE];
+
+	if (*offset != 0)
+		return -EINVAL;
+	if (count > ((size_t) TIME_BUFSIZE - 1))
+		return -EINVAL;	/* Likely trying to feed bogus data anyway. */
+	result = copy_from_user(tmpbuf, buffer, count);
+	if (result)
+		return -EFAULT;
+	tmpbuf[count] = '\0';
+	if (text2time(tmpbuf))
+		return -EINVAL;
+	return count;
+}
+
+static int __init time_init(void)
+{
+	return misc_register(&timedev);
+}
+
+static void __exit time_exit(void)
+{
+	misc_deregister(&timedev);
+}
+
+module_init(time_init);
+module_exit(time_exit);
-- 
1.6.2

