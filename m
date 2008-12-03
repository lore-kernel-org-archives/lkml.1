Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYLCUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYLCUId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYLCTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:58 -0500
Received: from kroah.org ([198.145.64.141]:60099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755279AbYLCTwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:54 -0500
Date: Wed, 3 Dec 2008 11:51:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 046/104] x86: SB600: skip ACPI IRQ0 override if it is not
	routed to INT2 of IOAPIC
Message-ID: <20081203195127.GU8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-sb600-skip-acpi-irq0-override-if-it-is-not-routed-to-int2-of-ioapic.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 26adcfbf00e0726b4469070aa2f530dcf963f484 upstream.

On some more HP laptops BIOS reports an IRQ0 override
but the SB600 chipset is configured such that timer
interrupts go to INT0 of IOAPIC.

Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the
timer override.

http://bugzilla.kernel.org/show_bug.cgi?id=11715
http://bugzilla.kernel.org/show_bug.cgi?id=11516

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/early-quirks.c |   55 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,7 +95,8 @@ static void __init nvidia_bugs(int num, 
 
 }
 
-static u32 ati_ixp4x0_rev(int num, int slot, int func)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
 	u8  b;
@@ -115,7 +116,6 @@ static u32 ati_ixp4x0_rev(int num, int s
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 	u32 d;
 	u8  b;
 
@@ -138,9 +138,56 @@ static void __init ati_bugs(int num, int
 		printk(KERN_INFO "If you got timer trouble "
 		       "try acpi_use_timer_override\n");
 	}
-#endif
 }
 
+static u32 __init ati_sbx00_rev(int num, int slot, int func)
+{
+	u32 old, d;
+
+	d = read_pci_config(num, slot, func, 0x70);
+	old = d;
+	d &= ~(1<<8);
+	write_pci_config(num, slot, func, 0x70, d);
+	d = read_pci_config(num, slot, func, 0x8);
+	d &= 0xff;
+	write_pci_config(num, slot, func, 0x70, old);
+
+	return d;
+}
+
+static void __init ati_bugs_contd(int num, int slot, int func)
+{
+	u32 d, rev;
+
+	if (acpi_use_timer_override)
+		return;
+
+	rev = ati_sbx00_rev(num, slot, func);
+	if (rev > 0x13)
+		return;
+
+	/* check for IRQ0 interrupt swap */
+	d = read_pci_config(num, slot, func, 0x64);
+	if (!(d & (1<<14)))
+		acpi_skip_timer_override = 1;
+
+	if (acpi_skip_timer_override) {
+		printk(KERN_INFO "SB600 revision 0x%x\n", rev);
+		printk(KERN_INFO "Ignoring ACPI timer override.\n");
+		printk(KERN_INFO "If you got timer trouble "
+		       "try acpi_use_timer_override\n");
+	}
+}
+#else
+static void __init ati_bugs(int num, int slot, int func)
+{
+}
+
+static void __init ati_bugs_contd(int num, int slot, int func)
+{
+}
+#endif
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -162,6 +209,8 @@ static struct chipset early_qrk[] __init
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 	{}
 };
 

