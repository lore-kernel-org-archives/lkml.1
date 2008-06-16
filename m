Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbYFPVzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbYFPVzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbYFPVz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:55:28 -0400
Received: from gw.goop.org ([64.81.55.164]:38032 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbYFPVz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:55:28 -0400
Message-ID: <4856E126.2040400@goop.org>
Date: Mon, 16 Jun 2008 14:54:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] xen: reserve Xen-specific memory in e820 map
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the start_info and pfn->mfn translation array are reserved.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/xen/setup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -40,8 +40,21 @@
 	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
 
 	e820.nr_map = 0;
+
 	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
 	e820_add_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
+
+	/*
+	 * Reserve Xen bits:
+	 *  - mfn_list
+	 *  - xen_start_info
+	 * See comment above "struct start_info" in <xen/interface/xen.h>
+	 */
+	e820_add_region(__pa(xen_start_info->mfn_list),
+			xen_start_info->pt_base - xen_start_info->mfn_list,
+			E820_RESERVED);
+
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
 	return "Xen";
 }


