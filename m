Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZEAAMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZEAAMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762358AbZEAABz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:01:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61662 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761815AbZEAABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:01:52 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 10/11] x86: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 20:01:37 -0400
Message-Id: <1241136098-10376-11-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-10-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
 <1241136098-10376-6-git-send-email-tabbott@mit.edu>
 <1241136098-10376-7-git-send-email-tabbott@mit.edu>
 <1241136098-10376-8-git-send-email-tabbott@mit.edu>
 <1241136098-10376-9-git-send-email-tabbott@mit.edu>
 <1241136098-10376-10-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.read_mostly should not need a separate output section; this
change moves it into the .data section.

Since after the .data.read_mostly unification, _edata is now in the
same place on 32-bit and 64-bit, combine the definitions.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/vmlinux.lds.S |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 296b49c..7235ee5 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -107,33 +107,18 @@ SECTIONS
 		NOSAVE_DATA
 #ifdef CONFIG_X86_32
 		CACHELINE_ALIGNED_DATA(32)
+		READ_MOSTLY_DATA(32)
 #else
 		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
+		READ_MOSTLY_DATA(CONFIG_X86_INTERNODE_CACHE_BYTES)
 #endif
 		DATA_DATA
 		CONSTRUCTORS
 
-#ifdef CONFIG_X86_64
 		/* End of data section */
 		_edata = .;
-#endif
 	} :data
 
-	/* rarely changed data like cpu maps */
-#ifdef CONFIG_X86_32
-	. = ALIGN(32);
-#else
-	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-#endif
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
-
-#ifdef CONFIG_X86_32
-		/* End of data section */
-		_edata = .;
-#endif
-	}
-
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-- 
1.6.2.1

