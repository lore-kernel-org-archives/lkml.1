Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbYDQJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbYDQJRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbYDQJLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:12 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58956
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbYDQJK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 15/45] s390: KVM guest: detect when running on kvm
Date: Thu, 17 Apr 2008 12:10:20 +0300
Message-Id: <1208423450-29415-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

From: Carsten Otte <cotte@de.ibm.com>

This patch adds functionality to detect if the kernel runs under the KVM
hypervisor. A macro MACHINE_IS_KVM is exported for device drivers. This
allows drivers to skip device detection if the systems runs non-virtualized.
We also define a preferred console to avoid having the ttyS0, which is a line
mode only console.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/Kconfig        |    7 +++++++
 arch/s390/kernel/early.c |    4 ++++
 arch/s390/kernel/setup.c |   10 +++++++---
 include/asm-s390/setup.h |    1 +
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c43b250..235ddce 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -533,6 +533,13 @@ config ZFCPDUMP
 	  Select this option if you want to build an zfcpdump enabled kernel.
 	  Refer to <file:Documentation/s390/zfcpdump.txt> for more details on this.
 
+config S390_GUEST
+bool "s390 guest support (EXPERIMENTAL)"
+	depends on 64BIT && EXPERIMENTAL
+	select VIRTIO
+	select VIRTIO_RING
+	help
+	  Select this option if you want to run the kernel under s390 linux
 endmenu
 
 source "net/Kconfig"
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 01832c4..9886578 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -143,6 +143,10 @@ static noinline __init void detect_machine_type(void)
 	/* Running on a P/390 ? */
 	if (cpuinfo->cpu_id.machine == 0x7490)
 		machine_flags |= 4;
+
+	/* Running under KVM ? */
+	if (cpuinfo->cpu_id.version == 0xfe)
+		machine_flags |= 64;
 }
 
 #ifdef CONFIG_64BIT
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 526c135..c64bfb4 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -793,9 +793,13 @@ setup_arch(char **cmdline_p)
 	       "This machine has an IEEE fpu\n" :
 	       "This machine has no IEEE fpu\n");
 #else /* CONFIG_64BIT */
-	printk((MACHINE_IS_VM) ?
-	       "We are running under VM (64 bit mode)\n" :
-	       "We are running native (64 bit mode)\n");
+	if (MACHINE_IS_VM)
+		printk("We are running under VM (64 bit mode)\n");
+	else if (MACHINE_IS_KVM) {
+		printk("We are running under KVM (64 bit mode)\n");
+		add_preferred_console("ttyS", 1, NULL);
+	} else
+		printk("We are running native (64 bit mode)\n");
 #endif /* CONFIG_64BIT */
 
 	/* Save unparsed command line copy for /proc/cmdline */
diff --git a/include/asm-s390/setup.h b/include/asm-s390/setup.h
index a76a6b8..aaf4b51 100644
--- a/include/asm-s390/setup.h
+++ b/include/asm-s390/setup.h
@@ -62,6 +62,7 @@ extern unsigned long machine_flags;
 #define MACHINE_IS_VM		(machine_flags & 1)
 #define MACHINE_IS_P390		(machine_flags & 4)
 #define MACHINE_HAS_MVPG	(machine_flags & 16)
+#define MACHINE_IS_KVM		(machine_flags & 64)
 #define MACHINE_HAS_IDTE	(machine_flags & 128)
 #define MACHINE_HAS_DIAG9C	(machine_flags & 256)
 
-- 
1.5.5

