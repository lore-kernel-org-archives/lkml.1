Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0BMDgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:36:14 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:21468 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab0BMDgL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 12 Feb 2010 22:36:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com,
       rostedt@goodmis.org, jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] x86_64: allow sections that are recycled to set _PAGE_RW
Date: Fri, 12 Feb 2010 22:15:28 -0500
Message-Id: <1266030928-2126-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com>
References: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B761E25.0086:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes BUG: unable to handle kernel paging request at ffff8800013f4000

 IP: [<ffffffff8102bb0b>] free_init_pages+0xa3/0xcc
 PGD 1611067 PUD 1615067 PMD 556b067 PTE 100000013f4025
...
  [<ffffffff8102c2cb>] mark_rodata_ro+0x4a2/0x527
  [<ffffffff810021a5>] init_post+0x2b/0x10e
...

On platforms where the pages to be recycled ("free") are 4KB (Xen PV guest).

In the mark_rodata_ro, we set the .text through .sdata section to RO,
then for selective sections (.__stop___ex_table -> .__start_rodata)
and (.__end_rodata -> ._sdata) set them to RW. The logic in
static_protections forbids this and unsets the _PAGE_RW attribute.

This is not an issue if the sections to be recycled are in 2MB pages
so on native platform this isn't seen.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/pageattr.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1d4eb93..44ebcd7 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -291,8 +291,17 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 */
 	if (kernel_set_to_readonly &&
 	    within(address, (unsigned long)_text,
-		   (unsigned long)__end_rodata_hpage_align))
-		pgprot_val(forbidden) |= _PAGE_RW;
+		   (unsigned long)__end_rodata_hpage_align)) {
+		/* When 'kernel_set_to_readonly', it is OK to set PAGE_RW
+		 * on the ones that are being recycled by free_init_pages
+		 * in mark_rodata_ro.
+		 */
+		if (!within(address, (unsigned long)&__stop___ex_table,
+				(unsigned long)&__start_rodata) &&
+		    !within(address, (unsigned long)&__end_rodata,
+				(unsigned long)&_sdata))
+			pgprot_val(forbidden) |= _PAGE_RW;
+	}
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
-- 
1.6.2.5

