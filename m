Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYKDO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYKDO42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYKDOxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60559 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbYKDOxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:44 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 14/16] kvmx: x86: set kvm_x86_ops earlier on kvm_arch_init()
Date: Tue,  4 Nov 2008 12:52:42 -0200
Message-Id: <1225810364-8990-15-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small change that will be needed when we use set_virt_disable_func()
on kvm_arch_init().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/x86.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a4a39c..049c6a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2603,19 +2603,22 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	kvm_x86_ops = ops;
+
 	r = kvm_mmu_module_init();
 	if (r)
-		goto out;
+		goto out_clear_ops;
 
 	kvm_init_msr_list();
 
-	kvm_x86_ops = ops;
 	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
 	kvm_mmu_set_base_ptes(PT_PRESENT_MASK);
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0, 0);
 	return 0;
 
+out_clear_ops:
+	kvm_x86_ops = NULL;
 out:
 	return r;
 }
-- 
1.5.5.GIT

