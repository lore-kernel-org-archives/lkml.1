Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbZJILnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbZJILnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZJILng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:43:36 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45319 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbZJILnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:43:35 -0400
Date: Fri, 9 Oct 2009 11:42:56 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: ieidus@redhat.com
Cc: mtosatti@redhat.com, linux-kernel@vger.kernel.org
Subject: [patch] kvm: fix pointer cast
Message-ID: <20091009114256.GA29528@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a 32 bits compile, commit 3da0dd433dc399a8c0124d0614d82a09b6a49bce
introduced the following warnings:

arch/x86/kvm/mmu.c: In function ‘kvm_set_pte_rmapp’:
arch/x86/kvm/mmu.c:770: warning: cast to pointer from integer of different size
arch/x86/kvm/mmu.c: In function ‘kvm_set_spte_hva’:
arch/x86/kvm/mmu.c:849: warning: cast from pointer to integer of different size

The following patch uses 'unsigned long' instead of u64 to match the
pointer size on both arches.

Regards,
Frederik


Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 685a4ff..818b92a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -748,7 +748,8 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	return write_protected;
 }
 
-static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp, u64 data)
+static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
+			   unsigned long data)
 {
 	u64 *spte;
 	int need_tlb_flush = 0;
@@ -763,7 +764,8 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp, u64 data)
 	return need_tlb_flush;
 }
 
-static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp, u64 data)
+static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
+			     unsigned long data)
 {
 	int need_flush = 0;
 	u64 *spte, new_spte;
@@ -799,9 +801,10 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp, u64 data)
 	return 0;
 }
 
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva, u64 data,
+static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
+			  unsigned long data,
 			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
-					 u64 data))
+					 unsigned long data))
 {
 	int i, j;
 	int retval = 0;
@@ -846,10 +849,11 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
-	kvm_handle_hva(kvm, hva, (u64)&pte, kvm_set_pte_rmapp);
+	kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
 }
 
-static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp, u64 data)
+static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
+			 unsigned long data)
 {
 	u64 *spte;
 	int young = 0;
