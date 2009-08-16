Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZHPJcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZHPJcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZHPJcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45361 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/48] KVM: Calculate available entries in coalesced mmio ring
Date: Sun, 16 Aug 2009 12:29:50 +0300
Message-Id: <1250415008-17175-31-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking whether we'll wrap around, calculate how many entries
are available, and check whether we have enough (just one) for the pending
mmio.

By itself, this doesn't change anything, but it paves the way for making
this function lockless.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index c4c7ec2..7549068 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -24,7 +24,8 @@ static int coalesced_mmio_in_range(struct kvm_io_device *this,
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_zone *zone;
-	int next;
+	struct kvm_coalesced_mmio_ring *ring;
+	unsigned avail;
 	int i;
 
 	if (!is_write)
@@ -40,10 +41,9 @@ static int coalesced_mmio_in_range(struct kvm_io_device *this,
 	 * check if we don't meet the first used entry
 	 * there is always one unused entry in the buffer
 	 */
-
-	next = (dev->kvm->coalesced_mmio_ring->last + 1) %
-							KVM_COALESCED_MMIO_MAX;
-	if (next == dev->kvm->coalesced_mmio_ring->first) {
+	ring = dev->kvm->coalesced_mmio_ring;
+	avail = (ring->first - ring->last - 1) % KVM_COALESCED_MMIO_MAX;
+	if (avail < 1) {
 		/* full */
 		return 0;
 	}
-- 
1.6.3.3

