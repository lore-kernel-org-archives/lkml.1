Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYLHLo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYLHLo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYLHLh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYLHLhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:06 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 42/45] ppc: Create disassemble.h to extract instruction fields
Date: Mon,  8 Dec 2008 13:36:53 +0200
Message-Id: <1228736216-15787-43-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This is used in a couple places in KVM, but isn't KVM-specific.

However, this patch doesn't modify other in-kernel emulation code:
- xmon uses a direct copy of ppc_opc.c from binutils
- emulate_instruction() doesn't need it because it can use a series
  of mask tests.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/disassemble.h |   80 ++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/emulate.c             |   57 +----------------------
 2 files changed, 81 insertions(+), 56 deletions(-)
 create mode 100644 arch/powerpc/include/asm/disassemble.h

diff --git a/arch/powerpc/include/asm/disassemble.h b/arch/powerpc/include/asm/disassemble.h
new file mode 100644
index 0000000..9b198d1
--- /dev/null
+++ b/arch/powerpc/include/asm/disassemble.h
@@ -0,0 +1,80 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __ASM_PPC_DISASSEMBLE_H__
+#define __ASM_PPC_DISASSEMBLE_H__
+
+#include <linux/types.h>
+
+static inline unsigned int get_op(u32 inst)
+{
+	return inst >> 26;
+}
+
+static inline unsigned int get_xop(u32 inst)
+{
+	return (inst >> 1) & 0x3ff;
+}
+
+static inline unsigned int get_sprn(u32 inst)
+{
+	return ((inst >> 16) & 0x1f) | ((inst >> 6) & 0x3e0);
+}
+
+static inline unsigned int get_dcrn(u32 inst)
+{
+	return ((inst >> 16) & 0x1f) | ((inst >> 6) & 0x3e0);
+}
+
+static inline unsigned int get_rt(u32 inst)
+{
+	return (inst >> 21) & 0x1f;
+}
+
+static inline unsigned int get_rs(u32 inst)
+{
+	return (inst >> 21) & 0x1f;
+}
+
+static inline unsigned int get_ra(u32 inst)
+{
+	return (inst >> 16) & 0x1f;
+}
+
+static inline unsigned int get_rb(u32 inst)
+{
+	return (inst >> 11) & 0x1f;
+}
+
+static inline unsigned int get_rc(u32 inst)
+{
+	return inst & 0x1;
+}
+
+static inline unsigned int get_ws(u32 inst)
+{
+	return (inst >> 11) & 0x1f;
+}
+
+static inline unsigned int get_d(u32 inst)
+{
+	return inst & 0xffff;
+}
+
+#endif /* __ASM_PPC_DISASSEMBLE_H__ */
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index c5d2bfc..5fd9cf7 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -28,62 +28,7 @@
 #include <asm/time.h>
 #include <asm/byteorder.h>
 #include <asm/kvm_ppc.h>
-
-/* Instruction decoding */
-static inline unsigned int get_op(u32 inst)
-{
-	return inst >> 26;
-}
-
-static inline unsigned int get_xop(u32 inst)
-{
-	return (inst >> 1) & 0x3ff;
-}
-
-static inline unsigned int get_sprn(u32 inst)
-{
-	return ((inst >> 16) & 0x1f) | ((inst >> 6) & 0x3e0);
-}
-
-static inline unsigned int get_dcrn(u32 inst)
-{
-	return ((inst >> 16) & 0x1f) | ((inst >> 6) & 0x3e0);
-}
-
-static inline unsigned int get_rt(u32 inst)
-{
-	return (inst >> 21) & 0x1f;
-}
-
-static inline unsigned int get_rs(u32 inst)
-{
-	return (inst >> 21) & 0x1f;
-}
-
-static inline unsigned int get_ra(u32 inst)
-{
-	return (inst >> 16) & 0x1f;
-}
-
-static inline unsigned int get_rb(u32 inst)
-{
-	return (inst >> 11) & 0x1f;
-}
-
-static inline unsigned int get_rc(u32 inst)
-{
-	return inst & 0x1;
-}
-
-static inline unsigned int get_ws(u32 inst)
-{
-	return (inst >> 11) & 0x1f;
-}
-
-static inline unsigned int get_d(u32 inst)
-{
-	return inst & 0xffff;
-}
+#include <asm/disassemble.h>
 
 static void kvmppc_emulate_dec(struct kvm_vcpu *vcpu)
 {
-- 
1.6.0.3

