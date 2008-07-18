Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYGRUsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYGRUsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYGRUsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:48:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYGRUs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:48:29 -0400
Date: Fri, 18 Jul 2008 22:48:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       jbarnes@virtuousgeek.org, Jack Howarth <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: detect end_bus_number according to acpi/e820
	reserved
Message-ID: <20080718204814.GA24373@elte.hu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <200807181322.37500.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807181322.37500.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> for MacBookPro2
> 
> change the mconf bus range from [0,0xff] to to [0, 0x3f]
> to match range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

pushed the commit below into tip/pci-for-jesse.

Jack, could you check whether the end result in tip/master boots fine on 
your 3GB MacBook by default:

   http://people.redhat.com/mingo/x86.git/README

... and let us know if there are any other problems/weirdnesses.

	Ingo

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git pci-for-jesse

------------------------->
commit 473e6a3881ed2b5903252cb6a759d55aecff8611
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Fri Jul 18 13:22:36 2008 -0700

    x86, pci: detect end_bus_number according to acpi/e820 reserved
    
    Jack Howarth reported that 2.6.26-rc9-git9 doesn't boot on MacBookPro2.
    
    the reason is a faulty BIOS update that reportes faulty resources.
    
    Nevertheless it's possible for Linux to be more resolent about this
    situation (and similar situations) and work around this bug, by
    cross-checking the mmconf range against the e820 table and ACPI resources.
    
    Change the mconf bus range from [0,0xff] to to [0, 0x3f]
    to match range [0xf0000000, 0xf4000000) in e820 tables.
    
    Reported-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Cc: jbarnes@virtuousgeek.org
    Cc: Jack Howarth <howarth@bromo.msbb.uc.edu>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/mmconfig-shared.c |   64 +++++++++++++++++++++++++++++----------
 1 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 23faaa8..9297882 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -293,7 +293,7 @@ static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
 	return AE_OK;
 }
 
-static int __init is_acpi_reserved(unsigned long start, unsigned long end)
+static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
 {
 	struct resource mcfg_res;
 
@@ -310,6 +310,41 @@ static int __init is_acpi_reserved(unsigned long start, unsigned long end)
 	return mcfg_res.flags;
 }
 
+typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
+
+static int __init is_mmconf_reserved(check_reserved_t is_reserved,
+		u64 addr, u64 size, int i,
+		typeof(pci_mmcfg_config[0]) *cfg, int with_e820)
+{
+	u64 old_size = size;
+	int valid = 0;
+
+	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
+		size >>= 1;
+		if (size < (16UL<<20))
+			break;
+	}
+
+	if (size >= (16UL<<20) || size == old_size) {
+		printk(KERN_NOTICE
+		       "PCI: MCFG area at %Lx reserved in %s\n",
+			addr, with_e820?"E820":"ACPI motherboard resources");
+		valid = 1;
+
+		if (old_size != size) {
+			/* update end_bus_number */
+			cfg->end_bus_number = cfg->start_bus_number + ((size>>20) - 1);
+			printk(KERN_NOTICE "PCI: updated MCFG configuration %d: base %lx "
+			       "segment %hu buses %u - %u\n",
+			       i, (unsigned long)cfg->address, cfg->pci_segment,
+			       (unsigned int)cfg->start_bus_number,
+			       (unsigned int)cfg->end_bus_number);
+		}
+	}
+
+	return valid;
+}
+
 static void __init pci_mmcfg_reject_broken(int early)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
@@ -324,21 +359,21 @@ static void __init pci_mmcfg_reject_broken(int early)
 
 	for (i = 0; i < pci_mmcfg_config_num; i++) {
 		int valid = 0;
-		u32 size = (cfg->end_bus_number + 1) << 20;
+		u64 addr, size;
+
 		cfg = &pci_mmcfg_config[i];
+		addr = cfg->start_bus_number;
+		addr <<= 20;
+		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
+		size <<= 20;
 		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
 		       "segment %hu buses %u - %u\n",
 		       i, (unsigned long)cfg->address, cfg->pci_segment,
 		       (unsigned int)cfg->start_bus_number,
 		       (unsigned int)cfg->end_bus_number);
 
-		if (!early &&
-		    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
-			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
-			       "in ACPI motherboard resources\n",
-			       cfg->address);
-			valid = 1;
-		}
+		if (!early)
+			valid = is_mmconf_reserved(is_acpi_reserved, addr, size, i, cfg, 0);
 
 		if (valid)
 			continue;
@@ -347,16 +382,11 @@ static void __init pci_mmcfg_reject_broken(int early)
 			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
 			       " reserved in ACPI motherboard resources\n",
 			       cfg->address);
+
 		/* Don't try to do this check unless configuration
 		   type 1 is available. how about type 2 ?*/
-		if (raw_pci_ops && e820_all_mapped(cfg->address,
-						  cfg->address + size - 1,
-						  E820_RESERVED)) {
-			printk(KERN_NOTICE
-			       "PCI: MCFG area at %Lx reserved in E820\n",
-			       cfg->address);
-			valid = 1;
-		}
+		if (raw_pci_ops)
+			valid = is_mmconf_reserved(e820_all_mapped, addr, size, i, cfg, 1);
 
 		if (!valid)
 			goto reject;
