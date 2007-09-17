Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbXIQImU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbXIQImU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXIQIcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:45249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 049/104] KVM: Use kmem_cache_free for kmem_cache_zalloc'ed objects
Date: Mon, 17 Sep 2007 10:31:31 +0200
Message-Id: <11900179482249-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

We use kfree in svm.c and vmx.c, and this works, but it could break at
any time.  kfree() is supposed to match up with kmalloc().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    4 ++--
 drivers/kvm/vmx.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 3ec30d7..436bdff 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -610,7 +610,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 uninit:
 	kvm_vcpu_uninit(&svm->vcpu);
 free_svm:
-	kfree(svm);
+	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
 	return ERR_PTR(err);
 }
@@ -621,7 +621,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	kvm_vcpu_uninit(vcpu);
-	kfree(svm);
+	kmem_cache_free(kvm_vcpu_cache, svm);
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index ae54d9a..708055a 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2359,7 +2359,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	kfree(vmx->host_msrs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
-	kfree(vmx);
+	kmem_cache_free(kvm_vcpu_cache, vmx);
 }
 
 static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
@@ -2410,7 +2410,7 @@ free_guest_msrs:
 uninit_vcpu:
 	kvm_vcpu_uninit(&vmx->vcpu);
 free_vcpu:
-	kfree(vmx);
+	kmem_cache_free(kvm_vcpu_cache, vmx);
 	return ERR_PTR(err);
 }
 
-- 
1.5.3

