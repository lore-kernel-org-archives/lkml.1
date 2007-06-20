Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXFTBQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXFTBQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbXFTBQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:16:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:50053 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbXFTBQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:16:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,440,1175497200"; 
   d="scan'208";a="258893352"
Date: Wed, 20 Jun 2007 09:15:21 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Carlo Wood <carlo@alinoe.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070620011521.GB2856@zhen-devel.sh.intel.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
References: <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619233716.GA5779@alinoe.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.20 01:37:16 +0000, Carlo Wood wrote:
> The result of this patch is that the kernel starts to print
> "agpgart: Detected an Intel 965G Chipset." again with the usual
> disastrous results. Now, that doesn't mean that this patch is
> wrong - but it explains why the problem returns after this patch.
> 

Yep, the device table patch doesn't change any function, so your problem
started from when 965G support patch has been in kernel. 

Carlo, pls try a kernel param of "pci=nommconf" to see if that could
fix your hang. There might be a BIOS bug, as similar issue also happen
like https://bugzilla.novell.com/show_bug.cgi?id=228683

I think for i965 we could have following patch to fix this, we may
fail if no IGD device got detected. 

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 0439ee9..5a54a9c 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1855,15 +1855,15 @@ static const struct intel_driver_description {
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
 		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, 0, "965G",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, 0, "965Q",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, 0, "G33",
@@ -1917,6 +1917,7 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 	}
 
 	if (bridge->driver == NULL) {
+		/* The bridge has no AGP or no gfx device */
 		printk(KERN_WARNING PFX "Failed to find bridge device "
 			"(chip_id: %04x)\n", intel_agp_chipsets[i].gmch_chip_id);
 		agp_put_bridge(bridge);
---
