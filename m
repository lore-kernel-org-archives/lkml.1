Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYBXTCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYBXTCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYBXTCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:02:32 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:14958 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYBXTCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:02:30 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47C1BF2C.4080701@tremplin-utc.net>
Date: Sun, 24 Feb 2008 20:02:04 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20080214 Mandriva/2.0.0.9-8mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, len.brown@intel.com,
       dsdt@gaugusch.at,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, trenn@suse.de
Subject: Re: [PATCH] Use userland-like functions for reading the ACPI table
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080212053730.GA15347@lst.de> <47BDC705.6090902@tremplin-utc.net> <47C07536.6040404@tremplin-utc.net> <alpine.LFD.1.00.0802231232280.21332@woody.linux-foundation.org> <20080224013113.GA12512@lst.de>
In-Reply-To: <20080224013113.GA12512@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24/02/08 02:31, Christoph Hellwig wrote/a écrit:
> On Sat, Feb 23, 2008 at 12:45:38PM -0800, Linus Torvalds wrote:
>>> As recommended by Christoph Hellwig, even if we can't rely on the userspace
>>> firmware loader so early at boot, at least use normal syscall (as in
>>> init/do_mounts_*.c). Similarly, use kfree() instead of ACPI_FREE().
>> So I'm missing a lot of the background here.
>>
>> I don't think "sys_open()" is in any way preferable to the alternatives, 
>> especially since it depends on thread-global state (the file descriptor 
>> table) rather than much more local state ("struct file" that you've 
>> opened).
>>
>> I think the calls to sys_open() in init do_dounts etc are very different: 
>> they really are more about a real kernel-level almost-user-mode thread 
>> than a core driver. 
> 
> Well, that's what this code is like aswell.  That's why I recommended
> to Eric to move it to init/ and make it look like that code.  I haven't
> quite caught up with the discussion yet, but Eric think moving it
> there might not be a that good idea.  Having this code in drivers/
> even if it's just called in init time is a bad idea, as people will
> copy it.  Then again using the functions the code was using before
> isn't any better.
Ok, I see the problem with leaving the code in the drivers/ directory.
Here is a new version of the patch that also moves the code to
init/initramfs.c, the file which seems to have the closer relationship
to the code. It also keeps the address space swapping which I had
mistakenly "cleaned up". 

Eric

--
Use userland-like functions for reading the ACPI table

As recommended by Christoph Hellwig, even if we can't rely on the userspace
firmware loader so early at boot, at least use normal syscall (as in
init/do_mounts_*.c). Move the function to init/ so that it's obvious that this
code is not ran as a normal core driver.  Moreover, use kfree() instead of
ACPI_FREE().

Also, it's recommended to open the file before stating it, to avoid surprises.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/acpi/osl.c |   62 +--------------------------------------------------
 init/initramfs.c   |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 8edba7b..b075781 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -93,6 +93,7 @@ static char osi_additional_string[OSI_STRING_LENGTH_MAX];
 
 #ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
 static int acpi_no_initrd_override;
