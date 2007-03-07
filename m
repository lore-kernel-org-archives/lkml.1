Return-Path: <linux-kernel-owner+w=401wt.eu-S1161351AbXCGJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161351AbXCGJBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXCGJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:01:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:38183 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030496AbXCGJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:01:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/2] KVM: Unset kvm_arch_ops if arch module loading failed
Date: Wed,  7 Mar 2007 11:01:28 +0200
Message-Id: <11732580894019-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <1173258089147-git-send-email-avi@qumranet.com>
References: <1173258089147-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the core module thinks the arch module is loaded, and won't
let you reload it after you've fixed the bug.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a163bca..dc7a8c7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2464,7 +2464,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 
 	r = kvm_arch_ops->hardware_setup();
 	if (r < 0)
-	    return r;
+		goto out;
 
 	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
@@ -2500,6 +2500,8 @@ out_free_2:
 out_free_1:
 	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
+out:
+	kvm_arch_ops = NULL;
 	return r;
 }
 
-- 
1.5.0.2

