Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYBUSrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYBUSrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYBUSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:46:53 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:15157 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbYBUSqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:46:52 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47BDC705.6090902@tremplin-utc.net>
Date: Thu, 21 Feb 2008 19:46:29 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20080214 Mandriva/2.0.0.9-8mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: dsdt@gaugusch.at, len.brown@intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, trenn@suse.de
Subject: Re: acpi dsts loading and populate_rootfs
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080212053730.GA15347@lst.de>
In-Reply-To: <20080212053730.GA15347@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12/02/08 06:37, Christoph Hellwig wrote/a écrit:
> [skipping the populate_rootfs discussion as it seems you have a better
>  handle on that than me]
> 
> On Sun, Feb 10, 2008 at 12:58:09PM +0100, Eric Piel wrote:
>>> And while we're at it the file reading thing in there is utter crap
>>> aswell.  You really should be using the firmware loader which works
>>> perfectly fine if you initramfs is set up for it.  So please folks,
>>> back to the drawing board, do it properly and send it out to lkml
>>> for review please.
>> Christoph, if you have seen this part of the code, you have probably 
>> also read the big fat warning explaining why this cannot be done by 
>> firmware loader (ie: userspace cannot be run at this early time, 
>> corresponding to acpi_early_init()). However, you probably know the 
>> kernel ten times better than me. Could you explain what I misunderstood 
>> when writing this warning, and give me some hints about how to use the 
>> firmware loader in this case?
> 
> Sorry, I misparsed the comment.  I took it for the usual I'm too lazy
> to put something that could load firmware into initramfs excuse.
> 
> But thinking about it is there a reason acpi initialization needs to
> happen so early that we can't even have userspace in initramfs running?

Hi,
I guess in the complete absolute point of view it's possible to run
userspace without ACPI, after all that's what happens if you don't
activate ACPI in your kernel. However, so far I've taken the init order
as a constant. I'd really prefer not to have to mess with a complete
init order reorganization ;-)

> 
> But if we can't use real userspace this could should at least be written
> like the pseudo-userspace in init/do_mounts*.c, using the sys_ syscall
> implementations.
Yes, thank you very much for the links. Attached is a patch that does
this.

> 
> As an additional comment the stat + open approach is racy and not a good
> idea.  Please just open the file using sys_open, it will tell you
> if the file doesn't exist and then use fstat on it to find the
> length.  It would also be useful if this kind of code is not hidden
> inside acpi but rather done somewhere close to the early init code
> because that's where people would expect this kind of nastiness.
The attached patch also fixes the stat + open order.

Concerning the place of the code, I've tried to find a better place.
However, as acpi_early_init(), from which this function is called, is
placed in driver/acpi/ and the acpi_find_dsdt_initrd() function contains
quite a few references to acpi code it really looked strange to move it
out from the current file. If you still think it make much more sense to
move it somewhere else, could you hint me about which you would think it
fit better in?

In the mean time, here is a patch which should get the situation already
much cleaner. It has been tested on various configs (with and without
DSDT). Let me know if you think it is acceptable.

See you,
Eric

---
Use userland-like functions for reading the ACPI table

As recommended by Christoph Hellwig, even if we can't rely on the userspace
firmware loader so early at boot, at least use normal syscall (as in
init/do_mounts_*.c). Similarly, use kfree() instead of ACPI_FREE().

Also, it's recommended to open the file before stating it, to avoid surprises.
---
 drivers/acpi/osl.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 34b3386..b836305 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -42,6 +42,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/processor.h>
 #include <asm/uaccess.h>
+#include <linux/syscalls.h>
 
 #include <linux/efi.h>
 #include <linux/ioport.h>
@@ -327,8 +328,7 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
 #ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
 static struct acpi_table_header *acpi_find_dsdt_initrd(void)
 {
-	struct file *firmware_file;
-	mm_segment_t oldfs;
+	int fd;
 	unsigned long len, len2;
 	struct acpi_table_header *dsdt_buffer, *ret = NULL;
 	struct kstat stat;
@@ -342,20 +342,21 @@ struct acpi_table_header *acpi_find_dsdt_initrd(void)
 	 * But this code must be run before there is any userspace available.
 	 * A static/init firmware infrastructure doesn't exist yet...
 	 */
-	if (vfs_stat(ramfs_dsdt_name, &stat) < 0)
-		return ret;
+	fd = sys_open(ramfs_dsdt_name, O_RDONLY, 0);
+	if (fd < 0)
+		return ret; /* No need for warning, no DSDT override is normal */
+
+	/* There exists 3 different sys_fstat's, all are wrapper to vfs_fstat */
+	if (vfs_fstat(fd, &stat) < 0) {
+		printk(KERN_ERR PREFIX "Failed to stat %s.\n", ramfs_dsdt_name);
+		goto err;
+	}
 
 	len = stat.size;
 	/* check especially against empty files */
 	if (len <= 4) {
 		printk(KERN_ERR PREFIX "Failed: DSDT only %lu bytes.\n", len);
-		return ret;
-	}
-
-	firmware_file = filp_open(ramfs_dsdt_name, O_RDONLY, 0);
-	if (IS_ERR(firmware_file)) {
-		printk(KERN_ERR PREFIX "Failed to open %s.\n", ramfs_dsdt_name);
-		return ret;
+		goto err;
 	}
 
 	dsdt_buffer = kmalloc(len, GFP_ATOMIC);
@@ -364,15 +365,11 @@ struct acpi_table_header *acpi_find_dsdt_initrd(void)
 		goto err;
 	}
 
-	oldfs = get_fs();
-	set_fs(KERNEL_DS);
-	len2 = vfs_read(firmware_file, (char __user *)dsdt_buffer, len,
-		&firmware_file->f_pos);
-	set_fs(oldfs);
+	len2 = sys_read(fd, (char __user *)dsdt_buffer, len);
 	if (len2 < len) {
 		printk(KERN_ERR PREFIX "Failed to read %lu bytes from %s.\n",
 			len, ramfs_dsdt_name);
-		ACPI_FREE(dsdt_buffer);
+		kfree(dsdt_buffer);
 		goto err;
 	}
 
@@ -380,7 +377,7 @@ struct acpi_table_header *acpi_find_dsdt_initrd(void)
 			len, ramfs_dsdt_name);
 	ret = dsdt_buffer;
 err:
-	filp_close(firmware_file, NULL);
+	sys_close(fd);
 	return ret;
 }
 #endif

