Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZHSNDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZHSNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZHSNDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:03:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50589 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032AbZHSNCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 47/47] KVM: fix lock imbalance
Date: Wed, 19 Aug 2009 16:02:43 +0300
Message-Id: <1250686963-8357-48-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

There is a missing unlock on one fail path in ioapic_mmio_write,
fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/ioapic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index ddf6aa9..8a9c6cc 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -292,7 +292,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		data = *(u32 *) val;
 	else {
 		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
-		return 0;
+		goto unlock;
 	}
 
 	addr &= 0xff;
@@ -313,6 +313,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	default:
 		break;
 	}
+unlock:
 	mutex_unlock(&ioapic->kvm->irq_lock);
 	return 0;
 }
-- 
1.6.3.3

