Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbZDINYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbZDINYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbZDINY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:24:26 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:50677 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbZDINY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:24:26 -0400
X-BigFish: VPS-8(zz936eQzz1202hzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KHU583-02-0FT-01
Date: Thu, 9 Apr 2009 15:24:06 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH 7/8] x86: cacheinfo: disable L3 ECC scrubbing when L3 cache
	index is disabled
Message-ID: <20090409132406.GK31527@alberich.amd.com>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 13:24:07.0534 (UTC) FILETIME=[75E830E0:01C9B916]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

x86: cacheinfo: disable L3 ECC scrubbing when L3 cache index is disabled

(Use correct mask to zero out bits 24-28 by Andreas)

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 55d134f..47e4fb4 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -731,6 +731,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	int node = cpu_to_node(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
+	unsigned int scrubber = 0;
 
 	if (!this_leaf->can_disable)
 		return -EINVAL;
@@ -745,6 +746,11 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 		return -EINVAL;
 
 	val |= 0xc0000000;
+
+	pci_read_config_dword(dev, 0x58, &scrubber);
+	scrubber &= ~0x1f000000;
+	pci_write_config_dword(dev, 0x58, scrubber);
+
 	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
 	wbinvd();
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-- 
1.6.2