+extern struct acpi_table_header *acpi_find_dsdt_initrd(void);
 #endif
 
 /*
@@ -324,67 +325,6 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
 	return AE_OK;
 }
 
-#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
-static struct acpi_table_header *acpi_find_dsdt_initrd(void)
-{
-	struct file *firmware_file;
-	mm_segment_t oldfs;
-	unsigned long len, len2;
-	struct acpi_table_header *dsdt_buffer, *ret = NULL;
-	struct kstat stat;
-	char *ramfs_dsdt_name = "/DSDT.aml";
-
-	printk(KERN_INFO PREFIX "Checking initramfs for custom DSDT\n");
-
-	/*
-	 * Never do this at home, only the user-space is allowed to open a file.
-	 * The clean way would be to use the firmware loader.
-	 * But this code must be run before there is any userspace available.
-	 * A static/init firmware infrastructure doesn't exist yet...
-	 */
-	if (vfs_stat(ramfs_dsdt_name, &stat) < 0)
-		return ret;
-
-	len = stat.size;
-	/* check especially against empty files */
-	if (len <= 4) {
-		printk(KERN_ERR PREFIX "Failed: DSDT only %lu bytes.\n", len);
-		return ret;
-	}
-
-	firmware_file = filp_open(ramfs_dsdt_name, O_RDONLY, 0);
-	if (IS_ERR(firmware_file)) {
-		printk(KERN_ERR PREFIX "Failed to open %s.\n", ramfs_dsdt_name);
-		return ret;
-	}
-
-	dsdt_buffer = kmalloc(len, GFP_ATOMIC);
-	if (!dsdt_buffer) {
-		printk(KERN_ERR PREFIX "Failed to allocate %lu bytes.\n", len);
-		goto err;
-	}
-
-	oldfs = get_fs();
-	set_fs(KERNEL_DS);
-	len2 = vfs_read(firmware_file, (char __user *)dsdt_buffer, len,
-		&firmware_file->f_pos);
-	set_fs(oldfs);
-	if (len2 < len) {
-		printk(KERN_ERR PREFIX "Failed to read %lu bytes from %s.\n",
-			len, ramfs_dsdt_name);
-		ACPI_FREE(dsdt_buffer);
-		goto err;
-	}
-
-	printk(KERN_INFO PREFIX "Found %lu byte DSDT in %s.\n",
-			len, ramfs_dsdt_name);
-	ret = dsdt_buffer;
-err:
-	filp_close(firmware_file, NULL);
-	return ret;
-}
-#endif
-
 acpi_status
 acpi_os_table_override(struct acpi_table_header * existing_table,
 		       struct acpi_table_header ** new_table)
diff --git a/init/initramfs.c b/init/initramfs.c
index b74e845..9a0563a 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -1,3 +1,4 @@
+#include <asm/uaccess.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -6,6 +7,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/syscalls.h>
+#include <acpi/acpi.h>
 
 static __initdata char *message;
 static void __init error(char *x)
@@ -577,3 +579,64 @@ int __init populate_rootfs(void)
 	}
 	return 0;
 }
+
+#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
+struct acpi_table_header *acpi_find_dsdt_initrd(void)
+{
+	int fd;
+	mm_segment_t oldfs;
+	unsigned long len, len2;
+	struct acpi_table_header *dsdt_buffer, *ret = NULL;
+	struct kstat stat;
+	char *ramfs_dsdt_name = "/DSDT.aml";
+
+	printk(KERN_INFO "ACPI: Checking initramfs for custom DSDT\n");
+
+	/*
+	 * Never do this at home, only the user-space is allowed to open a file.
+	 * The clean way would be to use the firmware loader.
+	 * But this code must be run before there is any userspace available.
+	 * A static/init firmware infrastructure doesn't exist yet...
+	 */
+	fd = sys_open(ramfs_dsdt_name, O_RDONLY, 0);
+	if (fd < 0)
+		return ret; /* No need for warning, no DSDT override is normal */
+
+	/* There exists 3 different sys_fstat's, all are wrapper to vfs_fstat */
+	if (vfs_fstat(fd, &stat) < 0) {
+		printk(KERN_ERR "ACPI: Failed to stat %s.\n", ramfs_dsdt_name);
+		goto err;
+	}
+
+	len = stat.size;
+	/* check especially against empty files */
+	if (len <= 4) {
+		printk(KERN_ERR "ACPI: Failed: DSDT only %lu bytes.\n", len);
+		goto err;
+	}
+
+	dsdt_buffer = kmalloc(len, GFP_ATOMIC);
+	if (!dsdt_buffer) {
+		printk(KERN_ERR "ACPI: Failed to allocate %lu bytes.\n", len);
+		goto err;
+	}
+
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	len2 = sys_read(fd, (char __user *)dsdt_buffer, len);
+	set_fs(oldfs);
+	if (len2 < len) {
+		printk(KERN_ERR "ACPI: Failed to read %lu bytes from %s.\n",
+			len, ramfs_dsdt_name);
+		kfree(dsdt_buffer);
+		goto err;
+	}
+
+	printk(KERN_INFO "ACPI: Found %lu byte DSDT in %s.\n",
+			len, ramfs_dsdt_name);
+	ret = dsdt_buffer;
+err:
+	sys_close(fd);
+	return ret;
+}
+#endif
