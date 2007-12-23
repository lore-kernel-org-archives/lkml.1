Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXLWOzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXLWOzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXLWOvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:35908 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXLWOvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:41 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Ryan Harper <ryanh@us.ibm.com>
Subject: [PATCH 11/50] KVM: MMU: Ignore reserved bits in cr3 in non-pae mode
Date: Sun, 23 Dec 2007 16:50:56 +0200
Message-Id: <1198421495-31481-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Harper <ryanh@us.ibm.com>

This patch removes the fault injected when the guest attempts to set reserved
bits in cr3.  X86 hardware doesn't generate a fault when setting reserved bits.
The result of this patch is that vmware-server, running within a kvm guest,
boots and runs memtest from an iso.

Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index da057cf..b10fd7e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -554,14 +554,11 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 				inject_gp(vcpu);
 				return;
 			}
-		} else {
-			if (cr3 & CR3_NONPAE_RESERVED_BITS) {
-				printk(KERN_DEBUG
-				       "set_cr3: #GP, reserved bits\n");
-				inject_gp(vcpu);
-				return;
-			}
 		}
+		/*
+		 * We don't check reserved bits in nonpae mode, because
+		 * this isn't enforced, and VMware depends on this.
+		 */
 	}
 
 	mutex_lock(&vcpu->kvm->lock);
-- 
1.5.3.7

