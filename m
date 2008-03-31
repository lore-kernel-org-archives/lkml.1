Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYCaOl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYCaOl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYCaOhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:39 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51309
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <andrea@qumranet.com>
Subject: [PATCH 15/40] KVM: Disable pagefaults during copy_from_user_inatomic()
Date: Mon, 31 Mar 2008 17:36:59 +0300
Message-Id: <1206974244-9716-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <andrea@qumranet.com>

With CONFIG_PREEMPT=n, this is needed in order to disable the fault-in
code from sleeping.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7972e3a..cf6df51 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -554,7 +554,9 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
+	pagefault_disable();
 	r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
+	pagefault_enable();
 	if (r)
 		return -EFAULT;
 	return 0;
-- 
1.5.4.5

