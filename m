Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbYHGMdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbYHGMdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYHGMbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:31:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:62231 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYHGMbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:31:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,319,1215414000"; 
   d="scan'208";a="368540991"
Subject: [PATCH 2/6] kexec jump: check code size in control page
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:05:26 +0800
Message-Id: <1218099926.5164.33.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec/Kexec-jump requires code size in control page is less than
PAGE_SIZE/2. This patch adds runtime checking for this.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c   |    4 ++++
 arch/x86/kernel/relocate_kernel_32.S |    3 +++
 include/asm-x86/kexec.h              |    1 +
 3 files changed, 8 insertions(+)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -92,6 +92,10 @@ int machine_kexec_prepare(struct kimage 
 {
 	if (nx_enabled)
 		set_pages_x(image->control_code_page, 1);
+
+	BUG_ON((unsigned long)kexec_control_page_code_end - \
+	       (unsigned long)relocate_kernel >= PAGE_SIZE/2);
+
 	return 0;
 }
 
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -376,3 +376,6 @@ swap_pages:
 	popl	%ebx
 	popl	%ebp
 	ret
+
+	.globl kexec_control_page_code_end
+kexec_control_page_code_end:
--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -159,6 +159,7 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address,
 		unsigned int has_pae,
 		unsigned int preserve_context);
+void kexec_control_page_code_end(void);
 #else
 NORET_TYPE void
 relocate_kernel(unsigned long indirection_page,


