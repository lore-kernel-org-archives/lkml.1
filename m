Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbYBWUG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbYBWUG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758271AbYBWUGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:06:45 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:3778 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbYBWUGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:06:43 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47C07536.6040404@tremplin-utc.net>
Date: Sat, 23 Feb 2008 20:34:14 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20080214 Mandriva/2.0.0.9-8mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: len.brown@intel.com
CC: Christoph Hellwig <hch@lst.de>, dsdt@gaugusch.at,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       trenn@suse.de
Subject: [PATCH] Use userland-like functions for reading the ACPI table
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080212053730.GA15347@lst.de> <47BDC705.6090902@tremplin-utc.net>
In-Reply-To: <47BDC705.6090902@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21/02/08 19:46, Éric Piel wrote/a écrit:
> In the mean time, here is a patch which should get the situation already
> much cleaner. It has been tested on various configs (with and without
> DSDT). Let me know if you think it is acceptable.
> 
It seems the patch looks ok for people around so here is a s-o-b version 
for Len. It's against 2.6.25-rc2.

Eric

--

As recommended by Christoph Hellwig, even if we can't rely on the userspace
firmware loader so early at boot, at least use normal syscall (as in
init/do_mounts_*.c). Similarly, use kfree() instead of ACPI_FREE().

Also, it's recommended to open the file before stating it, to avoid surprises.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
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
