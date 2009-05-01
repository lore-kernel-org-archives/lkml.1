Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbZEAALp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbZEAALp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZEAABu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:01:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61644 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286AbZEAABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:01:49 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 07/11] x86: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 20:01:34 -0400
Message-Id: <1241136098-10376-8-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-7-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
 <1241136098-10376-6-git-send-email-tabbott@mit.edu>
 <1241136098-10376-7-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

This removes the extra ALIGN(PAGE_SIZE) before the cache-aligned data
on x86_32, since I don't see a purpose for it.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/vmlinux.lds.S |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 88b059b..c7d54bf 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -104,6 +104,11 @@ SECTIONS
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
+#ifdef CONFIG_X86_32
+		CACHELINE_ALIGNED_DATA(32)
+#else
+		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
+#endif
 		DATA_DATA
 		CONSTRUCTORS
 
@@ -113,17 +118,6 @@ SECTIONS
 #endif
 	} :data
 
-#ifdef CONFIG_X86_32
-	. = ALIGN(32);
-#else
-	. = ALIGN(PAGE_SIZE);
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-#endif
-	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
-	}
-
 	/* rarely changed data like cpu maps */
 #ifdef CONFIG_X86_32
 	. = ALIGN(32);
-- 
1.6.2.1

