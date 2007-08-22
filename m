Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXHVIMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXHVIMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXHVIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:12:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48176 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbXHVIMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:12:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [RFC][PATCH -mm 1/4] Hibernation: Arbitrary boot kernel support - generic code
Date: Wed, 22 Aug 2007 10:17:12 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708221015.16493.rjw@sisk.pl>
In-Reply-To: <200708221015.16493.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221017.13111.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add the bits needed for supporting arbitrary boot kernels to the common
hibernation code.

To support arbitrary boot kernels, make it possible to replace the 'struct
new_utsname' and the kernel version in the hibernation image header by some
architecture specific data that will be used to verify if the image is valid
and to restore the image.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/power.h    |    6 +++-
 kernel/power/snapshot.c |   60 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 17 deletions(-)

Index: linux-2.6.23-rc3/kernel/power/power.h
===================================================================
--- linux-2.6.23-rc3.orig/kernel/power/power.h
+++ linux-2.6.23-rc3/kernel/power/power.h
@@ -11,14 +11,16 @@ struct swsusp_info {
 	unsigned long		size;
 } __attribute__((aligned(PAGE_SIZE)));
 
-
-
 #ifdef CONFIG_HIBERNATION
+/* Maximum size of architecture specific data in a hibernation header */
+#define MAX_ARCH_HEADER_SIZE	(sizeof(struct new_utsname) + 4)
+
 /*
  * Keep some memory free so that I/O operations can succeed without paging
  * [Might this be more than 4 MB?]
  */
 #define PAGES_FOR_IO	((4096 * 1024) >> PAGE_SHIFT)
+
 /*
  * Keep 1 MB of memory free so that device drivers can allocate some pages in
  * their .suspend() routines without breaking the suspend to disk.
Index: linux-2.6.23-rc3/kernel/power/snapshot.c
===================================================================
--- linux-2.6.23-rc3.orig/kernel/power/snapshot.c
+++ linux-2.6.23-rc3/kernel/power/snapshot.c
@@ -1239,17 +1239,29 @@ asmlinkage int swsusp_save(void)
 	return 0;
 }
 
-static void init_header(struct swsusp_info *info)
+#ifdef ARCH_HAS_HIBERNATION_HEADER
+static int init_header_complete(struct swsusp_info *info)
 {
-	memset(info, 0, sizeof(struct swsusp_info));
+	return arch_hibernation_header_save(info, MAX_ARCH_HEADER_SIZE);
+}
+#else /* !ARCH_HAS_HIBERNATION_HEADER */
+static int init_header_complete(struct swsusp_info *info)
+{
+	memcpy(&info->uts, init_utsname(), sizeof(struct new_utsname));
 	info->version_code = LINUX_VERSION_CODE;
+	return 0;
+}
+#endif /* !ARCH_HAS_HIBERNATION_HEADER */
+
+static int init_header(struct swsusp_info *info)
+{
+	memset(info, 0, sizeof(struct swsusp_info));
 	info->num_physpages = num_physpages;
-	memcpy(&info->uts, init_utsname(), sizeof(struct new_utsname));
-	info->cpus = num_online_cpus();
 	info->image_pages = nr_copy_pages;
 	info->pages = nr_copy_pages + nr_meta_pages + 1;
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+	return init_header_complete(info);
 }
 
 /**
@@ -1303,7 +1315,11 @@ int snapshot_read_next(struct snapshot_h
 			return -ENOMEM;
 	}
 	if (!handle->offset) {
-		init_header((struct swsusp_info *)buffer);
+		int error;
+
+		error = init_header((struct swsusp_info *)buffer);
+		if (error)
+			return error;
 		handle->buffer = buffer;
 		memory_bm_position_reset(&orig_bm);
 		memory_bm_position_reset(&copy_bm);
@@ -1394,22 +1410,36 @@ duplicate_memory_bitmap(struct memory_bi
 	}
 }
 
-static inline int check_header(struct swsusp_info *info)
+#ifdef ARCH_HAS_HIBERNATION_HEADER
+static char *check_image_kernel(struct swsusp_info *info)
+{
+	return arch_hibernation_header_restore(info) ?
+			"architecture specific data" : NULL;
+}
+#else /* !ARCH_HAS_HIBERNATION_HEADER */
+static char *check_image_kernel(struct swsusp_info *info)
 {
-	char *reason = NULL;
-
 	if (info->version_code != LINUX_VERSION_CODE)
-		reason = "kernel version";
-	if (info->num_physpages != num_physpages)
-		reason = "memory size";
+		return "kernel version";
 	if (strcmp(info->uts.sysname,init_utsname()->sysname))
-		reason = "system type";
+		return "system type";
 	if (strcmp(info->uts.release,init_utsname()->release))
-		reason = "kernel release";
+		return "kernel release";
 	if (strcmp(info->uts.version,init_utsname()->version))
-		reason = "version";
+		return "version";
 	if (strcmp(info->uts.machine,init_utsname()->machine))
-		reason = "machine";
+		return "machine";
+	return NULL;
+}
+#endif /* !ARCH_HAS_HIBERNATION_HEADER */
+
+static int check_header(struct swsusp_info *info)
+{
+	char *reason;
+
+	reason = check_image_kernel(info);
+	if (!reason && info->num_physpages != num_physpages)
+		reason = "memory size";
 	if (reason) {
 		printk(KERN_ERR "swsusp: Resume mismatch: %s\n", reason);
 		return -EPERM;

