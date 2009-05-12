Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbZELJdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbZELJdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbZELJcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:32:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:60107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760229AbZELJcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:32:52 -0400
Date: Tue, 12 May 2009 09:32:21 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sheng.yang@intel.com, shaohua.li@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sheng.yang@intel.com, tglx@linutronix.de, shaohua.li@intel.com,
       mingo@elte.hu
In-Reply-To: <1242117600.22431.0.camel@sli10-desk.sh.intel.com>
References: <1242117600.22431.0.camel@sli10-desk.sh.intel.com>
Subject: [tip:x86/mm] x86: make sparse mem work in non-NUMA mode
Message-ID: <tip-ed077b58f6146684069975122b1728a9d248a501@git.kernel.org>
Git-Commit-ID: ed077b58f6146684069975122b1728a9d248a501
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 09:32:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed077b58f6146684069975122b1728a9d248a501
Gitweb:     http://git.kernel.org/tip/ed077b58f6146684069975122b1728a9d248a501
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Tue, 12 May 2009 16:40:00 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 11:26:35 +0200

x86: make sparse mem work in non-NUMA mode

With sparse memory, holes should not be marked present for memmap.
This patch makes sure sparsemem really works on SMP mode (!NUMA).

[ Impact: use less memory to map fragmented RAM, avoid boot-OOM/crash ]

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
LKML-Reference: <1242117600.22431.0.camel@sli10-desk.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index fef1d90..949708d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -706,15 +706,15 @@ void __init initmem_init(unsigned long start_pfn,
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memory_present(0, 0, highend_pfn);
 	e820_register_active_regions(0, 0, highend_pfn);
+	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	memory_present(0, 0, max_low_pfn);
 	e820_register_active_regions(0, 0, max_low_pfn);
+	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
