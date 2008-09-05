Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYIESr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYIESr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYIESrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:47:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIESrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:47:15 -0400
Subject: Re: [PATCH] Blacklist DMAR on Intel G31/G33 chipsets
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, arjan@infradead.org,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20080905183459.GC14258@elte.hu>
References: <1220439231.2985.103.camel@pmac.infradead.org>
	 <1220518477.2985.163.camel@pmac.infradead.org>
	 <20080905183459.GC14258@elte.hu>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 19:47:09 +0100
Message-Id: <1220640430.2985.389.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 20:34 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
> > when they don't. Avoid the resulting crashes when it doesn't work as
> > expected.
> > 
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > ---
> > 
> > This time, I build-tested it with CONFIG_DMAR actually enabled. Sorry. 
> > I'd still be grateful if someone could test it on a DG33BU with the 
> > old BIOS though, since I've killed mine. I tested the DMI version, but 
> > not this one.
> 
> ok - fixing this makes sense. I have two worries about this patch.
> 
> Firstly, the quirk is keyed off an ACPI capability which is quite bad if 
> someone boots with ACPI off. (which is still quite possible) The DMAR is 
> PCI enumerated so there's nothing inherently ACPI about this. A DMI 
> quirk (which will work even if ACPI is disabled) looks more robust.

No, the intel-iommu code is isn't PCI-enumerated -- it all depends on
that ACPI table, unfortunately. That's why we're have this problem in
the first place and why I'm left with a dead board; apparently they
still drag crack-smoking hobos in off the street to write BIOSes, and
we're trusting more and more of our system to this crap every day.

I'm perfectly happy to go back to my original DMI-based version though.
Here it is...

Subject: Blacklist DMAR on Intel G31/G33 chipsets
    
Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
when they don't. Avoid the resulting crashes when it doesn't work as
expected.
    
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>


diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8d0e60a..c3edcdc 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2348,11 +2348,34 @@ static void __init iommu_exit_mempool(void)
 
 }
 
+static int blacklist_iommu(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO "%s detected; disabling IOMMU\n",
+	       id->ident);
+	dmar_disabled = 1;
+	return 0;
+}
+
+static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
+	{	/* Some DG33BU BIOS revisions advertised non-existent VT-d */
+		.callback = blacklist_iommu,
+		.ident = "Intel DG33BU",
+		{	DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "DG33BU"),
+		}
+	},
+	{ }
+};
+
+
 void __init detect_intel_iommu(void)
 {
 	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
 		return;
 	if (early_dmar_detect()) {
+		dmi_check_system(intel_iommu_dmi_table);
+		if (dmar_disabled)
+			return;
 		iommu_detected = 1;
 	}
 }


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



