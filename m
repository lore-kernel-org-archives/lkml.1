Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbYALCCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbYALCCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 21:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYALCCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 21:02:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYALCCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 21:02:00 -0500
Subject: [Fwd: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a
	driver opt-in]
From: Tony Camuso <tcamuso@redhat.com>
To: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@atrey.karlin.mff.cuni.cz" 
	<linux-pci@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 21:01:54 -0500
Message-Id: <1200103314.13490.7.camel@dhcp83-188.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, 

Meant to press reply/all. 

-------- Forwarded Message --------
From: Tony Camuso <tcamuso@redhat.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a
driver opt-in
Date: Fri, 11 Jan 2008 20:58:52 -0500

Greg KH wrote:
> Ivan, you posted one a while ago, but never seemed to get any
> confirmation if it helped or not.  Should I use that and drop Arjan's?
> Or use both?  Or something else like the patches proposed by Tony
> Camuso?

The 5-patch set I submitted is for Northbridges that don't respond to 
MMCONFIG cycles at all. We (RH & HP) were blacklisting boxes in RHEL,
limiting them to legacy PCI, platform-wide. This was bad for systems
that had both PCI legacy and PCI express buses, because it limited 
the functionality of the PCI express buses. 

The problem Matthew described is different, having to do with bus
sizing code causing the large displacement of the graphics chip to
overlap the decode for MMCONFIG space. 

Ivan suggested a fix for this problem that limits offsets below 64 bytes
to lgecacy PCI config access. 

I tried this and it works perfectly!

I submitted an informal patch for folks to try. 

Here it is again.

diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 1bf5816..4474979 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -73,7 +73,7 @@ static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 	}
 
 	base = get_base_addr(seg, bus, devfn);
-	if (!base)
+	if ((!base) || (reg < 0x40))
 		return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -106,7 +106,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		return -EINVAL;
 
 	base = get_base_addr(seg, bus, devfn);
-	if (!base)
+	if ((!base) || (reg < 0x40))
 		return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
 	spin_lock_irqsave(&pci_config_lock, flags);
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 4095e4d..4ad1fcb 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -61,7 +61,7 @@ static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 	}
 
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if ((!addr) || (reg < 0x40))
 		return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
 	switch (len) {
@@ -89,7 +89,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		return -EINVAL;
 
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if ((!addr) || (reg < 0x40))
 		return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
 	switch (len) {


