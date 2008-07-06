Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYGFIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYGFIrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 04:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYGFIrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 04:47:05 -0400
Received: from il.qumranet.com ([212.179.150.194]:11637 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbYGFIrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 04:47:04 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.26-rc9
Date: Sun,  6 Jul 2008 11:47:02 +0300
Message-Id: <1215334022-16553-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kvm fixes from the repo and branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.26

adding a missing memory clobber to kvm hypercalls, which cause failures
when running guests compiled with gcc 4.3.0, and fixing ioapic interrupt
redelivery under certain loads.

Shortlog, diffstat, and diff follow.

Anthony Liguori (1):
      x86: KVM guest: Add memory clobber to hypercalls

Mark McLoughlin (1):
      KVM: IOAPIC: Fix level-triggered irq injection hang

 include/asm-x86/kvm_para.h |   15 ++++++++++-----
 virt/kvm/ioapic.c          |    2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index bfd9900..76f3921 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -71,7 +71,8 @@ static inline long kvm_hypercall0(unsigned int nr)
 	long ret;
 	asm volatile(KVM_HYPERCALL
 		     : "=a"(ret)
-		     : "a"(nr));
+		     : "a"(nr)
+		     : "memory");
 	return ret;
 }
 
@@ -80,7 +81,8 @@ static inline long kvm_hypercall1(unsigned int nr, unsigned long p1)
 	long ret;
 	asm volatile(KVM_HYPERCALL
 		     : "=a"(ret)
-		     : "a"(nr), "b"(p1));
+		     : "a"(nr), "b"(p1)
+		     : "memory");
 	return ret;
 }
 
@@ -90,7 +92,8 @@ static inline long kvm_hypercall2(unsigned int nr, unsigned long p1,
 	long ret;
 	asm volatile(KVM_HYPERCALL
 		     : "=a"(ret)
-		     : "a"(nr), "b"(p1), "c"(p2));
+		     : "a"(nr), "b"(p1), "c"(p2)
+		     : "memory");
 	return ret;
 }
 
@@ -100,7 +103,8 @@ static inline long kvm_hypercall3(unsigned int nr, unsigned long p1,
 	long ret;
 	asm volatile(KVM_HYPERCALL
 		     : "=a"(ret)
-		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3));
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
 	return ret;
 }
 
@@ -111,7 +115,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	long ret;
 	asm volatile(KVM_HYPERCALL
 		     : "=a"(ret)
-		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3), "S"(p4));
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3), "S"(p4)
+		     : "memory");
 	return ret;
 }
 
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1dcf9f3..4458908 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -278,7 +278,7 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int gsi)
 
 	ent->fields.remote_irr = 0;
 	if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
-		ioapic_deliver(ioapic, gsi);
+		ioapic_service(ioapic, gsi);
 }
 
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
