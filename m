Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXBYM6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXBYM6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964914AbXBYM6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:58:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:37871 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXBYM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:58:08 -0500
Subject: [PATCH 4/4] KVM: Remove write access permissions when
	dirty-page-logging is enabled
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 25 Feb 2007 12:58:07 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45E186FE.2000909@qumranet.com>
In-Reply-To: <45E186FE.2000909@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070225125807.2EDAF250196@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling dirty page logging is done using KVM_SET_MEMORY_REGION ioctl.
If the memory region already exists, we need to remove write accesses,
so writes will be caught, and dirty pages will be logged.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index be7694d..e48b4d7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -748,6 +748,8 @@ raced:
 		vcpu = vcpu_load_slot(kvm, i);
 		if (!vcpu)
 			continue;
+		if (new.flags & KVM_MEM_LOG_DIRTY_PAGES)
+			do_remove_write_access(vcpu, mem->slot);
 		kvm_mmu_reset_context(vcpu);
 		vcpu_put(vcpu);
 	}
