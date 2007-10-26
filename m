Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbXJZFVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbXJZFVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXJZFVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:21:07 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51688 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXJZFVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:21:06 -0400
Message-Id: <472178DE.9080409@mxs.nes.nec.co.jp>
Date: Fri, 26 Oct 2007 14:19:26 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH] Dump filtering supports x86_64 sparsemem(Re: Linux v2.6.24-rc1)
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch adds the symbol "init_level4_pgt" to the vmcoreinfo data so
that makedumpfile (dump filtering command) supports x86_64 sparsemem 
kernel of linux-2.6.24.

makedumpfile creates a small dumpfile by excluding unnecessary pages for
the analysis. It checks attributes in page structures and distinguishes
necessary pages and unnecessary ones. To check them, makedumpfile gets
the vmcoreinfo data which has the minimum debugging information only for
dump filtering.

For older x86_64 kernel (linux-2.6.23 or before), makedumpfile translates
the virtual address of page structure into physical address by subtracting
PAGE_OFFSET from virtual address, but this translation isn't effective for
linux-2.6.24 sparsemem kernel, because its page structures are in virtual
memmap area. makedumpfile should translate their virtual address by 4-levels
paging and it needs the symbol "init_level4_pgt".


Thanks
Ken'ichi Ohmichi 

---
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

---
diff -rpuN a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c	2007-10-26 11:05:34.000000000 +0900
+++ b/arch/x86/kernel/machine_kexec_64.c	2007-10-26 11:16:24.000000000 +0900
@@ -233,6 +233,8 @@ NORET_TYPE void machine_kexec(struct kim
 
 void arch_crash_save_vmcoreinfo(void)
 {
+	VMCOREINFO_SYMBOL(init_level4_pgt);
+
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
_




