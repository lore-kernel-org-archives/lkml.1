Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYIXMrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYIXMrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIXMqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:46:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:63112 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYIXMqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=b5S/DhiLGji/ug1jx3a0kbCWRek07hMP9yr4uKsbEoB1We+T2rOGU487yPxBniMfg7
         /tEqXiTtX8AyvFdA+iGmt1SukB5GHxUOJskN13BHeDNm4vWh5XOUI4ddhnJF084EcC6C
         /k91YaTtErynUJazHYSYjBVbv3FboB1T+KL30=
Date: Wed, 24 Sep 2008 20:22:10 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D12490.5010003@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Message-ID: <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detects whether we are running as a VMware guest or not. Detection is
based upon DMI vendor string.

It provides a function:
int is_vmware_guest(void)
that can be used easily to detect if we are running as a VMware guest
or not.

I haven't used PCI vendor Id since that requires copying a trunk of
codes from early_quirks() and I think copying code is not good. And
reusing codes from early_quirks() needs intrivial change to present
codes structure. Comparatively, checking "VMware" string against DMI
manufacturer is a lot more simpler (one-line code). Also there's no
evidence indicating that VMware will change their vendor string in
near future. Therefore I choose to use simpler way.

Tested on x86 and x86-64 VMs and machines.

Signed-off-by: Yan Li <elliot.li.tech@gmail.com>
---
 arch/x86/Kconfig         |   10 ++++++++++
 arch/x86/kernel/Makefile |    1 +
 arch/x86/kernel/vmware.c |   23 +++++++++++++++++++++++
 include/asm-x86/vmware.h |   20 ++++++++++++++++++++
 4 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/vmware.c
 create mode 100644 include/asm-x86/vmware.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..85dfebd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -445,6 +445,16 @@ config PARAVIRT_DEBUG
          Enable to debug paravirt_ops internals.  Specifically, BUG if
 	 a paravirt_op is missing when it is called.
 
+config VMWARE_GUEST_DETECT
+	bool "VMware guest detection support"
+	default y
+	depends on DMI && !X86_VOYAGER
+	help
+          This enables detection of running as a full-virtualized
+          VMware guest (as under VMware Workstation or VMware
+          Server). Currently this is used to suppress false warnings
+          from initialization.
+
 config MEMTEST
 	bool "Memtest"
 	help
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3db651f..a3a16a8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
+obj-$(CONFIG_VMWARE_GUEST_DETECT)	+= vmware.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
diff --git a/arch/x86/kernel/vmware.c b/arch/x86/kernel/vmware.c
new file mode 100644
index 0000000..352d5d8
--- /dev/null
+++ b/arch/x86/kernel/vmware.c
@@ -0,0 +1,23 @@
+/*
+ * Check if we are running as a VMware guest or not
+ *
+ * Copyright (C) 2008 Yan Li <elliot.li.tech@gmail.com>
+ *
+ */
+
+#include <linux/dmi.h>
+#include <linux/kernel.h>
+#include <asm/vmware.h>
+
+/*
+ * detect whether we are running as a VMware guest or not. this
+ * function depends on DMI so it should not be used early before
+ * dmi_scan_machine() in setup_arch()
+ */
+int is_vmware_guest(void)
+{
+	if (!dmi_available)
+		return 0;
+	else
+		return dmi_name_in_vendors("VMware");
+}
diff --git a/include/asm-x86/vmware.h b/include/asm-x86/vmware.h
new file mode 100644
index 0000000..554f0f9
--- /dev/null
+++ b/include/asm-x86/vmware.h
@@ -0,0 +1,20 @@
+/*
+ * Check if we are running as a VMware guest or not
+ *
+ * Copyright (C) 2008 Yan Li <elliot.li.tech@gmail.com>
+ *
+ */
+
+#ifndef _ASM_X86_VMWARE_H
+#define _ASM_X86_VMWARE_H
+
+/*
+ *  is_vmware_guest - return non-zero if running as a VMware guest
+ */
+#ifdef CONFIG_VMWARE_GUEST_DETECT
+extern int is_vmware_guest(void);
+#else
+int is_vmware_guest(void) { return 0; }
+#endif /* CONFIG_VMWARE_GUEST_DETECT */
+
+#endif /* _ASM_X86_VMWARE_H */
-- 
1.5.4.3


-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
