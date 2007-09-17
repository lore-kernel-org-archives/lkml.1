Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXIQJHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXIQJHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXIQIeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:45244 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 015/104] KVM: Use standard CR8 flags, and fix TPR definition
Date: Mon, 17 Sep 2007 10:30:57 +0200
Message-Id: <11900179473769-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Intel manual (and KVM definition) say the TPR is 4 bits wide.  Also fix
CR8_RESEVED_BITS typo.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c             |    4 ++--
 include/asm-i386/processor-flags.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 193197f..f0fc8d9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -92,7 +92,7 @@ static struct dentry *debugfs_dir;
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR	\
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
-#define CR8_RESEVED_BITS (~0x0fULL)
+#define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
 #ifdef CONFIG_X86_64
@@ -625,7 +625,7 @@ EXPORT_SYMBOL_GPL(set_cr3);
 
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	if ( cr8 & CR8_RESEVED_BITS) {
+	if (cr8 & CR8_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr8: #GP, reserved bits 0x%lx\n", cr8);
 		inject_gp(vcpu);
 		return;
diff --git a/include/asm-i386/processor-flags.h b/include/asm-i386/processor-flags.h
index 5404e90..199cab1 100644
--- a/include/asm-i386/processor-flags.h
+++ b/include/asm-i386/processor-flags.h
@@ -63,7 +63,7 @@
 /*
  * x86-64 Task Priority Register, CR8
  */
-#define X86_CR8_TPR	0x00000007 /* task priority register */
+#define X86_CR8_TPR	0x0000000F /* task priority register */
 
 /*
  * AMD and Transmeta use MSRs for configuration; see <asm/msr-index.h>
-- 
1.5.3

