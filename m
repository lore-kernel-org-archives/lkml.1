Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYCOTnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYCOTnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 15:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYCOTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 15:43:06 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:7497 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYCOTnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 15:43:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -6.389
Message-ID: <47DC26BC.7060502@tremplin-utc.net>
Date: Sat, 15 Mar 2008 20:42:52 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080305 Mandriva/2.0.0.12-3mdv2008.1 (2008.1) Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>  <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>  <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>  <1205525184.12763.32.camel@nimitz.home.sr71.net>  <47DAE55C.3080506@tremplin-utc.net>  <1205530551.8167.20.camel@nimitz.home.sr71.net>  <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030904090409050707080003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030904090409050707080003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

15/03/08 20:21, Linus Torvalds wrote/a écrit:
> 
> On Sat, 15 Mar 2008, Tilman Schmidt wrote:
>> Sorry to say, it doesn't. That is, it does shut up the warning I
>> reported, but there's a new one appearing now instead, three lines
>> later.
> 
> I've reverted the whole thing. Or rather, since there were various small 
> fixup commits over time, and a simple revert doesn't really work, I ended 
> up just removing the option and the code that was conditional on it - that 
> way, if we really want to fight this out some time (after 2.6.25 is out) 
> or some vendor wants to use a known-broken option anyway, there's a simple 
> and fairly clean commit to revert the revert.
> 
> It's commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47, see 
> 
> 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9a9e0d685553af76cb6ae2af93cca4913e7fcd47
> 
> for details if you aren't a git person.
Hi,
It's a pity, I had just nearly finished a new approach. Instead of
relying on populate_rootfs() and the filesystem infrastructure, the new
approach directly finds the file in the initramfs. With
unpack_to_rootfs(), it turned out to be rather straightforward. Attached
 is a half-tested version of the patch (it boots and works but I haven't
compiled without the option yet). Just in case you would like to change
your mind ;-)


> But quite frankly I don't think that we even want to re-introduce this in 
> that form. If we really want to have a dynamic custom DSDT, I think we 
> should do the whole DSDT replacement *much* later by ACPI (like just 
> before driver loading or something like that).
> 
> If the BIOS-provided DSDT is _so_ broken that we cannot even get core 
> stuff like the CPU's going, I think it has more serious issues than any 
> custom DSDT will ever fix, but letting ACPI actually switch DSDT's at 
> run-time (instead of just replacing it when looking for it very very early 
> in the boot sequence) in order to work around some device issues sounds 
> reasonably sane.
> 
> So how about aiming to make that DSDT-replacement something you can do 
> from any kernel module, _after_ the original DSDT has already been parsed? 
> And then the whole "load it from initrd" turns into a regular thing that 
> we can do pretty early, but that we don't have to do quite _this_ early!
Indeed, this form of DSDT override would be the best. However, I have no
idea what is necessary to implement it. Len, does this approach sound
feasible? Where should I start looking at?

Eric


--------------030904090409050707080003
Content-Type: text/plain;
 name="0001-DSDT-in-initramfs-directly-access-the-initramfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-DSDT-in-initramfs-directly-access-the-initramfs.patch"

>From a0e8247f5f0dd5f332639b5635258a35c3648159 Mon Sep 17 00:00:00 2001
From: Eric Piel <eric@circle.(none)>
Date: Sat, 15 Mar 2008 19:49:05 +0100
Subject: [PATCH 1/1] DSDT in initramfs: directly access the initramfs

