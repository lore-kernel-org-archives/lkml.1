Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYGYQSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYGYQSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYGYQRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:17:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:26852 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYGYQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:17:30 -0400
X-BigFish: VPS-8(zz4015M62a3L936fQ173nzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K4KL8G-01-GGN-01
Message-ID: <20080725161723.636932280@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 25 Jul 2008 18:17:23 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/9] x86: AMD microcode patch loading support
X-OriginalArrivalTime: 25 Jul 2008 16:17:08.0510 (UTC) FILETIME=[E2DFEBE0:01C8EE71]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces microcode patch loading support for AMD processors. It includes refactoring
of existing code to allow code sharing. Vendor specific code has been split off, leading to a
multi-module solution as compared to the current single-module approach.

Thanks,

Peter Oruba

--
Advanced Micro Devices, Inc.
Operating System Research Center
email: peter.oruba@amd.com
>From peter.oruba@amd.com Fri Jul 25 18:20:02 2008
Message-Id: <20080725162001.917239960@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 25 Jul 2008 18:17:24 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>,
 Thomas Gleixner <tglx@linutronix.de>,
 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Peter Oruba <peter.oruba@amd.com>
Bcc: osrc-patches@elbe.amd.com
Subject: [patch 1/9] [PATCH 1/9] x86: Moved Intel microcode patch loader declarations to seperate header file.
References: <20080725161723.636932280@amd.com>
Content-Disposition: inline; filename=0001-x86-Moved-Intel-microcode-patch-loader-declarations.patch

Intel specific microcode declarations have been moved to a seperate header file.
There are no code changes to the code itself and no side effects to other parts.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c |    1 +
 include/asm-x86/microcode.h |   34 ++++++++++++++++++++++++++++++++++
 include/asm-x86/processor.h |   35 -----------------------------------
 3 files changed, 35 insertions(+), 35 deletions(-)
 create mode 100644 include/asm-x86/microcode.h

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 56b9331..230ca7e 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -93,6 +93,7 @@
 #include <asm/msr.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <asm/microcode.h>
 
 MODULE_DESCRIPTION("Intel CPU (IA-32) Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
new file mode 100644
index 0000000..5a05568
--- /dev/null
+++ b/include/asm-x86/microcode.h
@@ -0,0 +1,34 @@
+struct microcode_header {
+	unsigned int            hdrver;
+	unsigned int            rev;
+	unsigned int            date;
+	unsigned int            sig;
+	unsigned int            cksum;
+	unsigned int            ldrver;
+	unsigned int            pf;
+	unsigned int            datasize;
+	unsigned int            totalsize;
+	unsigned int            reserved[3];
+};
+
+struct microcode {
+	struct microcode_header hdr;
+	unsigned int            bits[0];
+};
+
+typedef struct microcode          microcode_t;
+typedef struct microcode_header   microcode_header_t;
+
+/* microcode format is extended from prescott processors */
+struct extended_signature {
+	unsigned int            sig;
+	unsigned int            pf;
+	unsigned int            cksum;
+};
+
+struct extended_sigtable {
+	unsigned int            count;
+	unsigned int            cksum;
+	unsigned int            reserved[3];
+	struct extended_signature sigs[0];
+};
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 15cb82a..f3c5c93 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -561,41 +561,6 @@ static inline void clear_in_cr4(unsigned long mask)
 	write_cr4(cr4);
 }
 
-struct microcode_header {
-	unsigned int		hdrver;
-	unsigned int		rev;
-	unsigned int		date;
-	unsigned int		sig;
-	unsigned int		cksum;
-	unsigned int		ldrver;
-	unsigned int		pf;
-	unsigned int		datasize;
-	unsigned int		totalsize;
-	unsigned int		reserved[3];
-};
-
-struct microcode {
-	struct microcode_header	hdr;
-	unsigned int		bits[0];
-};
-
-typedef struct microcode	microcode_t;
-typedef struct microcode_header	microcode_header_t;
-
-/* microcode format is extended from prescott processors */
-struct extended_signature {
-	unsigned int		sig;
-	unsigned int		pf;
-	unsigned int		cksum;
-};
-
-struct extended_sigtable {
-	unsigned int		count;
-	unsigned int		cksum;
-	unsigned int		reserved[3];
-	struct extended_signature sigs[0];
-};
-
 typedef struct {
 	unsigned long		seg;
 } mm_segment_t;
-- 
1.5.4.5




