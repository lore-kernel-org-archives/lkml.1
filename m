Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0BVXtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:49:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:36478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0BVXtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:49:41 -0500
Date: Mon, 22 Feb 2010 23:48:43 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       konrad.wilk@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       konrad.wilk@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1266522700.2909.34.camel@sbs-t61.sc.intel.com>
References: <1266522700.2909.34.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86_64, cpa: Don't work hard in preserving kernel 2M mappings when using 4K already
Message-ID: <tip-281ff33b7c1b1ba2a5f9b03425e5f692a94913fa@git.kernel.org>
Git-Commit-ID: 281ff33b7c1b1ba2a5f9b03425e5f692a94913fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 22 Feb 2010 23:48:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  281ff33b7c1b1ba2a5f9b03425e5f692a94913fa
Gitweb:     http://git.kernel.org/tip/281ff33b7c1b1ba2a5f9b03425e5f692a94913fa
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 18 Feb 2010 11:51:40 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 22 Feb 2010 15:09:31 -0800

x86_64, cpa: Don't work hard in preserving kernel 2M mappings when using 4K already

We currently enforce the !RW mapping for the kernel mapping that maps
holes between different text, rodata and data sections. However, kernel
identity mappings will have different RWX permissions to the pages mapping to
text and to the pages padding (which are freed) the text, rodata sections.
Hence kernel identity mappings will be broken to smaller pages. For 64-bit,
kernel text and kernel identity mappings are different, so we can enable
protection checks that come with CONFIG_DEBUG_RODATA, as well as retain 2MB
large page mappings for kernel text.

Konrad reported a boot failure with the Linux Xen paravirt guest because of
this. In this paravirt guest case, the kernel text mapping and the kernel
identity mapping share the same page-table pages. Thus forcing the !RW mapping
for some of the kernel mappings also cause the kernel identity mappings to be
read-only resulting in the boot failure. Linux Xen paravirt guest also
uses 4k mappings and don't use 2M mapping.

Fix this issue and retain large page performance advantage for native kernels
by not working hard and not enforcing !RW for the kernel text mapping,
if the current mapping is already using small page mapping.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1266522700.2909.34.camel@sbs-t61.sc.intel.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@kernel.org	[2.6.32, 2.6.33]
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/pageattr.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1d4eb93..cf07c26 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -291,8 +291,29 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 */
 	if (kernel_set_to_readonly &&
 	    within(address, (unsigned long)_text,
-		   (unsigned long)__end_rodata_hpage_align))
-		pgprot_val(forbidden) |= _PAGE_RW;
+		   (unsigned long)__end_rodata_hpage_align)) {
+		unsigned int level;
+
+		/*
+		 * Don't enforce the !RW mapping for the kernel text mapping,
+		 * if the current mapping is already using small page mapping.
+		 * No need to work hard to preserve large page mappings in this
+		 * case.
+		 *
+		 * This also fixes the Linux Xen paravirt guest boot failure
+		 * (because of unexpected read-only mappings for kernel identity
+		 * mappings). In this paravirt guest case, the kernel text
+		 * mapping and the kernel identity mapping share the same
+		 * page-table pages. Thus we can't really use different
+		 * protections for the kernel text and identity mappings. Also,
+		 * these shared mappings are made of small page mappings.
+		 * Thus this don't enforce !RW mapping for small page kernel
+		 * text mapping logic will help Linux Xen parvirt guest boot
+		 * aswell.
+		 */
+		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
+			pgprot_val(forbidden) |= _PAGE_RW;
+	}
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
