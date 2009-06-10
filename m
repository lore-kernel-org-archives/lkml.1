Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZFJBc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZFJBc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZFJBcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:32:52 -0400
Received: from mga10.intel.com ([192.55.52.92]:60035 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754058AbZFJBcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,336,1241420400"; 
   d="scan'208,223";a="464981767"
Message-ID: <4A2F0D45.2040602@linux.intel.com>
Date: Tue, 09 Jun 2009 18:32:53 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Martin Mares <mj@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-arch@vger.kernel.org
Subject: RFC: x86: cap iomem_resource to addressable physical memory
Content-Type: multipart/mixed;
 boundary="------------080009000602050700000706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080009000602050700000706
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

x86 cannot generate full 64-bit addresses; this patch clamps iomem
addresses to the accessible range.

I wanted to post it for review before committing it, however; comments
would be appreciated, especially of the kind "this is done too early/too
late/in the wrong place/incorrectly".

	-hpa

--------------080009000602050700000706
Content-Type: text/x-patch;
 name="0001-x86-cap-iomem_resource-to-addressable-physical-memo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-cap-iomem_resource-to-addressable-physical-memo.pat";
 filename*1="ch"

>From 8dd8d59d1d1586b350401d6a5f8c7a9e30f142d4 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Tue, 9 Jun 2009 18:20:39 -0700
Subject: [PATCH] x86: cap iomem_resource to addressable physical memory

iomem_resource is by default initialized to -1, which means 64 bits of
physical address space if 64-bit resources are enabled.  However, x86
CPUs cannot address 64 bits of physical address space.  Thus, we want
to cap the physical address space to what the union of all CPU can
actually address.

Without this patch, we may end up assigning inaccessible values to
uninitialized 64-bit PCI memory resources.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Martin Mares <mj@ucw.cz>
Cc: stable@kernel.org
---
 arch/x86/kernel/cpu/common.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 77848d9..de8a49c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -839,6 +839,9 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	numa_add_cpu(smp_processor_id());
 #endif
+
+	/* Cap the iomem address space to what is addressable on all CPUs */
+	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
 }
 
 #ifdef CONFIG_X86_64
-- 
1.6.0.6


--------------080009000602050700000706--
