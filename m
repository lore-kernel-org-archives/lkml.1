Return-Path: <linux-kernel-owner+w=401wt.eu-S1765387AbYAaHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765387AbYAaHiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYAaHhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:37:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:26792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYAaHhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:37:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="510975837"
Subject: [PATCH 2/5] x86: c_p_a clflush_cache_range fix
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 15:36:02 +0800
Message-Id: <1201764962.12950.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 07:35:00.0493 (UTC) FILETIME=[C937E3D0:01C863DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because in i386 early boot stage, boot_cpu_data may be not available,
which makes clflush_cach_range() into infinite loop, which is called
by change_page_attr(). This patch fixes this by providing a default
clflush_size of 64. But the better method may be providing a
early_identify_cpu() for i386.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/pageattr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -36,11 +36,14 @@ within(unsigned long addr, unsigned long
  */
 void clflush_cache_range(void *vaddr, unsigned int size)
 {
+	int clflush_size;
 	void *vend = vaddr + size - 1;
 
 	mb();
 
-	for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
+	/* In boot stage, boot_cpu_data may be not available */
+	clflush_size = boot_cpu_data.x86_clflush_size ? : 64;
+	for (; vaddr < vend; vaddr += clflush_size)
 		clflush(vaddr);
 	/*
 	 * Flush any possible final partial cacheline:

