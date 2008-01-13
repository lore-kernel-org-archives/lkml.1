Return-Path: <linux-kernel-owner+w=401wt.eu-S1751506AbYAMH6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbYAMH6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 02:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYAMH6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 02:58:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55001 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYAMH6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 02:58:33 -0500
Date: Sun, 13 Jan 2008 00:58:31 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080113075830.GC18741@parisc-linux.org>
References: <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113072415.GB18741@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 12:24:15AM -0700, Matthew Wilcox wrote:
> Here's a patch (on top of Ivan's) to improve things further.

Oops.  I forgot to check the ordering of mmconfig vs direct probing, so
that patch would end up just using mmconfig for everything.  Not what we
want.  Also, there's three bits of mmconfig-shared that're probing using
conf1, even if it might have failed.  And if we're going to use
raw_pci_read() when conf1 might have failed and mmconf isn't set up yet,
we need to check raw_pci_ops in raw_pci_read().  Add the check in
raw_pci_write too, just for symmetry.

I don't like it that mmconfig_32 prints a message and mmconfig_64
doesn't, but fixing that is not part of this patch.

Interdiff:

diff -u b/arch/x86/pci/common.c b/arch/x86/pci/common.c
--- b/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -31,7 +31,7 @@
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
 {
-	if (reg < 256)
+	if (reg < 256 && raw_pci_ops)
 		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
 	if (raw_pci_ext_ops)
 		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
@@ -41,7 +41,7 @@
 int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 val)
 {
-	if (reg < 256)
+	if (reg < 256 && raw_pci_ops)
 		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
 	if (raw_pci_ext_ops)
 		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
diff -u b/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
--- b/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -28,7 +28,7 @@
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+	raw_pci_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
 
 	win = win & 0xf000;
 	if(win == 0x0000 || win == 0xf000)
@@ -53,7 +53,7 @@
 
 	pci_mmcfg_config_num = 1;
 
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+	raw_pci_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
 
 	/* Enable bit */
 	if (!(pciexbar & 1))
@@ -118,7 +118,7 @@
 	int i;
 	const char *name;
 
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
+	raw_pci_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
 	vendor = l & 0xffff;
 	device = (l >> 16) & 0xffff;
 
diff -u b/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
--- b/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -132,8 +132,10 @@
 
 int __init pci_mmcfg_arch_init(void)
 {
-	printk(KERN_INFO "PCI: Using MMCONFIG\n");
-	raw_pci_ops = &pci_mmcfg;
+	printk(KERN_INFO "PCI: Using MMCONFIG for %s config space\n",
+		raw_pci_ops ? "extended" : "all");
+	if (!raw_pci_ops)
+		raw_pci_ops = &pci_mmcfg;
 	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
diff -u b/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
--- b/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -144,7 +144,8 @@
 			return 0;
 		}
 	}
-	raw_pci_ops = &pci_mmcfg;
+	if (!raw_pci_ops)
+		raw_pci_ops = &pci_mmcfg;
 	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
