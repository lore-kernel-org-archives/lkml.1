Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbXFVTSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbXFVTSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759899AbXFVTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:18:00 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63871 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXFVTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:17:59 -0400
Date: Fri, 22 Jun 2007 12:19:15 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86-64: disable the GART before allocate aperture
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706221219.16243.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86-64: disable the GART before allocate aperture

For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
installed. when mem is allocated for GART, it will do the memset for clear.
and for kexec case, the first kernel already enable that, the memset in second
kernel will cause the system restart. So disable that at first before we try to
allocate mem for it.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86_64/kernel/aperture.c b/arch/x86_64/kernel/aperture.c
index a3d450d..7a1b072 100644
--- a/arch/x86_64/kernel/aperture.c
+++ b/arch/x86_64/kernel/aperture.c
@@ -270,6 +270,19 @@ void __init iommu_hole_init(void)
 		printk("This costs you %d MB of RAM\n",
 		       32 << fallback_aper_order);
 
+		/*
+		 * disable it in case it is enabled before, esp for kexec/kdump,
+		 * previous kernel already enable that. otherwise memset called
+		 * by allocate_aperture/__alloc_bootmem_nopanic cause restart.
+		 */
+		for (num = 24; num < 32; num++) {
+			if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
+				continue;
+
+			write_pci_config(0, num, 3, 0x90, 0);
+			write_pci_config(0, num, 3, 0x94, 0);
+		}
+
 		aper_order = fallback_aper_order;
 		aper_alloc = allocate_aperture();
 		if (!aper_alloc) { 
