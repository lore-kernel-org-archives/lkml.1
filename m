Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZHSNFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZHSNFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZHSNEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50577 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/47] KVM: s390: Fix memslot initialization for userspace_addr != 0
Date: Wed, 19 Aug 2009 16:02:27 +0300
Message-Id: <1250686963-8357-32-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Since
commit 854b5338196b1175706e99d63be43a4f8d8ab607
Author: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
    KVM: s390: streamline memslot handling

s390 uses the values of the memslot instead of doing everything in the arch
ioctl handler of the KVM_SET_USER_MEMORY_REGION. Unfortunately we missed to
set the userspace_addr of our memslot due to our s390 ifdef in
__kvm_set_memory_region.
Old s390 userspace launchers did not notice, since they started the guest at
userspace address 0.
Because of CONFIG_DEFAULT_MMAP_MIN_ADDR we now put the guest at 1M userspace,
which does not work. This patch makes sure that new.userspace_addr is set
on s390.
This fix should go in quickly. Nevertheless, looking at the code we should
clean up that ifdef in the long term. Any kernel janitors?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 04bdedd..1da8072 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1199,6 +1199,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (old.npages)
 			kvm_arch_flush_shadow(kvm);
 	}
+#else  /* not defined CONFIG_S390 */
+	new.user_alloc = user_alloc;
+	if (user_alloc)
+		new.userspace_addr = mem->userspace_addr;
 #endif /* not defined CONFIG_S390 */
 
 	if (!npages)
-- 
1.6.3.3