The current method for reading the DSDT in the initramfs uses the filesystem. Not only this is bad because such functions should normally not used in the kernel, but in addition it brings the requirement that the filesystem infrastructure is already initialised before initialising ACPI. This is quite unlikely to ever happen. (cf http://marc.info/?t=120536629300001&r=1&w=2)

This patch changes the method of access to initramfs. It uses directly unpack_to_rootfs(). This is build over the "check_only" mode: the initramfs is just read... but if we find a file matching the one we are looking for we copy it to memory.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/acpi/osl.c |   62 +----------------------------------------
 init/initramfs.c   |   79 ++++++++++++++++++++++++++++++++++++++++++++++++----
 init/main.c        |    7 ----
 3 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 065819b..8fa630f 100644
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
index c0b1e05..224bf48 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -6,8 +6,15 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/syscalls.h>
+#include <acpi/acpi.h>
 
 static __initdata char *message;
+#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
+static __initdata char *file_looked_for;
+static __initdata void *file_mem;
+#else
+#define file_looked_for 0
+#endif
 static void __init error(char *x)
 {
 	if (!message)
@@ -123,6 +130,7 @@ static __initdata enum state {
 	SkipIt,
 	GotName,
 	CopyFile,
+	CopyFileMem,
 	GotSymlink,
 	Reset
 } state, next_state;
@@ -267,6 +275,11 @@ static int __init do_name(void)
 		free_hash();
 		return 0;
 	}
+	if (file_looked_for) {
+		if (S_ISREG(mode) && (strcmp(collected, file_looked_for) == 0))
+			state = CopyFileMem;
+		return 0;
+	}
 	if (dry_run)
 		return 0;
 	clean_path(collected, mode);
@@ -299,6 +312,37 @@ static int __init do_name(void)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
+static int __init do_copy_mem(void)
+{
+	static void *file_current; /* current position in the file */
+	if (file_mem == NULL) {
+		if (body_len < 4) { /* check especially against empty files */
+			error("file is less than 4 bytes");
+			return 1;
+		}
+		file_mem = kmalloc(body_len, GFP_ATOMIC);
+		if (!file_mem) {
+			error("failed to allocate enough memory");
+			return 1;
+		}
+		file_current = file_mem;
+	}
+	if (count >= body_len) {
+		memcpy(file_current, victim, body_len);
+		eat(body_len);
+	} else {
+		memcpy(file_current, victim, count);
+		body_len -= count;
+		file_current += count;
+		eat(count);
+	}
+	return 1;
+}
+#else
+#define do_copy_mem NULL
+#endif
+
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
@@ -333,6 +377,7 @@ static __initdata int (*actions[])(void) = {
 	[SkipIt]	= do_skip,
 	[GotName]	= do_name,
 	[CopyFile]	= do_copy,
+	[CopyFileMem]	= do_copy_mem,
 	[GotSymlink]	= do_symlink,
 	[Reset]		= do_reset,
 };
@@ -538,7 +583,7 @@ skip:
 	initrd_end = 0;
 }
 
-int __init populate_rootfs(void)
+static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
@@ -577,10 +622,32 @@ int __init populate_rootfs(void)
 	}
 	return 0;
 }
-#ifndef CONFIG_ACPI_CUSTOM_DSDT_INITRD
-/*
- * if this option is enabled, populate_rootfs() is called _earlier_ in the
- * boot sequence. This insures that the ACPI initialisation can find the file.
- */
 rootfs_initcall(populate_rootfs);
+
+#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
+struct acpi_table_header *acpi_find_dsdt_initrd(void)
+{
+	char *err, *ramfs_dsdt_name = "DSDT.aml";
+
+	printk(KERN_INFO "ACPI: Checking initramfs for custom DSDT\n");
+	file_mem = NULL;
+	file_looked_for = ramfs_dsdt_name;
+	err = unpack_to_rootfs((char *)initrd_start,
+			initrd_end - initrd_start, 1);
+	file_looked_for = NULL;
+
+	if (err) {
+		/*
+		 * Even if reading the DSDT file was successful,
+		 * we give up if the initramfs cannot be entirely read.
+		 */
+		kfree(file_mem);
+		printk(KERN_ERR "ACPI: Aborded because %s.\n", err);
+		return NULL;
+	}
+	if (file_mem)
+		printk(KERN_INFO "ACPI: Found DSDT in %s.\n", ramfs_dsdt_name);
+
+	return file_mem;
+}
 #endif
diff --git a/init/main.c b/init/main.c
index fbb0167..99ce949 100644
--- a/init/main.c
+++ b/init/main.c
@@ -102,12 +102,6 @@ static inline void mark_rodata_ro(void) { }
 extern void tc_init(void);
 #endif
 
-#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
-extern int populate_rootfs(void);
-#else
-static inline void populate_rootfs(void) {}
-#endif
-
 enum system_states system_state;
 EXPORT_SYMBOL(system_state);
 
@@ -650,7 +644,6 @@ asmlinkage void __init start_kernel(void)
 
 	check_bugs();
 
-	populate_rootfs(); /* For DSDT override from initramfs */
 	acpi_early_init(); /* before LAPIC and SMP init */
 
 	/* Do the rest non-__init'ed, we're now alive */
-- 
1.5.4.3


--------------030904090409050707080003--
