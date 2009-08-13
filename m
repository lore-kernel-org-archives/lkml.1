Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZHMTr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZHMTr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbZHMTr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:56 -0400
Received: from kroah.org ([198.145.64.141]:36746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbZHMTrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:37 2009
Message-Id: <20090813194337.619553936@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, jbarnes@virtuousgeek.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 14/28] x86: enable GART-IOMMU only after setting up protection methods
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -658,8 +658,6 @@ static __init int init_k8_gatt(struct ag
 	memset(gatt, 0, gatt_size);
 	agp_gatt_table = gatt;
 
-	enable_gart_translations();
-
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
 		error = sysdev_register(&device_gart);
@@ -828,6 +826,14 @@ void __init gart_iommu_init(void)
 	wbinvd();
 
 	/*
+	 * Now all caches are flushed and we can safely enable
+	 * GART hardware.  Doing it early leaves the possibility
+	 * of stale cache entries that can lead to GART PTE
+	 * errors.
+	 */
+	enable_gart_translations();
+
+	/*
 	 * Try to workaround a bug (thanks to BenH):
 	 * Set unmapped entries to a scratch page instead of 0.
 	 * Any prefetches that hit unmapped entries won't get an bus abort


