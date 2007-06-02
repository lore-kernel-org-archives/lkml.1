Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXFBOQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXFBOQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXFBOQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:16:14 -0400
Received: from n3.bullet.mail.re4.yahoo.com ([206.190.56.22]:23936 "HELO
	n3.bullet.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757788AbXFBOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:16:13 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jun 2007 10:16:13 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 560728.22211.bm@rrr3.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=N+iCDP4cd7MsUewMc9GL2pi+BK2bYfImjs2yJ9d8kFYUDD0rh32B+A6vktfsqwZdClZU22NlXVcwbAkqRTxVXRc9KYk3PSppW3HtL64qaCPz6jqPswmjGark9D/HOhnXL3b9G9LcUze+6eB8edKEXKfWWA5KTHrjZ2wAZpB9bWY=;
X-YMail-OSG: WzmeU8UVM1nQ.4sLt_UuuEZYlwKFWgjBTX4416Ki421Esj_.8JpqXU0JxhHaiIt_FtoO.g4e6UT_ml5GujSKB_xencqz8BZdWqq9K2nUH7drEZUy6I4TumVmmo6e6qCp
Date: Sat, 2 Jun 2007 07:10:58 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: [RFC][PATCH] IO-APIC blacklist
To: mingo@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1144838462-1180793458=:96605"
Content-Transfer-Encoding: 8bit
Message-ID: <477357.96605.qm@web63602.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1144838462-1180793458=:96605
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Hi,

I own a Dell OptiPlex GX240 which, when ACPI is disabled
but IO-APIC is enabled, shows very slow USB performance.
I thought that this could be related to IO-APIC and
tried to boot with "noapic" appended to the kernel
command line. This way the USB transfer speed returned
to normal values.

To make sure that noone else encounters a similar problem,
I have written a patch which includes an IO-APIC blacklist
and disables IO-APIC according to the blacklist.

I would like this patch to be merged into the main
tree. If there is any revision/correction that needs to
be done on the patch, please let me know.

I would appreciate any comments.

Thank you for your attention.

Regards,
- Tear

Note: The patch is appended and attached (in case
Yahoo wraps some lines.)

diff -u -r linux-2.6.21.3.orig/arch/i386/kernel/io_apic.c
linux-2.6.21.3/arch/i386/kernel/io_apic.c
--- linux-2.6.21.3.orig/arch/i386/kernel/io_apic.c	2007-06-01 19:01:35.000000000 +0000
+++ linux-2.6.21.3/arch/i386/kernel/io_apic.c	2007-06-01 21:00:46.000000000 +0000
@@ -35,6 +35,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
+#include <linux/dmi.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -98,6 +99,30 @@
 	unsigned int data;
 };
 
+static int __init disable_blacklisted_ioapic(struct dmi_system_id *d)
+{
+	printk(KERN_WARNING "%s detected... Disabling IO-APIC\n", d->ident);
+	skip_ioapic_setup = 1;
+	return(0);
+}
+
+static struct dmi_system_id __initdata ioapic_blacklist_dmi_table[] = {
+	{
+		.callback = disable_blacklisted_ioapic,
+		.ident = "Dell OptiPlex GX240",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex GX240"),
+		},
+	},
+	{ }
+};
+
+void __init check_ioapic_blacklist(void) {
+	printk(KERN_INFO "Checking for IO-APIC blacklisted systems...\n");
+	dmi_check_system(ioapic_blacklist_dmi_table);
+}
+
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
diff -u -r linux-2.6.21.3.orig/arch/i386/kernel/setup.c linux-2.6.21.3/arch/i386/kernel/setup.c
--- linux-2.6.21.3.orig/arch/i386/kernel/setup.c	2007-06-01 19:01:35.000000000 +0000
+++ linux-2.6.21.3/arch/i386/kernel/setup.c	2007-06-01 21:04:01.000000000 +0000
@@ -124,6 +124,7 @@
 #endif
 
 extern void early_cpu_init(void);
+extern void check_ioapic_blacklist(void);
 extern int root_mountflags;
 
 unsigned long saved_videomode;
@@ -616,6 +617,11 @@
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif	
+
+#ifdef CONFIG_X86_IO_APIC
+	check_ioapic_blacklist();
+#endif
+
 	if (efi_enabled)
 		efi_map_memmap();
 






       
____________________________________________________________________________________
Sick sense of humor? Visit Yahoo! TV's 
Comedy with an Edge to see what's on, when. 
http://tv.yahoo.com/collections/222
--0-1144838462-1180793458=:96605
Content-Type: text/x-patch; name="io_apic-patch.diff"
Content-Description: 1403027118-io_apic-patch.diff
Content-Disposition: inline; filename="io_apic-patch.diff"

diff -u -r linux-2.6.21.3.orig/arch/i386/kernel/io_apic.c linux-2.6.21.3/arch/i386/kernel/io_apic.c
--- linux-2.6.21.3.orig/arch/i386/kernel/io_apic.c	2007-06-01 19:01:35.000000000 +0000
+++ linux-2.6.21.3/arch/i386/kernel/io_apic.c	2007-06-01 21:00:46.000000000 +0000
@@ -35,6 +35,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
+#include <linux/dmi.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -98,6 +99,30 @@
 	unsigned int data;
 };
 
+static int __init disable_blacklisted_ioapic(struct dmi_system_id *d)
+{
+	printk(KERN_WARNING "%s detected... Disabling IO-APIC\n", d->ident);
+	skip_ioapic_setup = 1;
+	return(0);
+}
+
+static struct dmi_system_id __initdata ioapic_blacklist_dmi_table[] = {
+	{
+		.callback = disable_blacklisted_ioapic,
+		.ident = "Dell OptiPlex GX240",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex GX240"),
+		},
+	},
+	{ }
+};
+
+void __init check_ioapic_blacklist(void) {
+	printk(KERN_INFO "Checking for IO-APIC blacklisted systems...\n");
+	dmi_check_system(ioapic_blacklist_dmi_table);
+}
+
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
diff -u -r linux-2.6.21.3.orig/arch/i386/kernel/setup.c linux-2.6.21.3/arch/i386/kernel/setup.c
--- linux-2.6.21.3.orig/arch/i386/kernel/setup.c	2007-06-01 19:01:35.000000000 +0000
+++ linux-2.6.21.3/arch/i386/kernel/setup.c	2007-06-01 21:04:01.000000000 +0000
@@ -124,6 +124,7 @@
 #endif
 
 extern void early_cpu_init(void);
+extern void check_ioapic_blacklist(void);
 extern int root_mountflags;
 
 unsigned long saved_videomode;
@@ -616,6 +617,11 @@
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif	
+
+#ifdef CONFIG_X86_IO_APIC
+	check_ioapic_blacklist();
+#endif
+
 	if (efi_enabled)
 		efi_map_memmap();
 

--0-1144838462-1180793458=:96605--

