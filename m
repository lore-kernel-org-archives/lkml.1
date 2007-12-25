Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbXLYFQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbXLYFQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 00:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXLYFQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 00:16:04 -0500
Received: from mga05.intel.com ([192.55.52.89]:20469 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757AbXLYFQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 00:16:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,205,1196668800"; 
   d="scan'208";a="460781234"
Subject: volanoMark 24% regression in 2.6.24-rc6: why a simple patch makes
	it
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: travis@sgi.com, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com
Content-Type: text/plain; charset=utf-8
Date: Tue, 25 Dec 2007 13:14:05 +0800
Message-Id: <1198559645.6362.195.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 2.6.24-rc6, volanoMark has much regression.

1) On 8-core stoakley: 17%;
2) On 16-core tigerton: 24%.

I bisected it down to patch fbdcf18df73758b2e187ab94678b30cd5f6ff9f9. It is
to fix the bad cpu number in /proc/cpuinfo. As a matter of fact, this issue
is already fixed by other 2 patches:
699d934d5f958d7944d195c03c334f28cc0b3669
and
c0c52d28e05e8bdaa2126570c02ecb1a7358cecc.

At the first glance, the patch looks good, at least no conflict with the other
2 patches. After double-checking it, I found in below call chain:

smp_store_cpu_info => identify_cpu => init_intel => init_intel_cacheinfo.

When CONFIG_X86_HT=y, init_intel_cacheinfo will uses cpuinfo_x86->cpu_index, which
is initiated by smp_store_cpu_info. If with patch fbdcf18df73758b2e187ab94678b30cd5f6ff9f9,
cpuinfo_x86->cpu_index is initiated after identify_cpu is called, so
init_intel_cacheinfo just always initiates per_cpu(cpu_llc_id, 0) = l2_id or l3_id. Then,
set_cpu_sibling_map will set bad llc_shared_map, so the core domain won't be built.

By checking domain info from dmesg, it really confirms my consequence.

>From this case, I really found that core domain could improve performance, at least when
testing by volanoMark. :)

The solution is just to revert patch fbdcf18df73758b2e187ab94678b30cd5f6ff9f9,
because other 2 patches which fixed the same issue are already in 2.6.24-rc5.

-yanmin


