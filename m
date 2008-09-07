Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYIHAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYIHAVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYIHAV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:21:29 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:7740 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYIHAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EXUnXaJq6pzLw5HnN+A7PlsqfZ24M/PDSPzlBr2g8yVf8Qo/KNGcrmcSUsldMj3SFT
         C+Z1y8iqzU2YTUzTKYZbjSm52IlNQv5Z0tnptAvW3sMiRU3vI0uWXwW3YaxYdeTmBQ+h
         Sw9kIkKgAZ4UI25pyCkTYA+oQgAbpOLxyvVn8=
Date: Mon, 8 Sep 2008 07:45:11 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, joerg.roedel@amd.com, elliot.li.tech@gmail.com,
       rjmaomao@gmail.com
Subject: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080907234510.GA24133@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221115452.GB13948@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 12:54:52PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> >  	if (!highest_pfn) {
> >  		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all
> >  		blank?\n");
> > -		WARN_ON(1);
> >  		return 0;
> >  	}
> 
> instead of obscuring a possibly useful warning, please instead
> detect 
> that it's a KVM guest and skip both the warning and the backtrace in 
> that case.

This patch detects whether we are running as a VMware guest or
not. Used 'official' detection code from VMware's Open Virtual Machine
Tools (open-vm-tools/checkvm), with LGPLv2.1 changed to GPLv2.

It provides a function:
int is_vmware_guest(void)
that can be used easily to detect if we are running as a VMware guest.

Currently this can be useful in suppressing false warning from mtrr
module, hope some other modules find this useful too (like adopting
less aggressive strategy on cache using, since the host is already
doing cache for us, etc.)

Signed-off-by: Yan Li <elliot.li.tech@gmail.com>
---
 arch/x86/lib/Makefile    |    1 +
 arch/x86/lib/vmware.c    |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/vmware.h |   30 ++++++++++++++++++++++
 3 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/lib/vmware.c
 create mode 100644 include/asm-x86/vmware.h

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index aa3fa41..8327a12 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -8,6 +8,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-y += vmware.o
 
 ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
diff --git a/arch/x86/lib/vmware.c b/arch/x86/lib/vmware.c
new file mode 100644
index 0000000..39c9360
--- /dev/null
+++ b/arch/x86/lib/vmware.c
@@ -0,0 +1,61 @@
+/*
+ * Check if we are running as a VMware guest or not
+ *
+ * Copyright (C) 2007 VMware, Inc. All rights reserved.
+ * Adapted to Linux by Yan Li <elliot.li.tech@gmail.com>
+ * from open-vm-tools/checkvm
+ * from VMware's Open Virtual Machine Tools (under LGPLv2.1)
+ *               (open-vm-tools.sourceforge.net)
+ *
+ * The original codes from VMware are licensed under LGPLv2.1, I (Yan
+ * Li) converted the following parts to use GPL license as stated in
+ * COPYING file of Linux.
+ */
+
+#include <linux/kernel.h>
+#include <asm/vmware.h>
+
+/* Backdoor def from open-vm-tools/lib/include/backdoor_def.h */
+#define BDOOR_MAGIC          0x564D5868
+/* Low-bandwidth backdoor port. --hpreg */
+#define BDOOR_PORT           0x5658
+#define BDOOR_CMD_GETVERSION 10
+#define VERSION_MAGIC        0x6
+
+/*
+ *  getVersion  -  Read VM version & product code through backdoor
+ */
+void getVersion(u32 *version)
+{
+	u32 eax, ebx, ecx, edx;
+
+	asm volatile("inl (%%dx)" :
+		     "=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :
+		     "0"(BDOOR_MAGIC), "1"(BDOOR_CMD_GETVERSION),
+		     "2"(BDOOR_PORT) : "memory");
+	version[0] = eax;
+	version[1] = ebx;
+	version[2] = ecx;
+}
+
+
+int is_vmware_guest(void)
+{
+	u32 version[3];
+
+	getVersion(&version[0]);
+
+	if (version[1] != BDOOR_MAGIC) {
+		/* Incorrect virtual machine version */
+		return 0;
+	}
+
+	if (version[0] != VERSION_MAGIC) {
+		/* Incorrect version magic */
+		return 0;
+	}
+
+	/* Yes, we are running as VMware Guest */
+	printk(KERN_INFO "vmware detected\n");
+	return 1;
+}
diff --git a/include/asm-x86/vmware.h b/include/asm-x86/vmware.h
new file mode 100644
index 0000000..aad262a
--- /dev/null
+++ b/include/asm-x86/vmware.h
@@ -0,0 +1,30 @@
+/*
+ * Check if we are running as a VMware guest or not
+ *
+ * Copyright (C) 2007 VMware, Inc. All rights reserved.
+ * Adapted to Linux by Yan Li <elliot.li.tech@gmail.com>
+ * from open-vm-tools/checkvm
+ * from VMware's Open Virtual Machine Tools (under LGPLv2.1)
+ *               (open-vm-tools.sourceforge.net)
+ *
+ * The original codes from VMware are licensed under LGPLv2.1, I (Yan
+ * Li) converted the following parts to use GPL license as stated in
+ * COPYING file of Linux.
+ */
+
+#ifndef _ASM_X86_VMWARE_H
+#define _ASM_X86_VMWARE_H
+
+#include <asm/types.h>
+
+/*
+ *  getVersion  -  Read VMware version & product code through backdoor
+ */
+void getVersion(u32 *version);
+
+/*
+ *  is_vmware_guest - return non-zero if running as a VMware guest
+ */
+int is_vmware_guest(void);
+
+#endif /* _ASM_X86_VMWARE_H */
-- 
1.5.6.3


-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
