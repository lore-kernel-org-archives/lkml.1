Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYEJUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYEJUlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYEJUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:41:07 -0400
Received: from www.tglx.de ([62.245.132.106]:59057 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYEJUlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:41:05 -0400
Date: Sat, 10 May 2008 22:40:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
In-Reply-To: <20080509165501.a0fdb29d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805102238440.3197@apollo.tec.linutronix.de>
References: <20080509094911.GG5023@alberich.amd.com> <20080509163731.5f851bec.akpm@linux-foundation.org> <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de> <20080509165501.a0fdb29d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Andrew Morton wrote:
> On Sat, 10 May 2008 01:42:30 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 9 May 2008, Andrew Morton wrote:
> > > On Fri, 9 May 2008 11:49:11 +0200
> > > Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > > 
> > > > x86: enable hpet=force for ATI SB400
> > > 
> > > Sigh.
> > > 
> > > > Add quirk to allow forced usage of HPET on ATI SB400.
> > > > I stumbled over machines where HPET is enabled but not reported
> > > > by BIOS.
> > > 
> > > Is there no way in which we can probe for or identify this condition,
> > > rather than hoping that the user will find out about this boot option?
> > 
> > I'd love to have a sane solution for that, but looking at the rate of
> > HPET wreckage since we increased the usage of HPET I'm happy to have
> > this as an opt in thingy.
> > 
> 
> Well we don't have to auto-enable the hpet.  Simply adding a loud "you
> should try the hpet=force option" printk would help a lot of people.

Something like this ? That's on top of linus + Andreas SB400 patch

Thanks,
	tglx

------------> 
commit 3d5f406b110b1b1d314805a1a4c1744ff05d7f22
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat May 10 21:42:14 2008 +0200

    x86: print info about available HPET quirk
    
    We have a lot of HPET quirks available which might force enable HPET
    even when the BIOS does not enable it. Some of those quirks depend on
    the command line option "hpet=force".
    
    Andrew pointed out that hoping that the user will find out about this
    boot option is not really helpful.
    
    Emit a kernel info which informs the user about the "hpet=force" boot
    option when we enter a quirk which depends on this option and the user
    did not provide it.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 5fe6bd5..ddbf34d 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -175,6 +175,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
 
 static struct pci_dev *cached_dev;
 
+static void hpet_print_force_info(void)
+{
+	printk(KERN_INFO "HPET not enabled in BIOS. "
+	       "You might try hpet=force boot option\n");
+}
+
 static void old_ich_force_hpet_resume(void)
 {
 	u32 val;
@@ -254,6 +260,8 @@ static void old_ich_force_enable_hpet_user(struct pci_dev *dev)
 {
 	if (hpet_force_user)
 		old_ich_force_enable_hpet(dev);
+	else
+		hpet_print_force_info();
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0,
@@ -291,8 +299,13 @@ static void vt8237_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 uninitialized_var(val);
 
-	if (!hpet_force_user || hpet_address || force_hpet_address)
+	if (hpet_address || force_hpet_address)
+		return;
+
+	if (!hpet_force_user) {
+		hpet_print_force_info();
 		return;
+	}
 
 	pci_read_config_dword(dev, 0x68, &val);
 	/*
@@ -341,8 +354,13 @@ static void ati_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 uninitialized_var(val);
 
-	if (!hpet_force_user || hpet_address || force_hpet_address)
+	if (hpet_address || force_hpet_address)
+		return;
+
+	if (!hpet_force_user) {
+		hpet_print_force_info();
 		return;
+	}
 
 	pci_write_config_dword(dev, 0x14, 0xfed00000);
 	pci_read_config_dword(dev, 0x14, &val);
@@ -369,8 +387,13 @@ static void nvidia_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 uninitialized_var(val);
 
-	if (!hpet_force_user || hpet_address || force_hpet_address)
+	if (hpet_address || force_hpet_address)
+		return;
+
+	if (!hpet_force_user) {
+		hpet_print_force_info();
 		return;
+	}
 
 	pci_write_config_dword(dev, 0x44, 0xfed00001);
 	pci_read_config_dword(dev, 0x44, &val);
