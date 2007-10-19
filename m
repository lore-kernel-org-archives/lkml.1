Return-Path: <linux-kernel-owner+w=401wt.eu-S1765844AbXJSRvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765844AbXJSRvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935452AbXJSRut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:50:49 -0400
Received: from slackadelic.com ([65.196.224.53]:54936 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203AbXJSRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:50:48 -0400
From: Carlos Corbacho <cathectic@slackadelic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: Force enable HPET for CK804 (nForce 4) chipsets
Date: Fri, 19 Oct 2007 18:51:27 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200710190423.31714.cathectic@slackadelic.com> <200710191629.11526.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710191736280.22770@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710191736280.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710191851.28639.cathectic@slackadelic.com>
X-slackadelic.com-MailScanner-Information: Please contact the ISP for more information
X-slackadelic.com-MailScanner: Found to be clean
X-slackadelic.com-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.1, required 4, RDNS_DYNAMIC 0.10)
X-slackadelic.com-MailScanner-From: cathectic@slackadelic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <cathectic@gmail.com>

This patch adds a quirk from LinuxBIOS to force enable HPET on
the nVidia CK804 (nForce 4) chipset.

This quirk can very likely support more than just nForce 4
(LinuxBIOS use the same code for nForce 5), and possibly nForce 3,
but I don't have those chipsets, so cannot add and test them.

Tested on an Abit KN9 (CK804).

Signed-off-by: Carlos Corbacho <cathectic@gmail.com>
---
Thomas,

I've rewritten the code based on what LinuxBIOS does, since they have a better idea
of how to drive the HPET than I do. I've tested this code, and it's also working
fine here on my system.

 Documentation/kernel-parameters.txt |    3 +-
 arch/x86/kernel/quirks.c            |   36 ++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 983f631..8abbfe6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -434,7 +434,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	hpet=		[X86-32,HPET] option to control HPET usage
 			Format: { enable (default) | disable | force }
 			disable: disable HPET and use PIT instead
-			force: allow force enabled of undocumented chips (ICH4, VIA)
+			force: allow force enabled of undocumented chips (ICH4,
+			VIA, nVidia)
 
 	com20020=	[HW,NET] ARCnet - COM20020 chipset
 			Format:
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index a4ce191..cb21bcb 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -60,7 +60,8 @@ static enum {
 	NONE_FORCE_HPET_RESUME,
 	OLD_ICH_FORCE_HPET_RESUME,
 	ICH_FORCE_HPET_RESUME,
-	VT8237_FORCE_HPET_RESUME
+	VT8237_FORCE_HPET_RESUME,
+	NVIDIA_FORCE_HPET_RESUME,
 } force_hpet_resume_type;
 
 static void __iomem *rcba_base;
@@ -321,6 +322,36 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
 
+/*
+ * Undocumented chipset feature taken from LinuxBIOS.
+ */
+static void nvidia_force_hpet_resume(void)
+{
+	pci_write_config_dword(cached_dev, 0x44, 0xfed00001);
+	printk(KERN_DEBUG "Force enabled HPET at resume\n");
+}
+
+static void nvidia_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 uninitialized_var(val);
+
+	if (!hpet_force_user || hpet_address || force_hpet_address)
+		return;
+
+	pci_write_config_dword(dev, 0x44, 0xfed00001);
+	pci_read_config_dword(dev, 0x44, &val);
+	force_hpet_address = val & 0xfffffffe;
+	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+		force_hpet_address);
+	cached_dev = dev;
+	return;
+}
+
+/* ISA Bridges */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0050,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0051,
+			nvidia_force_enable_hpet);
 
 void force_hpet_resume(void)
 {
@@ -334,6 +365,9 @@ void force_hpet_resume(void)
 	    case VT8237_FORCE_HPET_RESUME:
 		return vt8237_force_hpet_resume();
 
+	    case NVIDIA_FORCE_HPET_RESUME:
+		return nvidia_force_hpet_resume();
+
 	    default:
 		break;
 	}
-- 
1.5.2.2
