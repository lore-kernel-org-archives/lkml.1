Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYBLD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYBLD0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 22:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYBLD0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 22:26:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61679 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYBLD0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 22:26:01 -0500
Date: Mon, 11 Feb 2008 19:45:38 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 4/4] x86_64: check msr to get mmconfig for amd family 10h
 opteron v3
In-reply-to: <20080211185115.87e878d3.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: greg@kroah.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Message-id: <200802111945.38920.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802111643.17265.yinghai.lu@sun.com>
 <200802111820.47244.yinghai.lu@sun.com>
 <20080211185115.87e878d3.akpm@linux-foundation.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 06:51:15 pm Andrew Morton wrote:
> On Mon, 11 Feb 2008 18:20:46 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > On Monday 11 February 2008 05:09:44 pm Andrew Morton wrote:
> > > On Mon, 11 Feb 2008 16:48:35 -0800
> > > Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > > 
> > > > From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> > > > 
> > > > so even booting kernel with acpi=off or even MCFG is not there, we still can
> > > > use MMCONFIG.
> > > > 
> > > 
> > > This patch threw a big reject.  I didn't check why.
> > > 
> > > 
> > > > +		pci_direct_conf1.read(0, bus, devfn, 0, 4, &l);
> > > 
> > > When I fixed the reject, compilation failed here.
> > > 
> > > arch/x86/pci/mmconfig-shared.c: In function 'pci_mmcfg_check_hostbridge':
> > > arch/x86/pci/mmconfig-shared.c:214: error: 'pci_direct_conf1' undeclared (first use in this function)
> > > 
> > > 
> > > What kernel are you patching?
> > > 
> > 
> > linus tree. 
> 
> hm.  So why didn't it compile?  pci_direct_conf1 is defined over in
> arch/x86/pci/direct.c and is not mentioned in any header file.

it is in arch/x86/pci/pci.h

and arch/x86/pci/mmconf_shared.c has one 
#include "pci.h"

did you compile that for 32 bit? 

YH

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b6ce068a1285a24185b01be8a49021827516b3e1

diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 36cb44c..3431518 100644 (file)
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -85,10 +85,17 @@ extern spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
-extern int pci_conf1_write(unsigned int seg, unsigned int bus,
-                          unsigned int devfn, int reg, int len, u32 value);
-extern int pci_conf1_read(unsigned int seg, unsigned int bus,
-                         unsigned int devfn, int reg, int len, u32 *value);
+struct pci_raw_ops {
+       int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
+                                               int reg, int len, u32 *val);
+       int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
+                                               int reg, int len, u32 val);
+};
+
+extern struct pci_raw_ops *raw_pci_ops;
+extern struct pci_raw_ops *raw_pci_ext_ops;
+
+extern struct pci_raw_ops pci_direct_conf1;
 
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
