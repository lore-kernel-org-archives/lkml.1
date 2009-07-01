Return-Path: <linux-kernel-owner+w=401wt.eu-S1764906AbZGAA7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764906AbZGAA7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761467AbZGAAet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:49 -0400
Received: from kroah.org ([198.145.64.141]:60357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761458AbZGAAes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:27 2009
Message-Id: <20090701002427.223080661@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, jbarnes@virtuousgeek.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 045/108] x86: enable GART-IOMMU only after setting up protection methods
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Langsdorf <mark.langsdorf@amd.com>

commit fe2245c905631a3a353504fc04388ce3dfaf9d9e upstream.

The current code to set up the GART as an IOMMU enables GART
translations before it removes the aperture from the kernel memory
map, sets the GART PTEs to UC, sets up the guard and scratch
pages, or does a wbinvd().  This leaves the possibility of cache
aliasing open and can cause system crashes.

Re-order the code so as to enable the GART translations only
after all safeguards are in place and the tlb has been flushed.

AMD has tested this patch on both Istanbul systems and 1st
generation Opteron systems with APG enabled and seen no adverse
effects.  Istanbul systems with HT Assist enabled sometimes
see MCE errors due to cache artifacts with the unmodified
code.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: akpm@linux-foundation.org
Cc: jbarnes@virtuousgeek.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/pci-gart_64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -688,8 +688,6 @@ static __init int init_k8_gatt(struct ag
 
 	agp_gatt_table = gatt;
 
-	enable_gart_translations();
-
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
 		error = sysdev_register(&device_gart);
@@ -845,6 +843,14 @@ void __init gart_iommu_init(void)
 	 * the pages as Not-Present:
 	 */
 	wbinvd();
+
+	/*
+	 * Now all caches are flushed and we can safely enable
+	 * GART hardware.  Doing it early leaves the possibility
+	 * of stale cache entries that can lead to GART PTE
+	 * errors.
+	 */
+	enable_gart_translations();
 
 	/*
 	 * Try to workaround a bug (thanks to BenH):


