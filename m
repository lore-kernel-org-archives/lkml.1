Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbXGQNho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbXGQNho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbXGQNhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:37:37 -0400
Received: from ozlabs.org ([203.10.76.45]:53463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbXGQNhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:37:36 -0400
Subject: [PATCH 10/10] Use standard CR8 flags, and fix TPR definition
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1184679256.10380.27.camel@localhost.localdomain>
References: <1184677946.10380.4.camel@localhost.localdomain>
	 <1184678060.10380.7.camel@localhost.localdomain>
	 <1184678129.10380.10.camel@localhost.localdomain>
	 <1184678171.10380.12.camel@localhost.localdomain>
	 <1184678216.10380.14.camel@localhost.localdomain>
	 <1184678275.10380.16.camel@localhost.localdomain>
	 <1184678348.10380.19.camel@localhost.localdomain>
	 <1184679175.10380.25.camel@localhost.localdomain>
	 <1184679256.10380.27.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 23:37:17 +1000
Message-Id: <1184679437.10380.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel manual (and KVM definition) say it's TPR is 4 bits wide.  Also fix
CR8_RESEVED_BITS typo.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 6ef0b4c0d6f7 drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c	Tue Jul 17 18:07:48 2007 +1000
+++ b/drivers/kvm/kvm_main.c	Tue Jul 17 18:20:22 2007 +1000
@@ -92,7 +92,7 @@ static struct dentry *debugfs_dir;
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR	\
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
-#define CR8_RESEVED_BITS (~0x0fULL)
+#define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
 #ifdef CONFIG_X86_64
@@ -633,7 +633,7 @@ EXPORT_SYMBOL_GPL(set_cr3);
 
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	if ( cr8 & CR8_RESEVED_BITS) {
+	if (cr8 & CR8_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr8: #GP, reserved bits 0x%lx\n", cr8);
 		inject_gp(vcpu);
 		return;
diff -r 6ef0b4c0d6f7 include/asm-i386/processor-flags.h
--- a/include/asm-i386/processor-flags.h	Tue Jul 17 18:07:48 2007 +1000
+++ b/include/asm-i386/processor-flags.h	Tue Jul 17 18:12:54 2007 +1000
@@ -63,7 +63,7 @@
 /*
  * x86-64 Task Priority Register, CR8
  */
-#define X86_CR8_TPR	0x00000007 /* task priority register */
+#define X86_CR8_TPR	0x0000000F /* task priority register */
 
 /*
  * AMD and Transmeta use MSRs for configuration; see <asm/msr-index.h>


