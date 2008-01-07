Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYAGMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYAGMnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYAGMnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:43:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50151 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754703AbYAGMne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:43:34 -0500
Date: Mon, 7 Jan 2008 13:23:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Unify arch/x86/kernel/acpi/sleep*.c
Message-ID: <20080107122305.GA11062@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify arch/x86/kernel/acpi/sleep*.c

Pretty trivial unification; when two functions differed, it was
usually in error handling, and better of the two was picked up.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---

(Seems to work on i386, but needs some x86-64 testing.)

commit f540777f36d35da3ac43a76f73d66400e4024763
tree 28b02babaf0c597e1ea25bda9df96825ae94ef9e
parent dc9f39b93dc9e4ddddeaa25c2f7ec3e0a4ec830a
author Pavel <pavel@amd.ucw.cz> Mon, 07 Jan 2008 13:21:49 +0100
committer Pavel <pavel@amd.ucw.cz> Mon, 07 Jan 2008 13:21:49 +0100

 arch/x86/kernel/acpi/Makefile   |    2 -
 arch/x86/kernel/acpi/sleep.c    |   87 +++++++++++++++++++++++++++++
 arch/x86/kernel/acpi/sleep_32.c |   70 -----------------------
 arch/x86/kernel/acpi/sleep_64.c |  117 ---------------------------------------
 4 files changed, 88 insertions(+), 188 deletions(-)

diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 1351c39..19d3d6e 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_ACPI)		+= boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep_$(BITS).o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o processor.o
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
new file mode 100644
index 0000000..26db0c1
--- /dev/null
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -0,0 +1,87 @@
+/*
+ * sleep.c - x86-specific ACPI sleep support.
+ *
+ *  Copyright (C) 2001-2003 Patrick Mochel
+ *  Copyright (C) 2001-2003 Pavel Machek <pavel@suse.cz>
+ */
+
+#include <linux/acpi.h>
+#include <linux/bootmem.h>
+#include <linux/dmi.h>
+#include <linux/cpumask.h>
+
+#include <asm/smp.h>
+
+/* address in low memory of the wakeup routine. */
+unsigned long acpi_wakeup_address = 0;
+unsigned long acpi_realmode_flags;
+extern char wakeup_start, wakeup_end;
+
+extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
+
+/**
+ * acpi_save_state_mem - save kernel state
+ *
+ * Create an identity mapped page table and copy the wakeup routine to
+ * low memory.
+ */
+int acpi_save_state_mem(void)
+{
+	if (!acpi_wakeup_address) {
+		printk(KERN_ERR "Could not allocate memory during boot, S3 disabled\n");
+		return -ENOMEM;
+	}
+	memcpy((void *)acpi_wakeup_address, &wakeup_start,
+	       &wakeup_end - &wakeup_start);
+	acpi_copy_wakeup_routine(acpi_wakeup_address);
+
+	return 0;
+}
+
+/*
+ * acpi_restore_state - undo effects of acpi_save_state_mem
+ */
+void acpi_restore_state_mem(void)
+{
+}
+
+
+/**
+ * acpi_reserve_bootmem - do _very_ early ACPI initialisation
+ *
+ * We allocate a page from the first 1MB of memory for the wakeup
+ * routine for when we come back from a sleep state. The
+ * runtime allocator allows specification of <16MB pages, but not
+ * <1MB pages.
+ */
+void __init acpi_reserve_bootmem(void)
+{
+	if ((&wakeup_end - &wakeup_start) > PAGE_SIZE*2) {
+		printk(KERN_ERR
+		       "ACPI: Wakeup code way too big, S3 disabled.\n");
+		return;
+	}
+
+	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE*2);
+	if (!acpi_wakeup_address)
+		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
+}
+
+
+static int __init acpi_sleep_setup(char *str)
+{
+	while ((str != NULL) && (*str != '\0')) {
+		if (strncmp(str, "s3_bios", 7) == 0)
+			acpi_realmode_flags |= 1;
+		if (strncmp(str, "s3_mode", 7) == 0)
+			acpi_realmode_flags |= 2;
+		if (strncmp(str, "s3_beep", 7) == 0)
+			acpi_realmode_flags |= 4;
+		str = strchr(str, ',');
+		if (str != NULL)
+			str += strspn(str, ", \t");
+	}
+	return 1;
+}
+
+__setup("acpi_sleep=", acpi_sleep_setup);
diff --git a/arch/x86/kernel/acpi/sleep_32.c b/arch/x86/kernel/acpi/sleep_32.c
index 1069948..63fe552 100644
--- a/arch/x86/kernel/acpi/sleep_32.c
+++ b/arch/x86/kernel/acpi/sleep_32.c
@@ -12,76 +12,6 @@ #include <linux/cpumask.h>
 
 #include <asm/smp.h>
 
