Return-Path: <linux-kernel-owner+w=401wt.eu-S1765872AbXJSP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765872AbXJSP2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXJSP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:28:29 -0400
Received: from slackadelic.com ([65.196.224.53]:34522 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXJSP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:28:28 -0400
From: Carlos Corbacho <cathectic@slackadelic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: nVidia HPET force enable - merge requirements? (resend)
Date: Fri, 19 Oct 2007 16:29:10 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200710190423.31714.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710190847500.22770@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710190847500.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191629.11526.cathectic@slackadelic.com>
X-slackadelic.com-MailScanner-Information: Please contact the ISP for more information
X-slackadelic.com-MailScanner: Found to be clean
X-slackadelic.com-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.7, required 4, J_CHICKENPOX_45 0.60, RDNS_DYNAMIC 0.10)
X-slackadelic.com-MailScanner-From: cathectic@slackadelic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Friday 19 October 2007 07:50:08 Thomas Gleixner wrote:
> So if there are working quirks, please refactor them analogous to the
> existing ones in quirks.c.
> 
> All undocumented chipset poking needs to be protected by the
> hpet=force boot option, so the default is not to do scan for it.

Would the following patch be more acceptable then? I've limited the device
id's to just the nForce 4 chipset, because that's the only one I have here
to test with at the moment - it appears to work fine:

hpet clockevent registered
hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1

At the moment, I'm not clear on how to detect if the HPET has not been
enabled by the BIOS (but given that this is hidden behind hpet=force,
would this be acceptable, since the user would have to explicitly call
hpet=force, and then it either works or doesn't?)

-Carlos

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index a4ce191..7c772bf 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -321,6 +321,26 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
 
+static void nvidia_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 uninitialized_var(val);
+
+	if (!hpet_force_user || hpet_address || force_hpet_address)
+		return;
+
+	pci_read_config_dword(dev, 0x44, &val);
+	force_hpet_address = val;
+	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+	       force_hpet_address);
+	cached_dev = dev;
+	return;
+}
+
+/* ISA Bridge */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0050,
+			 nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0051,
+			 nvidia_force_enable_hpet);
 
 void force_hpet_resume(void)
 {
