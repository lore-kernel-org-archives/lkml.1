Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZD2HqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZD2HqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZD2HpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:25 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55961 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 10/13] x86, vmlinux.lds: unify parainstructions
Date: Wed, 29 Apr 2009 09:47:26 +0200
Message-Id: <1240991249-27117-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 bit:
- increased alignment from 4 to 8 for .parainstructions
- increased alignment from 4 to 8 for .altinstructions

64 bit:
- move ALIGN() outside output section for .altinstructions

None of the above should result in any functional change.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   18 ++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   18 ------------------
 arch/x86/kernel/vmlinux_64.lds.S |   18 ------------------
 3 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 458fa58..6cfb1e1 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -286,6 +286,24 @@ SECTIONS
 
 	SECURITY_INIT
 
+	. = ALIGN(8);
+	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+		__parainstructions = .;
+		*(.parainstructions)
+		__parainstructions_end = .;
+	}
+
+	. = ALIGN(8);
+	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+
+	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
+		*(.altinstr_replacement)
+	}
+
 
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index d8ba539..5df9647 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,21 +1,3 @@
-	. = ALIGN(4);
-	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-		__alt_instructions = .;
-		*(.altinstructions)
-		__alt_instructions_end = .;
-	}
-
-	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-		*(.altinstr_replacement)
-	}
-
-	. = ALIGN(4);
-	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-		__parainstructions = .;
-		*(.parainstructions)
-		__parainstructions_end = .;
-	}
-
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 0e8054e..9ef7096 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,21 +1,3 @@
-	. = ALIGN(8);
-	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-		__parainstructions = .;
-		*(.parainstructions)
-		__parainstructions_end = .;
-	}
-
-	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-		. = ALIGN(8);
-		__alt_instructions = .;
-		*(.altinstructions)
-		__alt_instructions_end = .;
-	}
-
-	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-		*(.altinstr_replacement)
-	}
-
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
-- 
1.6.0.6

