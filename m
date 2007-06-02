Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXFBXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXFBXsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbXFBXsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:48:10 -0400
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:36344 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754420AbXFBXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:48:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 147103.7042.bm@rrr3.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=SNDBLJ071U1N7Fn32sTq6bd9Hjl6iaWIV5cKkbAvJPCG/TL1bZpXyFJWYUjFeLk88yc9eUwBaRppvyuvzC4dfCQHyxIwbpqFsukf3v5AuEBhboQxJXW1loq5m3Xz61t6QnGMl821TgrWog3aGboWjncl5pccWquzfd0sY0lA5DI=;
X-YMail-OSG: BrW4GYoVM1nMuCj.8A7cV4EsiBzmc4dQoIhRurU3ZgnPTBFDOp.hOIq5AU2FW_1YwbipJjKEYu1cQB0yubQ36I65Yg--
Date: Sat, 2 Jun 2007 16:48:05 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, mingo@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0706021353430.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-9664584-1180828085=:60161"
Content-Transfer-Encoding: 8bit
Message-ID: <962387.60161.qm@web63610.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-9664584-1180828085=:60161
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Linus Torvalds wrote:
> On Sat, 2 Jun 2007, Tear wrote:
> > >
> > > Wouldn't this also disable the IOAPIC in the (working) ACPI+IOAPIC case?
> >
> > Yes, it would. However, I wanted to make my addition
> > to the kernel generic so that other people with
> > problematic IO-APIC implementations can blacklist
> > their systems without checking whether ACPI is enabled
> > or not.
> 
> But that's just wrong. First off, all distro kernels come with ACPI on, so
> the thing you're fixing is really just for somebody who compiles his own
> kernel in a particular (and unusual/strange) configuration, and you're
> making it _worse_ for everybody else.

Mr. Torvalds,

The patch scans the DMI for "Dell OptiPlex GX240"
and disables IO-APIC only if such a system is detected.
It does not disable IO-APIC for other people.

In addition, Dell OptiPlex GX240 is (at least currently)
in the ACPI blacklist. So with a regular distro, one
gets IO-APIC and acpi=ht which causes USB transfers
to be very slow. 

I have made an attempt to get Dell OptiPlex GX240
out of the ACPI blacklist. Please see:
http://marc.info/?t=117897881900001&r=1&w=2

Nevertheless, I am willing to modify the patch
to make IO-APIC work when ACPI is enabled. A
quick search pointed me to the variable named
"acpi_disabled". I can use this variable to
detect whether ACPI is enabled and disable
IO-APIC if it is not. Please see the
attached patch for such an implementation.

> And you're blacklisting it without even understaning _what_ is wrong. I
> really think we should figure that part out first,

I willing to put effort into figuring out what
is wrong. Please let me know if there is anything
I can do to further our information about this
problem. As I said before, I would be glad to
send to you the diff between any of the four
cases I mentioned in my previous e-mail to you.

Were you able to take a look at the dmesg
outputs in my previous e-mail?

Thank you for your attention.

Regards,
- Tear




       
____________________________________________________________________________________
Choose the right car based on your needs.  Check out Yahoo! Autos new Car Finder tool.
http://autos.yahoo.com/carfinder/
--0-9664584-1180828085=:60161
Content-Type: text/x-patch; name="io_apic-patch2.diff"
Content-Description: 4294953666-io_apic-patch2.diff
Content-Disposition: inline; filename="io_apic-patch2.diff"

--- linux-2.6.21.3.orig/arch/i386/kernel/io_apic.c	2007-06-02 14:17:10.000000000 +0000
+++ linux-2.6.21.3/arch/i386/kernel/io_apic.c	2007-06-02 22:24:44.000000000 +0000
@@ -35,6 +35,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
+#include <linux/dmi.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -44,6 +45,7 @@
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/acpi.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
@@ -98,6 +100,33 @@
 	unsigned int data;
 };
 
+static int __init disable_gx240_ioapic(struct dmi_system_id *d)
+{
+	/* Disable IO-APIC only if ACPI is disabled */
+	if (acpi_disabled) {
+		printk(KERN_WARNING "%s detected... Disabling IO-APIC\n", d->ident);
+		skip_ioapic_setup = 1;
+	}
+	return(0);
+}
+
+static struct dmi_system_id __initdata ioapic_blacklist_dmi_table[] = {
+	{
+		.callback = disable_gx240_ioapic,
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
--- linux-2.6.21.3.orig/arch/i386/kernel/setup.c	2007-06-02 14:17:10.000000000 +0000
+++ linux-2.6.21.3/arch/i386/kernel/setup.c	2007-06-02 22:39:46.000000000 +0000
@@ -124,6 +124,7 @@
 #endif
 
 extern void early_cpu_init(void);
+extern void check_ioapic_blacklist(void);
 extern int root_mountflags;
 
 unsigned long saved_videomode;
@@ -642,6 +643,11 @@
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
 #endif
 #endif
+
+#ifdef CONFIG_X86_IO_APIC
+	check_ioapic_blacklist(); /* This must be after acpi_boot_init */
+#endif
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	if (smp_found_config)
 		get_smp_config();

--0-9664584-1180828085=:60161--

