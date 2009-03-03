Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZCCHiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZCCHiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZCCHiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:38:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:53576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZCCHiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:38:10 -0500
Message-ID: <49ACDDED.1060508@kernel.org>
Date: Mon, 02 Mar 2009 23:36:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Huang Ying <ying.huang@intel.com>, Brian Maly <bmaly@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make init_memory_mapping could handle small range
References: <49A965AD.10701@redhat.com>	 <49AAEC79.3000808@redhat.com>	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>	 <49AB38E7.60305@redhat.com>	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>	 <49AB4171.7000508@kernel.org>	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>	 <49AB4521.8010909@kernel.org>	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>	 <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>	 <49AC51D7.1080203@kernel.org>	 <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>	 <49AC87AE.60001@kernel.org>	 <1236046936.6204.243.camel@yhuang-dev.sh.intel.com>	 <49AC9B99.5020000@kernel.org>	 <1236049574.6204.253.camel@yhuang-dev.sh.intel.com>	 <49ACAAAF.90300@kernel.org>	 <1236058371.6204.267.camel@yhuang-dev.sh.intel.com>	 <49ACC205.2040504@kernel.org>	 <1236058858.6204.273.camel@yhuang-dev.sh.intel.com>	 <49ACC56D.8050304@kernel.org> <1236062253.6204.278.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1236062253.6204.278.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix small range ...

Ying Huang found init_memory_mapping has problem for small range less than 2M
when he tried to direct map for EFI runtime code out of max_low_pfn_mapped

it turns out we never consider that will be usedd for small range. and didn't
check the range...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Ying Huang <ying.huang@intel.com>

---
 arch/x86/mm/init_64.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -748,6 +748,8 @@ unsigned long __init_refok init_memory_m
 	pos = start_pfn << PAGE_SHIFT;
 	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > (end>>PAGE_SHIFT))
+		end_pfn = end>>PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pos = end_pfn << PAGE_SHIFT;