-/* address in low memory of the wakeup routine. */
-unsigned long acpi_wakeup_address = 0;
-unsigned long acpi_realmode_flags;
-extern char wakeup_start, wakeup_end;
-
-extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
-
-/**
- * acpi_save_state_mem - save kernel state
- *
- * Create an identity mapped page table and copy the wakeup routine to
- * low memory.
- */
-int acpi_save_state_mem(void)
-{
-	if (!acpi_wakeup_address)
-		return 1;
-	memcpy((void *)acpi_wakeup_address, &wakeup_start,
-	       &wakeup_end - &wakeup_start);
-	acpi_copy_wakeup_routine(acpi_wakeup_address);
-
-	return 0;
-}
-
-/*
- * acpi_restore_state - undo effects of acpi_save_state_mem
- */
-void acpi_restore_state_mem(void)
-{
-}
-
-/**
- * acpi_reserve_bootmem - do _very_ early ACPI initialisation
- *
- * We allocate a page from the first 1MB of memory for the wakeup
- * routine for when we come back from a sleep state. The
- * runtime allocator allows specification of <16MB pages, but not
- * <1MB pages.
- */
-void __init acpi_reserve_bootmem(void)
-{
-	if ((&wakeup_end - &wakeup_start) > PAGE_SIZE) {
-		printk(KERN_ERR
-		       "ACPI: Wakeup code way too big, S3 disabled.\n");
-		return;
-	}
-
-	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE);
-	if (!acpi_wakeup_address)
-		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
-}
-
-static int __init acpi_sleep_setup(char *str)
-{
-	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_realmode_flags |= 1;
-		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_realmode_flags |= 2;
-		if (strncmp(str, "s3_beep", 7) == 0)
-			acpi_realmode_flags |= 4;
-		str = strchr(str, ',');
-		if (str != NULL)
-			str += strspn(str, ", \t");
-	}
-	return 1;
-}
-
-__setup("acpi_sleep=", acpi_sleep_setup);
-
 /* Ouch, we want to delete this. We already have better version in userspace, in
    s2ram from suspend.sf.net project */
 static __init int reset_videomode_after_s3(const struct dmi_system_id *d)
diff --git a/arch/x86/kernel/acpi/sleep_64.c b/arch/x86/kernel/acpi/sleep_64.c
deleted file mode 100644
index da42de2..0000000
--- a/arch/x86/kernel/acpi/sleep_64.c
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- *  acpi.c - Architecture-Specific Low-Level ACPI Support
- *
- *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
- *  Copyright (C) 2001 Jun Nakajima <jun.nakajima@intel.com>
- *  Copyright (C) 2001 Patrick Mochel <mochel@osdl.org>
- *  Copyright (C) 2002 Andi Kleen, SuSE Labs (x86-64 port)
- *  Copyright (C) 2003 Pavel Machek, SuSE Labs
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/stddef.h>
-#include <linux/slab.h>
-#include <linux/pci.h>
-#include <linux/bootmem.h>
-#include <linux/acpi.h>
-#include <linux/cpumask.h>
-
-#include <asm/mpspec.h>
-#include <asm/io.h>
-#include <asm/apic.h>
-#include <asm/apicdef.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/pgalloc.h>
-#include <asm/io_apic.h>
-#include <asm/proto.h>
-#include <asm/tlbflush.h>
-
-/* --------------------------------------------------------------------------
-                              Low-Level Sleep Support
-   -------------------------------------------------------------------------- */
-
-/* address in low memory of the wakeup routine. */
-unsigned long acpi_wakeup_address = 0;
-unsigned long acpi_realmode_flags;
-extern char wakeup_start, wakeup_end;
-
-extern unsigned long acpi_copy_wakeup_routine(unsigned long);
-
-/**
- * acpi_save_state_mem - save kernel state
- *
- * Create an identity mapped page table and copy the wakeup routine to
- * low memory.
- */
-int acpi_save_state_mem(void)
-{
-	memcpy((void *)acpi_wakeup_address, &wakeup_start,
-	       &wakeup_end - &wakeup_start);
-	acpi_copy_wakeup_routine(acpi_wakeup_address);
-
-	return 0;
-}
-
-/*
- * acpi_restore_state
- */
-void acpi_restore_state_mem(void)
-{
-}
-
-/**
- * acpi_reserve_bootmem - do _very_ early ACPI initialisation
- *
- * We allocate a page in low memory for the wakeup
- * routine for when we come back from a sleep state. The
- * runtime allocator allows specification of <16M pages, but not
- * <1M pages.
- */
-void __init acpi_reserve_bootmem(void)
-{
-	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE*2);
-	if ((&wakeup_end - &wakeup_start) > (PAGE_SIZE*2))
-		printk(KERN_CRIT
-		       "ACPI: Wakeup code way too big, will crash on attempt"
-		       " to suspend\n");
-}
-
-static int __init acpi_sleep_setup(char *str)
-{
-	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_realmode_flags |= 1;
-		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_realmode_flags |= 2;
-		if (strncmp(str, "s3_beep", 7) == 0)
-			acpi_realmode_flags |= 4;
-		str = strchr(str, ',');
-		if (str != NULL)
-			str += strspn(str, ", \t");
-	}
-	return 1;
-}
-
-__setup("acpi_sleep=", acpi_sleep_setup);
-

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
