Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZF2QFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZF2QFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbZF2QFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:05:37 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:52420 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZF2QFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:05:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] KVM: fix lock imbalance
Date: Mon, 29 Jun 2009 18:05:10 +0200
Message-Id: <1246291510-3676-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a missing unlock on one fail path in ioapic_mmio_write,
fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 virt/kvm/ioapic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index d8b2eca..2b3307b 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -290,7 +290,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		data = *(u32 *) val;
 	else {
 		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
-		return;
+		goto unlock;
 	}
 
 	addr &= 0xff;
@@ -311,6 +311,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	default:
 		break;
 	}
+unlock:
 	mutex_unlock(&ioapic->kvm->irq_lock);
 }
 
-- 
1.6.3.2

