Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYFTN0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYFTN0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFTNZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:25:51 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:61114 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYFTNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:25:50 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linux PPC devel <linuxppc-dev@ozlabs.org>
Subject: [RFC 3/3 v2] s390: use virtio_console for KVM on s390
Date: Fri, 20 Jun 2008 15:24:18 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <200806031444.21945.borntraeger@de.ibm.com>
In-Reply-To: <200806031444.21945.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201524.18953.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables virtio_console as the default console on kvm for
s390. We currently use the same notify hack as lguest for early
console output. I will try to address this for lguest and s390 later.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/Kconfig             |    1 +
 arch/s390/kernel/setup.c      |    4 +++-
 drivers/s390/kvm/kvm_virtio.c |   20 ++++++++++++++++++++
 include/asm-s390/kvm_virtio.h |   10 ++++++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

Index: kvm/arch/s390/Kconfig
===================================================================
--- kvm.orig/arch/s390/Kconfig
+++ kvm/arch/s390/Kconfig
@@ -544,6 +544,7 @@ bool "s390 guest support (EXPERIMENTAL)"
 	depends on 64BIT && EXPERIMENTAL
 	select VIRTIO
 	select VIRTIO_RING
+	select VIRTIO_CONSOLE
 	help
 	  Select this option if you want to run the kernel under s390 linux
 endmenu
Index: kvm/arch/s390/kernel/setup.c
===================================================================
--- kvm.orig/arch/s390/kernel/setup.c
+++ kvm/arch/s390/kernel/setup.c
@@ -54,6 +54,7 @@
 #include <asm/sections.h>
 #include <asm/ebcdic.h>
 #include <asm/compat.h>
+#include <asm/kvm_virtio.h>
 
 long psw_kernel_bits	= (PSW_BASE_BITS | PSW_MASK_DAT | PSW_ASC_PRIMARY |
 			   PSW_MASK_MCHECK | PSW_DEFAULT_KEY);
@@ -799,7 +800,8 @@ setup_arch(char **cmdline_p)
 		printk("We are running under VM (64 bit mode)\n");
 	else if (MACHINE_IS_KVM) {
 		printk("We are running under KVM (64 bit mode)\n");
-		add_preferred_console("ttyS", 1, NULL);
+		add_preferred_console("hvc", 0, NULL);
+		s390_virtio_console_init();
 	} else
 		printk("We are running native (64 bit mode)\n");
 #endif /* CONFIG_64BIT */
Index: kvm/drivers/s390/kvm/kvm_virtio.c
===================================================================
--- kvm.orig/drivers/s390/kvm/kvm_virtio.c
+++ kvm/drivers/s390/kvm/kvm_virtio.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_console.h>
 #include <linux/interrupt.h>
 #include <linux/virtio_ring.h>
 #include <linux/pfn.h>
@@ -333,6 +334,25 @@ static int __init kvm_devices_init(void)
 	return 0;
 }
 
+/* code for early console output with virtio_console */
+static __init int early_put_chars(u32 vtermno, const char *buf, int count)
+{
+	char scratch[17];
+	unsigned int len = count;
+
+	if (len > sizeof(scratch) - 1)
+		len = sizeof(scratch) - 1;
+	scratch[len] = '\0';
+	memcpy(scratch, buf, len);
+	kvm_hypercall1(KVM_S390_VIRTIO_NOTIFY, __pa(scratch));
+	return len;
+}
+
+void s390_virtio_console_init(void)
+{
+	virtio_cons_early_init(early_put_chars);
+}
+
 /*
  * We do this after core stuff, but before the drivers.
  */
Index: kvm/include/asm-s390/kvm_virtio.h
===================================================================
--- kvm.orig/include/asm-s390/kvm_virtio.h
+++ kvm/include/asm-s390/kvm_virtio.h
@@ -50,4 +50,14 @@ struct kvm_vqconfig {
 #define KVM_S390_VIRTIO_RESET		1
 #define KVM_S390_VIRTIO_SET_STATUS	2
 
+#ifdef __KERNEL__
+/* early virtio console setup */
+#ifdef CONFIG_VIRTIO_CONSOLE
+extern void s390_virtio_console_init(void);
+#else
+static inline void s390_virtio_console_init(void)
+{
+}
+#endif /* CONFIG_VIRTIO_CONSOLE */
+#endif /* __KERNEL__ */
 #endif
