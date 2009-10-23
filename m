Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZJWPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZJWPp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZJWPp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:45:28 -0400
Received: from server1.wserver.cz ([82.113.45.157]:35258 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZJWPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:45:27 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/1] crash_dump: fix non-pae kdump kernel memory accesses
Date: Fri, 23 Oct 2009 17:45:29 +0200
Message-Id: <1256312729-22935-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-PAE 32-bit dump kernels may wrap an address around 4G and
poke unwanted space. ptes there are 32-bit long, and since
pfn << PAGE_SIZE may exceed this limit, high pfn bits are cropped
and wrong address mapped by kmap_atomic_pfn in copy_oldmem_page.

Don't allow this behavior in non-PAE kdump kernels by checking
pfns passed into copy_oldmem_page. In the case of failure,
userspace process gets EFAULT.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/crash_dump_32.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
index f7cdb3b..b78dab8 100644
--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -16,6 +16,19 @@ static void *kdump_buf_page;
 /* Stores the physical address of elf header of crash image. */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 
+#ifndef CONFIG_X86_PAE
+/* non-PAE kdump kernel executed from a PAE one will crop high pte bits and
+   poke unwanted space counting again from address 0, we don't want that */
+static inline bool is_crashed_pfn_valid(unsigned long pfn)
+{
+	/* on non-PAE pte must fit into unsigned long
+	   in fact the test is (pfn & 0x000fffff) */
+	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
+}
+#else
+static inline bool is_crashed_pfn_valid(unsigned long pfn) { return true; }
+#endif
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
@@ -41,6 +54,9 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
+	if (!is_crashed_pfn_valid(pfn))
+		return -EFAULT;
+
 	vaddr = kmap_atomic_pfn(pfn, KM_PTE0);
 
 	if (!userbuf) {
-- 
1.6.4.2

