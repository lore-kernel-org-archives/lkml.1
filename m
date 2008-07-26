Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYGZJZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYGZJZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYGZJZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:25:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34119 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYGZJZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:25:34 -0400
Date: Sat, 26 Jul 2008 11:25:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-ID: <20080726092519.GA4341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


please apply before -rc1.

	Ingo

----------->
>From 72db7cba50b6a05825f8a287f74002cc38f04fb7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 26 Jul 2008 11:22:33 +0200
Subject: [PATCH] crashdump: fix undefined reference to `elfcorehdr_addr'

fix build bug introduced by 95b68dec0d5 "calgary iommu: use the first
kernels TCE tables in kdump":

 arch/x86/kernel/built-in.o: In function `calgary_iommu_init':
 (.init.text+0x8399): undefined reference to `elfcorehdr_addr'
 arch/x86/kernel/built-in.o: In function `calgary_iommu_init':
 (.init.text+0x856c): undefined reference to `elfcorehdr_addr'
 arch/x86/kernel/built-in.o: In function `detect_calgary':
 (.init.text+0x8c68): undefined reference to `elfcorehdr_addr'
 arch/x86/kernel/built-in.o: In function `detect_calgary':
 (.init.text+0x8d0c): undefined reference to `elfcorehdr_addr'

make elfcorehdr_addr a generally available symbol.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/crash_dump.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 6cd39a9..025e4f5 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -8,7 +8,13 @@
 #include <linux/proc_fs.h>
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
+
+#ifdef CONFIG_PROC_VMCORE
 extern unsigned long long elfcorehdr_addr;
+#else
+static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+#endif
+
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
 extern const struct file_operations proc_vmcore_operations;
