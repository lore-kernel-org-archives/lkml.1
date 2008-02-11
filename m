Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYBKT37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYBKT37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760077AbYBKT3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:29:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760623AbYBKT3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:29:44 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 4/5] [PATCH] introduce paravirt helpers
Date: Mon, 11 Feb 2008 17:16:04 -0200
Message-Id: <1202757365-18634-4-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1202757365-18634-3-git-send-email-gcosta@redhat.com>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
 <1202757365-18634-2-git-send-email-gcosta@redhat.com>
 <1202757365-18634-3-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/Kconfig          |    3 ++
 arch/x86/kernel/vsmp_64.c |   56 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9d0aced..0c4134b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -323,7 +323,8 @@ config X86_RDC321X
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
 	depends on X86_64 && PCI
-	 help
+	select PARAVIRT
+	help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
 	  if you have one of these machines.
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index fdf9fba..b93ed66 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -8,6 +8,8 @@
  *
  * Ravikiran Thirumalai <kiran@scalemp.com>,
  * Shai Fultheim <shai@scalemp.com>
+ * Paravirt ops integration: Glauber de Oliveira Costa <gcosta@redhat.com>,
+ *			     Ravikiran Thirumalai <kiran@scalemp.com>
  */
 
 #include <linux/init.h>
@@ -15,6 +17,60 @@ #include <linux/pci_ids.h>
 #include <linux/pci_regs.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
+#include <asm/paravirt.h>
+
+/*
+ * Interrupt control on vSMPowered systems:
+ * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
+ * and vice versa.
+ */
+
+static unsigned long vsmp_save_fl(void)
+{
+	unsigned long flags = native_save_fl();
+
+	if (!(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC))
+		flags &= ~X86_EFLAGS_IF;
+	return flags;
+}
+
+static void vsmp_restore_fl(unsigned long flags)
+{
+	if (flags & X86_EFLAGS_IF)
+		flags &= ~X86_EFLAGS_AC;
+	else
+		flags |= X86_EFLAGS_AC;
+	native_restore_fl(flags);
+}
+
+static void vsmp_irq_disable(void)
+{
+	unsigned long flags = native_save_fl();
+
+	native_restore_fl((flags & ~X86_EFLAGS_IF) | X86_EFLAGS_AC);
+}
+
+static void vsmp_irq_enable(void)
+{
+	unsigned long flags = native_save_fl();
+
+	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
+}
+
+static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+				  unsigned long addr, unsigned len)
+{
+	switch (type) {
+	case PARAVIRT_PATCH(pv_irq_ops.irq_enable):
+	case PARAVIRT_PATCH(pv_irq_ops.irq_disable):
+	case PARAVIRT_PATCH(pv_irq_ops.save_fl):
+	case PARAVIRT_PATCH(pv_irq_ops.restore_fl):
+		return paravirt_patch_default(type, clobbers, ibuf, addr, len);
+	default:
+		return native_patch(type, clobbers, ibuf, addr, len);
+	}
+
+}
 
 void __init vsmp_init(void)
 {
-- 
1.4.2

