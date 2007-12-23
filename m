Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXLWPE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXLWPE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbXLWOwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:25 -0500
Received: from il.qumranet.com ([82.166.9.18]:35917 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbXLWOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 49/50] KVM: Use virtual cpu accounting if available for guest times.
Date: Sun, 23 Dec 2007 16:51:34 +0200
Message-Id: <1198421495-31481-50-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

ppc and s390 offer the possibility to track process times precisely
by looking at cpu timer on every context switch, irq, softirq etc.
We can use that infrastructure as well for guest time accounting.
We need to account the used time before we change the state.
This patch adds a call to account_system_vtime to kvm_guest_enter
and kvm_guest exit. If CONFIG_VIRT_CPU_ACCOUNTING is not set,
account_system_vtime is defined in hardirq.h as an empty function,
which means this patch does not change the behaviour on other
platforms.

I compile tested this patch on x86 and function tested the patch on
s390.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index df0711c..e8a21e8 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/hardirq.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -671,11 +672,13 @@ __init void kvm_arch_init(void);
 
 static inline void kvm_guest_enter(void)
 {
+	account_system_vtime(current);
 	current->flags |= PF_VCPU;
 }
 
 static inline void kvm_guest_exit(void)
 {
+	account_system_vtime(current);
 	current->flags &= ~PF_VCPU;
 }
 
-- 
1.5.3.7

