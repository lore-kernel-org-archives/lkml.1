Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbZD1RIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbZD1RIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933033AbZD1RFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:05:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55532 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbZD1RFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:05:18 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH v2 12/15] powerpc: Use macros for .data.page_aligned section.
Date: Tue, 28 Apr 2009 13:00:59 -0400
Message-Id: <1240938062-3264-13-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-12-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
 <1240938062-3264-2-git-send-email-tabbott@mit.edu>
 <1240938062-3264-3-git-send-email-tabbott@mit.edu>
 <1240938062-3264-4-git-send-email-tabbott@mit.edu>
 <1240938062-3264-5-git-send-email-tabbott@mit.edu>
 <1240938062-3264-6-git-send-email-tabbott@mit.edu>
 <1240938062-3264-7-git-send-email-tabbott@mit.edu>
 <1240938062-3264-8-git-send-email-tabbott@mit.edu>
 <1240938062-3264-9-git-send-email-tabbott@mit.edu>
 <1240938062-3264-10-git-send-email-tabbott@mit.edu>
 <1240938062-3264-11-git-send-email-tabbott@mit.edu>
 <1240938062-3264-12-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.page_aligned should not need a separate output section, so as
part of this cleanup I moved into the .data output section in the
linker scripts in order to eliminate unnecessary references to the
section name.

Note that this change moves the page-aligned data inside _edata.
Since it _is_ data, I suspect having page-aligned data outside _edata
was a bug.  Please comment if it is not.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/vdso.c                  |    2 +-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 ++-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 ++-
 arch/powerpc/kernel/vmlinux.lds.S           |    6 +-----
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index ad06d5c..841910a 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -74,7 +74,7 @@ static int vdso_ready;
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __page_aligned_data
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /* Format of the patch table */
diff --git a/arch/powerpc/kernel/vdso32/vdso32_wrapper.S b/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
index 556f0ca..6e8f507 100644
--- a/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
+++ b/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
@@ -1,7 +1,8 @@
 #include <linux/init.h>
+#include <linux/linkage.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	__PAGE_ALIGNED_DATA
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
diff --git a/arch/powerpc/kernel/vdso64/vdso64_wrapper.S b/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
index 0529cb9..b8553d6 100644
--- a/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
+++ b/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
@@ -1,7 +1,8 @@
 #include <linux/init.h>
+#include <linux/linkage.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	__PAGE_ALIGNED_DATA
 
 	.globl vdso64_start, vdso64_end
 	.balign PAGE_SIZE
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 47899b0..d3dcea0 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -221,6 +221,7 @@ SECTIONS
 	_sdata = .;
 
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		PAGE_ALIGNED_DATA
 		DATA_DATA
 #ifdef CONFIG_PPC32
 		*(.sdata)
@@ -258,11 +259,6 @@ SECTIONS
 		*(.data.init_task)
 	}
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
-	}
-
 	.data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
 		*(.data.cacheline_aligned)
 	}
-- 
1.6.2.1

