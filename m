Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYJETL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYJETL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbYJETKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:10:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:33004 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbYJETKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:10:38 -0400
Date: Sun, 5 Oct 2008 12:09:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86: corruption-check: some post-move cleanups
Message-ID: <20081005120947.36bbfe82@infradead.org>
In-Reply-To: <20081005120705.02492d44@infradead.org>
References: <20081005120705.02492d44@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 5 Oct 2008 12:05:30 -0700
Subject: [PATCH] x86: corruption-check: some post-move cleanups

now that the code is moved and converted to a work queue,
there's some minor cleanups that can be done.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/Makefile |    3 ++-
 arch/x86/kernel/check.c  |   10 ++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index d042063..31a41b2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,7 +36,6 @@ obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc.o io_delay.o rtc.o
-obj-y			+= check.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
@@ -106,6 +105,8 @@ microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
 obj-$(CONFIG_MICROCODE)			+= microcode.o
 
+obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 55eed17..3ba1100 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -11,7 +11,6 @@
  * remaining free memory in that area and fill it with a distinct
  * pattern.
  */
-#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 #define MAX_SCAN_AREAS	8
 
 static int __read_mostly memory_corruption_check = -1;
@@ -23,7 +22,7 @@ static struct e820entry scan_areas[MAX_SCAN_AREAS];
 static int num_scan_areas;
 
 
-static int set_corruption_check(char *arg)
+static __init int set_corruption_check(char *arg)
 {
 	char *end;
 
@@ -33,7 +32,7 @@ static int set_corruption_check(char *arg)
 }
 early_param("memory_corruption_check", set_corruption_check);
 
-static int set_corruption_check_period(char *arg)
+static __init int set_corruption_check_period(char *arg)
 {
 	char *end;
 
@@ -43,7 +42,7 @@ static int set_corruption_check_period(char *arg)
 }
 early_param("memory_corruption_check_period", set_corruption_check_period);
 
-static int set_corruption_check_size(char *arg)
+static __init int set_corruption_check_size(char *arg)
 {
 	char *end;
 	unsigned size;
@@ -134,7 +133,7 @@ void check_for_bios_corruption(void)
 		}
 	}
 
-	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
+	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\n");
 }
 
 static void check_corruption(struct work_struct *dummy);
@@ -161,5 +160,4 @@ static int start_periodic_check_for_corruption(void)
 }
 
 module_init(start_periodic_check_for_corruption);
-#endif
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
